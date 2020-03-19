//
//  LoginView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 17/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class LoginView: SuperView {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {

        fileprivate static let BACKGROUND: String = "Background/Basic_1"
        
        struct BUTTONS {

            fileprivate static let BACKGROUND: String = "Background/Basic_2"
            fileprivate static let HEIGHT: CGFloat = 50.0
            
        }
        
    }

    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .lightContent)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
    }
    
    // MARK: - Private Methods
    
    @objc private func loginWithPhoneNumber() {
        print("dasdsadasdsa")
//        self.transitionToChildOverlapContainer(viewName: "PhoneNumberView", nil, .coverVertical, false, nil)
    }

    // MARK: - Interstitial SuperView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: DEFAULT.BACKGROUND)
        var originY: CGFloat = self.safeAreaView.frame.height
        if let textView: UITextView = CONSTANTS.GLOBAL.createTextViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: 0, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.clear
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = String(format: "READ_&_TAPPING_TO_ACCEPT".localized, "PRIVACY_POLICY".localized, "AGREE_AND_CONTINUE".localized, "TERMS_OF_SERVICE".localized)
            argument[CONSTANTS.KEYS.ELEMENTS.ENABLE] = false
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.LINK] = UIColor(named: "Background/Basic_2")
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UITextView {
            textView.textContainerInset = .zero
            self.safeAreaView.addSubview(textView)
            originY -= (CONSTANTS.SCREEN.MARGIN() + textView.heightOfString())
            textView.frame = CGRect(x: textView.frame.origin.x, y: originY, width: textView.frame.width, height: textView.heightOfString())
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let underlineAttriString = NSMutableAttributedString(string: textView.text)
            underlineAttriString.addAttributes([.paragraphStyle: paragraph,
                                                .foregroundColor : UIColor.white,
                                                .font : CONSTANTS.GLOBAL.createFont(ofSize: 16.0, false)], range: (textView.text as NSString).range(of: textView.text))
            underlineAttriString.addAttributes([.font : CONSTANTS.GLOBAL.createFont(ofSize: 16.0, true),
                                                .link: "https://www.google.com"], range: (textView.text as NSString).range(of: "PRIVACY_POLICY".localized))
            underlineAttriString.addAttributes([.font : CONSTANTS.GLOBAL.createFont(ofSize: 16.0, true),
                                                .link: "https://www.google.com"], range: (textView.text as NSString).range(of: "TERMS_OF_SERVICE".localized))
            textView.attributedText = underlineAttriString
        }
        originY -= (CONSTANTS.SCREEN.MARGIN(2) + DEFAULT.BUTTONS.HEIGHT)
        self.safeAreaView.addSubview(CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: DEFAULT.BUTTONS.HEIGHT), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor(named: "Background/Basic_2")
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "AGREE_AND_CONTINUE".localized
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.loginWithPhoneNumber)]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! CustomizeButton)
        

        
        
    }
    
}
