//
//  SurveyPt4ViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class SurveyPt4ViewController: UIViewController {
    
    
    // MARK: - Properties

    @IBOutlet weak var lbsButton05: ShadowButton!
    @IBOutlet weak var lbsButton1: ShadowButton!
    @IBOutlet weak var lbsButton15: ShadowButton!
    @IBOutlet weak var lbsButton2: ShadowButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - Helper Functions & Actions
    
    @IBAction func lbsButton05Press(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
    }
    
    @IBAction func lbsButton1Press(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
    }
    
    @IBAction func lbsButton15Press(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
    }
    
    @IBAction func lbsButton2Press(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
    }
    

}
