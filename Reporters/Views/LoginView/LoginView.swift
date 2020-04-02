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
        
        struct BACKGROUND {
            
            fileprivate static let BASIC: String = "Background/LoginView/Basic"
            fileprivate static let SECONDARY: String = "Background/LoginView/Secondary"
            
        }
        
        struct BUTTONS {

            fileprivate static let COLOR: String = "Background/Basic_2"
            fileprivate static let HEIGHT: CGFloat = 50.0
            
        }
        
        struct MESSAGE {
            
            fileprivate static let MARGIN: CGFloat = 3.0
            
            struct THUMB {
                fileprivate static let SIZE: CGFloat = 50.0
            }
            
        }
        
    }

    // MARK: - Declare Basic Variables

    private var messagesView: SuperView!
    private var messagesArray: [UIView] = [UIView]()

    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .lightContent)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
    }
    
    // MARK: - Private Methods
    
    @objc private func loginWithPhoneNumber() {
//        self.transitionToChildOverlapContainer(viewName: "PhoneNumberView", nil, .coverVertical, false, nil)
        self.transitionToChildOverlapContainer(viewName: "SignUpUserDetailsView", nil, .coverVertical, false, nil)
    }
    
    private func activateDemoMessages() {
        let message: UIView = UIView(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: self.messagesView.frame.height, width: self.messagesView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 0))
        self.messagesView.addSubview(message)
        let numRows: Int = Int.random(in: 1 ... 4)
        var width: CGFloat = message.frame.width - DEFAULT.MESSAGE.MARGIN - DEFAULT.MESSAGE.THUMB.SIZE
        var originX: CGFloat = CONSTANTS.SCREEN.LEFT_DIRECTION ? DEFAULT.MESSAGE.MARGIN + DEFAULT.MESSAGE.THUMB.SIZE : width
        if numRows == 1 {
            let percent: Float = Float.random(in: 0.6 ... 1.0)
            width *= CGFloat(percent)
        }
        if !CONSTANTS.SCREEN.LEFT_DIRECTION {
            originX -= width
        }
        let height: CGFloat = CGFloat(numRows + 1) * 20.0 + 10.0
        let rowsCore: UIView = UIView(frame: CGRect(x: originX, y: 0, width: width, height: height))
        rowsCore.backgroundColor = UIColor(named: "Background/LoginView/Messages/Message/Background")
        rowsCore.roundCorners(corners: CONSTANTS.SCREEN.LEFT_DIRECTION ? [.topLeft, .topRight, .bottomRight] : [.topLeft, .topRight, .bottomLeft], radius: 20.0)
        message.addSubview(rowsCore)
        for i in 1 ... numRows {
            var width: CGFloat = width - CONSTANTS.SCREEN.MARGIN(2)
            if i > 1 {
                let percent: Float = Float.random(in: 0.4 ... 1.0)
                width *= CGFloat(percent)
            }
            let row: UIView = UIView(frame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? CONSTANTS.SCREEN.MARGIN(1) : rowsCore.frame.width - width - CONSTANTS.SCREEN.MARGIN(1), y: CGFloat(i) * 20.0, width: width, height: 10.0))
            row.backgroundColor = UIColor(named: "Background/LoginView/Messages/Message/Text")
            rowsCore.addSubview(row)
        }
        message.frame = CGRect(x: message.frame.origin.x, y: message.frame.origin.y, width: message.frame.width, height: rowsCore.frame.height + 30.0 + DEFAULT.MESSAGE.MARGIN)
        let thumb: UIView = UIView(frame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? 0 : rowsCore.frame.origin.x + rowsCore.frame.width + DEFAULT.MESSAGE.MARGIN, y: message.frame.height - DEFAULT.MESSAGE.THUMB.SIZE, width: DEFAULT.MESSAGE.THUMB.SIZE, height: DEFAULT.MESSAGE.THUMB.SIZE))
        thumb.backgroundColor = UIColor(named: "Background/LoginView/Messages/Thumb")
        message.addSubview(thumb)
        let widthAuthorView: CGFloat = rowsCore.frame.width * CGFloat(Float.random(in: 0.5 ... 0.7))
        let authorView: UIView = UIView(frame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? rowsCore.frame.origin.x : rowsCore.frame.origin.x + rowsCore.frame.width - widthAuthorView, y: rowsCore.frame.height + DEFAULT.MESSAGE.MARGIN, width: widthAuthorView, height: 30.0))
        authorView.backgroundColor = UIColor(named: "Background/LoginView/Messages/Author/Background")
        message.addSubview(authorView)
        let rowAuthor: UIView = UIView(frame: CGRect(x: 10.0, y: 10.0, width: authorView.frame.width  - 20.0, height: 10.0))
        rowAuthor.backgroundColor = UIColor(named: "Background/LoginView/Messages/Author/Text")
        authorView.addSubview(rowAuthor)
        self.messagesArray.append(message)
        let decreaseOriginY: CGFloat = message.frame.height + CONSTANTS.SCREEN.MARGIN(3)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
            for nextMessage in self.messagesArray {
                nextMessage.frame = CGRect(x: nextMessage.frame.origin.x, y: nextMessage.frame.origin.y - decreaseOriginY, width: nextMessage.frame.width, height: nextMessage.frame.height)
            }
        }, completion: { _ in
            for i in 0 ..< self.messagesArray.count {
                if -self.messagesArray[i].frame.origin.y >= self.messagesArray[i].frame.height {
                    self.messagesArray.remove(at: i)
                } else {
                    break
                }
            }
            let dispatchAfter = DispatchTimeInterval.seconds(Int.random(in: 1 ... 10))
            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
                self.activateDemoMessages()
            }
        })
    }

    // MARK: - Interstitial SuperView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: DEFAULT.BACKGROUND.BASIC)
        var originY: CGFloat = self.safeAreaView.frame.height
        if let textView: UITextView = CONSTANTS.GLOBAL.createTextViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: 0, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.clear
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 17.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = String(format: "READ_OUR".localized, "PRIVACY_POLICY".localized)
            argument[CONSTANTS.KEYS.ELEMENTS.ALLOW.ENABLE] = false
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.LINK] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UITextView {
            textView.textContainerInset = .zero
            self.safeAreaView.addSubview(textView)
            originY -= (CONSTANTS.SCREEN.MARGIN(2) + textView.heightOfString())
            textView.frame = CGRect(x: textView.frame.origin.x, y: originY, width: textView.frame.width, height: textView.heightOfString())
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let underlineAttriString = NSMutableAttributedString(string: textView.text)
            underlineAttriString.addAttributes([.paragraphStyle: paragraph,
                                                .foregroundColor: UIColor.white,
                                                .font: CONSTANTS.GLOBAL.createFont(ofSize: 17.0, false)], range: (textView.text as NSString).range(of: textView.text))
            underlineAttriString.addAttributes([.font: CONSTANTS.GLOBAL.createFont(ofSize: 17.0, true),
                                                .link: "https://www.google.com"], range: (textView.text as NSString).range(of: "PRIVACY_POLICY".localized))
            textView.attributedText = underlineAttriString
        }
        originY -= (CONSTANTS.SCREEN.MARGIN(2) + DEFAULT.BUTTONS.HEIGHT)
        self.safeAreaView.addSubview(CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: DEFAULT.BUTTONS.HEIGHT), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] = DEFAULT.BUTTONS.HEIGHT / 2.0
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "AGREE_AND_CONTINUE".localized
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.loginWithPhoneNumber)]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 22.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! CustomizeButton)
        if let textView: UITextView = CONSTANTS.GLOBAL.createTextViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: 0, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.clear
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 17.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = String(format: "TAPPING_TO_ACCEPT".localized, "AGREE_AND_CONTINUE".localized, "TERMS_OF_SERVICE".localized)
            argument[CONSTANTS.KEYS.ELEMENTS.ALLOW.ENABLE] = false
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.LINK] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UITextView {
            textView.textContainerInset = .zero
            self.safeAreaView.addSubview(textView)
            originY -= (CONSTANTS.SCREEN.MARGIN(2) + textView.heightOfString())
            textView.frame = CGRect(x: textView.frame.origin.x, y: originY, width: textView.frame.width, height: textView.heightOfString())
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let underlineAttriString = NSMutableAttributedString(string: textView.text)
            underlineAttriString.addAttributes([.paragraphStyle: paragraph,
                                                .foregroundColor: UIColor.white,
                                                .font: CONSTANTS.GLOBAL.createFont(ofSize: 17.0, false)], range: (textView.text as NSString).range(of: textView.text))
            underlineAttriString.addAttributes([.font: CONSTANTS.GLOBAL.createFont(ofSize: 17.0, true),
                                                .link: "https://www.google.com"], range: (textView.text as NSString).range(of: "TERMS_OF_SERVICE".localized))
            textView.attributedText = underlineAttriString
        }
        originY -= CONSTANTS.SCREEN.MARGIN(2)
        if let view: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.safeAreaView.frame.origin.y + originY), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.CLIPS] = true
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor(named: DEFAULT.BACKGROUND.SECONDARY)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.messagesView = view
            self.addSubview(self.messagesView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.activateDemoMessages()
        }
    }
    
}
