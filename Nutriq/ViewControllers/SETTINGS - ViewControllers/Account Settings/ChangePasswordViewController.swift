//
//  ChangePasswordViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/13/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    
    // MARK: - Properties
    let userID = Auth.auth().currentUser?.uid
    var password = ""
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmNewPasswordField: UITextField!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Helper Functions & Actions
    @IBAction func onConfirmButtonPressed(_ sender: Any) {
        guard let currentPassword = currentPasswordField.text else { return }
        guard let newPassword = newPasswordField.text else { return }
        guard let confirmNewPassword = confirmNewPasswordField.text else { return }
        
        // Check for empty fields
        if currentPassword == "" {
            print("The current password field is empty. Please input your current password and try again!")
            let emptyCurrentPasswordFieldAlert = UIAlertController(title: "Empty current password field", message: "The current password field is empty. Please input your current password and try again.", preferredStyle: .alert)
            emptyCurrentPasswordFieldAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyCurrentPasswordFieldAlert, animated: true)
            return
        } else if newPassword == "" {
            print("The new password field is empty. Please input your new password and try again!")
            let emptyNewPasswordFieldAlert = UIAlertController(title: "Empty new password field", message: "The new password field is empty. Please input your new password and try again.", preferredStyle: .alert)
            emptyNewPasswordFieldAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyNewPasswordFieldAlert, animated: true)
            return
        } else if confirmNewPassword == "" {
            print("The confirm new password field is empty. Please input your new password confirmation again and try again!")
            let emptyConfirmNewPasswordFieldAlert = UIAlertController(title: "Empty confirm password field", message: "The confirm new password field is empty. Please input your new password confirmation again and try again.", preferredStyle: .alert)
            emptyConfirmNewPasswordFieldAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyConfirmNewPasswordFieldAlert, animated: true)
            return
        }
        
        // Check if current password is correct. If yes, continue input validation
        checkCredentials(userID!, currentPassword) {
            // Make sure new password isn't the same as the current password
            if newPassword == currentPassword {
                print("The new password cannot be your current password!")
                let newPasswordSameAsCurrentPasswordErrorAlert = UIAlertController(title: "Error", message: "The new password cannot be your current password! Please input a different new password and try again.", preferredStyle: .alert)
                newPasswordSameAsCurrentPasswordErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(newPasswordSameAsCurrentPasswordErrorAlert, animated: true)
                return
            } else if newPassword != confirmNewPassword { // If new password and confirm new password don't match, alert the user
                print("The 'New Password' and 'Confirm New Password' fields must match!")
                let newPasswordConfirmPasswordMismatchErrorAlert = UIAlertController(title: "Error", message:"The 'New Password' and 'Confirm New Password' fields must match! They currently do not.", preferredStyle: .alert)
                newPasswordConfirmPasswordMismatchErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(newPasswordConfirmPasswordMismatchErrorAlert, animated: true)
                return
            } else { // Input validation passed. Change current user's password
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    if let error = error {
                        print("Failed to update password with error:", error.localizedDescription)
                        return
                    }
                    print("Password has been updated successfully.")
                    let passwordUpdateAlert = UIAlertController(title: "Password Updated", message: "Your password has been updated successfully", preferredStyle: .alert)
                    passwordUpdateAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                        print("Taking user to 'Account Settings' screen...\n")
                        _ = self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(passwordUpdateAlert, animated: true, completion: nil)
                    return
                })
            }
        }
    }
    
    func checkCredentials(_ userID: String, _ password: String, completion: @escaping () -> ()) {
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
                    let invalidPasswordReauthenticationErrorAlert = UIAlertController(title: "Authentication Error", message: "The current password entered is invalid. Please input the correct current password and try again.", preferredStyle: .alert)
                    invalidPasswordReauthenticationErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidPasswordReauthenticationErrorAlert, animated: true)
                    return
                } else {
                    let reauthenticationErrorAlert = UIAlertController(title: "Authentication Error", message: "The user could not be re-authenticated with error: \(error.localizedDescription)", preferredStyle: .alert)
                    reauthenticationErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(reauthenticationErrorAlert, animated: true)
                    return
                }
            }
            print("Email user successfully re-authenticated")
            completion()
        })
    }

}
