//
//  GradientView.swift
//  Nutriq
//
//  Created by Michael Mcmanus on 4/17/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

// This code defines the properties of the GradientView class, which can be pulled from the
// object library and used to set a gradient background for view controllers. Pretty sweet.


import UIKit
@IBDesignable

class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var isAngled: Bool = true {
        didSet {
            updateView()
        }
    }
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
        
    func updateView() {
            let layer = self.layer as! CAGradientLayer
            layer.colors = [firstColor, secondColor].map{$0.cgColor}
            if (self.isAngled) {
                layer.startPoint = CGPoint(x: 0.75, y: 0.75)
                layer.endPoint = CGPoint (x: 1, y: 0.5)
            } else {
                layer.startPoint = CGPoint(x: 0.5, y: 0)
                layer.endPoint = CGPoint (x: 0.5, y: 1)
            }
        }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
