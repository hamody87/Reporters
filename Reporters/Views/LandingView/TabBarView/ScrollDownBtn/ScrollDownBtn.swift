//
//  ScrollDownBtn.swift
//  Reporters
//
//  Created by Muhammad Jbara on 08/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class ScrollDownBtn: SuperView {
    
    // MARK: - Declare Basic Variables
    
    // MARK: - Drawing Methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let lineWidth: CGFloat = 3.0
        print((self.frame.width - lineWidth ) / 2.0)
        let contextRef: CGContext! = UIGraphicsGetCurrentContext()
        contextRef.setLineWidth(lineWidth)
        contextRef.addArc(center: CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0), radius: (self.frame.width - lineWidth) / 2.0, startAngle: 0, endAngle: .pi * 2.0, clockwise: false)
        contextRef.setStrokeColor(UIColor.white.cgColor)
        contextRef.strokePath()
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = .clear
        if let img_scrollDownIcon: UIImage = UIImage(named: "\(self.classDir())scrollDownIcon") {
            print("\(self.classDir())ScrollDownIcon")
            self.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: (self.frame.width - img_scrollDownIcon.size.width) / 2.0, y: (self.frame.height - img_scrollDownIcon.size.height) / 2.0, width: img_scrollDownIcon.size.width, height: img_scrollDownIcon.size.height), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_scrollDownIcon
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
            self.setNeedsDisplay()
        }
    }
    
}
