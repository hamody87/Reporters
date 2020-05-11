//
//  ProfileView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 10/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class ProfileView: SuperView {
    
    // MARK: - Basic Constants
        
    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .lightContent)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
        self.setStatusBarIsHidden(hide: false)
    }
    
    // MARK: - Private Methods
    
    @objc public func backToPrevSuperView() {
        self.dismissChildOverlapContainer()
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: "Background/Basic")
        if let img_backBtn: UIImage = UIImage(named: "BackBtn-rtl") {
            if let backBtn: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 0, y: CONSTANTS.SCREEN.MARGIN(), width: 0, height: img_backBtn.size.height), nil)[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
                self.safeAreaView.addSubview(backBtn)
                var widthBackBtn: CGFloat = 0
                if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: 0, width: 0, height: backBtn.frame.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "BACK".localized
                    argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
                    argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                    label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: CONSTANTS.SCREEN.MARGIN(0.5) + label.widthOfString(), height: label.frame.height)
                    backBtn.addSubview(label)
                    widthBackBtn += label.frame.width
                }
                backBtn.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: widthBackBtn, y: 0, width: img_backBtn.size.width, height: img_backBtn.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_backBtn
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
                widthBackBtn += img_backBtn.size.width
                backBtn.frame = CGRect(x: self.safeAreaView.frame.width - widthBackBtn - CONSTANTS.SCREEN.MARGIN(), y: backBtn.frame.origin.y, width: widthBackBtn, height: backBtn.frame.height)
                backBtn.addSubview(CONSTANTS.GLOBAL.createButtonElement(withFrame: backBtn.bounds, {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.backToPrevSuperView)]
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIButton)
            }
        }
        if let userInfo: [String: Any] = CONSTANTS.GLOBAL.getUserInfo([CONSTANTS.KEYS.JSON.FIELD.NAME, CONSTANTS.KEYS.JSON.FIELD.THUMB, CONSTANTS.KEYS.JSON.FIELD.COUNTRY.SELF, CONSTANTS.KEYS.JSON.FIELD.LEVEL]), let fullName: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String, let country: [String: Any] = userInfo[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.SELF] as? [String: Any], let countryName: String = country[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.NAME] as? String {
            let sizeThumb: CGFloat = 120.0
            var originY: CGFloat = CONSTANTS.SCREEN.MARGIN(2)
            if let thumbView: CustomizeImage = CONSTANTS.GLOBAL.createCustomThumbElement(withFrame: CGRect(x: (self.frame.width - sizeThumb) / 2.0, y: originY, width: sizeThumb, height: sizeThumb), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Background/LoginView/Basic")
                argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] = [CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION: [UIRectCorner.allCorners], CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS: sizeThumb / 2.0]
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeImage {
                self.safeAreaView.addSubview(thumbView)
                originY += thumbView.frame.height
                thumbView.imageWithName(fullName)
                if let urlImage: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String {
                    thumbView.imageWithUrl(urlImage)
                }
            }
            originY += CONSTANTS.SCREEN.MARGIN(2)
            if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: originY, width: self.frame.width, height: 30.0), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = fullName
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 26.0, true)
                argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
                argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                self.safeAreaView.addSubview(label)
                originY += label.frame.height
            }
            if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: originY, width: 0, height: 0), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = countryName
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
                argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
                argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                self.safeAreaView.addSubview(label)
                var widthCountryView: CGFloat = label.widthOfString()
                if let countryCode: String = country[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.CODE] as? String, let img_countryCode: UIImage = UIImage(named: countryCode.lowercased()) {
                    widthCountryView += img_countryCode.size.width + CONSTANTS.SCREEN.MARGIN(0.5)
                    self.safeAreaView.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: (self.frame.width - widthCountryView) / 2.0, y: originY + (label.heightOfString() - img_countryCode.size.height) / 2.0, width: img_countryCode.size.width, height: img_countryCode.size.height), {
                        var argument: [String: Any] = [String: Any]()
                        argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_countryCode
                        return argument
                    }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
                }
                label.frame = CGRect(x: (self.frame.width - widthCountryView) / 2.0 + (widthCountryView - label.widthOfString()), y: label.frame.origin.y, width: label.widthOfString(), height: label.heightOfString())
                originY += label.frame.height
            }
            originY += CONSTANTS.SCREEN.MARGIN(2)
            let widthEditProfileBtn: CGFloat = CONSTANTS.GLOBAL.getWidthLabel(byText: "EDIT_PROFILE".localized, CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)) + CONSTANTS.SCREEN.MARGIN(4)
            self.safeAreaView.addSubview(CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: (self.safeAreaView.frame.width - widthEditProfileBtn) / 2.0, y: originY, width: widthEditProfileBtn, height: 40.0), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] = [CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION: [UIRectCorner.allCorners], CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS: 20.0]
                argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
                argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "EDIT_PROFILE".localized
//                argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.loginWithPhoneNumber)]
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! CustomizeButton)
        }
    }
    
}
