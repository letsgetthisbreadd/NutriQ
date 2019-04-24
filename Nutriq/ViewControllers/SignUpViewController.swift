//
//  SignUpViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/12/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var signupButton: ShadowButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Create User
    
    func createUser(withEmail email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to sign user up with error: ", error.localizedDescription)
                let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true)
                return
            }
            
            // Get the unique userID of the current user signing up
            guard let userID = result?.user.uid else { return }
            
            let emailValue = ["email": email]
            
            // Update the database for the userID above with the email address the user entered
            Database.database().reference().child("users").child(userID).updateChildValues(emailValue, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print("Failed to updated database email value with error: ", error.localizedDescription)
                    return
                }
                print("Successfully signed user up...")
//                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "signupSegue", sender: self)
            })
            
        }
    }
    
    
    // MARK: - Helper Functions & Actions
    
    @objc func handleSignUp() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        guard let confirmPassword = confirmPasswordField.text else { return }
        
        
        if email == "" {
            print("The email field is empty. Please input an email address and try to sign up again!")
            let emptyEmailAlert = UIAlertController(title: "Empty email field", message: "The email field is empty. Please input an email address and try to sign up again.", preferredStyle: .alert)
            emptyEmailAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyEmailAlert, animated: true)
        } else if password == "" {
            print("The first password field is empty. Please input a password and try to sign up again!")
            let emptyPasswordAlert = UIAlertController(title: "Empty password field", message: "The first password field is empty. Please input a password and try to sign up again.", preferredStyle: .alert)
            emptyPasswordAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyPasswordAlert, animated: true)
        } else if confirmPassword == "" {
            print("The second password field is empty. Please input a confirmation password and try to sign up again!")
            let emptyConfirmPasswordAlert = UIAlertController(title: "Empty confirmation password field", message: "The second password field is empty. Please input a confirmation password and try to sign up again.", preferredStyle: .alert)
            emptyConfirmPasswordAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyConfirmPasswordAlert, animated: true)
        } else if password != confirmPassword {
            print("Please make sure both passwords match!")
            let passwordMismatchAlert = UIAlertController(title: "Password fields mismatch", message: "The passwords entered do not match. Make sure they match and then try to sign up again.", preferredStyle: .alert)
            passwordMismatchAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(passwordMismatchAlert, animated: true)
        } else {
            createUser(withEmail: email, password: password)
        }
    }
    
    @IBAction func onSignupButtonPressed(_ sender: Any) {
        handleSignUp()
    }

        
//    @IBAction func onSignupButtonPressed(_ sender: Any) {
//        // Make sure the password and confirmation password match
//        if passwordField.text! != "" && passwordField.text! == confirmPasswordField.text! {
//            // Sign the user up for an account
//            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
//                if error != nil {
//                    print(error!)
//                } else {
//                    print("User registration successful")
//                    self.performSegue(withIdentifier: "signupSegue", sender: self)
//                }
//            }
//        } else {
//            print("Please make sure both passwords match!")
//        }
//
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
