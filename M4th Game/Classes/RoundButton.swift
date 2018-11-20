//
//  RoundButton.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 13/08/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = radius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
}
