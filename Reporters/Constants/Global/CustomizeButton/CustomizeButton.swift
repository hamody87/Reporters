//
//  CustomizeButton.swift
//  Reporters
//
//  Created by Muhammad Jbara on 18/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class CustomizeButton: SuperView {
    
    // MARK: - Declare Basic Variables
    
    private var coreBtn: UIView!
    private var textBtn: UILabel!
    private var touchBtn: UIButton!
    
    // MARK: - Public Methods
    
    public func enableTouch(_ enable: Bool) {
        self.alpha = enable ? 1.0 : 0.3
        self.touchBtn.isEnabled = enable
    }
    
    public func addtext(_ text: String) {
        self.textBtn.text = text
    }
    
    public func setBackgroundButton(_ color: UIColor) {
        self.coreBtn.backgroundColor = color
    }
    
    // MARK: - Interstitial CustomizeButton
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
    }

    required convenience init?(withFrame frame: CGRect!, argument: [String: Any]! = nil) {
        self.init(withFrame: frame, delegate: nil)
        if let view: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: self.bounds, {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.black
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.coreBtn = view
            self.addSubview(self.coreBtn)
            if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: self.bounds, {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.clear
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
                argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
                argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                self.textBtn = label
                self.addSubview(self.textBtn)
            }
            if let btn: UIButton = CONSTANTS.GLOBAL.createButtonElement(withFrame: self.bounds, nil)[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIButton {
                self.touchBtn = btn
                self.addSubview(self.touchBtn)
            }
            self.enableTouch(true)
        }
        if let argument = argument {
            if let enable = argument[CONSTANTS.KEYS.ELEMENTS.ALLOW.ENABLE] as? Bool {
                self.enableTouch(enable)
            }
            if let text = argument[CONSTANTS.KEYS.ELEMENTS.TEXT] as? String {
                self.textBtn.text = text
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] as? UIColor {
                self.coreBtn.backgroundColor = color
            }
            if let corner: [String: Any] = argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] as? [String: Any], let direction: [UIRectCorner] = corner[CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION] as? [UIRectCorner], let radius: NSNumber = corner[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] as? NSNumber {
                var cornersToRound: UIRectCorner = []
                for next in direction {
                    cornersToRound.insert(next)
                }
                self.roundCorners(corners: cornersToRound, radius: CGFloat(radius.floatValue))
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] as? UIColor {
                self.textBtn.textColor = color
            }
            if let font = argument[CONSTANTS.KEYS.ELEMENTS.FONT] as? UIFont {
                self.textBtn.font = font
            }
            if let text = argument[CONSTANTS.KEYS.ELEMENTS.TEXT] as? String {
                self.textBtn.text = text
            }
            if let alignment = argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] as? NSTextAlignment {
                self.textBtn.textAlignment = alignment
            }
            if let action = argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] as? [String: Any], let selector = action[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR] as? Selector, let target = action[CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET] {
                if let event = action[CONSTANTS.KEYS.ELEMENTS.BUTTON.EVENT]  as? UIControl.Event  {
                    self.touchBtn.addTarget(target, action: selector, for: event)
                } else {
                    self.touchBtn.addTarget(target, action: selector, for: .touchUpInside)
                }
            }
        }
    }
    
}
