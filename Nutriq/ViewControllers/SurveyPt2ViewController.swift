//
//  SurveyPt2ViewController.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/25/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class SurveyPt2ViewController: UIViewController {

    @IBOutlet weak var notActiveBtn: ShadowButton!
    @IBOutlet weak var lightlyActiveBtn: ShadowButton!
    @IBOutlet weak var modActiveBtn: ShadowButton!
    @IBOutlet weak var veryActiveBtn: ShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func notActiveBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
    }
    
    @IBAction func lightlyActiveBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
    }
    
    @IBAction func modActiveBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
    }
    
    @IBAction func veryActiveBtnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "surveySegue1", sender: self)
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
