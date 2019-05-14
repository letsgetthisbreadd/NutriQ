//
//  GetCurrentPasswordPopupViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/14/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
// TODO: - Add alert popup for user if password entered into password confirmation field is NOT correct
class GetCurrentPasswordPopupViewController: UIViewController {

    
    // MARK: - Properties
    
    let userID = Auth.auth().currentUser?.uid
    var accountType = ""
    var password = ""
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var popupView: UIView!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popupView.layer.cornerRadius = 5
    }

    
    
    // MARK: - Helper Functions & Actions

    @IBAction func onCancelButtonPressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    // TODO: - Reauthenticate the user
    @IBAction func onConfirmButtonPressed(_ sender: Any) {
        // TODO: - Input validation (empty password field)
        // Check if current password entered was correct
        password = currentPasswordField.text!
//        reauthenticateUser(userID!) {
//            print("User reauthenticated!\n")
        print("Checking credentials...\n")
        self.checkCredentials(self.userID!, self.password, completion: {
            print("Credentials checked!\n")
            print("Presenting confirmation to delete account...\n")
            self.presentConfirmAccountDeletionAlert {
                print("Account deletion confirmed..\n")
                self.presentAccountDeletedMessageAlert {
                    print("The account has been completely deleted...\n")
                }
            }
        })
//        }
    }
    
//    // See whether the account type is either email or Google; This will be used to help re-authenticate the user
//    func reauthenticateUser(_ userID: String, completion: @escaping () -> ()) {
//        print("Reauthenticating the user...\n")
//        let userReference = Database.database().reference().child("users/\(userID)")
//
//        userReference.observeSingleEvent(of: .value) { (snapshot) in
//            print("Snapshot of the user:\n", snapshot.value!) // Returns snapshot of user
//            let snapshotValue = snapshot.value! as? NSDictionary
//            self.accountType = snapshotValue?["account-type"] as! String
//
//            // "Reauthenticate user" task has been completed
//            completion()
//        }
//    }
    
    // Re-authenticate user to allow user to change password or delete the account
    func checkCredentials(_ userID: String, _ password: String, completion: @escaping () -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        var credential: AuthCredential
        
        guard let email = Auth.auth().currentUser?.email else { return }
        credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        // Prompt user to re-provide their sign-in credentials
        user.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
            if let error = error {
                // An re-authentication error occurred
                print("Failed to re-authenticate email user with error:", error.localizedDescription)
                return
            }
            print("Email user successfully re-authenticated")
            completion()
            self.view.removeFromSuperview()
        })
    }
//    } else { // Account type is Google
//            let googleUser = GIDSignIn.sharedInstance().currentUser
//            print("Google user:", googleUser as Any)
//            guard let idToken = googleUser?.authentication.idToken else { return }
//            guard let accessToken = googleUser?.authentication.accessToken else { return }
//            print("idToken:", idToken, "\n")
//            print("accessToken:", accessToken, "\n")
//
//            credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//
//            // Prompt user to re-provide their sign-in credentials
//            user.reauthenticateAndRetrieveData(with: credential) { (authResult, error) in
//                if let error = error {
//                    // A re-authentication error occurred
//                    print("Failed to re-authenticate Google user with error:", error.localizedDescription)
//                    return
//                }
//                print("Google user successfully re-authenticated")
//                completion()
//                self.view.removeFromSuperview()
//            }
//        }
//    }
    
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
        let accountDeletedAlert = UIAlertController(title: "Account Deleted", message: "Your account has been deleted. You will now be returned to the welcome screen", preferredStyle: .alert)
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
