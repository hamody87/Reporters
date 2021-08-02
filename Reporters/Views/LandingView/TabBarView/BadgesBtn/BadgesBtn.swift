//
//  BadgesBtn.swift
//  Reporters
//
//  Created by Muhammad Jbara on 29/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class BadgesBtn: SuperView {
    
    // MARK: - Declare Basic Variables
    
    private var numMessagesLabel: UILabel!
    private var numMessagesBtn: UIButton!
    private var isHide: Bool = false
    
    // MARK: - Drawing Methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isHide {
            let contextRef: CGContext! = UIGraphicsGetCurrentContext()
            contextRef.setFillColor(UIColor.red.cgColor)
            contextRef.addArc(center: CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0), radius: self.frame.width / 2.0, startAngle: 0, endAngle: .pi * 2.0, clockwise: false)
            contextRef.fillPath()
        }
    }
    
    // MARK: - Private Methods
    
    @objc private func scrollToNewMessages() {
        if !isHide {
            self.delegate?.transferArgumentToPreviousSuperView(anArgument: nil)
        }
    }
    
    // MARK: - Public Methods
    
    public func hideBadges() {
        self.isHide = true
        self.numMessagesLabel.isHidden = true
        self.setNeedsDisplay()
    }
    
    public func newBadges(withNum num: Int) {
        if num <= 0 {
            self.hideBadges()
            return
        }
        self.isHide = false
        self.numMessagesLabel.isHidden = false
        if num > 999 {
            self.numMessagesLabel.text = "\(num / 1000)K"
            return
        }
        self.numMessagesLabel.text = "\(num)"
        self.setNeedsDisplay()
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = .clear
        if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: self.bounds, {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 15.0, true)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor.white
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            self.numMessagesLabel = label
            self.addSubview(self.numMessagesLabel)
        }
        if let btn: UIButton = CONSTANTS.GLOBAL.createButtonElement(withFrame: self.bounds, {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.scrollToNewMessages)]
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIButton {
            self.numMessagesBtn = btn
            self.addSubview(self.numMessagesBtn)
        }
        self.hideBadges()
    }
    
}
