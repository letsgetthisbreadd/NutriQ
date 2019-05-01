//
//  SurveyViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/12/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

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
    

}
