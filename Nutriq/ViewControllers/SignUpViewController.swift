//
//  SignUpViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/12/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignUpViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    
    // MARK: - Properties
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var signupButton: ShadowButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Create User
    
    func createUser(withEmail email: String, password: String, username: String) {
        // Attempt to create user if username is unique
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            // General sign up error
            if let error = error {
                print("Failed to sign user up with error: ", error.localizedDescription)
                let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true)
                return
            }
            
            // Get the unique userID of the current user signing up
            guard let userID = result?.user.uid else { return }
        
            let userInfo = ["username": username, "email": email]
            
            // Update the database for the userID above with the email address & username entered
            Database.database().reference().child("users").child(userID).updateChildValues(userInfo, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print("Failed to updated database with error: ", error.localizedDescription)
                    return
                }
                print("Successfully signed user up...")
                self.performSegue(withIdentifier: "signupSegue", sender: self)
            })
    
        }
    }
    
    
    // MARK: - Helper Functions & Actions
    
    @objc func handleSignUp() {
        guard let email = emailField.text else { return }
        guard let username = usernameField.text else { return }
        guard let password = passwordField.text else { return }
        guard let confirmPassword = confirmPasswordField.text else { return }
        
        if username == "" {
            print("The username field is empty. Please input a username and try to sign up again!")
            let emptyUsernameAlert = UIAlertController(title: "Empty username field", message: "The username field is empty. Please input a username and try to sign up again.", preferredStyle: .alert)
            emptyUsernameAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyUsernameAlert, animated: true)
            return
        } else if email == "" {
            print("The email field is empty. Please input an email address and try to sign up again!")
            let emptyEmailAlert = UIAlertController(title: "Empty email field", message: "The email field is empty. Please input an email address and try to sign up again.", preferredStyle: .alert)
            emptyEmailAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyEmailAlert, animated: true)
            return
        } else if password == "" {
            print("The first password field is empty. Please input a password and try to sign up again!")
            let emptyPasswordAlert = UIAlertController(title: "Empty password field", message: "The first password field is empty. Please input a password and try to sign up again.", preferredStyle: .alert)
            emptyPasswordAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyPasswordAlert, animated: true)
            return
        } else if confirmPassword == "" {
            print("The second password field is empty. Please input a confirmation password and try to sign up again!")
            let emptyConfirmPasswordAlert = UIAlertController(title: "Empty confirmation password field", message: "The second password field is empty. Please input a confirmation password and try to sign up again.", preferredStyle: .alert)
            emptyConfirmPasswordAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyConfirmPasswordAlert, animated: true)
            return
        } else if password != confirmPassword {
            print("Please make sure both passwords match!")
            let passwordMismatchAlert = UIAlertController(title: "Password field mismatch", message: "The passwords entered do not match. Make sure they match and then try to sign up again.", preferredStyle: .alert)
            passwordMismatchAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(passwordMismatchAlert, animated: true)
            return
        }
        
        // Make sure the username user entered is unique
        Database.database().reference().child("users").queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value!) // Snapshot of keys/values in DB that have matching username
            // If username is not unique, alert user and cancel sign up process
            if (!(snapshot.value! is NSNull)) {
                print("Username already exists!")
                let usernameExistsAlert = UIAlertController(title: "Username exists", message: "The username entered already exists. Please input another username and try to sign up again.", preferredStyle: .alert)
                usernameExistsAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(usernameExistsAlert, animated: true)
                return
            }
        })
    
        // Create user if validation throws no error
        createUser(withEmail: email, password: password, username: username)
    }
    
    @IBAction func onSignupButtonPressed(_ sender: Any) {
        handleSignUp()
    }
    
    
    // TODO: - Add Google sign in (sign up) button to this screen
    // TODO: - Use a custom button to make the label say "Sign up with Google" instead of "Sign in with Google"; Refer to the TODO in the LoginViewController describing how to create the custom button (Hint: Refer to the 'userLogin' branch)


}
