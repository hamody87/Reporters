//
//  SignUpUserDetailsView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 31/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class SignUpUserDetailsView: TemplateLoginView {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {
        
        struct TITLES {
            fileprivate static let FIRST: [String?] = ["SIGNUP_FIRST_TITLE_1".localized, "SIGNUP_FIRST_TITLE_2".localized]
            fileprivate static let SECOND: [String?] = ["SIGNUP_SECOND_TITLE_1".localized, "SIGNUP_SECOND_TITLE_2".localized]
        }
        
    }
    
    // MARK: - Declare Enums
    
    enum StepTag: Int {
        case fullName = 0
        case country
        case notification
    }
    
    // MARK: - Declare Basic Variables
    
    private var mainScrollView: UIScrollView!
    private var stepControl: StepControl!
    private var textFieldReference: [UITextField] = [UITextField]()
    private var customizeButtonReference: [CustomizeButton] = [CustomizeButton]()
    
    // MARK: - Private Methods
    
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
            if self.textFieldReference[self.stepControl.presentStep() - 1].text?.count ?? 0 >= 3 {
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
        self.endEditingTextField()
        self.stepControl.next()
        self.showNextStep()
    }
    
    @objc private func presentCountriesList() {
        var argument: [String: Any] = [String: Any]()
        argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "4444"
        self.transitionToChildOverlapContainer(viewName: "CountriesList", argument, .coverVertical, true, nil)
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
        print("dsadasdsassssssssssffffff")
    }
    
    // MARK: - Interstitial SuperView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.title = "REGISTER".localized
        var originY: CGFloat = self.navBar.frame.height + CONSTANTS.SCREEN.MARGIN(3)
        self.stepControl = StepControl(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(3), y: originY, width: self.frame.width - CONSTANTS.SCREEN.MARGIN(6), height: 10.0), 3)!
        self.safeAreaView.addSubview(self.stepControl)
        originY += stepControl.frame.height + CONSTANTS.SCREEN.MARGIN(3)
        self.mainScrollView = UIScrollView(frame: CGRect(x: 0, y: originY, width: self.frame.width, height: self.frame.height - originY - CONSTANTS.SCREEN.SAFE_AREA.BOTTOM()))
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
            argument[CONSTANTS.KEYS.ELEMENTS.ENABLE] = false
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.nextStep(_ :))]
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeButton {
            self.customizeButtonReference.insert(customButton, at: StepTag.fullName.rawValue)
            self.mainScrollView.addSubview(customButton)
        }
        origin.x = self.mainScrollView.frame.width * CGFloat(self.stepControl.numSteps() - (StepTag.country.rawValue + 1)) + CONSTANTS.SCREEN.MARGIN(3)
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
                countryView.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? CONSTANTS.SCREEN.MARGIN() : countryView.frame.width - CONSTANTS.SCREEN.MARGIN() - img_flag.size.width, y: (countryView.frame.height - img_flag.size.height) / 2.0, width: img_flag.size.width, height: img_flag.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_flag
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
                sizeLabel.width -= (img_flag.size.width + CONSTANTS.SCREEN.MARGIN())
                if CONSTANTS.SCREEN.LEFT_DIRECTION {
                    pointLabel.x += img_flag.size.width + CONSTANTS.SCREEN.MARGIN()
                }
            }
            countryView.addSubview(CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(origin: pointLabel, size: sizeLabel), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "Israel"
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
                argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.black
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UILabel)
            

           
            countryView.addSubview(CONSTANTS.GLOBAL.createButtonElement(withFrame: countryView.bounds, {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.presentCountriesList as () -> Void)]
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIButton)
            
            
            
            origin.y += countryView.frame.height + CONSTANTS.SCREEN.MARGIN(2)
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
        
        
        print(self)
    }
    
}
