//
//  EnableRemoteNotifications.swift
//  Reporters
//
//  Created by Muhammad Jbara on 08/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class EnableRemoteNotifications: SuperView {
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: "Background/Basic")
        
        
        var originY: CGFloat = self.safeAreaView.frame.height - CONSTANTS.SCREEN.MARGIN(2) - 30.0
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: originY, width: 0, height: 30.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "NOT_NOW".localized
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            label.frame = CGRect(x: (self.safeAreaView.frame.width - label.widthOfString()) / 2.0, y: label.frame.origin.y, width: label.widthOfString(), height: label.frame.height)
            self.safeAreaView.addSubview(label)
//            if let btn: UIButton = CONSTANTS.GLOBAL.createButtonElement(withFrame: label.frame, {
//                var argument: [String: Any] = [String: Any]()
//                argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET] = self
//                argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR] = #selector(self.dismissChildOverlapContainer as () -> Void)
//                return argument
//            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIButton {
//                coreView.addSubview(btn)
//            }
        }
        
        originY -= (CONSTANTS.SCREEN.MARGIN(2) + 50.0)
        self.safeAreaView.addSubview(CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] = [CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION: [UIRectCorner.allCorners], CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS: 50.0 / 2.0]
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "I_WANT_TO_BE_NOTIFIED".localized
//            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.loginWithPhoneNumber)]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 22.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! CustomizeButton)
        originY -= CONSTANTS.SCREEN.MARGIN(6)
        

        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame:  CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: 0, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "SUBJECT_ENBALE_NOTIFICATION".localized
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            originY -= label.heightOfString()
            label.frame = CGRect(x: label.frame.origin.x, y: originY, width: label.frame.width, height: label.heightOfString())
            self.safeAreaView.addSubview(label)
        }
        
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame:  CGRect(x: CONSTANTS.SCREEN.MARGIN(1), y: 0, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(2), height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "TITLE_ENBALE_NOTIFICATION".localized
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 28.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            originY -= label.heightOfString()
            label.frame = CGRect(x: label.frame.origin.x, y: originY, width: label.frame.width, height: label.heightOfString())
            self.safeAreaView.addSubview(label)
        }
        
        if let img_maskNotificationIcon: UIImage = UIImage(named: "\(self.classDir())MaskNotificationIcon") {
            print("dsadsa")
            if let iconView: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: (self.safeAreaView.frame.width - img_maskNotificationIcon.size.width) / 2.0, y: (originY - img_maskNotificationIcon.size.height) / 2.0, width: img_maskNotificationIcon.size.width, height: img_maskNotificationIcon.size.height), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.MASK] = img_maskNotificationIcon
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.safeAreaView.addSubview(iconView)
        }
        }
    }

}
