//
//  EnterView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 10/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

final class EnterView {
    
    // MARK: - Declare Static Variables
    
    private static var sharedInstance: EnterView = {
        let instance = EnterView()
        return instance
    }()
    
    // MARK: - Public Methods
    
    public func startEnterView(_ superView: UIView) {
        let enterView: UIView = UIView(frame: superView.bounds)
        enterView.backgroundColor = UIColor(named: "Background/Basic")
        enterView.alpha = 1.0
        superView.addSubview(enterView)
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: enterView.frame.height - CONSTANTS.SCREEN.SAFE_AREA.BOTTOM() - 40.0, width: enterView.frame.width, height: 20.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "\(CONSTANTS.INFO.APP.BUNDLE.VERSION)v"
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 17.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            enterView.addSubview(label)
            if let img_launchIcon: UIImage = UIImage(named: "LaunchIcon") {
                if let launchIcon: UIImageView = CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: (superView.frame.width - img_launchIcon.size.width) / 2.0, y: label.frame.origin.y - 10.0 - img_launchIcon.size.height, width: img_launchIcon.size.width, height: img_launchIcon.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_launchIcon
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIImageView {
                    enterView.addSubview(launchIcon)
                }
            }
        }
        UIView.animate(withDuration: 0.2, delay: 1.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: [.curveEaseOut], animations: {
            enterView.alpha = 0
        }, completion: { _ in
            enterView.removeFromSuperview()
        })
    }
    
    // MARK: - Accessors

    class func shared() -> EnterView {
        return self.sharedInstance
    }
    
}
