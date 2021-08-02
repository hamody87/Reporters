//
//  UIColorExtension.swift
//  Reporters
//
//  Created by Muhammad Jbara on 20/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
