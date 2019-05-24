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
    var mealData: [String: Any]!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealNameLabel.text = mealTitle
        let fallbackURL = "https://spoonacular.com/recipeImages/640190-556x370.jpg"
        let baseURL = mealData["image"] as? String ?? fallbackURL
        let posterURL = URL(string: baseURL)!
        mealImage.af_setImage(withURL: posterURL)
        
        let recipeText = mealData["instructions"] as! String
        recipeLabel.text = recipeText

    }
    
    
    // MARK: - Helper Functions & Actions
    


}
