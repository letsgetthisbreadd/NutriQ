//
//  SurveyPt2ViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class SurveyPt2ViewController: UIViewController {

    
    // MARK: - Properties
    
    @IBOutlet weak var notActiveBtn: ShadowButton!
    @IBOutlet weak var lightlyActiveBtn: ShadowButton!
    @IBOutlet weak var modActiveBtn: ShadowButton!
    @IBOutlet weak var veryActiveBtn: ShadowButton!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - Helper Functions & Actions
    
    @IBAction func notActiveBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
    }
    
    @IBAction func lightlyActiveBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
    }
    
    @IBAction func modActiveBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
    }
    
    @IBAction func veryActiveBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
    }
    

}
