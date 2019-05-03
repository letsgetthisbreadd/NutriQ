//
//  SurveyPt2ViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class SurveyPt2ViewController: UIViewController {

    
    // MARK: - Properties
    var activityMultiplier: Double = 0
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
        activityMultiplier = 1.2
        storeSurveyInfo(activityLevel: "Not very active", activityMultiplier: activityMultiplier)
    }

    @IBAction func lightlyActiveButtonPressed(_ sender: Any) {
        activityMultiplier = 1.375
        storeSurveyInfo(activityLevel: "Lightly active", activityMultiplier: activityMultiplier)
    }
    
    @IBAction func moderatelyActiveButtonPressed(_ sender: Any) {
        activityMultiplier = 1.55
        storeSurveyInfo(activityLevel: "Moderately active", activityMultiplier: activityMultiplier)
    }
    
    @IBAction func veryActiveButtonPressed(_ sender: Any) {
        activityMultiplier = 1.725
        storeSurveyInfo(activityLevel: "Very active", activityMultiplier: activityMultiplier)
    }
    
    func storeSurveyInfo(activityLevel: String, activityMultiplier: Double) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        // Create the health-stats object which will be added to the current user's data
        let userActivityDetails = ["activity-level": activityLevel, "activity-multiplier": activityMultiplier] as [String : Any]
        
        Database.database().reference().child("users").child(userID).child("health-stats").updateChildValues(userActivityDetails) { (error, ref) in
            if let error = error {
                print("Failed to udpate database with error: ", error.localizedDescription)
                return
            }
            print("Successfully added user's health-stats(2) to Firebase database!")
        }
        performSegue1()
    }
    
    func performSegue1() {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
    }
    

}
