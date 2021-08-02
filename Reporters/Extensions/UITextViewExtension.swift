//
//  UITextViewExtension.swift
//  Reporters
//
//  Created by Muhammad Jbara on 17/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

extension UITextView {
    
    public func widthOfString() -> CGFloat {
        return ceil(NSString(string: self.text!).boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height:  self.frame.height), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: self.font ?? 0], context: nil).size.width)
    }
    
    public func heightOfString() -> CGFloat {
        return ceil(NSString(string: self.text!).boundingRect(with: CGSize(width: self.frame.width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: self.font ?? 0], context: nil).size.height)
    }
    
}
