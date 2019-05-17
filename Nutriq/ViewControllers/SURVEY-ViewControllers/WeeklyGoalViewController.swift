//
//  WeeklyGoalViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/16/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class WeeklyGoalViewController: UIViewController {

    // MARK: - Properties
    
    var overallGoal = ""
    var weeklyGoal: Double = 0
    @IBOutlet weak var halfPoundButton: ShadowButton!
    @IBOutlet weak var onePoundButton: ShadowButton!
    @IBOutlet weak var oneAndHalfPoundButton: ShadowButton!
    @IBOutlet weak var twoPoundButton: ShadowButton!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prependOverallGoalToButtons(with: overallGoal)
        
        if overallGoal == "Lose" { // Set weekly goal to negative for losing weight
            weeklyGoal = -1
        } else if overallGoal == "Gain" { // Set weekly goal to positive for gaining weight
            weeklyGoal = 1
        }
        
    }
    
    // MARK: - Helper Functions & Actions
    
    @IBAction func halfPoundButtonPressed(_ sender: Any) {
        storeSurveyInfo(weeklyGoalOf: weeklyGoal * 0.5)
    }
    
    @IBAction func onePoundButtonPressed(_ sender: Any) {
        storeSurveyInfo(weeklyGoalOf: weeklyGoal * 1)
    }
    
    @IBAction func oneAndHalfPoundButtonPressed(_ sender: Any) {
        storeSurveyInfo(weeklyGoalOf: weeklyGoal * 1.5)
    }
    
    @IBAction func twoPoundButtonPressed(_ sender: Any) {
        storeSurveyInfo(weeklyGoalOf: weeklyGoal * 2)
    }
    
    // Prepend user's overall goal to the beginning of each button on the screen
    func prependOverallGoalToButtons(with overallGoal: String) {
        halfPoundButton.setTitle(overallGoal + " " + halfPoundButton.titleLabel!.text!, for: .normal)
        onePoundButton.setTitle(overallGoal + " " + onePoundButton.titleLabel!.text!, for: .normal)
        oneAndHalfPoundButton.setTitle(overallGoal + " " + oneAndHalfPoundButton.titleLabel!.text!, for: .normal)
        twoPoundButton.setTitle(overallGoal + " " + twoPoundButton.titleLabel!.text!, for: .normal)
    }
    
    func storeSurveyInfo(weeklyGoalOf weeklyGoal: Double) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let healthStatsReference = Database.database().reference().child("users/\(userID)/health-stats")
        
        let userWeeklyGoal = ["weekly-goal": weeklyGoal]
        
        healthStatsReference.updateChildValues(userWeeklyGoal) { (error, ref) in
            if let error = error {
                print("Failed to update database with error: ", error.localizedDescription)
                return
            }
            print("Successfully added user's weekly goal to the Firebase database!")
        }
        segueToSurveyResults()
    }
    
    
    // MARK: - Navigation
    
    func segueToSurveyResults() {
        print("Segueing to SurveyResultsViewController...")
        self.performSegue(withIdentifier: "weeklyGoalToSurveyResultsSegue", sender: self)
    }
    
}
