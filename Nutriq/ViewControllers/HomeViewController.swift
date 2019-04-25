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
    
    
    // MARK: - API
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
    
    func signOut() {
        do {
            // TODO: - If user signed in with Google account, end their session with GIDSignIn.sharedInstance().signOut()    ; Otherwise, if user signed in with email, perform the try Auth.auth().signout() block
            try Auth.auth().signOut()
            
            self.dismiss(animated: true, completion: nil)
        } catch let error {
            print("Failed to sign out with error: ", error)
        }
    }
    
    
    
    
    // MARK: - Helper Functions & Actions
    
    @IBAction func signoutButtonPressed(_ sender: Any) {
        handleSignOut()
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
