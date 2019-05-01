//
//  SurveyPt3ViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class SurveyPt3ViewController: UIViewController {

    
    // MARK: - Properties
    
    @IBOutlet weak var loseButton: ShadowButton!
    @IBOutlet weak var gainButton: ShadowButton!
    @IBOutlet weak var maintainButton: ShadowButton!
    
  
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - Helper Functions & Actions
    
    
    @IBAction func loseButtonPressed(_ sender: Any) {
        performSegue2()
    }
    
    @IBAction func gainButtonPressed(_ sender: Any) {
        performSegue2()
    }
    
    @IBAction func maintainButtonPressed(_ sender: Any) {
        // TODO: - Remove this segue because it causes the segue to occur twice (once from the storyboard and again below. This makes the SurveyResultsViewController present twice
//        self.performSegue(withIdentifier: "maintainWeightSegue", sender: self)
    }
    
    func performSegue2() {
        self.performSegue(withIdentifier: "surveySegue2", sender: self)
    }
    


}
