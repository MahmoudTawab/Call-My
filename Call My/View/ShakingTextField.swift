//
//  ShakingTextField.swift
//  Call My
//
//  Created by Mahmoud Abd El Tawab on 3/25/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit

class ShakingTextField: UITextField {
    
    func shaking() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y - 2))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y + 2))
        self.layer.add(animation, forKey: "position")
    }
}
