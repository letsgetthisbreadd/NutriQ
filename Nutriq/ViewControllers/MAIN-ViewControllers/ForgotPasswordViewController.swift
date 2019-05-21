//
//  ForgotPasswordViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/15/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
// TODO: - Check to make sure the email exists + perform input validation
class ForgotPasswordViewController: UIViewController {

    
    // MARK: - Properties
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var emailField: UITextField!
    
    
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
    
    @IBAction func onSendEmailButtonPressed(_ sender: Any) {
        let email = emailField.text!
        
        // Input validation for "Email" field
        if email == "" { // "Email" field is empty
            let emptyEmailFieldAlert = UIAlertController(title: "Empty email field", message: "The email field is empty. Please input your email address and try again.", preferredStyle: .alert)
            emptyEmailFieldAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyEmailFieldAlert, animated: true)
            return
        }
        
        print("Checking if email exists in database...\n")
        checkIfEmailExistsInDatabase(email) {
            print("Completed checking if email exists in database...\n")
        }
        
    }
    
    func checkIfEmailExistsInDatabase(_ email: String, completion: @escaping () -> ()) {
        
        Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value!) // Snapshot of the keys/values in DB that have matching email address
            
            if (!snapshot.exists()) {
                print("Email address:", email, "does not exist in the database!")
                let emailDoesNotExistErrorAlert = UIAlertController(title: "Invalid email address", message: "The email field entered does not belong to any user. Please input a valid email address and try again.", preferredStyle: .alert)
                emailDoesNotExistErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(emailDoesNotExistErrorAlert, animated: true)
                return
            }
            
            print("Email address:", email, "exists in the database!")
            
            // Check account type
            let snapshotValue = snapshot.value! as? NSDictionary
            let snapshotValueKeys = Array(snapshotValue!.allKeys)
            let userID = snapshotValueKeys[0] as! String
            
            self.checkIfGoogleAccount(userID, completion: { (isGoogleAccount) in
                print("Account type checked.")
                if isGoogleAccount {
                    print("The account is a Google account!")
                    completion()
                } else {
                    print("The account is an Email account!")
                    // Send password reset email
                    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                        if let error = error {
                            print(error)
                            print("Failed to send password reset email with error:", error.localizedDescription)
                            let passwordResetErrorAlert = UIAlertController(title: "Password Reset Error", message: error.localizedDescription, preferredStyle: .alert)
                            passwordResetErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(passwordResetErrorAlert, animated: true)
                            return
                        }
                        print("Password reset email sent to:", email)
                        let passwordResetEmailSentAlert = UIAlertController(title: "Password Reset Email Sent", message: "An password reset email has been sent to the email address associated with this account.", preferredStyle: .alert)
                        passwordResetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                            self.closePopupView()
                            //                    self.takeUserToLoginScreen()
                        }))
                        self.present(passwordResetEmailSentAlert, animated: true)
                        
                        // Completed checking if email entered exists in the database
                        completion()
                    }
                }
            })
        }
    }
    
    func checkIfGoogleAccount(_ userID: String, completion: @escaping (Bool) -> ()) {
        // Check if email address is associated with an email or a Google account; If email, allow sending of password reset email
        
        Database.database().reference().child("users/\(userID)/account-type").observeSingleEvent(of: .value, with: { (snapshot) in
            print("The account type is:", snapshot.value!)
            
            if snapshot.value! as! String == "Google" {
                let googleAccountAlert = UIAlertController(title: "Error", message: "The password for this email address cannot be reset because the acocunt associated with it was created without a password. The password for this account can only be changed through Google's password reset page.", preferredStyle: .alert)
                googleAccountAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(googleAccountAlert, animated: true)
                completion(true)
            } else {
                completion(false)
            }
        })
        
    }
    
    func takeUserToLoginScreen() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        UIApplication.topViewController()?.present(loginVC, animated: true, completion: nil)
    }
    
    // Show animation for "Reset Password" popup
    func showPopupView() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    // Close animation for "Reset Password" popup
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
