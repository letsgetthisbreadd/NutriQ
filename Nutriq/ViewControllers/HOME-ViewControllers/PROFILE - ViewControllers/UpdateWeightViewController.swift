//
//  UpdateWeightViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/16/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class UpdateWeightViewController: UIViewController {
    
    
    // MARK: - Properties
    let currentWeight: Double = 0
    var maintenanceCalories: Int = 0
    @IBOutlet weak var currentWeightField: UITextField!
    @IBOutlet weak var popupView: UIView!
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popupView.layer.cornerRadius = 5
        showPopupView()
    }
    
    
    // MARK: - Helper Functions & Actions
    
    @IBAction func onCancelButtonPressed(_ sender: Any) {
        self.closePopupView()
    }
    
    @IBAction func onConfirmButtonPressed(_ sender: Any) {
        // Check for empty current weight field
        if currentWeightField.text == "" {
            print("The current weight field is empty. Please input your current weight and try again!")
            let emptyCurrentWeightAlert = UIAlertController(title: "Empty current weight field", message: "The current weight field is empty. Please input your current weight and try again.", preferredStyle: .alert)
            emptyCurrentWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyCurrentWeightAlert, animated: true)
            return
        }
        
        guard let currentWeight = Double(currentWeightField.text!) else { return }
        
        // Check for values too small or too large for current weight field
        if currentWeight <= 80 { // Current weight too low
            print("The current weight entered is too small. Please input a larger current weight and try again!")
            let currentWeightTooLowAlert = UIAlertController(title: "Current weight too low", message: "The current weight entered is too small. Please input a larger current weight and try again.", preferredStyle: .alert)
            currentWeightTooLowAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(currentWeightTooLowAlert, animated: true)
            return
        } else if currentWeight > 450 { // current weight too high
            print("The current weight entered is too large. Please input a smaller current weight and try again!")
            let currentWeightTooHighAlert = UIAlertController(title: "Current weight too high", message: "The current weight entered is too large. Please input a smaller current weight and try again.", preferredStyle: .alert)
            currentWeightTooHighAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(currentWeightTooHighAlert, animated: true)
            return
        }
        
        // User input validation passed; Send the current weight for storage in the Firebase Database
        recalculateGoalStats(currentWeight) {
            print("Completed recalculating goal stats. Closing update weight popup view...\n")
            self.closePopupViewAnimated()
        }

    }
    
    // Recalculate user's age, maintenance calories, goal calories, and weight left until goal; The age is recalculated because if the user constantly updates their weight, that's the best time to recalculate their age --> only other time would be when the app is loading
    func recalculateGoalStats(_ currentWeight: Double, completion: @escaping () -> ()) {
        // Male --> CaloricResults = ((9.99 * (weight * 0.45359237)) + (6.25 * (height * 2.54)) - (4.92 * age) + 5) * multiplier
        // Female -->  CaloricResults = ((9.99 * (weight * 0.45359237)) + (6.25 * (height * 2.54)) - (4.92 * age) - 161) * multiplier
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let healthStatsReference = Database.database().reference().child("users/\(userID)/health-stats")
        
        healthStatsReference.observeSingleEvent(of: .value) { (snapshot) in
            print("Snapshot of the user's health stats:\n", snapshot.value!) // Returns snapshot of all user's health stats
            
            // Get all user inputs necessary to calculate daily caloric needs from the Firebase database
            let snapshotValue = snapshot.value! as? NSDictionary
            let gender = snapshotValue?["gender"] as! String
            let height = snapshotValue?["height-inches"] as! Int
            let dateOfBirth = snapshotValue?["date-of-birth"] as! String
            let activityMultiplier = snapshotValue?["activity-multiplier"] as! Double
            let weeklyGoal = snapshotValue?["weekly-goal"] as! Double
            let oldCurrentWeight = snapshotValue?["current-weight-pounds"] as! Double
            let goalWeight = snapshotValue?["goal-weight-pounds"] as! Double
            let weightLeftUntilGoal: Double = abs(((currentWeight - goalWeight) * 10).rounded(.toNearestOrEven) / 10)
            let age = self.calculateAge(birthday: dateOfBirth)
            
            // If user's newly input current weight is the same as their old current weight, exit, not recalculating anything
            if currentWeight == oldCurrentWeight {
                print("Current weight is the same as old current weight. Not updating anything and exiting the function...\n")
                self.closePopupView()
            } else {
                print("Your age is:", age)
                
                // Calculate the user's daily caloric maintenance needs based on gender
                if gender == "Male" {
                    self.maintenanceCalories = Int(round(((9.99 * (currentWeight * 0.45359237)) + (6.25 * (Double(height) * 2.54)) - (4.92 * Double(age)) + 5) * activityMultiplier))
                } else {
                    self.maintenanceCalories = Int(round(((9.99 * (currentWeight * 0.45359237)) + (6.25 * (Double(height) * 2.54)) - (4.92 * Double(age)) - 161) * activityMultiplier))
                }
                
                print("Your daily caloric needs to maintain weight are:", self.maintenanceCalories)
                
                // Calculate the user's goal caloric maintenance based on how much weight they want to lose weekly
                print("Weekly goal is:", weeklyGoal, "and weekly goal * 500 is:", Int(round(weeklyGoal * 500)))
                let goalCalories = self.maintenanceCalories + Int(round(weeklyGoal * 500))
                print("Your daily caloric GOAL needs are:", goalCalories)
                
                completion()
                self.storeUserHealthStats(age, self.maintenanceCalories, goalCalories, currentWeight, weightLeftUntilGoal)
            }
            
            
        }
    }
    
    func storeUserHealthStats(_ age: Int, _ maintenanceCalories: Int, _ goalCalories: Int, _ currentWeight: Double, _ weightLeftUntilGoal: Double) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        // Create the objects to be stored in the health-stats object in the Firebase database
        let userHealthStats = ["age": age, "maintenance-calories": maintenanceCalories, "goal-calories": goalCalories, "current-weight-pounds": currentWeight, "weight-left-until-goal": weightLeftUntilGoal] as [String : Any]
        
        Database.database().reference().child("users/\(userID)/health-stats").updateChildValues(userHealthStats) { (error, ref) in
            if let error = error {
                print("Failed to udpate database with error:", error.localizedDescription)
                return
            }
            print("Successfully added user's updated health stats to the Firebase database!")
            return
        }
    }
        
    func calculateAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    // Show animation for "Update Weight" popup
    func showPopupView() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func closePopupView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
    
    // Close animation for "Update Weight" popup
    func closePopupViewAnimated() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
                
                // Update the changed values on the profile screen
                profileVCInstance.currentWeightLabel.alpha = 0

                if profileVCInstance.progressMessageLabel.text == "" {
                    profileVCInstance.progressMessageLabel.alpha = 0
                }
                
                profileVCInstance.maintenanceCaloriesLabel.alpha = 0
                profileVCInstance.goalCaloriesLabel.alpha = 0
                profileVCInstance.getAndLoadUserData()
            }
        }
    }
}
