//
//  GetCurrentPasswordPopupViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/14/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

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
        showPopupView()
    }

    
    // MARK: - Helper Functions & Actions

    @IBAction func onCancelButtonPressed(_ sender: Any) {
        self.closePopupView()
        
    }
    
    // Check if the password user entered matches the one associated with their account
    @IBAction func onConfirmButtonPressed(_ sender: Any) {
        password = currentPasswordField.text!

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
    }
    
    // Re-authenticate user to allow user to change password or delete the account
    func checkCredentials(_ userID: String, _ password: String, completion: @escaping () -> ()) {
        // Input validation for "Current Password" field
        if password == "" { // "Current Password" field is empty
            let emptyCurrentPasswordAlert = UIAlertController(title: "Empty current password field", message: "The current password field is empty. Please input your current password and try again.", preferredStyle: .alert)
            emptyCurrentPasswordAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyCurrentPasswordAlert, animated: true)
            return
        }
        
        guard let user = Auth.auth().currentUser else { return }
        var credential: AuthCredential
        
        guard let email = Auth.auth().currentUser?.email else { return }
        credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        
        // Prompt user to re-provide their sign-in credentials
        user.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
            if let error = error {
                // A re-authentication error occurred
                print("Failed to re-authenticate email user with error:", error.localizedDescription)
                if error.localizedDescription == "The password is invalid or the user does not have a password." {
                    let invalidPasswordReauthenticationErrorAlert = UIAlertController(title: "Incorrect Password Entered", message: "The current password entered is invalid. Please input the correct current password and try again.", preferredStyle: .alert)
                    invalidPasswordReauthenticationErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidPasswordReauthenticationErrorAlert, animated: true)
                    return
                }
            }
            print("Email user successfully re-authenticated")
            completion()
            self.view.removeFromSuperview()
        })
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
    
    
    // Show animation for "Confirm Password" popup
    func showPopupView() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    // Close animation for "Confirm Password" popup
    func closePopupView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }

    
}
