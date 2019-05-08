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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc func handleSignOut() {
        let signOutAlertController = UIAlertController(title:nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        
        signOutAlertController.addAction(UIAlertAction(title:"Sign Out", style: .destructive, handler: { (_) in self.signOut()
            
        }))
        
        signOutAlertController.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
        present(signOutAlertController, animated: true, completion: nil)
    }
    
    
    func signOut() {
        GIDSignIn.sharedInstance()?.signOut()
        
        do {
            try Auth.auth().signOut()
            self.takeUserToUsernameScreen()
        } catch let error {
            print("Failed to sign out with error: ", error.localizedDescription)
        }
    }
    
    func takeUserToUsernameScreen() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
        self.segueToBottom()
        UIApplication.topViewController()?.present(loginVC, animated: false, completion: nil)
    }
    
    func segueToBottom() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    @IBAction func onLogoutBtnPressed(_ sender: Any) {
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
