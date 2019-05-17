//
//  WelcomeViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/13/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import SwiftVideoBackground

class WelcomeViewController: UIViewController {

    
    // MARK: - Properties
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Plays the background video - See: SwiftVideoBackground in Pods folder
        try? VideoBackground.shared.play(view: view, videoName: "FoodVideo1", videoType: "mp4", isMuted: true, willLoopVideo: true)
        
        // Login persistence - send user to Home screen if already signed in
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "skipLoginSegue", sender: nil)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    

}
