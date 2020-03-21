//
//  PhoneNumberView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 20/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit
import Firebase

extension PhoneNumberView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let num: Int = Int(string) ?? -1
        if 0 ... 9 ~= num {
            return true
        }
        return false
    }
    
}

class PhoneNumberView: TemplateLoginView {
    
    // MARK: - Declare Basic Variables
    
    private var phoneNumberTextField: UITextField!
    private var flag: UIImageView!
    private var phoneCode: UILabel!
    private var button: CustomizeButton!
    
    // MARK: - Private Methods
    
    @objc private func presentCountriesList() {
        self.phoneNumberTextField.endEditing(true)
        self.transitionToChildOverlapContainer(viewName: "CountriesList", nil, .coverVertical, false, nil)
    }
    
    private func updatePhoneCode() {
        if let code: String = UserDefaults.standard.value(forKey: CONSTANTS.KEYS.USERDEFAULTS.COUNTRY.CODE) as? String {
            self.phoneCode.text = "+\(CONSTANTS.INFO.GLOBAL.COUNTRY.PHONE_CODE[code] ?? 0)"
            if let img_flag: UIImage = UIImage(named: code.lowercased()) {
                self.flag.image = img_flag
            }
        }
    }
    
    @objc private func textFieldDidChange() {
        self.button.enableTouch(self.phoneNumberTextField.text?.count ?? 0 > 0)
    }
    
    @objc private func sendVerificationCode(_ sender: UIButton) {
//        self.phoneNumberTextField.endEditing(true)
//        let progress: ExpressProgress! = ExpressProgress(showProgressAddedTo: self)
//        progress.showProgress()
//        let phoneNumber: String = "\(self.phoneCode.text ?? "0")\(self.phoneNumberTextField.text ?? "0")"
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
//            if let error = error {
//                progress.errorProgress(withMessage: error.localizedDescription.localized, {
//                    self.phoneNumberTextField.becomeFirstResponder()
//                })
//                return
//            }
//            progress.doneProgress(withMessage: "Verification code sent successfully".localized, {
//                var argument: [String: Any] = [String: Any]()
//                argument[CONSTANTS.KEYS.JSON.FIELD.VERIFICATION_ID] =  verificationID
//                argument[CONSTANTS.KEYS.JSON.FIELD.PHONE.CODE] =  Int(self.phoneCode.text ?? "0")
//                argument[CONSTANTS.KEYS.JSON.FIELD.PHONE.NUMBER] =  Int(self.phoneNumberTextField.text ?? "0")
//                self.transitionToChildOverlapContainer(viewName: "VerificationCodeView", argument, .coverLeft, false, nil)
//            })
//        }
    }
    
    // MARK: - Override Methods
    
    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.phoneNumberTextField.becomeFirstResponder()
        self.updatePhoneCode()
    }
    
    override func backToPrevSuperView() {
        super.backToPrevSuperView()
        self.phoneNumberTextField.endEditing(true)
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        var originY: CGFloat = self.navBar.frame.height + CONSTANTS.SCREEN.MARGIN(2)
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: originY, width: self.frame.width, height: 30.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "ENTER_PHONE_NUMBER".localized
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 22.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Font/First")
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            self.addSubview(label)
            originY += label.frame.height
        }
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(1), y: originY, width: self.frame.width - CONSTANTS.SCREEN.MARGIN(2), height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "NOTICE_ENTER_PHONE_NUMBER".localized
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Font/Basic")
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.width, height: label.heightOfString())
            self.addSubview(label)
            originY += label.frame.height + CONSTANTS.SCREEN.MARGIN(2)
        }
        if let codeCountryView: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: 110.0, height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor(named: "Background/Fourth")
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.addSubview(codeCountryView)
            if let img_flag: UIImage = UIImage(named: "none") {
                if let imageView: UIImageView = CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: (codeCountryView.frame.height - img_flag.size.height) / 2.0, width: img_flag.size.width, height: img_flag.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_flag
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIImageView {
                    self.flag = imageView
                    codeCountryView.addSubview(self.flag)
                    if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: self.flag.frame.width + CONSTANTS.SCREEN.MARGIN() + 4.0, y: 0, width: codeCountryView.frame.width - self.flag.frame.width - CONSTANTS.SCREEN.MARGIN(2), height: codeCountryView.frame.height), {
                        var argument: [String: Any] = [String: Any]()
                        argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "+0"
                        argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 22.0, false)
                        argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.left
                        argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Font/Basic")
                        return argument
                    }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                        self.phoneCode = label
                        codeCountryView.addSubview(self.phoneCode)
                    }
                }
                UserDefaults.standard.set(CONSTANTS.INFO.GLOBAL.COUNTRY.CODE, forKey: CONSTANTS.KEYS.USERDEFAULTS.COUNTRY.CODE)
                self.updatePhoneCode()
            }
            if let img_arrow: UIImage = UIImage(named: "DownArrow") {
                codeCountryView.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: codeCountryView.frame.width - img_arrow.size.width - CONSTANTS.SCREEN.MARGIN(), y: (codeCountryView.frame.height - img_arrow.size.height) / 2.0, width: img_arrow.size.width, height: img_arrow.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_arrow
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
            }
            self.addSubview(CONSTANTS.GLOBAL.createButtonElement(withFrame: codeCountryView.frame, {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET] = self
                argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR] = #selector(self.presentCountriesList as () -> Void)
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIButton)
            if let textField: UITextField = CONSTANTS.GLOBAL.createTextFieldElement(withFrame: CGRect(x: codeCountryView.frame.width + CONSTANTS.SCREEN.MARGIN(4), y: originY, width: self.frame.width - codeCountryView.frame.width - CONSTANTS.SCREEN.MARGIN(7), height: 50.0), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] =  UIColor(named: "Background/Fourth")
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 22.0, false)
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Font/Basic")
                argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.APPEARANCE] = UIKeyboardAppearance.dark
                argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.TYPE] = UIKeyboardType.phonePad
                argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.RETURNKEY] = UIReturnKeyType.default
                argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.left
                argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.LEFT] = 10.0
                argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.RIGHT] = 10.0
                argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UITextField {
                self.phoneNumberTextField = textField
                self.addSubview(self.phoneNumberTextField)
                NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChange), name: UITextField.textDidChangeNotification, object: nil)
            }
            originY += codeCountryView.frame.height + CONSTANTS.SCREEN.MARGIN(2)
        }
        if let customButton: CustomizeButton = CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 45.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor(named: "Font/First")
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "أرسل رمز التحقق"
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.sendVerificationCode(_ :))]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Font/Second")
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeButton {
            self.button = customButton
            self.addSubview(self.button)
        }
    }
    
}

