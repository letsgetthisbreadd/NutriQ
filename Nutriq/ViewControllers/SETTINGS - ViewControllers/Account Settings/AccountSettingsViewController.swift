//
//  AccountSettingsViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/10/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class AccountSettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    let userID = Auth.auth().currentUser?.uid
    var accountType = ""
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        // Sign the Google user in again (silently) to allow user to change password or delete account
        GIDSignIn.sharedInstance()?.signInSilently()
        
        displayTitle {
            // If account type is a Google account, hide the "Change Password" button
            reauthenticateUserAndGetAccountType(userID!) {
                if self.accountType == "Google" {
                    self.changePasswordButton.isHidden = true
                }
            }
        }
    }


    // MARK: - Helper Functions & Actions
    
    func displayTitle(completion: () -> ()) {
        self.title = "Account Settings"
        completion()
    }
    
    @IBAction func onLogoutButtonPressed(_ sender: Any) {
        handleSignOut()
    }
    
    // Sign user out - works for BOTH Google and email sign out
    func signOut() {
        GIDSignIn.sharedInstance().signOut() // Google sign out
        do {
            // TODO: - Before release, check to make sure that not checking which sign out is occuring will not impact the app in any way
            try Auth.auth().signOut() // Email sign out
            self.takeUserToLoginScreen()
        } catch let error {
            print("Failed to sign out with error: ", error.localizedDescription)
        }
    }
    
    @objc func handleSignOut() {
        let signOutAlertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        signOutAlertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        signOutAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(signOutAlertController, animated: true, completion: nil)
    }
    
    func takeUserToLoginScreen() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.segueToBottom()
        UIApplication.topViewController()?.present(loginVC, animated: false, completion: nil)
    }
    
    // Top-to-bttom segue animation
    func segueToBottom() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    @IBAction func onDeleteAccountButtonPressed(_ sender: Any) {
        if self.accountType == "Email" { // Account is an Email account; Send user to password confirmation screen and then begin account deletion process
            showConfirmPasswordPopup()
        } else { // Account is a Google account; Begin account deletion process
            print("Checking credentials...\n")
            checkCredentials {
                print("Credentials checked!\n")
                print("Presenting confirmation to delete account...\n")
                self.presentConfirmAccountDeletionAlert {
                    print("Account deletion confirmed..\n")
                    self.presentAccountDeletedMessageAlert {
                        print("The account has been completely deleted...\n")
                    }
                }
            }
        }
    }
    
    // Pops up a small view controller which reauthenticates the current user by getting user to input current password
    func showConfirmPasswordPopup() {
        let confirmPasswordVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "GetCurrentPasswordPopupViewController") as! GetCurrentPasswordPopupViewController
        self.addChild(confirmPasswordVC)
        confirmPasswordVC.view.frame = self.view.frame
        self.view.addSubview(confirmPasswordVC.view)
        confirmPasswordVC.didMove(toParent: self)
    }
    
    
    // See whether the account type is either email or Google; This will be used to help re-authenticate the user
    func reauthenticateUserAndGetAccountType(_ userID: String, completion: @escaping () -> ()) {
        print("Reauthenticating the user...\n")
        let userReference = Database.database().reference().child("users/\(userID)")
        
        userReference.observeSingleEvent(of: .value) { (snapshot) in
            print("Snapshot of the user:\n", snapshot.value!) // Returns snapshot of user
            let snapshotValue = snapshot.value! as? NSDictionary
            self.accountType = snapshotValue?["account-type"] as! String
            
            // "Reauthenticate user" task has been completed
            completion()
        }
    }
    
    func checkCredentials(completion: @escaping () -> ()) {
        guard let user = Auth.auth().currentUser else { return } // The account located on the "Authentication" page
        let googleUser = GIDSignIn.sharedInstance().currentUser
        print("Google user:", googleUser as Any)
        
        var credential: AuthCredential
        guard let idToken = googleUser?.authentication.idToken else { return }
        guard let accessToken = googleUser?.authentication.accessToken else { return }
        print("idToken:", idToken, "\n")
        print("accessToken:", accessToken, "\n")

        credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

        // Prompt user to re-provide their sign-in credentials
        user.reauthenticateAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // A re-authentication error occurred
                print("Failed to re-authenticate Google user with error:", error.localizedDescription)
                return
            }
            print("Google user successfully re-authenticated")
            completion()
        }
    }
    
    func presentConfirmAccountDeletionAlert(completion: @escaping () -> ()) {
        let confirmAccountDeletionAlertController = UIAlertController(title: nil, message: "Are you sure you want to delete your account? This cannot be undone!", preferredStyle: .actionSheet)
        confirmAccountDeletionAlertController.addAction(UIAlertAction(title: "Delete Account", style: .destructive, handler: { (_) in
            self.deleteAccount(completion: {
                print("Account deleted!\n")
                // Confirm account deletion alert has completed presenting
                completion()
            }
            )}))
        confirmAccountDeletionAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(confirmAccountDeletionAlertController, animated: true, completion: nil)
        
    }
    
    func deleteAccount(completion: @escaping () -> ()) {
        print("Deleting account...\n")
        let user = Auth.auth().currentUser
        
        GIDSignIn.sharedInstance().signOut() // Sign the user out to allow new user to select email on login/signup screens
        
        // Delete user from Firebase database
        Database.database().reference().child("users/\(userID!)").removeValue()
        
        // Delete user from authentication page
        user?.delete { error in
            if let error = error {
                print("Failed to delete account with error:", error.localizedDescription)
                let deleteAccountErrorAlert = UIAlertController(title: "Error Deleting Account", message: error.localizedDescription, preferredStyle: .alert)
                deleteAccountErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(deleteAccountErrorAlert, animated: true)
                return
            }
            // "Delete account" task has been completed
            completion()
        }
    }
    
    func presentAccountDeletedMessageAlert(completion: () -> ()) {
        let accountDeletedAlert = UIAlertController(title: "Account Deleted", message: "Your account has been deleted. You will now be returned to the welcome screen.", preferredStyle: .alert)
        accountDeletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            print("Taking user to welcome screen...\n")
            self.takeUserToWelcomeScreen()
        }))
        self.present(accountDeletedAlert, animated: true, completion: nil)
        
        // The account deleted message alert has completed presenting
        completion()
    }
    
    func takeUserToWelcomeScreen() {
        let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
        UIApplication.topViewController()?.present(welcomeVC, animated: true, completion: nil)
    }
    
}
