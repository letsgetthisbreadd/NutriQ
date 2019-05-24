//
//  UpdateGoalsViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 5/17/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class UpdateGoalsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    // MARK: - Properties
    
    var currentOverallGoal = ""
    var newOverallGoal = ""
    var currentWeeklyGoal : Double = 0.0
    var newWeeklyGoal: Double = 0.0
    var currentGoalWeight: Double = 0.0
    var currentWeight: Double = 0.0
//    var newGoalWeight: Double = 0.0
    var activityLevel = ""
    
//    var weeklyGoalSelectedRow = 0
    var loseGainWeeklyGoalSelectedRow = 0
    var maintainWeeklyGoalSelectedRow = 0
    
    @IBOutlet weak var goalsAndStatsView: GradientView!
    @IBOutlet weak var overallGoalLabel: UILabel!
    @IBOutlet weak var weeklyGoalLabel: UILabel!
    @IBOutlet weak var goalWeightLabel: UILabel!
    @IBOutlet weak var activityLevelLabel: UILabel!
    @IBOutlet weak var overallGoalTextField: UITextField!
    @IBOutlet weak var weeklyGoalTextField: UITextField!
    @IBOutlet weak var activityLevelTextField: UITextField!
    @IBOutlet weak var goalWeightTextField: UITextField!
    
    var overallGoalPicker = UIPickerView()
    var weeklyGoalPicker = UIPickerView()
    var activityLevelPicker = UIPickerView()
    
    let overallGoalsPickerValues = ["", "Lose", "Gain", "Maintain"]
    let weeklyGoalsPickerValues = ["", "0.5 lbs per week", "1 lb per week", "1.5 lbs per week", "2 lbs per week"]
    let maintainWeightGoalsPickerValues = ["", "Maintain Weight"]
    let activityLevelsPickerValues = ["", "Not very active", "Lightly active", "Moderately active", "Very active"]
    
    let overallGoalValues = ["", "Lose", "Maintain", "Gain"]
    let weeklyGoalValues = [0.5, 1, 1.5, 2]
    let activityLevelValues = ["", "Not very active", "Lightly active", "Moderately active", "Very active"]
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overallGoalLabel.alpha = 0.0
        weeklyGoalLabel.alpha = 0.0
        activityLevelLabel.alpha = 0.0
        goalWeightLabel.alpha = 0.0
        
        goalsAndStatsView.layer.cornerRadius = 5.0
        
        getUserData {
            print("User data retrieved successfully!")
        }
        
        // Set dataSource and delegate of all UIPickerViews
        overallGoalPicker.dataSource = self
        overallGoalPicker.delegate = self
        weeklyGoalPicker.dataSource = self
        weeklyGoalPicker.delegate = self
        activityLevelPicker.dataSource = self
        activityLevelPicker.delegate = self
        
        // Assign the UIPickerViews as inputs to their respective text fields
        overallGoalTextField.inputView = overallGoalPicker
        weeklyGoalTextField.inputView = weeklyGoalPicker
        activityLevelTextField.inputView = activityLevelPicker
        
        // Add toolbar to all UIPickerView
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(UpdateGoalsViewController.dismissPicker))
        overallGoalTextField.inputAccessoryView = toolBar
        weeklyGoalTextField.inputAccessoryView = toolBar
        activityLevelTextField.inputAccessoryView = toolBar
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(goalWeightTextField.endEditing(_:))))
        
    }
    
    
    // MARK: - Helper Functions & Actions
    
    func getUserData(completion: @escaping () -> ()) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let healthStatsReference = Database.database().reference().child("users/\(userID)/health-stats")
        
        healthStatsReference.observeSingleEvent(of: .value) { (snapshot) in
            print("Snapshot of the user's information:\n", snapshot.value!) // Returns snapshot of all user's health information (everything under health-stats)
            let snapshotValue = snapshot.value! as? NSDictionary
            
            self.currentOverallGoal = snapshotValue?["overall-goal"] as! String
            self.currentWeeklyGoal = snapshotValue?["weekly-goal"] as! Double
            self.newWeeklyGoal = snapshotValue?["weekly-goal"] as! Double
            self.activityLevel = snapshotValue?["activity-level"] as! String
            self.currentWeight = snapshotValue?["current-weight-pounds"] as! Double
            self.currentGoalWeight = snapshotValue?["goal-weight-pounds"] as! Double
            
            
            // Set up attributed string variables (these are for adding attributes to part of a string)
            var normalLabelText = ""
            var boldLabelText = ""
            
            // Set "Overall Goal" label
            boldLabelText = "Overall Goal"
            normalLabelText = " - \(self.currentOverallGoal) weight"
            var normalAttributedString = NSMutableAttributedString(string: normalLabelText)
            var boldString = NSMutableAttributedString(string: boldLabelText, attributes: [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Semibold", size: 20.0)!])
            boldString.append(normalAttributedString)
            self.overallGoalLabel.attributedText = boldString
            
            // Set "Weekly Goal" label
            boldLabelText = "Weekly Goal"
            if self.currentOverallGoal == "Maintain" {
                normalLabelText = " - Maintain weekly weight"
                normalAttributedString = NSMutableAttributedString(string: normalLabelText)
                boldString = NSMutableAttributedString(string: boldLabelText, attributes: [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Semibold", size: 20.0)!])
                boldString.append(normalAttributedString)
                self.weeklyGoalLabel.attributedText = boldString
            } else {
                normalLabelText = " - \(self.currentOverallGoal) \(abs(self.newWeeklyGoal)) pounds per week"
                normalAttributedString = NSMutableAttributedString(string: normalLabelText)
                boldString = NSMutableAttributedString(string: boldLabelText, attributes: [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Semibold", size: 20.0)!])
                boldString.append(normalAttributedString)
                self.weeklyGoalLabel.attributedText = boldString
            }
            
            // Set "Activity Level" label
            boldLabelText = "Activity Level"
            normalLabelText = " - \(self.activityLevel)"
            normalAttributedString = NSMutableAttributedString(string: normalLabelText)
            boldString = NSMutableAttributedString(string: boldLabelText, attributes: [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Semibold", size: 20.0)!])
            boldString.append(normalAttributedString)
            self.activityLevelLabel.attributedText = boldString
            
            
            // Set "Goal Weight" label
            boldLabelText = "Goal Weight"
            normalLabelText = " - \(self.currentGoalWeight) pounds"
            normalAttributedString = NSMutableAttributedString(string: normalLabelText)
            boldString = NSMutableAttributedString(string: boldLabelText, attributes: [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Semibold", size: 20.0)!])
            boldString.append(normalAttributedString)
            self.goalWeightLabel.attributedText = boldString
           
            // Animate the labels
            UIView.animate(withDuration: 0.5, animations: {
                self.overallGoalLabel.alpha = 1.0
                self.weeklyGoalLabel.alpha = 1.0
                self.activityLevelLabel.alpha = 1.0
                self.goalWeightLabel.alpha = 1.0
            })
            
            if (self.currentOverallGoal == "Maintain" && self.overallGoalTextField.text == "") {
                self.goalWeightTextField.isUserInteractionEnabled = false
            }
            
            completion()
        }
    }
    
    func validateUserInputs(completion: @escaping () -> ()) {
        
        
        if overallGoalTextField.text == "" && weeklyGoalTextField.text == "" && activityLevelTextField.text == "" && goalWeightTextField.text == "" { // If all fields blank
            print("The update of goals and stats failed because all fields are blank!")
            let allTextFieldsBlankAlert = UIAlertController(title: "Update Failed", message: "The update of goals and stats failed because all fields are blank.", preferredStyle: .alert)
            allTextFieldsBlankAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(allTextFieldsBlankAlert, animated: true)
            return
        } else if newOverallGoal == currentOverallGoal && weeklyGoalTextField.text == "" {
            print("The update of goals and stats failed because the new overall goal is the same as the current overall goal! Either change the overall goal or weekly goal to a different value!")
            let sameOverallGoalEmptyWeeklyGoalAlert = UIAlertController(title: "Update Failed", message: "The update of goals and stats failed because the new overall goal is the same as the current overall goal. Either change the overall goal to a different one or select a new weekly goal that doesn't match your current weekly goal.", preferredStyle: .alert)
            sameOverallGoalEmptyWeeklyGoalAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(sameOverallGoalEmptyWeeklyGoalAlert, animated: true)
            return
        } else if newWeeklyGoal == currentWeeklyGoal && weeklyGoalTextField.text != "" {
            print("The update of goals and stats failed because the new weekly goal chosen is the same as the current one!")
            let sameNewAndCurrentWeeklyGoalAlert = UIAlertController(title: "Update Failed", message: "The update of goals and stats failed because the new weekly goal chosen is the same as the current one.", preferredStyle: .alert)
            sameNewAndCurrentWeeklyGoalAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(sameNewAndCurrentWeeklyGoalAlert, animated: true)
            return
        } else if newOverallGoal == "Lose"  {
            
        } else if activityLevelTextField.text != "" && activityLevel == activityLevelTextField.text { // If activityLevel text field isn't blank, make sure the new activityLevel isn't the same as the current one
            print("The update of goals and stats failed because the new activity level chosen is the same as the current one!")
            let sameNewAndCurrentActivityLevelAlert = UIAlertController(title: "Update Failed", message: "The update of goals and stats failed because the new activity level chosen is the same as the current one.", preferredStyle: .alert)
            sameNewAndCurrentActivityLevelAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(sameNewAndCurrentActivityLevelAlert, animated: true)
            return
        }
        
        
        if goalWeightTextField.text != "" { // If goal weight isn't blank, perform input validation on it
            guard let newGoalWeight = Double(goalWeightTextField.text!) else { return }
            
            if (currentOverallGoal == "Lose" && overallGoalTextField.text == "") && (newGoalWeight >= currentWeight) {
                print("If your current overall goal is to lose weight, your new goal weight cannot be the greater than or equal to your current weight of \(currentWeight).")
                let newGoalWeightTooHighAlert = UIAlertController(title: "Update Failed", message: "If your current overall goal is to lose weight, your new goal weight cannot be the greater than or equal to your current weight of \(currentWeight).", preferredStyle: .alert)
                newGoalWeightTooHighAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(newGoalWeightTooHighAlert, animated: true)
                return
            } else if (currentOverallGoal == "Gain" && overallGoalTextField.text == "") && (newGoalWeight <= currentWeight) {
                print("If your current overall goal is to gain weight, your new goal weight cannot be the less than or equal to your current weight of \(currentWeight).")
                let newGoalWeightTooLowAlert = UIAlertController(title: "Update Failed", message: "If your current overall goal is to gain weight, your new goal weight cannot be the less than or equal to your current weight of \(currentWeight).", preferredStyle: .alert)
                newGoalWeightTooLowAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(newGoalWeightTooLowAlert, animated: true)
                return
            } else if currentOverallGoal == "Maintain" {
                if (newOverallGoal == "Lose") && (newGoalWeight >= currentWeight) {
                    print("If your new overall goal is to lose weight, your new goal weight cannot be the greater than or equal to your current weight of \(currentWeight).")
                    let newGoalWeightTooHighAlert = UIAlertController(title: "Update Failed", message: "If your current overall goal is to lose weight, your new goal weight cannot be the less than or equal to your current weight of \(currentWeight).", preferredStyle: .alert)
                    newGoalWeightTooHighAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(newGoalWeightTooHighAlert, animated: true)
                    return
                } else if (newOverallGoal == "Gain") && (newGoalWeight <= currentWeight) {
                    print("If your new overall goal is to gain weight, your new goal weight cannot be the less than or equal to your current weight of \(currentWeight).")
                    let newGoalWeightTooLowAlert = UIAlertController(title: "Update Failed", message: "If your current overall goal is to gain weight, your new goal weight cannot be the less than or equal to your current weight of \(currentWeight).", preferredStyle: .alert)
                    newGoalWeightTooLowAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(newGoalWeightTooLowAlert, animated: true)
                    return
                }
            }
        }
    }
    
    func updateUserGoalsAndStats() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let userGoalsAndStats: [String: Any] = [:]
        
        Database.database().reference().child("users/\(userID)/health-stats").updateChildValues(userGoalsAndStats) { (error, ref) in
            if let error = error {
                print("Failed to update database with error:", error.localizedDescription)
                return
            } else {
                print("Successfully updated user's goals and stats in the Firebase database!")
                return
            }
        }
    }
    
    @IBAction func onUpdateGoalsAndStatsButtonPressed(_ sender: Any) {
        validateUserInputs {
            self.getUserData {
                self.updateUserGoalsAndStats()
            }
        }
        
    }
    

    // MARK: - UIPickerView Protocol Stubs & Helper Functions
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == overallGoalPicker {
            print(overallGoalsPickerValues.count)
            return overallGoalsPickerValues.count
        } else if pickerView == weeklyGoalPicker && (currentOverallGoal == "Maintain" && newOverallGoal == "" || newOverallGoal == "Maintain") {
            return 2
        } else if pickerView == weeklyGoalPicker {
            print(weeklyGoalsPickerValues.count)
            return weeklyGoalsPickerValues.count
        } else if pickerView == activityLevelPicker {
            print(activityLevelsPickerValues.count)
            return activityLevelsPickerValues.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == overallGoalPicker {
            if row == 0 {
                return ""
            } else {
                return "\(overallGoalsPickerValues[row]) Weight"
            }
        } else if pickerView == weeklyGoalPicker && currentOverallGoal != "Maintain" && newOverallGoal != "Maintain"  {
            if row == 0 {
                return weeklyGoalsPickerValues[row]
            } else {
                if newOverallGoal == "" {
                    return "\(currentOverallGoal) \(weeklyGoalsPickerValues[row])"
                } else {
                    return "\(newOverallGoal) \(weeklyGoalsPickerValues[row])"
                }
            }
        } else if pickerView == weeklyGoalPicker && overallGoalTextField.text == "" {
            if currentOverallGoal == "Maintain" {
                return maintainWeightGoalsPickerValues[row]
            } else {
                if row == 0 {
                    return weeklyGoalsPickerValues[row]
                } else {
                    return "\(currentOverallGoal) \(weeklyGoalsPickerValues[row])"
                }
            }
        } else if pickerView == weeklyGoalPicker && (currentOverallGoal == "Maintain" && overallGoalTextField.text == "" || newOverallGoal == "Maintain") {
            return maintainWeightGoalsPickerValues[row]
        } else if pickerView == weeklyGoalPicker && currentOverallGoal == "Maintain" && (newOverallGoal == "Lose" || newOverallGoal == "Gain") {
            if row == 0 {
                return weeklyGoalsPickerValues[row]
            } else {
                return "\(newOverallGoal) \(weeklyGoalsPickerValues[row])"
            }
        } else if pickerView == activityLevelPicker {
            return activityLevelsPickerValues[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // ******** ACTIVITY LEVEL TEXT FIELD ******** // --> DONE
        // activityLevelPicker doesn't depend on anything so it can exist on its own
        if pickerView == activityLevelPicker {
            // Set up activityLevelPicker; It can either be empty or not. If it's empty, change the activityLevel variable but don't send the updated value to Firebase
            // TODO: - Make sure to check if activityLevel is empty or not when sending to Firebase. If it's empty, don't send it
            activityLevelTextField.text = activityLevelsPickerValues[row]
            self.activityLevel = activityLevelTextField.text!
        }

        
        
        if overallGoalTextField.text == ""
        { // ******** OVERALLGOAL TEXT FIELD EMPTY ******** //
            
            // if pickverView == overallGoalPicker
                // if weeklyGoalField.text is empty
                // else if weeklyGoalField.text is NOT empty
            // else if pickerView == weeklyGoalPicker
        }
        else
        { // ******** OVERALLGOAL TEXT FIELD NOT EMPTY ******** //
            if pickerView == overallGoalPicker { // current picker is overallGoalPicker
                // NEW OVERALL GOAL = Lose/Gain/Maintain
                if newOverallGoal == "Lose" {
                    // CURRENT OVERALL GOAL = Lose/Gain/Maintain
                    if currentOverallGoal == "Lose" { // newOverallGoal: "Lose" AND currentOverallGoal: "Lose"
                        loseGainWeeklyGoalSelectedRow = row
                        print("New overall goal:", newOverallGoal)
                    } else if currentOverallGoal == "Gain" { // newOverallGoal: "Lose" AND currentOverallGoal: "Gain"
                        
                    } else if currentOverallGoal == "Maintain" { // newOverallGoal: "Lose" AND currentOverallGoal: "Maintain"
                        
                    }
                } else if newOverallGoal == "Gain" {
                    // CURRENT OVERALL GOAL = Lose/Gain/Maintain
                    if currentOverallGoal == "Lose" { // newOverallGoal: "Gain" AND currentOverallGoal: "Lose"
                        
                    } else if currentOverallGoal == "Gain" { // newOverallGoal: "Gain" AND currentOverallGoal: "Gain"
                        
                    } else if currentOverallGoal == "Maintain" { // newOverallGoal: "Gain" AND currentOverallGoal: "Maintain"
                        
                    }
                } else if newOverallGoal == "Maintain" { // TODO: -  MIGHT BE ABLE TO REMOVE ALL THESE IF/ELSE STATEMENTS FOR THIS NEWOVERALLGOAL
                    // CURRENT OVERALL GOAL = Lose/Gain/Maintain
                    if currentOverallGoal == "Lose" { // newOverallGoal: "Maintain" AND currentOverallGoal: "Lose"
                        
                    } else if currentOverallGoal == "Gain" { // newOverallGoal: "Maintain" AND currentOverallGoal: "Gain"
                        
                    } else if currentOverallGoal == "Maintain" { // newOverallGoal: "Maintain" AND currentOverallGoal: "Maintain"
                        
                    }
                }
            }
            else if pickerView == weeklyGoalPicker {
                // NEW OVERALL GOAL exists (overall goal field is NOT EMPTY) --> depending on what the NEW OVERALL GOAL is, perform actions
                if newOverallGoal == "Lose" {
                    
                } else if newOverallGoal == "Gain" {
                    
                } else if newOverallGoal == "Maintain" {
                    
                }
            }
        }
    }
//        if pickerView == overallGoalPicker {
//            if row == 0 {
//                overallGoalTextField.text = overallGoalsPickerValues[row]
//                self.newOverallGoal = overallGoalsPickerValues[row]
//            } else {
//                overallGoalTextField.text = "\(overallGoalsPickerValues[row]) Weight"
//                self.newOverallGoal = overallGoalsPickerValues[row]
//            }
//            // Once a new overall goal is picked, if necessary, update the weekly goal text field to display the properly prepended overall goal
//            if weeklyGoalTextField.text != "" && weeklyGoalSelectedRow != 0 {
//                if newOverallGoal != "" {
//                    if newOverallGoal != currentOverallGoal || newOverallGoal == currentOverallGoal {
//                        if newOverallGoal != "Maintain" {
//                            weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[weeklyGoalSelectedRow])"
//                            if newOverallGoal == "Lose" {
//                                self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow - 1] * -1
//                                print("New overall goal is: '\(newOverallGoal)' and new weekly goal is:", self.newWeeklyGoal)
//                            } else if newOverallGoal == "Gain" {
//                                self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow - 1]
//                                print("New overall goal is: '\(newOverallGoal)' and new weekly goal is:", self.newWeeklyGoal)
//                            }
//
//                        } else {
//                            weeklyGoalTextField.text = "Maintain Weight"
////                            goalWeightTextField.isUserInteractionEnabled = false
//                            self.newWeeklyGoal = 0
//                            goalWeightTextField.text = String(currentWeight)
//                            self.currentGoalWeight = currentWeight
//                        }
//                    }
//                } else {
//                    if currentOverallGoal != "Maintain" {
//                        weeklyGoalTextField.text = "\(currentOverallGoal) \(weeklyGoalsPickerValues[weeklyGoalSelectedRow])"
//                        if newOverallGoal == "Lose" {
//                            self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow - 1] * -1
//                            print("New overall goal is: '\(newOverallGoal)' and new weekly goal is:", self.newWeeklyGoal)
//                        } else if newOverallGoal == "Gain" {
//                            self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow - 1]
//                            print("New overall goal is: '\(newOverallGoal)' and new weekly goal is:", self.newWeeklyGoal)
//                        }
//                    } else {
//                        weeklyGoalTextField.text = "Maintain Weight"
////                        goalWeightTextField.isUserInteractionEnabled = false
//                        self.newWeeklyGoal = 0
//                        goalWeightTextField.text = String(currentWeight)
//                        self.currentGoalWeight = currentWeight
//                    }
//                }
//            } else { // weeklyGoalTextField is blank
//                if (newOverallGoal != "" && newOverallGoal != currentOverallGoal) || (newOverallGoal == currentOverallGoal && weeklyGoalTextField.text != "") {
//                    if newOverallGoal == "Maintain" {
//                        weeklyGoalTextField.text = "Maintain Weight"
////                        goalWeightTextField.isUserInteractionEnabled = false
//                        self.newWeeklyGoal = 0
//                        goalWeightTextField.text = String(currentWeight)
//                        self.currentGoalWeight = currentWeight
//                    } else {
//                        if currentOverallGoal == "Maintain" {
//                            if newOverallGoal == "Lose" {
//                                self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow] * -1
//                            } else if newOverallGoal == "Gain" {
//                                self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow]
//                            }
//                            weeklyGoalTextField.text = "\(newOverallGoal) \(abs(self.newWeeklyGoal)) lbs per week"
//                        } else {
//                            if self.newWeeklyGoal == 0 {
//                                weeklyGoalTextField.text = "\(newOverallGoal) \(abs(self.currentWeeklyGoal)) lbs per week"
//                                self.newWeeklyGoal = self.currentWeeklyGoal
//                            } else if abs(self.newWeeklyGoal) == 1 {
//                                weeklyGoalTextField.text = "\(newOverallGoal) \(abs(self.newWeeklyGoal)) lb per week"
//                            } else {
//                                weeklyGoalTextField.text = "\(newOverallGoal) \(abs(self.newWeeklyGoal)) lbs per week"
//                            }
//                        }
//                    }
//                } else if (newOverallGoal == "" && weeklyGoalTextField.text == "") || (newOverallGoal == "" && weeklyGoalSelectedRow == 0) {
//                    weeklyGoalTextField.text = ""
//                }
//            }
//        } else if pickerView == weeklyGoalPicker && currentOverallGoal != "Maintain" && newOverallGoal != "Maintain" {
//            if row == 0 {
//                 weeklyGoalTextField.text = weeklyGoalsPickerValues[row]
//            } else {
//                weeklyGoalSelectedRow = row
//                if newOverallGoal == "" {
//                    weeklyGoalTextField.text = "\(currentOverallGoal) \(weeklyGoalsPickerValues[row])"
//                    if currentOverallGoal == "Lose" {
//                        self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow - 1] * -1
//                        print("Current overall goal is: '\(self.currentOverallGoal)' and new weekly goal is:", self.newWeeklyGoal)
//                    } else if currentOverallGoal == "Gain" {
//                        self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow - 1]
//                        print("Current overall goal is: '\(self.currentOverallGoal)' and new weekly goal is:", self.newWeeklyGoal)
//                    }
//                } else {
//                    weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[row])"
//                    if newOverallGoal == "Lose" {
//                        self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow - 1] * -1
//                        print("New overall goal is: '\(newOverallGoal)' and new weekly goal is:", self.newWeeklyGoal)
//                    } else if newOverallGoal == "Gain" {
//                        self.newWeeklyGoal = weeklyGoalValues[weeklyGoalSelectedRow - 1]
//                        print("New overall goal is: '\(newOverallGoal)' and new weekly goal is:", self.newWeeklyGoal)
//                    }
//                }
//            }
//        } else if pickerView == weeklyGoalPicker && (currentOverallGoal == "Maintain" && overallGoalTextField.text == "" || newOverallGoal == "Maintain") {
//            weeklyGoalTextField.text = maintainWeightGoalsPickerValues[row]
//            weeklyGoalSelectedRow = 1
//            self.newWeeklyGoal = weeklyGoalValues [weeklyGoalSelectedRow - 1]
//        } else if pickerView == activityLevelPicker {
//            activityLevelTextField.text = activityLevelsPickerValues[row]
//        }
//
//
//        if (currentOverallGoal == "Maintain" && overallGoalTextField.text == "") || newOverallGoal == "Maintain" {
//            goalWeightTextField.isUserInteractionEnabled = false
//        } else {
//            goalWeightTextField.isUserInteractionEnabled = true
//        }
//    }
    
}
