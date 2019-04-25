//
//  LoginViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/12/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    
    // MARK: - Properties
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: ShadowButton!
    @IBOutlet weak var googleSigninButton: GIDSignInButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.becomeFirstResponder()
        
        // Set the UI delegate of the GIDSignIn object
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Style Google sign in button
        // TODO: - Possibly use own custom Google sign in button (must refactor code); refer to the way the custom Google UIButton was made on the userLogin branch (the button is actually called "Button" and is unchanged)
        googleSigninButton.style = GIDSignInButtonStyle.wide
        googleSigninButton.layer.cornerRadius = 5
        
    }
    
    
    // MARK: - User Login
    // TODO: - Allow user to log in with either username or email? If one is empty, the other one must be filled out. Use the one that is filled out to complete the user log in.
    func logUserIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to sign user in with error: ", error.localizedDescription)
                // If user input invalid password
                if error.localizedDescription == "The password is invalid or the user does not have a password." {
                    let invalidPasswordAlert = UIAlertController(title: "Invalid password", message: "The password you entered is invalid. Please try again.", preferredStyle: .alert)
                    invalidPasswordAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidPasswordAlert, animated: true)
                } // If user input invalid username
                else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    let invalidUsernameAlert = UIAlertController(title: "Invalid email", message: "The email address you entered is invalid. Please try again.", preferredStyle: .alert)
                    invalidUsernameAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidUsernameAlert, animated: true)
                }
                return
            }
            print("Successfully logged user in...")
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    
    // MARK: - Helper Functions & Actions
    
    @objc func handleLogin() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        if email == "" {
            print("The email field is empty. Please input an email address and try to sign up again!")
            let emptyEmailAlert = UIAlertController(title: "Empty email field", message: "The email field is empty. Please input an email address and try to sign up again.", preferredStyle: .alert)
            emptyEmailAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyEmailAlert, animated: true)
        } else if password == "" {
            print("The password field is empty. Please input a password and try to sign up again!")
            let emptyPasswordAlert = UIAlertController(title: "Empty password field", message: "The first password field is empty. Please input a password and try to sign up again.", preferredStyle: .alert)
            emptyPasswordAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyPasswordAlert, animated: true)
        } else {
            logUserIn(withEmail: email, password: password)
        }
    }
    
    // Email login button
    @IBAction func onLoginButtonPressed(_ sender: Any) {
        handleLogin()
    }
    
    // Google login button
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Google sign in error occured with error: ", error.localizedDescription)
            // TODO: - Add alert for error using localized description?
            return
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
                if error == nil {
                    // TODO: - If email associated with Google account does not exist in the database, this means the user hasn't signed up yet. Segue to the username creation page (only for users signing in with Google); otherwise, if the email is associated with a Google account and exists in the database (as well as a username for that Google email address), perform the login segue
                    // TODO: - Add the Google user's email and username to the database
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                } else {
                    // TODO: - Change this error code below to localized description and add alert?
                    print(error as Any)
                }
            }
        }
    }
    
    
}
