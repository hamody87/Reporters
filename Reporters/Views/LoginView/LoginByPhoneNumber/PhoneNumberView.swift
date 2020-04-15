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
    private var selectedCode: String = CONSTANTS.INFO.GLOBAL.COUNTRY.CODE
    
    // MARK: - Private Methods
    
    @objc private func presentCountriesList() {
        self.phoneNumberTextField.endEditing(true)
        var argument: [String: Any] = [String: Any]()
        argument[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.CODE] = self.selectedCode
        self.transitionToChildOverlapContainer(viewName: "CountriesList", argument, .coverVertical, false, nil)
    }
    
    private func updatePhoneCode() {
        self.phoneCode.text = "+\(CONSTANTS.INFO.GLOBAL.COUNTRY.PHONE_CODE[self.selectedCode] ?? 0)" 
        if let img_flag: UIImage = UIImage(named: self.selectedCode.lowercased()) {
            self.flag.image = img_flag
        }
    }
    
    @objc private func textFieldDidChange() {
        self.button.enableTouch(self.phoneNumberTextField.text?.count ?? 0 > 0)
    }
    
    @objc private func sendVerificationCode(_ sender: UIButton) {
        self.phoneNumberTextField.endEditing(true)
        let progress: ExpressProgress! = ExpressProgress(showProgressAddedTo: self)
        progress.showProgress()
        if let code: String = self.phoneCode.text, let number: String = self.phoneNumberTextField.text, let intCode: Int = Int(code), let intNumber: Int = Int(number) {
            Auth.auth().languageCode = CONSTANTS.DEVICE.LANGUAGE.CODE
            PhoneAuthProvider.provider().verifyPhoneNumber("+\(intCode)\(intNumber)", uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    progress.stopProgress(isSuccess: false, error.localizedDescription.localized, {
                        self.phoneNumberTextField.becomeFirstResponder()
                    })
                    return
                }
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.JSON.FIELD.ID.VERIFICATION] =  verificationID
                argument[CONSTANTS.KEYS.JSON.FIELD.PHONE.CODE] = intCode
                argument[CONSTANTS.KEYS.JSON.FIELD.PHONE.NUMBER] = intNumber
                self.transitionToChildOverlapContainer(viewName: "VerificationCodeView", argument, .coverLeft, false, {
                    progress.hideProgress(nil)
                })
            }
            return
        }
        progress.hideProgress(nil)
    }
    
    // MARK: - Override Methods
        
    override func transferArgument(anArgument argument: Any!) {
        if let arg: [String: Any] = argument as? [String: Any], let code: String = arg[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.CODE] as? String {
            self.selectedCode = code
            self.updatePhoneCode()
        }
    }
    
    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.phoneNumberTextField.becomeFirstResponder()
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
        var originY: CGFloat = self.navBar.frame.height + CONSTANTS.SCREEN.MARGIN(3)
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: originY, width: self.frame.width, height: 30.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "ENTER_PHONE_NUMBER".localized
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 22.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            self.safeAreaView.addSubview(label)
            originY += label.frame.height
        }
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(1), y: originY, width: self.frame.width - CONSTANTS.SCREEN.MARGIN(2), height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "NOTICE_ENTER_PHONE_NUMBER".localized
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.width, height: label.heightOfString())
            self.safeAreaView.addSubview(label)
            originY += label.frame.height + CONSTANTS.SCREEN.MARGIN(2)
        }
        
        if let codeCountryView: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: 110.0, height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.safeAreaView.addSubview(codeCountryView)
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
                        argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
                        argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.left
                        argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
                        return argument
                    }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                        self.phoneCode = label
                        codeCountryView.addSubview(self.phoneCode)
                    }
                }
                self.updatePhoneCode()
            }
            if let img_arrow: UIImage = UIImage(named: "DownArrow") {
                codeCountryView.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: codeCountryView.frame.width - img_arrow.size.width - CONSTANTS.SCREEN.MARGIN(), y: (codeCountryView.frame.height - img_arrow.size.height) / 2.0, width: img_arrow.size.width, height: img_arrow.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_arrow
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
            }
            self.safeAreaView.addSubview(CONSTANTS.GLOBAL.createButtonElement(withFrame: codeCountryView.frame, {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.presentCountriesList as () -> Void)]
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIButton)
            if let textField: UITextField = CONSTANTS.GLOBAL.createTextFieldElement(withFrame: CGRect(x: codeCountryView.frame.width + CONSTANTS.SCREEN.MARGIN(4), y: originY, width: self.frame.width - codeCountryView.frame.width - CONSTANTS.SCREEN.MARGIN(7), height: 50.0), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 22.0, false)
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
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
                self.safeAreaView.addSubview(self.phoneNumberTextField)
                NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChange), name: UITextField.textDidChangeNotification, object: nil)
            }
            originY += codeCountryView.frame.height + CONSTANTS.SCREEN.MARGIN()
        }
        if let customButton: CustomizeButton = CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "\("SEND".localized) \("VERIFICATION_CODE".localized)"
            argument[CONSTANTS.KEYS.ELEMENTS.ALLOW.ENABLE] = false
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.sendVerificationCode(_ :))]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeButton {
            self.button = customButton
            self.safeAreaView.addSubview(self.button)
        }
    }
    
}

