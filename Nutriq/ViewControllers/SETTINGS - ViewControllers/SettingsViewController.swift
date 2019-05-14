//
//  SettingsViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 5/6/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingsViewController: UIViewController {

    
    // MARK: - Properties
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Helper Functions & Actions
    
    @IBAction func onLogoutButtonPressed(_ sender: Any) {
        handleSignOut()
    }
    
    // Sign user out - works for BOTH Google and email sign out
    func signOut() {
        GIDSignIn.sharedInstance().signOut() // Google sign out
        do {
            // TODO: - Before release, check to make sure that not checking which sign out is occuring will not impact the app in any way
            try Auth.auth().signOut() // Email sign out
            self.takeUserToLoginScreen()
        } catch let error {
            print("Failed to sign out with error: ", error.localizedDescription)
        }
    }
    
    @objc func handleSignOut() {
        let signOutAlertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        signOutAlertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        signOutAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(signOutAlertController, animated: true, completion: nil)
    }
    
    func takeUserToLoginScreen() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.segueToBottom()
        UIApplication.topViewController()?.present(loginVC, animated: false, completion: nil)
    }
    
    // Top-to-bttom segue animation
    func segueToBottom() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }

}
