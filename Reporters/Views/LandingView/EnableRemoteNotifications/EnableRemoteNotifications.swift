//
//  EnableRemoteNotifications.swift
//  Reporters
//
//  Created by Muhammad Jbara on 08/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class EnableRemoteNotifications: SuperView {
    
    // MARK: - Declare Basic Variables
    
    private var badgeNumber: UILabel!
    private var countBadges: Int = 1
    private var dispatchAfter: Float! = 1
    
    // MARK: - Private Methods
    
    private func startCountBadges() {
        if countBadges > 99 {
            self.badgeNumber.font = CONSTANTS.GLOBAL.createFont(ofSize: 14.0, true)
            self.badgeNumber.text = "+99"
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(Int(self.dispatchAfter * 1000))) {
            self.badgeNumber.text = "\(self.countBadges)"
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            self.startCountBadges()
        }
        switch countBadges {
        case 1 ... 5:
            self.dispatchAfter -= 0.15
        case 6 ... 9:
            self.dispatchAfter -= 0.25
        default:
            dispatchAfter = 0.001
        }
        self.countBadges += 1
    }
    
    @objc private func askForRegisterNotifications() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.notificationTransactions({
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dismissChildOverlapContainer()
            }
        })
    }
    
    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .lightContent)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
    }
    
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
            if let btn: UIButton = CONSTANTS.GLOBAL.createButtonElement(withFrame: label.frame, {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.dismissChildOverlapContainer as () -> Void)]
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIButton {
                self.safeAreaView.addSubview(btn)
            }
        }
        originY -= (CONSTANTS.SCREEN.MARGIN(2) + 50.0)
        self.safeAreaView.addSubview(CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] = [CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION: [UIRectCorner.allCorners], CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS: 50.0 / 2.0]
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "I_WANT_TO_BE_NOTIFIED".localized
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.askForRegisterNotifications)]
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
            if let iconView: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: (self.safeAreaView.frame.width - img_maskNotificationIcon.size.width) / 2.0, y: (originY - img_maskNotificationIcon.size.height) / 2.0, width: img_maskNotificationIcon.size.width, height: img_maskNotificationIcon.size.height), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
                argument[CONSTANTS.KEYS.ELEMENTS.MASK] = img_maskNotificationIcon
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
                self.safeAreaView.addSubview(iconView)
                if let badge: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 83.0, y: 38.0, width: 30.0, height: 30.0), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor(rgb: 0xe20038)
                    argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] = [CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION: [UIRectCorner.allCorners], CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS: 10]
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
                    iconView.addSubview(badge)
                    if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame:  badge.bounds, {
                        var argument: [String: Any] = [String: Any]()
                        argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "\(countBadges)".localized
                        argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, true)
                        argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
                        argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
                        return argument
                    }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                        self.badgeNumber = label
                        badge.addSubview(self.badgeNumber)
                        self.startCountBadges()
                    }
                }
            }
        }
    }

}
