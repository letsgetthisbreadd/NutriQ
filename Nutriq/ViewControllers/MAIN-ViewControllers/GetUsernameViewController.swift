//
//  GetUsernameViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 4/26/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class GetUsernameViewController: UIViewController {

    
    // MARK: - Properties
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var continueButton: ShadowButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.becomeFirstResponder()
        
    }
    
    
    // MARK: - Helper Functions and Actions
    
    @IBAction func onContinueButtonPressed(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let username = usernameField.text else { return }
        // If username field isn't empty and username is unique to the database, send user to survey
        if username != "" {
            Database.database().reference().child("users").queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot.value!) // Snapshot of the keys/values in DB that have matching username
                
                if (!snapshot.exists()) {
                    print("Username:", username, "does not exist in the Firebase database. Updating the database...")
                    
                    let userInfo = ["username": username]
                    
                    Database.database().reference().child("users").child(userID).updateChildValues(userInfo, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            print("Failed to update database with error: ", error.localizedDescription)
                            return
                        }
                        UserDefaults.standard.set(username, forKey: "username") // Store the username in UserDefaults
                        self.performSegue(withIdentifier: "usernameToSurveySegue", sender: self)
                    })
                } else {
                    let usernameTakenAlert = UIAlertController(title: "Username already taken", message: "The username you entered is already taken by another user. Please input another username and try to sign up again.", preferredStyle: .alert)
                    usernameTakenAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(usernameTakenAlert, animated: true)
                    return
                }
            }
        } else {
            let emptyUsernameFieldAlert = UIAlertController(title: "Empty username field", message: "The username field is empty. Please input a username and try to sign up again.", preferredStyle: .alert)
            emptyUsernameFieldAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyUsernameFieldAlert, animated: true)
            return
        }
    }
    
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
}
