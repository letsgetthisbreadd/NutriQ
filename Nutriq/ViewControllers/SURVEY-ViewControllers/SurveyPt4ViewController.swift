//
//  SurveyPt4ViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class SurveyPt4ViewController: UIViewController {
    
    
    // MARK: - Properties
    var overallGoal = ""
    var weeklyGoal: Double = 0
    var maintenanceCalories: Int = 0
    var goalCalories: Int = 0
    var age: Int = 0
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
            print("Successfully added user's health-stats(4) to Firebase database!")
        }
        
        
        // Calculate user's daily caloric needs and store them in the Firebase database
        calculateDailyCaloricNeeds()
        
    }
    
    func calculateDailyCaloricNeeds() {
       // Male --> CaloricResults = ((9.99 * (weight * 0.45359237)) + (6.25 * (height * 2.54)) - (4.92 * age) + 5) * multiplier
       // Female -->  CaloricResults = ((9.99 * (weight * 0.45359237)) + (6.25 * (height * 2.54)) - (4.92 * age) - 161) * multiplier
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let healthStatsReference = Database.database().reference().child("users/\(userID)/health-stats")
        
        healthStatsReference.observeSingleEvent(of: .value) { (snapshot) in
            print("Snapshot of the user's health stats:\n", snapshot.value!) // Returns snapshot of all user's health stats
            
            // Get all user inputs necessary to calculate daily caloric needs from the Firebase database
            let snapshotValue = snapshot.value! as? NSDictionary
            let gender = snapshotValue?["gender"] as! String
            let weight = snapshotValue?["weight-pounds"] as! Double
            let height = snapshotValue?["height-inches"] as! Int
            let dateOfBirth = snapshotValue?["date-of-birth"] as! String
            let activityMultiplier = snapshotValue?["activity-multiplier"] as! Double
            let weeklyGoal = snapshotValue?["weekly-goal"] as! Double
            self.age = self.calculateAge(birthday: dateOfBirth)
            
            print("Your age is:", self.age)
            
            // Calculate the user's daily caloric maintenance needs based on gender
            if gender == "Male" {
                self.maintenanceCalories = Int(round(((9.99 * (weight * 0.45359237)) + (6.25 * (Double(height) * 2.54)) - (4.92 * Double(self.age)) + 5) * activityMultiplier))
            } else {
                self.maintenanceCalories = Int(round(((9.99 * (weight * 0.45359237)) + (6.25 * (Double(height) * 2.54)) - (4.92 * Double(self.age)) - 161) * activityMultiplier))
            }
            print("Your daily caloric needs to maintain weight are:", self.maintenanceCalories)
            
            // Calculate the user's goal caloric maintenance based on how much weight they want to lose weekly
            print("Weekly goal is: ", weeklyGoal, "and weekly goal * 500 is:", Int(round(weeklyGoal * 500)))
            self.goalCalories = self.maintenanceCalories + Int(round(weeklyGoal * 500))
            print("Your daily caloric GOAL needs are:", self.goalCalories)
            
            self.storeSurveyInfo(self.age, self.maintenanceCalories, self.goalCalories)
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
    
    func storeSurveyInfo(_ age: Int, _ maintenanceCalories: Int, _ goalCalories: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        // Create the objects to be stored in the health-stats object in the Firebase database
        let ageAndCalorieDetails = ["age": age, "maintenance-calories": maintenanceCalories, "goal-calories": goalCalories]
        
        Database.database().reference().child("users").child(userID).child("health-stats").updateChildValues(ageAndCalorieDetails) { (error, ref) in
            if let error = error {
                print("Failed to udpate database with error: ", error.localizedDescription)
                return
            }
            print("Successfully added user's health-stats(4) to Firebase database!")
        }
        
        performSegue3()
    }
    
    func performSegue3() {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Passing data to Survey Results View Controller...")
        
        let surveyResultsViewController = segue.destination as! SurveyResultsViewController
        surveyResultsViewController.goalCalories = goalCalories
    }

}


//func storeSurveyInfo(_ goal: String) {
//    guard let userID = Auth.auth().currentUser?.uid else { return }
//
//    // Create the health-stats object which will be added to the current user's data
//    let userGoal = ["overall-goal": goal]
//

//}
