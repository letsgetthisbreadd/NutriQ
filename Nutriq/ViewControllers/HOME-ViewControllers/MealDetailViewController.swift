//
//  MealDetailViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 5/1/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var mealTitle: String = ""
    @IBOutlet weak var mealNameLabel: UILabel!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealNameLabel.text = mealTitle

    }
    
    
    // MARK: - Helper Functions & Actions
    


}
