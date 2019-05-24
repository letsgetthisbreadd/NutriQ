//
//  HealthStatsViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/16/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

//
//  SurveyViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/12/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class HealthStatsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    // MARK: - Properties
    
    var overallGoal = ""
    var dietPref = ""
    let weeklyGoal: Double = 0
    private var datePicker: UIDatePicker?
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var heightFeetTextField: UITextField!
    @IBOutlet weak var heightInchesTextField: UITextField!
    @IBOutlet weak var beginningWeightTextField: UITextField!
    @IBOutlet weak var goalWeightTextField: UITextField!
    @IBOutlet weak var dietPrefTextField: UITextField!
    
    
    var dietPicker = UIPickerView()
    let dietPickerValues = ["", "Vegetarian", "Paleo", "Keto", "Vegan", "Low Carb" ]
    let dietValues = ["", "vegetarian", "paleo", "keto", "vegan", "low+carb" ]
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dietPicker.dataSource = self
        dietPicker.delegate  = self
        dietPrefTextField.inputView = dietPicker
        
        // Configures the Date Picker to have a 'done' button
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(HealthStatsViewController.dateChanged(datePicker:)), for: .valueChanged)
        dobTextField.inputView = datePicker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(HealthStatsViewController.dismissPicker))
        dobTextField.inputAccessoryView = toolBar
        dietPrefTextField.inputAccessoryView = toolBar
    }
    
    
    // MARK: - Date Picker Helper Functions
    
    @objc func dismissPicker() {
        view.endEditing(true)
        
    }
    
    // Formats the date properly
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dobTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    // MARK: - Helper Functions & Actions
    
    @IBAction func onRightArrowPressed(_ sender: Any) {
        validateUserSurveyInput()
    }
    
    func validateUserSurveyInput() {
        if dobTextField.text == "" { // Empty date of birth field
            print("The date of birth field is empty. Please input your date of birth and try again!")
            let emptyDateOfBirthAlert = UIAlertController(title: "Empty date of birth field", message: "The date of birth field is empty. Please input your date of birth and try again.", preferredStyle: .alert)
            emptyDateOfBirthAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyDateOfBirthAlert, animated: true)
            return
        } else if heightFeetTextField.text == "" { // Empty height in feet field
            print("The height in feet field is empty. Please input your height in feet and try again!")
            let emptyHeightFeetAlert = UIAlertController(title: "Empty height in feet field", message: "The height in feet field is empty. Please input your height in feet and try again.", preferredStyle: .alert)
            emptyHeightFeetAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyHeightFeetAlert, animated: true)
            return
        } else if heightInchesTextField.text == "" { // Empty height in inches field
            print("The height in inches field is empty. Please input your height in inches and try again!")
            let emptyHeightInchesAlert = UIAlertController(title: "Empty height in inches field", message: "The height in inches field is empty. Please input your height in inches and try again.", preferredStyle: .alert)
            emptyHeightInchesAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyHeightInchesAlert, animated: true)
            return
        } else if beginningWeightTextField.text == "" { // Empty weight field
            print("The current weight field is empty. Please input your current weight in pounds and try again!")
            let emptybeginningWeightAlert = UIAlertController(title: "Empty current weight field", message: "The current weight field is empty. Please input your current weight in pounds and try again.", preferredStyle: .alert)
            emptybeginningWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptybeginningWeightAlert, animated: true)
            return
        } else if goalWeightTextField.text == "" { // Empty weight field
            print("The goal weight field is empty. Please input your goal weight in pounds and try again!")
            let emptyGoalWeightAlert = UIAlertController(title: "Empty goal weight field", message: "The goal weight field is empty. Please input your goal weight in pounds and try again.", preferredStyle: .alert)
            emptyGoalWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyGoalWeightAlert, animated: true)
            return
        }
        
        // User input validation partially passed. Begin storing
        let genders = ["Male", "Female"]
        let gender = genders[genderPicker.selectedSegmentIndex]
        guard let dateOfBirth = dobTextField.text else { return }
        guard let heightInFeet = Int(heightFeetTextField.text!) else { return }
        guard let heightInInches = Int(heightInchesTextField.text!) else { return }
        let totalHeight = heightInFeet * 12 + heightInInches
        guard let beginningWeight = Double(beginningWeightTextField.text!) else { return }
        let currentWeight = beginningWeight
        guard let goalWeight = Double(goalWeightTextField.text!) else { return }
        let weightLeftUntilGoal: Double
        
        // Finish user input validation
        if heightInInches > 11 { // Height in inches value too large
            print("The inches field cannot be higher than 11 inches! Please input your height in inches and try again!")
            let inchesTooLargeAlert = UIAlertController(title: "Height in inches too large", message: "The inches field cannot be higher than 11 inches! Please input your height in inches and try again.", preferredStyle: .alert)
            inchesTooLargeAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(inchesTooLargeAlert, animated: true)
            return
        } else if beginningWeight <= 80 { // Weight too low
            print("The current weight entered is too small. Please input a larger current weight and try again!")
            let beginningWeightTooLowAlert = UIAlertController(title: "Current weight too low", message: "The current weight entered is too small. Please input a larger current weight and try again.", preferredStyle: .alert)
            beginningWeightTooLowAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(beginningWeightTooLowAlert, animated: true)
            return
        } else if goalWeight <= 80 { // Goal weight too low
            print("The goal weight entered is too small. Please input a larger goal weight and try again!")
            let goalWeightTooLowAlert = UIAlertController(title: "Goal weight too low", message: "The goal weight entered is too small. Please input a larger goal weight and try again.", preferredStyle: .alert)
            goalWeightTooLowAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(goalWeightTooLowAlert, animated: true)
            return
        } else if goalWeight > 450 { // Goal weight too high
            print("The goal weight entered is too large. Please input a smaller goal weight and try again!")
            let goalWeightTooHighAlert = UIAlertController(title: "Goal weight too high", message: "The goal weight entered is too large. Please input a smaller goal weight and try again.", preferredStyle: .alert)
            goalWeightTooHighAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(goalWeightTooHighAlert, animated: true)
            return
        }
        
        // Get weight left until goal as well as user's overall goal
        if beginningWeight < goalWeight { // User wants to gain weight
            weightLeftUntilGoal = ((goalWeight - beginningWeight) * 10).rounded(.toNearestOrEven) / 10
            overallGoal = "Gain"
        } else if beginningWeight > goalWeight { // User wants to lose weight
            weightLeftUntilGoal = ((beginningWeight - goalWeight) * 10).rounded(.toNearestOrEven) / 10
            overallGoal = "Lose"
        } else { // User wants to maintain weight
            weightLeftUntilGoal = 0
            overallGoal = "Maintain"
        }
        
        // TODO: - Add date validation (format and age over 18 years old)
        
        // User input validation passed; Send the inputs for storage in the Firebase database
        storeSurveyInfo(gender: gender, dateOfBirth: dateOfBirth, totalHeight: totalHeight, beginningWeight: beginningWeight, goalWeight: goalWeight, currentWeight: currentWeight, weightLeftUntilGoal: weightLeftUntilGoal, overallGoal: overallGoal, weeklyGoal: weeklyGoal, dietPref: dietPref)
        
        
    }
    
    func storeSurveyInfo(gender: String, dateOfBirth: String, totalHeight: Int, beginningWeight: Double, goalWeight: Double, currentWeight: Double, weightLeftUntilGoal: Double, overallGoal: String, weeklyGoal: Double, dietPref: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        
        // Create the health-stats object which will be added to the current user's data
        let userHealthStats = ["health-stats": ["gender": gender, "date-of-birth": dateOfBirth, "height-inches": totalHeight, "beginning-weight-pounds": beginningWeight, "goal-weight-pounds": goalWeight, "current-weight-pounds": currentWeight, "weight-left-until-goal": weightLeftUntilGoal, "overall-goal": overallGoal, "weekly-goal": weeklyGoal, "diet-preference": dietPref]]
        
        Database.database().reference().child("users").child(userID).updateChildValues(userHealthStats) { (error, ref) in
            if let error = error {
                print("Failed to udpate database with error: ", error.localizedDescription)
                return
            }
            print("Successfully added user's health stats and goals to the Firebase database!")
        }
        
    }
    
    // MARK: - UIPickerView Protocol Stubs & Helper Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dietPicker {
            print(dietPickerValues.count)
            return dietPickerValues.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dietPicker {
            if row == 0 {
                return ""
            } else {
                return "\(dietPickerValues[row])"
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dietPicker {
            if row == 0 {
                dietPrefTextField.text = dietPickerValues[row]
                self.dietPref = dietValues[row]
            } else {
                dietPrefTextField.text = "\(dietPickerValues[row])"
                self.dietPref = dietValues[row]
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare for segue only if "Lose weight" or "Gain weight" buttons tapped
        if segue.identifier == "healthStatsToActivityLevelSegue" {
            print("Passing data to ActivityLevelViewController...")
            
            let activityLevelViewController = segue.destination as! ActivityLevelViewController
            activityLevelViewController.overallGoal = overallGoal
        }
    }
    
    
}

