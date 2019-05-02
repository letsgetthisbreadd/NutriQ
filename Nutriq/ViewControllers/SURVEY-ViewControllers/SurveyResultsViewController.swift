//
//  SurveyResultsViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class SurveyResultsViewController: UIViewController {

    
    // MARK: - Properties
    var goalCalories: Int = 0
    @IBOutlet weak var goalCaloriesLabel: UILabel!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the user email label transparent for a nice transition
        goalCaloriesLabel.alpha = 0
        displayGoalCalories()

    }
    
    func displayGoalCalories() {
        self.goalCaloriesLabel.text = "\(goalCalories) calories"
        
        UIView.animate(withDuration: 0.5, animations: {
            self.goalCaloriesLabel.alpha = 1
        })
    }

}
