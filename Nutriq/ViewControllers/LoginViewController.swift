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
        
        
        // Create a tap gesture recognizer within the Google sign in button (UIView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.performGoogleSignIn))
        self.googleSigninButton.addGestureRecognizer(gesture)
        
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
    
    @objc func handleEmailLogin() {
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
    
    @objc func handleGoogleLogin(forUserEmail email: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        // Check if "username" key exists for the current user
        let usernameValue = Database.database().reference().child("users/\(userID)/username")
        var usernameExists = false
        
        usernameValue.observeSingleEvent(of: .value) { (snapshot) in
            if (snapshot.exists()) {
                usernameExists = true
            }
            print(usernameExists)
            print(snapshot.value!) // Snapshot of the keys/values in DB that have the "username" key

        }
        
        // If user that is signing in with a Google account is not in the database, store their userID and email in the DB and segue them to the username creation screen
        Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value!) // Snapshot of the keys/values in DB that have matching userID
        
            if (!snapshot.exists()) {
                print("User ID:", userID, "and email:", email, "does not exist in the Firebase database. Updating the database...")
                
                let userInfo = [userID: ["email": email]]
                
                Database.database().reference().child("users").updateChildValues(userInfo, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        print("Failed to update database with error: ", error.localizedDescription)
                        return
                    }
                    print("Succesfully added Google user's userID and email address to Firebase database!")
                    
                    // Transfer user to username retrieval screen
                    let getUsernameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetUsernameViewController")
                    self.segueFromRight()
                    UIApplication.topViewController()?.present(getUsernameVC, animated: false, completion: nil)

                })
            } else if (snapshot.exists() && !usernameExists) {
                // If snapshot returns user with associated email AND that email doesn't have a username associated with it, send the user to the username creation screen.
                // If user signs in with Google and exists in the Firebase database but doesn't have a username, take them to the username creation screen. This scenario would happen if the user signed in with a Google account but didn't have an account to begin with. If that user exits and closes the app and then tries to sign in again, instead of being taking to the home page (which would result in an error since no stats are stored for that user), a check is performed to see if they created a username before exiting. If not, that means they didn't complete the survey either so the app takes them to the proper screen (to get the user's information)
                // Transfer user to username retrieval screen
                print("Username has not been created yet for:", userID, "Segueing to username creation screen...")
                let getUsernameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetUsernameViewController")
                self.segueFromRight()
                UIApplication.topViewController()?.present(getUsernameVC, animated: false, completion: nil)
            } else { // Current user has an email and username --> Send user to home screen
                print("Email and username for:", userID, "are stored in the database. Segueing home...")
                // Transfer user to username retrieval screen
                let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
                self.segueFromTop()
                UIApplication.topViewController()?.present(homeVC, animated: false, completion: nil)
            }
        }
    }
    
    // Google login button pressed
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Google sign in error occured with error: ", error.localizedDescription)
            // TODO: - Remove googleSigninAlert before release
            let googleSigninAlert = UIAlertController(title: "Google sign in error", message: "There was an error logging in with Google: \(error.localizedDescription)", preferredStyle: .alert)
            googleSigninAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(googleSigninAlert, animated: true)
            return
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            // Asynchronously signs in to Firebase with the given 3rd-party credentials (e.g. Google, Facebook) and returns additional identity provider data
            Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
                if error == nil {
                    // TODO: - If email associated with Google account does not exist in the database, this means the user hasn't signed up yet. Segue to the username creation page (only for users signing in with Google); otherwise, if the email is associated with a Google account and exists in the database (as well as a username for that Google email address), perform the login segue
                    // TODO: - Add the Google user's email and username to the database
                    // TODO: - Handle Google login here
                    guard let email = user.profile.email else { return }
                    self.handleGoogleLogin(forUserEmail: email)
                } else {
                    print(error as Any)
                    // TODO: - Remove firebaseAsyncSigninErrorAlert before release
                    let firebaseAsyncSigninErrorAlert = UIAlertController(title: "Firebase sign in error", message: "There was an error signing in to Firebase with the given Google credentials: \(error as Any)", preferredStyle: .alert)
                    firebaseAsyncSigninErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(firebaseAsyncSigninErrorAlert, animated: true)
                }
            }
        }
    }
    
    // Email login button pressed
    @IBAction func onLoginButtonPressed(_ sender: Any) {
        handleEmailLogin()
    }
    
    // Google login button pressed
    @objc func performGoogleSignIn(_ sender: UIView) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    // This animation forces the animation to look like the right-to-left segue animation
    func segueFromRight() {
        let transition = CATransition()
        transition.duration = 0.45
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    func segueFromTop() {
        let transition = CATransition()
        transition.duration = 0.45
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
}
