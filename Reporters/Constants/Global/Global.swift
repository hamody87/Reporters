//
//  Global.swift
//  Reporters
//
//  Created by Muhammad Jbara on 17/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

@objc public enum ModalTransitionStyle: Int {
    case leftDissolve
    case rightDissolve
    case coverVertical
    case coverLeft
    case coverRight
}

final class Global {
    
    public func createFont(ofSize size: CGFloat, _ bold: Bool) -> UIFont {
        guard let font: UIFont = UIFont(name: (bold ? "FONT_FAMILT_BOLD".localized : "FONT_FAMILT_LIGHT".localized), size: 16.0) else {
            return bold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    public func createImageViewElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let imageView: UIImageView = UIImageView(frame: frame)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = imageView
        if let argument = argument {
            if let tag = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? Int {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] as? UIColor {
                imageView.backgroundColor = color
            }
            if let image = argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] as? UIImage {
                imageView.image = image
            }
            if let hide = argument[CONSTANTS.KEYS.ELEMENTS.HIDDEN] as? Bool {
                imageView.isHidden = hide
            }
        }
        return document
    }
    
    public func createButtonElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let button: UIButton = UIButton(frame: frame)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = button
        if let argument = argument {
            if let tag = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? Int {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] as? UIColor {
                button.backgroundColor = color
            }
            if let image = argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] as? UIImage {
                button.setImage(image, for: UIControl.State.normal)
            }
            if let radius = argument[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] as? CGFloat {
                button.layer.cornerRadius = radius
            }
            if let hide = argument[CONSTANTS.KEYS.ELEMENTS.HIDDEN] as? Bool {
                button.isHidden = hide
            }
            if let action = argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] as? [String: Any], let selector = action[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR] as? Selector, let target = action[CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET] {
                if let event = action[CONSTANTS.KEYS.ELEMENTS.BUTTON.EVENT]  as? UIControl.Event  {
                    button.addTarget(target, action: selector, for: event)
                } else {
                    button.addTarget(target, action: selector, for: .touchUpInside)
                }
            }
        }
        return document
    }
    
    public func createLabelElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let label: UILabel = UILabel(frame: frame)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = label
        if let argument = argument {
            if let tag = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? Int {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] as? UIColor {
                label.backgroundColor = color
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] as? UIColor {
                label.textColor = color
            }
            if let font = argument[CONSTANTS.KEYS.ELEMENTS.FONT] as? UIFont {
                label.font = font
            }
            if let text = argument[CONSTANTS.KEYS.ELEMENTS.TEXT] as? String {
                label.text = text
            }
            if let alignment = argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] as? NSTextAlignment {
                label.textAlignment = alignment
            }
            if let numLines = argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] as? Int {
                label.numberOfLines = numLines
            }
            if let radius = argument[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] as? CGFloat {
                label.layer.masksToBounds = true
                label.layer.cornerRadius = radius
            }
        }
        return document
    }
    
    public func createCustomButtonElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let customButton: CustomizeButton! = CustomizeButton(withFrame: frame, argument: argument)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = customButton
        if let argument = argument, let tag = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? Int {
            document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag
        }
        return document
    }
    
    public func createSuperViewElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let superView: SuperView! = SuperView(withFrame: frame)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = superView
        if let argument = argument {
            if let delegate = argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] as? SuperViewDelegate {
                superView.delegate = delegate
            }
            if let tag = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? Int {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] as? UIColor {
                superView.backgroundColor = color
            }
            if let alpha = argument[CONSTANTS.KEYS.ELEMENTS.ALPHA] as? CGFloat {
                superView.alpha = alpha
            }
            if let radius = argument[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] as? CGFloat {
                superView.layer.cornerRadius = radius
            }
        }
        return document
    }
    
    public func createTextViewElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let textView: UITextView = UITextView(frame: frame)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = textView
        if let argument = argument {
            if let tag = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? Int {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag
            }
            if let delegate = argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] as? UITextViewDelegate {
                textView.delegate = delegate
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] as? UIColor {
                textView.backgroundColor = color
            }
            if let font = argument[CONSTANTS.KEYS.ELEMENTS.FONT] as? UIFont {
                textView.font = font
            }
            if let text = argument[CONSTANTS.KEYS.ELEMENTS.TEXT] as? String {
                textView.text = text
            }
            if let enable = argument[CONSTANTS.KEYS.ELEMENTS.ENABLE] as? Bool {
                textView.isEditable = enable
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.LINK] as? UIColor {
                textView.linkTextAttributes = [.foregroundColor: color]
            }
        }
        return document
    }
    
    public func createTextFieldElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let textView: UITextField = UITextField(frame: frame)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = textView
        if let argument = argument {
            if let tag = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? Int {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag
            }
            if let delegate = argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] as? UITextFieldDelegate {
                textView.delegate = delegate
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] as? UIColor {
                textView.backgroundColor = color
            }
            if let font = argument[CONSTANTS.KEYS.ELEMENTS.FONT] as? UIFont {
                textView.font = font
            }
            if let text = argument[CONSTANTS.KEYS.ELEMENTS.TEXT] as? String {
                textView.text = text
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] as? UIColor {
                textView.textColor = color
            }
            if let appearance = argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.APPEARANCE] as? UIKeyboardAppearance {
                textView.keyboardAppearance = appearance
            }
            if let alignment = argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] as? NSTextAlignment {
                textView.textAlignment = alignment
            }
            if let type = argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.TYPE] as? UIKeyboardType {
                textView.keyboardType = type
            }
            if let returnKey = argument[CONSTANTS.KEYS.ELEMENTS.KEYBOARD.RETURNKEY] as? UIReturnKeyType {
                textView.returnKeyType = returnKey
            }
            if let left = argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.LEFT] as? NSNumber {
                textView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(left.floatValue), height: textView.frame.height))
                textView.leftViewMode = .always
            }
            if let right = argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.RIGHT] as? NSNumber {
                textView.rightView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(right.floatValue), height: textView.frame.height))
                textView.rightViewMode = .always
            }
        }
        return document
    }
    
}