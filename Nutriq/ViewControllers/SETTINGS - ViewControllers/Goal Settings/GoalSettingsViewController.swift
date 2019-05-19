//
//  GoalSettingsViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/16/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class GoalSettingsViewController: UIViewController {

    
    // MARK: - Properties
    
    @IBOutlet weak var updateWeightButton: ShadowButton!
    @IBOutlet weak var updateGoalsButton: ShadowButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Goal Settings"
    }
    
    
    // MARK: - Helper Functions & Actions
    
    @IBAction func onUpdateWeightButtonPressed(_ sender: Any) {
        showUpdateWeightPopup()
    }
    
    // Pops up a small view controller which allows user to update their weight
    func showUpdateWeightPopup() {
        let updateWeightVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "UpdateWeightViewController") as! UpdateWeightViewController
        self.addChild(updateWeightVC)
        updateWeightVC.view.frame = self.view.frame
        self.view.addSubview(updateWeightVC.view)
        updateWeightVC.didMove(toParent: self)
    }
    
    
    
}
