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
    var newGoalWeight: Double = 0.0
    var currentWeight: Double = 0.0
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
    let maintainWeightGoalsPickerValues = ["", "Maintain weekly weight"]
    let activityLevelsPickerValues = ["", "Not very active", "Lightly active", "Moderately active", "Very active"]
    
//    let overallGoalValues = ["", "Lose", "Maintain", "Gain"]
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
            completion()
        }
    }
    
    func validateUserInputs(completion: @escaping () -> ()) {
        
        // ********* ALL FIELDS BLANK ********* //
        if overallGoalTextField.text == "" && weeklyGoalTextField.text == "" && activityLevelTextField.text == "" && goalWeightTextField.text == "" {
            print("The update of goals and stats failed because all fields are blank!")
            let allTextFieldsBlankAlert = UIAlertController(title: "Update Failed", message: "The update of goals and stats failed because all fields are blank.", preferredStyle: .alert)
            allTextFieldsBlankAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(allTextFieldsBlankAlert, animated: true)
            return
        } else if (newOverallGoal != currentOverallGoal) && overallGoalTextField.text != "" {
            if newOverallGoal == "Maintain" {
                // Weekly goal must be equal to 0
                if newWeeklyGoal != 0 {
                    print("The weekly goal field must be 'Maintain weekly weight' if your new overall goal is to maintain weight!")
                    let invalidNewWeeklyGoalValueAlert = UIAlertController(title: "Invalid Weekly Goal", message: "The weekly goal field must be 'Maintain weekly weight' if your new overall goal is to maintain weight! The weekly goal will now be set to 'Maintain weekly weight'", preferredStyle: .alert)
                    invalidNewWeeklyGoalValueAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidNewWeeklyGoalValueAlert, animated: true)
                    newWeeklyGoal = 0
                    weeklyGoalTextField.text = "Maintain weekly weight"
                    return
                }
                // Goal weight must be set to current weight
                if newGoalWeight != currentWeight || currentGoalWeight != currentWeight {
                    print("The goal weight must be set to current weight of \(currentWeight) since the new overall goal is to maintain weight!")
                    let invalidGoalWeightAlert = UIAlertController(title: "Invalid Goal Weight", message: "The goal weight must be set to current weight of \(currentWeight) pounds since the new overall goal is to maintain weight. The goal weight text field will now be changed to the current weight of \(currentWeight) pounds.", preferredStyle: .alert)
                    invalidGoalWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidGoalWeightAlert, animated: true)
                    newGoalWeight = currentWeight
                    goalWeightTextField.text = String(newGoalWeight)
                    return
                }
            } else if newOverallGoal == "Lose" {
                if newWeeklyGoal >= 0 {
                    print("Please change weekly goal field to 'Lose' followed by the amount of weight you'd like to lose per week and try updating your goals and stats again!")
                    let invalidNewWeeklyGoalValueAlert = UIAlertController(title: "Invalid Weekly Goal", message: "Please change weekly goal field to 'Lose' followed by the amount of weight you'd like to lose per week and try updating your goals & stats again.", preferredStyle: .alert)
                    invalidNewWeeklyGoalValueAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidNewWeeklyGoalValueAlert, animated: true)
                    return
                } else if ((currentGoalWeight >= currentWeight) && goalWeightTextField.text == "") || newGoalWeight >= currentWeight {
                    print("The goal weight must be set to a value lower than your current weight of \(currentWeight) since the new overall goal is to lose weight!")
                    let invalidNewGoalWeightAlert = UIAlertController(title: "Invalid Goal Weight", message: "The goal weight must be set to a value lower than your current weight of \(currentWeight) since the new overall goal is to lose weight.", preferredStyle: .alert)
                    invalidNewGoalWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidNewGoalWeightAlert, animated: true)
                    return
                }
            } else if newOverallGoal == "Gain" {
                if newWeeklyGoal <= 0 {
                    print("Please change weekly goal field to 'Gain' followed by the amount of weight you'd like to gain per week and try updating your goals and stats again!")
                    let invalidNewWeeklyGoalValueAlert = UIAlertController(title: "Invalid Weekly Goal", message: "Please change weekly goal field to 'Gain' followed by the amount of weight you'd like to gain per week and try updating your goals & stats again.", preferredStyle: .alert)
                    invalidNewWeeklyGoalValueAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidNewWeeklyGoalValueAlert, animated: true)
                    return
                } else if ((currentGoalWeight <= currentWeight) && goalWeightTextField.text == "") || newGoalWeight <= currentWeight {
                    print("The goal weight must be set to a value higher than your current weight of \(currentWeight) since the new overall goal is to gain weight!")
                    let invalidNewGoalWeightAlert = UIAlertController(title: "Invalid Goal Weight", message: "The goal weight must be set to a value higher than your current weight of \(currentWeight) since the new overall goal is to gain weight.", preferredStyle: .alert)
                    invalidNewGoalWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidNewGoalWeightAlert, animated: true)
                    return
                }
            }
        } else if newOverallGoal == currentOverallGoal { // only check for goal weight because weekly goal cannot possibly be a different overall goal
            if goalWeightTextField.text != "" {
                if newOverallGoal == "Lose" && newGoalWeight >= currentWeight {
                    print("The goal weight must be set to a value lower than your current weight of \(currentWeight) since the new overall goal is to lose weight!")
                    let invalidNewGoalWeightAlert = UIAlertController(title: "Invalid Goal Weight", message: "The goal weight must be set to a value lower than your current weight of \(currentWeight) since the new overall goal is to lose weight.", preferredStyle: .alert)
                    invalidNewGoalWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidNewGoalWeightAlert, animated: true)
                    return
                } else if newOverallGoal == "Gain" && newGoalWeight <= currentWeight {
                    print("The goal weight must be set to a value higher than your current weight of \(currentWeight) since the new overall goal is to gain weight!")
                    let invalidNewGoalWeightAlert = UIAlertController(title: "Invalid Goal Weight", message: "The goal weight must be set to a value higher than your current weight of \(currentWeight) since the new overall goal is to gain weight.", preferredStyle: .alert)
                    invalidNewGoalWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(invalidNewGoalWeightAlert, animated: true)
                    return
                }
            }
        }
        else if goalWeightTextField.text != "" && (overallGoalTextField.text == "" && weeklyGoalTextField.text == "") { // Only goal weight is being changed (not counting 'Activity Level'
            if currentOverallGoal == "Lose" && newGoalWeight >= currentWeight {
                print("The goal weight must be set to a value lower than your current weight of \(currentWeight) since the new overall goal is to lose weight!")
                let invalidNewGoalWeightAlert = UIAlertController(title: "Invalid Goal Weight", message: "The goal weight must be set to a value lower than your current weight of \(currentWeight) since the new overall goal is to lose weight.", preferredStyle: .alert)
                invalidNewGoalWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(invalidNewGoalWeightAlert, animated: true)
                return
            } else if currentOverallGoal == "Gain" && newGoalWeight <= currentWeight {
                print("The goal weight must be set to a value higher than your current weight of \(currentWeight) since the new overall goal is to gain weight!")
                let invalidNewGoalWeightAlert = UIAlertController(title: "Invalid Goal Weight", message: "The goal weight must be set to a value higher than your current weight of \(currentWeight) since the new overall goal is to gain weight.", preferredStyle: .alert)
                invalidNewGoalWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(invalidNewGoalWeightAlert, animated: true)
                return
            } else if currentOverallGoal == "Maintain" {
                print("The goal weight must be set to current weight of \(currentWeight) since the new overall goal is to maintain weight!")
                let invalidGoalWeightAlert = UIAlertController(title: "Invalid Goal Weight", message: "The goal weight must be set to current weight of \(currentWeight) pounds since the new overall goal is to maintain weight. The goal weight text field will now be changed to the current weight of \(currentWeight) pounds.", preferredStyle: .alert)
                invalidGoalWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(invalidGoalWeightAlert, animated: true)
                newGoalWeight = currentWeight
                goalWeightTextField.text = String(newGoalWeight)
                return
            }
        }
        completion()
    }
    
    func updateUserGoalsAndStats(completion: @escaping () -> ()) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        var userGoalsAndStats: [String: Any] = [:]
        
        // Store non-empty text field values into userGoalsAndStats
        if overallGoalTextField.text != "" {
            userGoalsAndStats.updateValue(newOverallGoal, forKey: "overall-goal")
        }
        if weeklyGoalTextField.text != "" {
            userGoalsAndStats.updateValue(newWeeklyGoal, forKey: "weekly-goal")
        }
        if activityLevelTextField.text != "" {
            userGoalsAndStats.updateValue(activityLevel, forKey: "activity-level")
        }
        if goalWeightTextField.text != "" {
            userGoalsAndStats.updateValue(newGoalWeight, forKey: "goal-weight-pounds")
            userGoalsAndStats.updateValue(abs(((currentWeight - newGoalWeight) * 10).rounded(.toNearestOrEven) / 10), forKey: "weight-left-until-goal")
        }
        
        Database.database().reference().child("users/\(userID)/health-stats").updateChildValues(userGoalsAndStats) { (error, ref) in
            if let error = error {
                print("Failed to update database with error:", error.localizedDescription)
                return
            } else {
                print("Successfully updated user's goals and stats in the Firebase database!")
                completion()
            }
        }
    }
    
    @IBAction func onUpdateGoalsAndStatsButtonPressed(_ sender: Any) {
        newGoalWeight = Double(goalWeightTextField.text!) ?? 0.0
        validateUserInputs {
            print("Input validation completed")
            self.updateUserGoalsAndStats() {
                self.viewDidLoad()
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
                return "\(overallGoalsPickerValues[row]) weight"
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
        
        if pickerView == activityLevelPicker { // Activity Level Picker can exist on its own without needing to be changed depending on the other pickers or text field values
            // TODO: - Make sure to check if activityLevel is empty or not when sending to Firebase. If it's empty, don't send it
            activityLevelTextField.text = activityLevelsPickerValues[row]
            activityLevel = activityLevelTextField.text!
        }
        
        if overallGoalTextField.text == "" { // ******** OVERALLGOAL TEXT FIELD EMPTY ******** //
            if pickerView == overallGoalPicker {
                if weeklyGoalTextField.text == "" {
                    if row == 0 {
                        overallGoalTextField.text = ""
                        newOverallGoal = currentOverallGoal
                    } else {
                        overallGoalTextField.text = "\(overallGoalsPickerValues[row]) weight"
                        newOverallGoal = "\(overallGoalsPickerValues[row])"
                        
                        loseGainWeeklyGoalSelectedRow = 1
                        
                        if newOverallGoal == "Lose" {
                            weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                            newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1] * -1
                            print("6 - The current lose/gain selected row is:", loseGainWeeklyGoalSelectedRow)
                            print("7 - The new weekly goal is:", currentWeeklyGoal)
                        } else if newOverallGoal == "Gain" {
                            weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                            newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1]
                            print("6 - The current lose/gain selected row is:", loseGainWeeklyGoalSelectedRow)
                            print("7 - The new weekly goal is:", currentWeeklyGoal)
                        } else if newOverallGoal == "Maintain" {
                            weeklyGoalTextField.text = "Maintain weekly weight"
                            newWeeklyGoal = 0
                            maintainWeeklyGoalSelectedRow = 1
                            print("1 - The new maintain goal selected row is:", maintainWeeklyGoalSelectedRow)
                        }
                        
                        print("3 - The new overall goal is:", newOverallGoal)
                    }
                } else { // weeklyGoalTextField is NOT EMPTY
                    if row == 0 {
                        overallGoalTextField.text = ""
                        newOverallGoal = currentOverallGoal
                    } else {
                        overallGoalTextField.text = "\(overallGoalsPickerValues[row]) weight"
                        newOverallGoal = "\(overallGoalsPickerValues[row])"
                        print("4 - The new overall goal is:", newOverallGoal)
                        
                        loseGainWeeklyGoalSelectedRow = 1
                        
                        if newOverallGoal == "Lose" {
                            weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                            newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1] * -1
                        } else if newOverallGoal == "Gain" {
                            weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                            newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1]
                        } else if newOverallGoal == "Maintain" {
                            weeklyGoalTextField.text = "Maintain weekly weight"
                            maintainWeeklyGoalSelectedRow = 1
                            newWeeklyGoal = 0
                        }
                        print("5 - The new weekly goal is:", newWeeklyGoal)
                    }
                }
            } else if pickerView == weeklyGoalPicker { // newOverallGoal is empty so use currentOverallGoal; overallGoalTextField is EMPTY
                if currentOverallGoal == "Lose" {
                    if row == 0 {
                        loseGainWeeklyGoalSelectedRow = row
                        weeklyGoalTextField.text = ""
                        newWeeklyGoal = currentWeeklyGoal
                        print("6 - The current lose/gain selected row is:", loseGainWeeklyGoalSelectedRow)
                        print("7 - The new weekly goal is:", currentWeeklyGoal)
                    } else {
                        loseGainWeeklyGoalSelectedRow = row
                        weeklyGoalTextField.text = "\(currentOverallGoal) \(weeklyGoalsPickerValues[row])"
                        newWeeklyGoal = weeklyGoalValues[row - 1] * -1
                        print("8 - The current lose/gain selected row is:", loseGainWeeklyGoalSelectedRow)
                        print("9 - The new weekly goal is:", newWeeklyGoal)
                    }
                    
                } else if currentOverallGoal == "Gain" {
                    if row == 0 {
                        loseGainWeeklyGoalSelectedRow = row
                        weeklyGoalTextField.text = ""
                        newWeeklyGoal = currentWeeklyGoal
                        print("10 - The current lose/gain selected row is:", loseGainWeeklyGoalSelectedRow)
                        print("11 - The new weekly goal is:", currentWeeklyGoal)
                    } else {
                        loseGainWeeklyGoalSelectedRow = row
                        weeklyGoalTextField.text = "\(currentOverallGoal) \(weeklyGoalsPickerValues[row])"
                        newWeeklyGoal = weeklyGoalValues[row - 1]
                        print("12 - The current lose/gain selected row is:", loseGainWeeklyGoalSelectedRow)
                        print("13 - The new weekly goal is:", newWeeklyGoal)
                    }
                } else if currentOverallGoal == "Maintain" {
                    if row == 0 {
                        maintainWeeklyGoalSelectedRow = row
                        weeklyGoalTextField.text = ""
                        newWeeklyGoal = currentWeeklyGoal
                        print("14 - The current maintain selected row is:", maintainWeeklyGoalSelectedRow)
                        print("15 - The new weekly goal is:", currentWeeklyGoal)
                    } else {
                        maintainWeeklyGoalSelectedRow = row
                        weeklyGoalTextField.text = "Maintain weekly weight"
                        newWeeklyGoal = 0
                        print("16 - The current maintain selected row is:", maintainWeeklyGoalSelectedRow)
                        print("17 - The new weekly goal is:", newWeeklyGoal)
                    }
                }
            }
        }
        else { // ******** OVERALLGOAL TEXT FIELD NOT EMPTY ******** //
            if pickerView == overallGoalPicker {
                if weeklyGoalTextField.text == "" {
                    if row == 0 {
                        overallGoalTextField.text = ""
                        newOverallGoal = currentOverallGoal
                        print("18 - The new overall goal is the current goal of:", newOverallGoal)
                    } else {
                        overallGoalTextField.text = "\(overallGoalsPickerValues[row]) weight"
                        newOverallGoal = "\(overallGoalsPickerValues[row])"
                        print("19 - The new overall goal is:", newOverallGoal)
                        
                        loseGainWeeklyGoalSelectedRow = 1

                        if newOverallGoal == "Lose" {
                            weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                            newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1] * -1
                        } else if newOverallGoal == "Gain" {
                            weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                            newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1]
                        } else if newOverallGoal == "Maintain" {
                            weeklyGoalTextField.text = "Maintain weekly weight"
                            maintainWeeklyGoalSelectedRow = 1
                            newWeeklyGoal = 0
                            print("20 - The new maintain goal selected row is:", maintainWeeklyGoalSelectedRow)
                            print("21 - The new weekly goal is:", newWeeklyGoal)
                        }
                        
                    }
                } else {
                    if row == 0 {
                        overallGoalTextField.text = ""
                        newOverallGoal = currentOverallGoal
                    } else {
                        overallGoalTextField.text = "\(overallGoalsPickerValues[row]) weight"
                        newOverallGoal = "\(overallGoalsPickerValues[row])"
                        print("22 - The new overall goal is:", newOverallGoal)
                    }
                    
                    loseGainWeeklyGoalSelectedRow = 1

                    if newOverallGoal == "Lose" {
                        weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                        newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1] * -1
                        print("23 - The new weekly goal is:", newWeeklyGoal)
                    } else if newOverallGoal == "Gain" {
                        weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                        newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1]
                        print("29 - The new weekly goal is:", newWeeklyGoal)
                    } else if newOverallGoal == "Maintain" {
                        weeklyGoalTextField.text = "Maintain weekly weight"
                        maintainWeeklyGoalSelectedRow = 1
                        newWeeklyGoal = 0
                        print("32 - The new maintain goal selected row is:", maintainWeeklyGoalSelectedRow)
                        print("33 - The new weekly goal is:", newWeeklyGoal)
                    }
                }

            }
            else if pickerView == weeklyGoalPicker {
                if row == 0 {
                    weeklyGoalTextField.text = ""
                    newWeeklyGoal = currentWeeklyGoal
                    print("34 - The new weekly goal is:", newWeeklyGoal)
                } else {
                    if newOverallGoal == "Lose" {
                        loseGainWeeklyGoalSelectedRow = row
                        weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                        newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1] * -1
                        print("35 - The current lose/gain selected row is:", loseGainWeeklyGoalSelectedRow)
                        print("36 - The new weekly goal is:", newWeeklyGoal)
                    } else if newOverallGoal == "Gain" {
                        loseGainWeeklyGoalSelectedRow = row
                        weeklyGoalTextField.text = "\(newOverallGoal) \(weeklyGoalsPickerValues[loseGainWeeklyGoalSelectedRow])"
                        newWeeklyGoal = weeklyGoalValues[loseGainWeeklyGoalSelectedRow - 1]
                        print("37 - The current lose/gain selected row is:", loseGainWeeklyGoalSelectedRow)
                        print("38 - The new weekly goal is:", newWeeklyGoal)
                    } else if newOverallGoal == "Maintain" {
                        maintainWeeklyGoalSelectedRow = row
                            weeklyGoalTextField.text = "Maintain weekly weight"
                            newWeeklyGoal = 0
                            print("39 - The current maintain selected row is:", maintainWeeklyGoalSelectedRow)
                            print("40 - The new weekly goal is:", newWeeklyGoal)
                    }
                }
            }
        }
    }
    
}
