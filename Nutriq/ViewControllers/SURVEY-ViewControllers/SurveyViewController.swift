//
//  SurveyViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/12/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase

class SurveyViewController: UIViewController {

    
    // MARK: - Properties
    
    private var datePicker: UIDatePicker?
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var heightFeetTextField: UITextField!
    @IBOutlet weak var heightInchesTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: - Date picker is bugging out
        // Configures the Date Picker to have a 'done' button
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SurveyViewController.dateChanged(datePicker:)), for: .valueChanged)
        dobTextField.inputView = datePicker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(SurveyViewController.dismissPicker))
        dobTextField.inputAccessoryView = toolBar
        
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
        } else if weightTextField.text == "" { // Empty weight field
            print("The weight field is empty. Please input your weight in pounds and try again!")
            let emptyWeightAlert = UIAlertController(title: "Empty weight field", message: "The weight field is empty. Please input your weight in pounds and try again.", preferredStyle: .alert)
            emptyWeightAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(emptyWeightAlert, animated: true)
            return
        }
        
        // User input validation partially passed. Begin storing
        let genders = ["Male", "Female"]
        let gender = genders[genderPicker.selectedSegmentIndex]
        guard let dateOfBirth = dobTextField.text else { return }
        guard let heightInFeet = Int(heightFeetTextField.text!) else { return }
        guard let heightInInches = Int(heightInchesTextField.text!) else { return }
        let totalHeight = heightInFeet * 12 + heightInInches
        guard let weight = Double(weightTextField.text!) else { return }
        
        // Finish user input validation
        if heightInInches > 11 { // Height in inches value too large
            print("The inches field cannot be higher than 11 inches! Please input your height in inches and try again!")
            let inchesTooLargeAlert = UIAlertController(title: "Height in inches too large", message: "The inches field cannot be higher than 11 inches! Please input your height in inches and try again.", preferredStyle: .alert)
            inchesTooLargeAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(inchesTooLargeAlert, animated: true)
            return
        } else if weight <= 10 { // Weight too low
                print("The weight entered is too small. Please input a larger weight and try again!")
                let weightTooLowAlert = UIAlertController(title: "Weight too low", message: "The weight entered is too small. Please input a larger weight and try again.", preferredStyle: .alert)
                weightTooLowAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(weightTooLowAlert, animated: true)
                return
        }
        
        // TODO: - Add date validation (format and age over 18 years old)
        
        // User input validation passed; Send the inputs for storage in the Firebase database
        storeSurveyInfo(gender: gender, dateOfBirth: dateOfBirth, totalHeight: totalHeight, weight: weight)
        
        
    }
    
    func storeSurveyInfo(gender: String, dateOfBirth: String, totalHeight: Int, weight: Double) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        // Create the health-stats object which will be added to the current user's data
        let userHealthStats = ["health-stats": ["gender": gender, "date-of-birth": dateOfBirth, "height-inches": totalHeight, "weight-pounds": weight]]
        
        Database.database().reference().child("users").child(userID).updateChildValues(userHealthStats) { (error, ref) in
            if let error = error {
                print("Failed to udpate database with error: ", error.localizedDescription)
                return
            }
            print("Successfully added user's health-stats(1) to Firebase database!")
        }
        
    }
    

}
