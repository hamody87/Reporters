//
//  TemplateLoginView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 19/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class TemplateLoginView: SuperView {
    
    // MARK: - Basic Constants

    struct DEFAULT {

        fileprivate static let BACKGROUND: String = "Background/Second"

        struct NAVBAR {
            struct HEIGHT {
                fileprivate static let SIZE: CGFloat = CORE + OVERRIDE.TOP + OVERRIDE.BOTTOM
                fileprivate static let CORE: CGFloat = 75.0
                struct OVERRIDE {
                    fileprivate static let TOP: CGFloat = CONSTANTS.SCREEN.SAFE_AREA.TOP()
                    fileprivate static let BOTTOM: CGFloat = 20.0
                }
            }
            fileprivate static let MARGIN: CGFloat = CONSTANTS.SCREEN.MARGIN(2)
        }

    }

    // MARK: - Declare Basic Variables

    internal var navBar: SuperView!
    internal var backBtn: SuperView!

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
        self.setStatusBarAnyStyle(statusBarStyle: .default)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
    }

    // MARK: - Interstitial SuperView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: DEFAULT.BACKGROUND)
        if let view: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 0, y: 0, width: self.frame.width, height: DEFAULT.NAVBAR.HEIGHT.SIZE), {
            return nil
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.navBar = view
            self.addSubview(self.navBar)
            if let img_logo: UIImage = UIImage(named: "Logo") {
                self.navBar.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: (self.navBar.frame.width - img_logo.size.width) / 2.0, y: DEFAULT.NAVBAR.HEIGHT.OVERRIDE.TOP + (DEFAULT.NAVBAR.HEIGHT.CORE - img_logo.size.height) / 2.0, width: img_logo.size.width, height: img_logo.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_logo
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
                if let img_backBtn: UIImage = UIImage(named: "RightBack_Btn") {
                    if let backBtn: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 0, y: DEFAULT.NAVBAR.HEIGHT.OVERRIDE.TOP + (DEFAULT.NAVBAR.HEIGHT.CORE - img_backBtn.size.height) / 2.0, width: 0, height: img_backBtn.size.height), nil)[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
                        self.backBtn = backBtn
                        self.addSubview(self.backBtn)
                        var widthBackBtn: CGFloat = 0
                        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: -2, width: 0, height: self.backBtn.frame.height), {
                            var argument: [String: Any] = [String: Any]()
                            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "Go Back".localized
                            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
                            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.right
                            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Font/Basic")
                            return argument
                        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                            label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.widthOfString(), height: label.frame.height)
                            self.backBtn.addSubview(label)
                            widthBackBtn += label.widthOfString() - 5
                        }
                        self.backBtn.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: widthBackBtn, y: 0, width: img_backBtn.size.width, height: img_backBtn.size.height), {
                            var argument: [String: Any] = [String: Any]()
                            argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_backBtn
                            return argument
                        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
                        widthBackBtn += img_backBtn.size.width
                        self.backBtn.addSubview(CONSTANTS.GLOBAL.createButtonElement(withFrame: CGRect(x: 0, y: 0, width: widthBackBtn, height: img_backBtn.size.height), {
                            var argument: [String: Any] = [String: Any]()
                            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET] = self
                            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR] = #selector(self.backToPrevSuperView as () -> Void)
                            return argument
                        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIButton)
                        self.backBtn.frame = CGRect(x: self.navBar.frame.width - widthBackBtn - DEFAULT.NAVBAR.MARGIN, y: self.backBtn.frame.origin.y, width: widthBackBtn, height: self.backBtn.frame.height)
                    }
                }
            }
            self.navBar.addSubview(CONSTANTS.GLOBAL.createTextViewElement(withFrame: CGRect(x: 0, y: self.navBar.frame.height - 1.0, width: self.navBar.frame.width, height: 1.0), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor(named: "Background/Fourth")
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIView)
        }
    }

}

