//
//  Global.swift
//  Reporters
//
//  Created by Muhammad Jbara on 17/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit
import Reachability

@objc public enum ModalTransitionStyle: Int {
    case leftDissolve
    case rightDissolve
    case coverVertical
    case coverLeft
    case coverRight
}

final class Global {
    
    private var reachability = try! Reachability()
    private var isReach: Bool!
    
    init() {
        self.reachability.whenReachable = { reachability in
            self.isReach = true
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        self.reachability.whenUnreachable = { _ in
            self.isReach = false
            print("Not reachable")
        }
        do {
            try self.reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    public func isReachability() -> Bool {
        return self.isReach
    }
    
    public func updateUserInfo(_ data: [String: Any]) -> Bool {
        if let userInfo: [String: Any] = CONSTANTS.GLOBAL.getUserInfo([CONSTANTS.KEYS.JSON.FIELD.ID.USER]), let userID: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String {
            let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
            if query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.USER, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(userID)'", data) {
                return true
            }
        }
        return false
    }
    
    public func getUserInfo(_ fields: [String]! = nil) -> [String: Any]! {
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        var sqlInfo: [String: Any] = [String: Any]()
        sqlInfo[CONSTANTS.KEYS.SQL.NAME_ENTITY] = CONSTANTS.KEYS.SQL.ENTITY.USER
        sqlInfo[CONSTANTS.KEYS.SQL.FIELDS] = fields
        if let data: [Any] = query.fetchRequest(sqlInfo), data.count == 1, let info: [String: Any] = data[0] as? [String: Any] {
            return info
        }
        return nil
    }
    
    public func getFollowingUser(_ fields: [String]! = nil) -> [[String: Any]]! {
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        var sqlInfo: [String: Any] = [String: Any]()
        sqlInfo[CONSTANTS.KEYS.SQL.NAME_ENTITY] = CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING
        sqlInfo[CONSTANTS.KEYS.SQL.FIELDS] = fields
        if let data: [Any] = query.fetchRequest(sqlInfo), data.count > 0, let info: [[String: Any]] = data as? [[String: Any]] {
            return info
        }
        return nil
    }
    
    public func createFont(ofSize size: CGFloat, _ bold: Bool) -> UIFont {
        guard let font: UIFont = UIFont(name: (bold ? "FONT_FAMILT_BOLD".localized : "FONT_FAMILT_LIGHT".localized), size: 16.0) else {
            return bold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    public func getWidthLabel(byText text: String, _ font: UIFont, _ height: CGFloat! = nil) -> CGFloat {
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: height == nil ? .zero : CGRect(x: 0, y: 0, width: 0, height: height), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = text
            argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = font
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            return label.widthOfString()
        }
        return 0
    }
    
    public func getHeightLabel(byText text: String, _ font: UIFont, _ width: CGFloat! = nil) -> CGFloat {
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: width == nil ? .zero : CGRect(x: 0, y: 0, width: width, height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = text
            argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = font
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            return label.heightOfString()
        }
        return 0
    }
    
    public func createImageViewElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let imageView: UIImageView = UIImageView(frame: frame)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = imageView
        if let argument = argument {
            if let tag: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? NSNumber {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag.intValue
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
            if let tag: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? NSNumber {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag.intValue
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] as? UIColor {
                button.backgroundColor = color
            }
            if let image = argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] as? UIImage {
                button.setImage(image, for: UIControl.State.normal)
            }
            if let corner: [String: Any] = argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] as? [String: Any], let direction: [UIRectCorner] = corner[CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION] as? [UIRectCorner], let radius: NSNumber = corner[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] as? NSNumber {
                var cornersToRound: UIRectCorner = []
                for next in direction {
                    cornersToRound.insert(next)
                }
                button.roundCorners(corners: cornersToRound, radius: CGFloat(radius.floatValue))
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
            if let tag: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? NSNumber {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag.intValue
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
            if let numLines: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] as? NSNumber {
                label.numberOfLines = numLines.intValue
            }
            if let radius: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] as? NSNumber {
                label.layer.masksToBounds = true
                label.layer.cornerRadius = CGFloat(radius.floatValue)
            }
        }
        return document
    }
    
    public func createCustomButtonElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let customButton: CustomizeButton! = CustomizeButton(withFrame: frame, argument: argument)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = customButton
        if let argument = argument, let tag: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? NSNumber {
            document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag.intValue
        }
        return document
    }
    
    public func createCustomThumbElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let customImage: CustomizeImage! = CustomizeImage(withFrame: frame, argument: argument)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = customImage
        if let argument = argument, let tag: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? NSNumber {
            document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag.intValue
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
            if let tag: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? NSNumber {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag.intValue
            }
            if let corner: [String: Any] = argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] as? [String: Any], let direction: [UIRectCorner] = corner[CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION] as? [UIRectCorner], let radius: NSNumber = corner[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] as? NSNumber {
                var cornersToRound: UIRectCorner = []
                for next in direction {
                    cornersToRound.insert(next)
                }
                superView.roundCorners(corners: cornersToRound, radius: CGFloat(radius.floatValue))
            }
            if let mask = argument[CONSTANTS.KEYS.ELEMENTS.MASK] as? UIImage {
                superView.layer.mask = UIImageView(image: mask).layer
            }
            if let color = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] as? UIColor {
                superView.backgroundColor = color
            }
            if let alpha: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.ALPHA] as? NSNumber {
                superView.alpha = CGFloat(alpha.floatValue)
            }
            if let radius: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] as? NSNumber {
                superView.layer.cornerRadius = CGFloat(radius.floatValue)
            }
            if let clips = argument[CONSTANTS.KEYS.ELEMENTS.CLIPS] as? Bool {
                superView.clipsToBounds = clips
            }
        }
        return document
    }
    
    public func createTextViewElement(withFrame frame: CGRect, _ argument: [String: Any]! = nil) -> [String: Any] {
        var document: [String: Any] = [String: Any]()
        let textView: UITextView = UITextView(frame: frame)
        document[CONSTANTS.KEYS.ELEMENTS.SELF] = textView
        if let argument = argument {
            if let tag: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? NSNumber {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag.intValue
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
            if let enable = argument[CONSTANTS.KEYS.ELEMENTS.ALLOW.ENABLE] as? Bool {
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
            if let tag: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TAG] as? NSNumber {
                document[CONSTANTS.KEYS.ELEMENTS.TAG] = tag.intValue
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
            if let left: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.LEFT] as? NSNumber {
                textView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(left.floatValue), height: textView.frame.height))
                textView.leftViewMode = .always
            }
            if let right: NSNumber = argument[CONSTANTS.KEYS.ELEMENTS.TEXTFIELD.MARGIN.RIGHT] as? NSNumber {
                textView.rightView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(right.floatValue), height: textView.frame.height))
                textView.rightViewMode = .always
            }
        }
        return document
    }
    
}
