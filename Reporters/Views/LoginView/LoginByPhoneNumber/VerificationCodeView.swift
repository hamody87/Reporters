//
//  VerificationCodeView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 29/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

extension VerificationCodeView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let num: Int = Int(string) ?? -1
        if 0 ... 9 ~= num {
            return !(textField.text?.count == 6)
        }
        return false
    }

}

class VerificationCodeView: TemplateLoginView {

    // MARK: - Declare Basic Variables

    private var verificationID: String!
    private var phoneNumberLabel: UILabel!
    private var authenticationCodeTextField: UITextField!
    private var button: CustomizeButton!

    // MARK: - Private Methods

    @objc private func textFieldDidChange() {
        self.button.enableTouch(self.authenticationCodeTextField.text?.count ?? 0 > 5)
    }

    @objc private func authenticationCode(_ sender: UIButton) {
        self.authenticationCodeTextField.endEditing(true)
        let progress: ExpressProgress! = ExpressProgress(showProgressAddedTo: self)
        progress.showProgress()
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: self.authenticationCodeTextField.text ?? "0")
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                progress.stopProgress(isSuccess: false, error.localizedDescription.localized, {
                    self.authenticationCodeTextField.becomeFirstResponder()
                })
                return
            }
            guard let user = Auth.auth().currentUser else {
                progress.stopProgress(isSuccess: false, "\("ERROR_OCCURRED".localized), \("TRY_LATER".localized)", nil)
                return
            }
            let db = Firestore.firestore()
            db.collection(CONSTANTS.KEYS.JSON.COLLECTION.USERS).document(user.uid).getDocument() { (document, error) in
                if let _ = error {
                    progress.stopProgress(isSuccess: false, "\("ERROR_OCCURRED".localized), \("TRY_LATER".localized)", nil)
                    return
                }
                if let document = document, document.exists, let argument: [String: Any] = document.data() {
                    let datatHandler: DatatHandler = DatatHandler.init()
                    datatHandler.loginUser(withData: argument, {
                        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
                        var sqlInfo: [String: Any] = [String: Any]()
                        sqlInfo[CONSTANTS.KEYS.SQL.NAME_ENTITY] = CONSTANTS.KEYS.SQL.ENTITY.USER
                        if let data: [Any] = query.fetchRequest(sqlInfo)  {
                            print(data)
                        }
                        self.transitionToChildOverlapContainer(viewName: "LandingView", nil, .coverVertical, false, nil)
                    }, {
                        progress.stopProgress(isSuccess: false, "\("ERROR_OCCURRED".localized), \("TRY_LATER".localized)", nil)
                    })
                    return
                }
                var argument: [String: Any]! = self.arguments as? [String: Any]
                argument[CONSTANTS.KEYS.JSON.FIELD.ID.USER] = user.uid
                self.transitionToChildOverlapContainer(viewName: "SignUpUserDetailsView", argument, .coverLeft, false, {
                    progress.hideProgress(nil)
                })
            }
        }
    }

    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.authenticationCodeTextField.becomeFirstResponder()
    }

    override func loadSuperView(anArgument: Any!) {
        super.loadSuperView(anArgument: anArgument)
        let argument: [String: Any]! = anArgument as? [String: Any]
        if let verificationID: String = argument[CONSTANTS.KEYS.JSON.FIELD.ID.VERIFICATION] as? String {
            self.verificationID = verificationID
        }
        if let phoneCode: Int = argument[CONSTANTS.KEYS.JSON.FIELD.PHONE.CODE] as? Int, let phoneNumber: Int = argument[CONSTANTS.KEYS.JSON.FIELD.PHONE.NUMBER] as? Int {
            self.phoneNumberLabel.text = "+\(phoneCode)\(phoneNumber)"
        }
    }

    override func backToPrevSuperView() {
        super.backToPrevSuperView()
        self.authenticationCodeTextField.endEditing(true)
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
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "\("ENTER".localized) \("VERIFICATION_CODE".localized)"
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
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "+0".localized
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.width, height: label.heightOfString())
            self.phoneNumberLabel = label
            self.safeAreaView.addSubview(self.phoneNumberLabel)
            originY += self.phoneNumberLabel.frame.height + CONSTANTS.SCREEN.MARGIN(2)
        }
        if let textField: UITextField = CONSTANTS.GLOBAL.createTextFieldElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 22.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.APPEARANCE] = UIKeyboardAppearance.dark
            argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.TYPE] = UIKeyboardType.phonePad
            argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.RETURNKEY] = UIReturnKeyType.default
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.LEFT] = 10.0
            argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.RIGHT] = 10.0
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UITextField {
            self.authenticationCodeTextField = textField
            self.safeAreaView.addSubview(self.authenticationCodeTextField)
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChange), name: UITextField.textDidChangeNotification, object: nil)
        }
        originY += self.authenticationCodeTextField.frame.height + CONSTANTS.SCREEN.MARGIN()
        if let customButton: CustomizeButton = CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "CONTINUE".localized
            argument[CONSTANTS.KEYS.ELEMENTS.ALLOW.ENABLE] = false
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.authenticationCode(_ :))]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeButton {
            self.button = customButton
            self.safeAreaView.addSubview(self.button)
        }
    }

}
