//
//  LoginViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/12/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: ShadowButton!
    
    // MARK: - Properties
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.becomeFirstResponder()
        
    }
    
    
    // MARK: - User Login    
    func logUserIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to sign user in with error: ", error.localizedDescription)
                return
            }
            print("Successfully logged user in...")
//            self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func onLoginButtonPressed(_ sender: Any) {
        handleLogin()
    }

    
    
    
    
    
    
//    func signInUser(email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            if error == nil {
//                // User is now signed in
//                print("User is signed in")
//                self.userDefaults.set(true, forKey: "usersignedin")
//                self.userDefaults.synchronize()
//                self.performSegue(withIdentifier: "loginSegue", sender: self)
//            } else if (error?._code == AuthErrorCode.userNotFound.rawValue) {
//                self.createUser(email: email, password: password)
//            } else {
//                print(error as Any)
//            }
//        }
//    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
