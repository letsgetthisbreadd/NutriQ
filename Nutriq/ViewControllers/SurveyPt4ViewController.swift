//
//  SurveyPt4ViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class SurveyPt4ViewController: UIViewController {

    @IBOutlet weak var lbsButton05: ShadowButton!
    @IBOutlet weak var lbsButton1: ShadowButton!
    @IBOutlet weak var lbsButton15: ShadowButton!
    @IBOutlet weak var lbsButton2: ShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func lbsButton05Press(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
    }
    
    @IBAction func lbsButton1Press(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
    }
    
    @IBAction func lbsButton15Press(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
    }
    
    @IBAction func lbsButton2Press(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue3", sender: self)
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
