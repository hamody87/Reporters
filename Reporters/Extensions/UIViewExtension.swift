//
//  UIViewExtension.swift
//  Reporters
//
//  Created by Muhammad Jbara on 28/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

extension UIView {
    
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.masksToBounds = true
    }
     
//    func borders(edges: UIRectEdge, radius: CGFloat) {
//         let path = UIBezierPath()
//         let mask = CAShapeLayer()
//         mask.path = path.cgPath
//         layer.mask = mask
//         layer.masksToBounds = true
//     }
    
    func clone() throws -> UIView? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIView
    }
//    func clone() -> UIView {
        
        

//        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false))! as! UIView
//     }
    
}
