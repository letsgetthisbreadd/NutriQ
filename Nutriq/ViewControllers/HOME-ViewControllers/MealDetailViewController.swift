//
//  MealDetailViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 5/1/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController {
    
   
    @IBOutlet weak var mealNameLabel: UILabel!
    
    
    
    var mealTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealNameLabel.text = mealTitle

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
