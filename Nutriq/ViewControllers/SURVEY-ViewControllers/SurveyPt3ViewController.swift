//
//  SurveyPt3ViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class SurveyPt3ViewController: UIViewController {

    @IBOutlet weak var loseButton: ShadowButton!
    @IBOutlet weak var gainButton: ShadowButton!
    @IBOutlet weak var maintainButton: ShadowButton!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loseBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue2", sender: self)
    }
    
    @IBAction func gainBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue2", sender: self)
    }
    
    @IBAction func maintainBtnPress(_ sender: Any) {
        // TODO: - Remove this segue because it causes the segue to occur twice (once from the storyboard and again below. This makes the SurveyResultsViewController present twice
//        self.performSegue(withIdentifier: "maintainWeightSegue", sender: self)
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
