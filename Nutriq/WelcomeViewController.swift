//
//  WelcomeViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/13/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import WebKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var webViewBG: WKWebView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        signupButton.layer.cornerRadius = 5

        
        
// ************************************************** BACKGROUND GIF/VIDEO***************************************************************** //
        let htmlPath = Bundle.main.path(forResource: "WebViewContent", ofType: "html")
        let htmlURL = URL(fileURLWithPath: htmlPath!)
        let html = try? Data(contentsOf: htmlURL)
        self.webViewBG.load(html!, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: htmlURL.deletingLastPathComponent())

        
        
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
