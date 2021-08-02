//
//  TemplateLoginView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 19/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class TemplateLoginView: SuperView {

    // MARK: - Declare Basic Variables

    internal var navBar: SuperView!
    internal var backBtn: SuperView!
    private var titleLabel: UILabel!
    public var title: String = "LOGIN".localized {
        didSet {
            self.titleLabel.text = self.title
            self.titleLabel.frame = CGRect(x: self.titleLabel.frame.origin.x, y: self.titleLabel.frame.origin.y, width: self.titleLabel.frame.width, height: self.titleLabel.heightOfString())
            self.navBar.frame = CGRect(x: self.navBar.frame.origin.x, y: self.navBar.frame.origin.y, width: self.navBar.frame.width, height: self.titleLabel.frame.height + CONSTANTS.SCREEN.MARGIN(2))
        }
    }

    // MARK: - Public Methods

    @objc public func backToPrevSuperView() {
        self.dismissChildOverlapContainer()
    }

    public func hideBackBtn(_ hide: Bool) {
        self.backBtn.isHidden = hide
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
        self.backgroundColor = UIColor(named: "Background/LoginView/Basic")
        if let view: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0), nil)[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.navBar = view
            self.safeAreaView.addSubview(self.navBar)
            if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: CONSTANTS.SCREEN.MARGIN(2), width: self.safeAreaView.frame.width, height: 0), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = self.title
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 26.0, true)
                argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                self.titleLabel = label
                label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.width, height: label.heightOfString())
                self.navBar.addSubview(label)
                self.navBar.frame = CGRect(x: self.navBar.frame.origin.x, y: self.navBar.frame.origin.y, width: self.navBar.frame.width, height: label.frame.height + CONSTANTS.SCREEN.MARGIN(2))
            }
            if let img_backBtn: UIImage = UIImage(named: "BackBtn-\("DIRECTION".localized)") {
                if let backBtn: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 0, y: CONSTANTS.SCREEN.MARGIN(), width: 0, height: img_backBtn.size.height), nil)[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
                    self.backBtn = backBtn
                    self.navBar.addSubview(self.backBtn)
                    var widthBackBtn: CGFloat = 0
                    if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? img_backBtn.size.width + CONSTANTS.SCREEN.MARGIN(0.5) : 0, y: 0, width: 0, height: self.backBtn.frame.height), {
                        var argument: [String: Any] = [String: Any]()
                        argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "BACK".localized
                        argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
                        argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
                        return argument
                    }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: (CONSTANTS.SCREEN.LEFT_DIRECTION ? 0 : CONSTANTS.SCREEN.MARGIN(0.5)) + label.widthOfString(), height: label.frame.height)
                        self.backBtn.addSubview(label)
                        widthBackBtn += label.frame.width
                    }
                    self.backBtn.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? 0 : widthBackBtn, y: 0, width: img_backBtn.size.width, height: img_backBtn.size.height), {
                        var argument: [String: Any] = [String: Any]()
                        argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_backBtn
                        return argument
                    }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
                    widthBackBtn += img_backBtn.size.width
                    self.backBtn.frame = CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? CONSTANTS.SCREEN.MARGIN() : self.safeAreaView.frame.width - widthBackBtn - CONSTANTS.SCREEN.MARGIN(), y: self.backBtn.frame.origin.y, width: widthBackBtn, height: self.backBtn.frame.height)
                    self.backBtn.addSubview(CONSTANTS.GLOBAL.createButtonElement(withFrame: self.backBtn.bounds, {
                        var argument: [String: Any] = [String: Any]()
                        argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.backToPrevSuperView as () -> Void)]
                        return argument
                    }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIButton)
                }
            }
        }
    }
    
}
