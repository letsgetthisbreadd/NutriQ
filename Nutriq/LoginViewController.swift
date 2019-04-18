//
//  LoginViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/12/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.becomeFirstResponder()
        
        if (FirebaseApp.app() == nil) {
            FirebaseApp.configure()
        }
        
        // FirebaseUI sign in flow
        let authUI = FUIAuth.defaultAuthUI()
        authUI!.delegate = self as? FUIAuthDelegate
        
        // Set the UI delegate of the GIDSignIn object
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
//        // Retrieve the credentials of a user who previously logged in
//        if Auth.auth().currentUser != nil {
//            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
//        }
    }
    

    @IBAction func onLoginButtonPressed(_ sender: Any) {
        // TODO:
        // Implement segue via login button
        
    }

    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
