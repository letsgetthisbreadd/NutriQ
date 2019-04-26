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

class WelcomeViewController: UIViewController {

    @IBOutlet weak var webViewBG: WKWebView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Login persistence - send user to Home screen if already signed in
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "skipLoginSegue", sender: nil)
        }

//        // Background GIF/Video
//        let htmlPath = Bundle.main.path(forResource: "WebViewContent", ofType: "html")
//        let htmlURL = URL(fileURLWithPath: htmlPath!)
//        let html = try? Data(contentsOf: htmlURL)
//        self.webViewBG.load(html!, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: htmlURL.deletingLastPathComponent())
        
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
