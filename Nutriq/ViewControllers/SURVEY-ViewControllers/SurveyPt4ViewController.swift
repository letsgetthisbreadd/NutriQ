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

    @IBOutlet weak var halfPoundButton: ShadowButton!
    @IBOutlet weak var onePoundButton: ShadowButton!
    @IBOutlet weak var oneAndHalfPoundButton: ShadowButton!
    @IBOutlet weak var twoPoundButton: ShadowButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - Helper Functions & Actions

    @IBAction func halfPoundButtonPressed(_ sender: Any) {
        performSegue3()
    }
    
    @IBAction func onePoundButtonPressed(_ sender: Any) {
        performSegue3()
    }
    
    @IBAction func oneAndHalfPoundButtonPressed(_ sender: Any) {
        performSegue3()
    }
    
    @IBAction func twoPoundButtonPressed(_ sender: Any) {
        performSegue3()
    }
    
    func performSegue3() {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
    }

}
