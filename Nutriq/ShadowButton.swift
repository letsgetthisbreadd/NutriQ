//
//  ShadowButton.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/17/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {

    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
    }

}
