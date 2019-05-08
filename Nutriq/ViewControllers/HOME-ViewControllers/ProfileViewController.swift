//
//  ProfileViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 5/1/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the label transparent for a nice transition
        userEmailLabel.alpha = 0
        loadUserData()
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
    
    /*
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
