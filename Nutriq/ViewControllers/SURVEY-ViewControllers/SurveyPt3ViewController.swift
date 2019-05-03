//
//  SurveyPt3ViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class SurveyPt3ViewController: UIViewController {

    
    // MARK: - Properties
    var overallGoal = ""
    @IBOutlet weak var loseWeightButton: ShadowButton!
    @IBOutlet weak var gainWeightButton: ShadowButton!
    @IBOutlet weak var maintainWeightButton: ShadowButton!
    
  
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - Helper Functions & Actions
    
    @IBAction func loseWeightButtonPressed(_ sender: Any) {
        overallGoal = "Lose"
        storeSurveyInfo("Lose")
        performSegue2()
    }
    
    @IBAction func maintainWeightButtonPressed(_ sender: Any) {
        overallGoal = "Maintain"
        storeSurveyInfo("Maintain")
    }

    @IBAction func gainWeightButtonPressed(_ sender: Any) {
        overallGoal = "Gain"
        storeSurveyInfo("Gain")
        performSegue2()
    }
    
    func storeSurveyInfo(_ overallGoal: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        var userGoal: [String : Any] = [:]
        
        // Create the health-stats object which will be added to the current user's data
        if overallGoal == "Maintain" {
            userGoal = ["overall-goal": overallGoal, "weekly-goal": 0]
        } else {
            userGoal = ["overall-goal": overallGoal]
        }
        
        Database.database().reference().child("users").child(userID).child("health-stats").updateChildValues(userGoal) { (error, ref) in
            if let error = error {
                print("Failed to udpate database with error: ", error.localizedDescription)
                return
            }
            print("Successfully added user's health-stats(3) to Firebase database!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare for segue only if "Lose weight" or "Gain weight" buttons tapped
        if segue.identifier == "surveySegue2" {
            print("Passing data to Survey Part 4 View Controller...")
            
            let surveyPt4ViewController = segue.destination as! SurveyPt4ViewController
            surveyPt4ViewController.overallGoal = overallGoal
        }
    }
    
    func performSegue2() {
        self.performSegue(withIdentifier: "surveySegue2", sender: self)
    }
    


}
