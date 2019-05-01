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
    
    @IBOutlet weak var notActiveButton: ShadowButton!
    @IBOutlet weak var lightlyActiveButton: ShadowButton!
    @IBOutlet weak var moderatelyActiveButton: ShadowButton!
    @IBOutlet weak var veryActiveButton: ShadowButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - Helper Functions & Actions

    @IBAction func notVeryActiveButtonPressed(_ sender: Any) {
        performSegue1()
    }

    @IBAction func lightlyActiveButtonPressed(_ sender: Any) {
        performSegue1()
    }
    
    @IBAction func moderatelyActiveButtonPressed(_ sender: Any) {
        performSegue1()
    }
    
    @IBAction func veryActiveButtonPressed(_ sender: Any) {
        performSegue1()
    }
    
    func performSegue1() {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
    }
    

}
