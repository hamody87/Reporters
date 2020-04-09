//
//  SignUpUserDetailsView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 31/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpUserDetailsView: TemplateLoginView {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {
        
        struct TITLES {
            fileprivate static let FIRST: [String?] = ["SIGNUP_FIRST_TITLE_1".localized, "SIGNUP_FIRST_TITLE_2".localized, "SIGNUP_FIRST_TITLE_3".localized]
            fileprivate static let SECOND: [String?] = ["SIGNUP_SECOND_TITLE_1".localized, "SIGNUP_SECOND_TITLE_2".localized, "SIGNUP_SECOND_TITLE_3".localized]
        }
        
    }
    
    // MARK: - Declare Enums
    
    enum StepTag: Int {
        case fullName = 0
        case country
        case photo
    }
    
    // MARK: - Declare Basic Variables
    
    private var mainScrollView: UIScrollView!
    private var stepControl: StepControl!
    private var textFieldReference: [UITextField] = [UITextField]()
    private var customizeButtonReference: [CustomizeButton] = [CustomizeButton]()
    private var flag: UIImageView!
    private var phoneCode: UILabel!
    private var selectedCode: String = CONSTANTS.INFO.GLOBAL.COUNTRY.CODE
    private var imageView: CustomizeImage!
    
    // MARK: - Private Methods
    
    private func updatePhoneCode() {
        self.phoneCode.text = CONSTANTS.INFO.GLOBAL.COUNTRY.NAME(code: self.selectedCode)
        if let img_flag: UIImage = UIImage(named: self.selectedCode.lowercased()) {
            self.flag.image = img_flag
        }
    }
    
    private func startEditingTextField() {
        if self.textFieldReference.indices.contains(self.stepControl.presentStep() - 1) {
            self.textFieldReference[self.stepControl.presentStep() - 1].becomeFirstResponder()
        }
    }
    
    private func endEditingTextField() {
        if self.textFieldReference.indices.contains(self.stepControl.presentStep() - 1) {
            self.textFieldReference[self.stepControl.presentStep() - 1].endEditing(true)
        }
    }
    
    @objc private func textFieldDidChange() {
        switch self.stepControl.presentStep() - 1 {
            
        case StepTag.fullName.rawValue:
            if self.textFieldReference[self.stepControl.presentStep() - 1].text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 3 {
                self.customizeButtonReference[self.stepControl.presentStep() - 1].enableTouch(true)
            } else {
                self.customizeButtonReference[self.stepControl.presentStep() - 1].enableTouch(false)
            }
            break
            
        default:
            break
            
        }
    }
    
    private func showNextStep() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: {
            self.mainScrollView.setContentOffset(CGPoint(x:  self.mainScrollView.frame.width * (CONSTANTS.SCREEN.LEFT_DIRECTION ? CGFloat(self.stepControl.presentStep() - 1) : CGFloat(self.stepControl.numSteps() - self.stepControl.presentStep())), y: 0.0), animated: false)
        }, completion: { _ in
            self.startEditingTextField()
        })
    }
    
    @objc private func nextStep(_ sender: UIButton) {
        switch self.stepControl.presentStep() - 1 {
            
        case StepTag.fullName.rawValue:
            if let fullName: String = self.textFieldReference[StepTag.fullName.rawValue].text {
                self.imageView.imageWithName(fullName)
            }
            break
            
        default:
            break
            
        }
        self.endEditingTextField()
        self.stepControl.next()
        self.showNextStep()
    }
    
    @objc private func presentCountriesList() {
        var argument: [String: Any] = [String: Any]()
        argument[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.CODE] = self.selectedCode
        argument[CONSTANTS.KEYS.ELEMENTS.HIDDEN] = true
        self.transitionToChildOverlapContainer(viewName: "CountriesList", argument, .coverVertical, false, nil)
    }
    
    @objc private func registerNewUser() {
        let progress: ExpressProgress! = ExpressProgress(showProgressAddedTo: self)
        progress.showProgress()
        var userInfoForCloud: [String: Any] = [String: Any]()
        if let fullName: String = self.textFieldReference[StepTag.fullName.rawValue].text {
            userInfoForCloud[CONSTANTS.KEYS.JSON.FIELD.NAME] = fullName.trimmingCharacters(in: .whitespacesAndNewlines).capitalizingFirstLetterOfSentence()
        }
        userInfoForCloud[CONSTANTS.KEYS.JSON.FIELD.LEVEL] = CONSTANTS.KEYS.ELEMENTS.LEVELS.RECEIVER
        if let arg: [String: Any] = self.arguments as? [String: Any] {
            if let phoneCode: Int = arg[CONSTANTS.KEYS.JSON.FIELD.PHONE.CODE] as? Int, let phoneNumber: Int = arg[CONSTANTS.KEYS.JSON.FIELD.PHONE.NUMBER] as? Int {
                var phone: [String: Any] = [String: Any]()
                phone[CONSTANTS.KEYS.JSON.FIELD.PHONE.CODE] = phoneCode
                phone[CONSTANTS.KEYS.JSON.FIELD.PHONE.NUMBER] = phoneNumber
                userInfoForCloud[CONSTANTS.KEYS.JSON.FIELD.PHONE.SELF] = phone
            }
            if let userID: String = arg[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String {
                userInfoForCloud[CONSTANTS.KEYS.JSON.FIELD.ID.USER] = userID
            }
        }
        var date: [String: Any] = [String: Any]()
        let dateNow: Date = Date()
        date[CONSTANTS.KEYS.JSON.FIELD.DATE.REGISTER] = dateNow
        date[CONSTANTS.KEYS.JSON.FIELD.DATE.LOGIN] = dateNow
        userInfoForCloud[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] = date
        var info: [String: Any] = [String: Any]()
        var app: [String: Any] = [String: Any]()
        app[CONSTANTS.KEYS.JSON.FIELD.INFO.APP.VERSION] = CONSTANTS.INFO.APP.BUNDLE.VERSION
        info[CONSTANTS.KEYS.JSON.FIELD.INFO.APP.SELF] = app
        var device: [String: Any] = [String: Any]()
        device[CONSTANTS.KEYS.JSON.FIELD.INFO.DEVICE.TYPE] = CONSTANTS.DEVICE.MODEL
        device[CONSTANTS.KEYS.JSON.FIELD.INFO.DEVICE.OPERATING_SYSTEM] = "iOS \(CONSTANTS.DEVICE.VERSION)"
        info[CONSTANTS.KEYS.JSON.FIELD.INFO.DEVICE.SELF] = device
        userInfoForCloud[CONSTANTS.KEYS.JSON.FIELD.INFO.SELF] = info
        var country: [String: Any] = [String: Any]()
        country[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.NAME] = CONSTANTS.INFO.GLOBAL.COUNTRY.NAME(code: self.selectedCode)
        country[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.CODE] = self.selectedCode
        userInfoForCloud[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.SELF] = country
        let db = Firestore.firestore()
        db.collection(CONSTANTS.KEYS.JSON.COLLECTION.USERS).document(userInfoForCloud[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as! String).setData(userInfoForCloud) { err in
            if let _ = err {
                progress.stopProgress(isSuccess: false, "\("ERROR_OCCURRED".localized), \("TRY_LATER".localized)", nil)
            } else {
                let datatHandler: DatatHandler = DatatHandler.init()
                datatHandler.loginUser(withData: userInfoForCloud, {
                    self.transitionToChildOverlapContainer(viewName: "LandingView", nil, .coverVertical, false, {
                        if let thumb: UIImage = self.imageView.getImage(), let userID: String = userInfoForCloud[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String {
                            datatHandler.uploadThmub(userID, thumb, "Images/\(userID)/Thumb/\(Int64((dateNow.timeIntervalSince1970 * 1000.0).rounded()))_\(userID)_tb", 0.25, {
                                NotificationAlert.shared().nextNotification("SUCCESSFULLY_UPLOADED_NOTICE".localized, "\("SUCCESS".localized)!", thumb, false)
                            }, {
                                NotificationAlert.shared().nextNotification("FAILURE_UPLOADED_NOTICE".localized, "ERROR".localized, thumb, true)
                            })
                        }
                    })
                }, {
                    progress.stopProgress(isSuccess: false, "\("ERROR_OCCURRED".localized), \("TRY_LATER".localized)", nil)
                })
            }
        }
        
    }
    
    // MARK: - Override Methods
    
    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.startEditingTextField()
    }
    
    override func backToPrevSuperView() {
        self.endEditingTextField()
        if self.stepControl.presentStep() == 1 {
            super.backToPrevSuperView()
            return
        }
        self.stepControl.previous()
        self.showNextStep()
    }
        
    override func transferArgument(anArgument argument: Any!) {
        if let arg: [String: Any] = argument as? [String: Any], let code: String = arg[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.CODE] as? String {
            self.selectedCode = code
            self.updatePhoneCode()
        }
    }
    
    // MARK: - Interstitial SuperView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.title = "REGISTER".localized
        var originY: CGFloat = self.navBar.frame.height + CONSTANTS.SCREEN.MARGIN(3)
        self.stepControl = StepControl(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.safeAreaView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 10.0), 3)!
        self.safeAreaView.addSubview(self.stepControl)
        originY += stepControl.frame.height + CONSTANTS.SCREEN.MARGIN(3)
        self.mainScrollView = UIScrollView(frame: CGRect(x: 0, y: originY, width: self.safeAreaView.frame.width, height: self.safeAreaView.frame.height - originY - CONSTANTS.SCREEN.MARGIN(2)))
        self.mainScrollView.isPagingEnabled = true
        self.mainScrollView.isScrollEnabled = false
        self.safeAreaView.addSubview(self.mainScrollView)
        var origin: CGPoint = CGPoint(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? 0 : self.mainScrollView.frame.width * CGFloat(self.stepControl.numSteps() - self.stepControl.presentStep()), y: 0)
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width * CGFloat(self.stepControl.numSteps()), height: self.mainScrollView.frame.height)
        self.mainScrollView.setContentOffset(CGPoint(x: origin.x, y: 0.0), animated: false)
        origin.x += CONSTANTS.SCREEN.MARGIN(3)
        self.mainScrollView.addSubview(CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 45.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = DEFAULT.TITLES.FIRST[StepTag.fullName.rawValue]
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 40.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UILabel)
        origin.y += 35.0
        self.mainScrollView.addSubview(CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 45.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = DEFAULT.TITLES.SECOND[StepTag.fullName.rawValue]
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 40.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UILabel)
        origin.y += 45.0 + CONSTANTS.SCREEN.MARGIN(2)
        if let textField: UITextField = CONSTANTS.GLOBAL.createTextFieldElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 22.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.APPEARANCE] = UIKeyboardAppearance.dark
            argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.TYPE] = UIKeyboardType.default
            argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.RETURNKEY] = UIReturnKeyType.default
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
            argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.LEFT] = 10.0
            argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.RIGHT] = 10.0
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UITextField {
            self.textFieldReference.insert(textField, at: StepTag.fullName.rawValue)
            self.mainScrollView.addSubview(textField)
            origin.y += textField.frame.height
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChange), name: UITextField.textDidChangeNotification, object: nil)
        }
        origin.y += CONSTANTS.SCREEN.MARGIN(0.5)
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 12.0, false)
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "SIGNUP_NOTICE_1".localized
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.width, height: label.heightOfString())
            self.mainScrollView.addSubview(label)
            origin.y += label.frame.height + CONSTANTS.SCREEN.MARGIN(2)
        }
        if let customButton: CustomizeButton = CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "CONTINUE".localized
            argument[CONSTANTS.KEYS.ELEMENTS.ALLOW.ENABLE] = false
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.nextStep(_ :))]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeButton {
            self.customizeButtonReference.insert(customButton, at: StepTag.fullName.rawValue)
            self.mainScrollView.addSubview(customButton)
        }
        origin.x = self.mainScrollView.frame.width * CGFloat(CONSTANTS.SCREEN.LEFT_DIRECTION ? StepTag.country.rawValue : self.stepControl.numSteps() - (StepTag.country.rawValue + 1)) + CONSTANTS.SCREEN.MARGIN(3)
        origin.y = 0
        self.mainScrollView.addSubview(CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 45.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = DEFAULT.TITLES.FIRST[StepTag.country.rawValue]
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 40.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UILabel)
        origin.y += 35.0
        self.mainScrollView.addSubview(CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 45.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = DEFAULT.TITLES.SECOND[StepTag.country.rawValue]
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 40.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UILabel)
        origin.y += 45.0 + CONSTANTS.SCREEN.MARGIN(2)
        if let countryView: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.mainScrollView.addSubview(countryView)
            var pointLabel: CGPoint = CGPoint(x: CONSTANTS.SCREEN.MARGIN(), y: 0)
            var sizeLabel: CGSize = CGSize(width: countryView.frame.width - CONSTANTS.SCREEN.MARGIN(2), height: countryView.frame.height)
            if let img_arrow: UIImage = UIImage(named: "DownArrow") {
                countryView.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? countryView.frame.width - CONSTANTS.SCREEN.MARGIN() - img_arrow.size.width : CONSTANTS.SCREEN.MARGIN(), y: (countryView.frame.height - img_arrow.size.height) / 2.0, width: img_arrow.size.width, height: img_arrow.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_arrow
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
                sizeLabel.width -= (img_arrow.size.width + CONSTANTS.SCREEN.MARGIN())
                if !CONSTANTS.SCREEN.LEFT_DIRECTION {
                    pointLabel.x += img_arrow.size.width + CONSTANTS.SCREEN.MARGIN()
                }
            }
            if let img_flag: UIImage = UIImage(named: "none") {
                if let imageView: UIImageView = CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? CONSTANTS.SCREEN.MARGIN() : countryView.frame.width - CONSTANTS.SCREEN.MARGIN() - img_flag.size.width, y: (countryView.frame.height - img_flag.size.height) / 2.0, width: img_flag.size.width, height: img_flag.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_flag
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIImageView {
                    self.flag = imageView
                    countryView.addSubview(self.flag)
                    sizeLabel.width -= (self.flag.frame.width + CONSTANTS.SCREEN.MARGIN())
                    if CONSTANTS.SCREEN.LEFT_DIRECTION {
                        pointLabel.x += self.flag.frame.width + CONSTANTS.SCREEN.MARGIN()
                    }
                }
            }
            if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(origin: pointLabel, size: sizeLabel), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "NONE".localized
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
                argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                self.phoneCode = label
                countryView.addSubview(self.phoneCode)
            }
            countryView.addSubview(CONSTANTS.GLOBAL.createButtonElement(withFrame: countryView.bounds, {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.presentCountriesList as () -> Void)]
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIButton)
            origin.y += countryView.frame.height + CONSTANTS.SCREEN.MARGIN(2)
            self.updatePhoneCode()
        }
        if let customButton: CustomizeButton = CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "CONTINUE".localized
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.nextStep(_ :))]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeButton {
            self.customizeButtonReference.insert(customButton, at: StepTag.country.rawValue)
            self.mainScrollView.addSubview(customButton)
        }
        
        origin.x = self.mainScrollView.frame.width * CGFloat(CONSTANTS.SCREEN.LEFT_DIRECTION ? StepTag.photo.rawValue : self.stepControl.numSteps() - (StepTag.photo.rawValue + 1)) + CONSTANTS.SCREEN.MARGIN(3)
        origin.y = 0
        self.mainScrollView.addSubview(CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 45.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = DEFAULT.TITLES.FIRST[StepTag.photo.rawValue]
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 40.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UILabel)
        origin.y += 35.0
        self.mainScrollView.addSubview(CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: origin.x, y: origin.y, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 45.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = DEFAULT.TITLES.SECOND[StepTag.photo.rawValue]
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 40.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UILabel)
        origin.y += 45.0 + CONSTANTS.SCREEN.MARGIN(2)
        
        if let imageView: CustomizeImage = CONSTANTS.GLOBAL.createCustomThumbElement(withFrame: CGRect(x: origin.x - CONSTANTS.SCREEN.MARGIN(3) + (self.mainScrollView.frame.width - 150.0) / 2.0, y: origin.y, width: 150.0, height: 150.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.ALLOW.UPDATE] = true
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Background/LoginView/Basic")
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeImage {
            self.imageView = imageView
            self.mainScrollView.addSubview(self.imageView)
        }
        if let customButton: CustomizeButton = CONSTANTS.GLOBAL.createCustomButtonElement(withFrame: CGRect(x: origin.x, y: self.mainScrollView.frame.height - 50.0, width: self.mainScrollView.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 50.0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.black
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "FINISH".localized
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.registerNewUser)]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeButton {
            self.customizeButtonReference.insert(customButton, at: StepTag.country.rawValue)
            self.mainScrollView.addSubview(customButton)
        }
        
    }
    
}
