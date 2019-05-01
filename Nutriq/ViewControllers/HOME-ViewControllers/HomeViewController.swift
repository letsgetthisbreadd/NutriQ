//
//  HomeViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 4/24/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the label transparent for a nice transition
        userEmailLabel.alpha = 0
        loadUserData()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleSignOut() {
        let signOutAlertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        signOutAlertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        signOutAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(signOutAlertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Helper Functions & Actions
    // TODO: - If user used Google sign in, set the welcome page to display their email
    // TODO: - Future TODO --> Possibly use username to welcome the user instead of thier email?
    func loadUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(userID).child("email").observeSingleEvent(of: .value) { (snapshot) in
            guard let username = snapshot.value as? String else { return }
            self.userEmailLabel.text = "Welcome, \(username)"
            
            UIView.animate(withDuration: 0.5, animations: {
                self.userEmailLabel.alpha = 1
            })
        }
    }
    
    // Sign user out - works for BOTH Google and email sign out
    func signOut() {
        GIDSignIn.sharedInstance().signOut() // Google sign out
        do {
            // TODO: - Before release, check to make sure that not checking which sign out is occuring will not impact the app in any way
            try Auth.auth().signOut() // Email sign out
            self.takeUserToUsernameScreen()
        } catch let error {
            print("Failed to sign out with error: ", error.localizedDescription)
        }
    }
    
    @IBAction func signoutButtonPressed(_ sender: Any) {
        handleSignOut()
    }
    
    func takeUserToUsernameScreen() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.segueToBottom()
        UIApplication.topViewController()?.present(loginVC, animated: false, completion: nil)
    }
    
    // Right-to-left segue animation
    func segueToBottom() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    

}
