//
//  TabBarView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 07/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class TabBarView: SuperView {
    
    // MARK: - Declare Basic Variables

    private var thumbView: CustomizeImage!
    private var addBtnView: SuperView!
    private var scrollDownBtn: ScrollDownBtn!
    
    // MARK: - Private Methods
    
    @objc private func showThumb() {
        self.thumbView.endUploadingImage()
        if let userInfo: [String: Any] = CONSTANTS.GLOBAL.getUserInfo([CONSTANTS.KEYS.JSON.FIELD.THUMB]), let urlImage: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String {
            self.thumbView.imageWithUrl(urlImage)
        }
    }
    
    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .default)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
    }
    
    @objc private func startUploadingThumb() {
        self.thumbView.startUploadingImage()
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: "Background/Basic")
        let topBorder: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 1.0))
        topBorder.backgroundColor = UIColor(named: "Background/Border")
        self.addSubview(topBorder)
        let sizeAllow: CGFloat = self.frame.height - 1.0 - CONSTANTS.SCREEN.MARGIN(2) - CONSTANTS.SCREEN.SAFE_AREA.BOTTOM()
        if let thumbView: CustomizeImage = CONSTANTS.GLOBAL.createCustomThumbElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(2), y: CONSTANTS.SCREEN.MARGIN(1) + 1.0, width: sizeAllow, height: sizeAllow), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Background/LoginView/Basic")
            argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] = [CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION: [UIRectCorner.allCorners], CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS: sizeAllow / 2.0]
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeImage {
            self.thumbView = thumbView
            self.addSubview(self.thumbView)
            if let userInfo: [String: Any] = CONSTANTS.GLOBAL.getUserInfo([CONSTANTS.KEYS.JSON.FIELD.NAME, CONSTANTS.KEYS.JSON.FIELD.THUMB]), let fullName: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String {
                self.thumbView.imageWithName(fullName)
                if let urlImage: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String {
                    self.thumbView.imageWithUrl(urlImage)
                }
            }
        }
        if let img_addIcon: UIImage = UIImage(named: "\(self.classDir())AddIcon") {
            if let addBtnView: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 0, y: CONSTANTS.SCREEN.MARGIN(1) + 1.0, width: 0, height: sizeAllow), nil)[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
                self.addBtnView = addBtnView
                self.addSubview(self.addBtnView)
                if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect.zero, {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "SEND_MESSAGE".localized
                    argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 14.0, false)
                    argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                    label.frame = CGRect(x: 0, y: self.addBtnView.frame.height - label.heightOfString(), width: label.widthOfString(), height: label.heightOfString())
                    self.addBtnView.frame = CGRect(x: (self.frame.width - label.frame.width) / 2.0, y: self.addBtnView.frame.origin.y, width: label.frame.width, height: self.addBtnView.frame.height)
                    self.addBtnView.addSubview(label)
                    self.addBtnView.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: (self.addBtnView.frame.width - img_addIcon.size.width) / 2.0, y: 0, width: img_addIcon.size.width, height: img_addIcon.size.height), {
                        var argument: [String: Any] = [String: Any]()
                        argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_addIcon
                        return argument
                    }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
                }
            }
        }
        self.scrollDownBtn = ScrollDownBtn(withFrame: CGRect(x: self.frame.width - CONSTANTS.SCREEN.MARGIN(2) - sizeAllow, y: CONSTANTS.SCREEN.MARGIN(1) + 1.0, width: sizeAllow, height: sizeAllow), delegate: self)
        self.addSubview(self.scrollDownBtn)
//        self.scrollDownBtn.isHidden = true
        self.addBtnView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.startUploadingThumb), name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.WILL.USER.CHANGE.THUMB), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showThumb), name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.DID.USER.CHANGE.THUMB), object: nil)
    }
    
}
