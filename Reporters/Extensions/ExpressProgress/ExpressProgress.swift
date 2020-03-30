//
//  ExpressProgress.swift
//  Zabit
//
//  Created by Muhammad Jbara on 07/01/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

final class ExpressProgress: UIView {
    
    struct DEFAULT {
        
        static let BACKGROUND: String = "Background/ExpressProgress/Basic"
        static let ALPHA: CGFloat = 0.8
        
        struct CIRCLE {
            
            static let BACKGROUND: String = "Background/ExpressProgress/Secondary"
            static let RADIUS: CGFloat = 30.0
            
            struct LINE {
                static let WIDTH: CGFloat = 3.0
            }

            static let ANGLE: CGFloat = .pi * 2.0
            
        }
        
        struct MESSAGE {
            
            fileprivate static let MARGIN: CGFloat = CONSTANTS.SCREEN.MARGIN(2)
            
            struct FONT {
                fileprivate static let SIZE: CGFloat = 16.0
                fileprivate static let COLOR: String = "Font/Basic"
            }
            
        }
        
    }
    
    // MARK: - Declare Enums
    
    enum ProgressStatus: Int {
        case standBy = 0
        case animating
        case done
        case error
    }
    
    // MARK: - Declare Basic Variables
    
    private var receiverView: UIView!
    private var percentProgress: CGFloat = 0
    private var timer: Timer!
    private var progressStatus: ProgressStatus = .standBy
    private var doneIndicator: UIImageView!
    private var errorIndicator: UIImageView!
    private var messageLabel: UILabel!
    private var existMessage: Bool = false
    private var startAngle: CGFloat!
    private var endAngle: CGFloat!
    private var isSuccess: Bool!
    private var newMessage: String!
    private var completion: (() -> Void)?
    
    // MARK: - Drawing Methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        switch self.progressStatus {
                        
            case .animating:
                self.doneIndicator.isHidden = true
                self.errorIndicator.isHidden = true
                self.messageLabel.isHidden = !self.existMessage
                let contextRef: CGContext! = UIGraphicsGetCurrentContext()
                contextRef.setAlpha(DEFAULT.ALPHA)
                contextRef.setFillColor(UIColor(named: DEFAULT.BACKGROUND)?.cgColor ?? UIColor.clear.cgColor)
                contextRef.fill(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
                contextRef.fillPath()
                contextRef.setAlpha(1.0)
                contextRef.setLineWidth(DEFAULT.CIRCLE.LINE.WIDTH)
                contextRef.addArc(center: CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0), radius: DEFAULT.CIRCLE.RADIUS, startAngle: self.startAngle * self.percentProgress, endAngle: self.endAngle + self.startAngle * self.percentProgress, clockwise: false)
                contextRef.setStrokeColor(UIColor(named: DEFAULT.CIRCLE.BACKGROUND)?.cgColor ?? UIColor.clear.cgColor)
                contextRef.strokePath()
                break
                            
            case .done, .error:
                if  self.progressStatus == .done {
                    self.doneIndicator.isHidden = false
                    self.errorIndicator.isHidden = true
                } else {
                    self.doneIndicator.isHidden = true
                    self.errorIndicator.isHidden = false
                }
                self.messageLabel.isHidden = !self.existMessage
                let contextRef: CGContext! = UIGraphicsGetCurrentContext()
                contextRef.setAlpha(DEFAULT.ALPHA)
                contextRef.setFillColor(UIColor(named: DEFAULT.BACKGROUND)?.cgColor ?? UIColor.clear.cgColor)
                contextRef.fill(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
                contextRef.fillPath()
                contextRef.setAlpha(1.0)
                contextRef.setLineWidth(DEFAULT.CIRCLE.LINE.WIDTH)
                contextRef.addArc(center: CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0), radius: DEFAULT.CIRCLE.RADIUS, startAngle: 0, endAngle: .pi * 2.0, clockwise: false)
                contextRef.setStrokeColor(UIColor(named: DEFAULT.CIRCLE.BACKGROUND)?.cgColor ?? UIColor.clear.cgColor)
                contextRef.strokePath()
                break
                
            default:
                self.doneIndicator.isHidden = true
                self.errorIndicator.isHidden = true
                self.messageLabel.isHidden = true
                break
            
        }
                
    }
    
    // MARK: - Private Methods
    
    @objc private func endAnimating() {
        self.percentProgress += 0.01
        if self.percentProgress >= 1.0 {
            self.percentProgress = 0
        }
        self.endAngle = min(DEFAULT.CIRCLE.ANGLE, self.endAngle + 0.02)
        self.setNeedsDisplay()
        if self.endAngle == DEFAULT.CIRCLE.ANGLE {
            self.timer?.invalidate()
            self.putMessage(self.newMessage)
            self.progressStatus = self.isSuccess ? .done : .error
            self.setNeedsDisplay()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.hideProgress(self.completion)
            }
        }
    }
    
    @objc private func startAnimating() {
        self.percentProgress += 0.01
        if self.percentProgress >= 1.0 {
            self.percentProgress = 0
        }
        self.endAngle = min(DEFAULT.CIRCLE.ANGLE * 0.6, self.endAngle + 0.03)
        self.setNeedsDisplay()
    }
    
    private func putMessage(_ message: String!) {
        self.existMessage = false
        if let message = message {
            self.existMessage = true
            self.messageLabel.text = message
            self.messageLabel.frame = CGRect(x: self.messageLabel.frame.origin.x, y: self.messageLabel.frame.origin.y, width: self.messageLabel.frame.width, height: self.messageLabel.heightOfString())
        }
    }
    
    // MARK: - Public Methods
    
    public func hideProgress(_ completion: (() -> Void)?) {
        self.timer?.invalidate()
        self.timer = nil
        self.progressStatus = .standBy
        self.removeFromSuperview()
        completion?()
    }

    public func stopProgress(isSuccess success: Bool, _ message: String!, _ completion: (() -> Void)?) {
        self.isSuccess = success
        self.newMessage = message
        self.completion = completion
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.init(timeInterval: 0.001, target: self, selector: #selector(endAnimating), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: .common)
    }
    
    public func showProgress(withMessage message: String!) {
        self.putMessage(message)
        self.startAngle = DEFAULT.CIRCLE.ANGLE
        self.endAngle = 0
        self.progressStatus = .animating
        self.removeFromSuperview()
        self.receiverView.addSubview(self)
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.init(timeInterval: 0.001, target: self, selector: #selector(startAnimating), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: .common)
    }
    
    public func showProgress() {
        self.showProgress(withMessage: nil)
    }
    
    // MARK: - Interstitial HeaderLoading
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(showProgressAddedTo view: UIView) {
        super.init(frame: view.bounds)
        self.backgroundColor = .clear
        if let img_doneIndicator: UIImage = UIImage(named: "ExpressProgress/Done") {
            self.doneIndicator = CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: (self.frame.width - img_doneIndicator.size.width) / 2.0, y: (self.frame.height - img_doneIndicator.size.height) / 2.0, width: img_doneIndicator.size.width, height: img_doneIndicator.size.height), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_doneIndicator
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIImageView
            self.addSubview(self.doneIndicator)
        }
        if let img_errorIndicator: UIImage = UIImage(named: "ExpressProgress/Error") {
            self.errorIndicator = CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: (self.frame.width - img_errorIndicator.size.width) / 2.0, y: (self.frame.height - img_errorIndicator.size.height) / 2.0, width: img_errorIndicator.size.width, height: img_errorIndicator.size.height), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_errorIndicator
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIImageView
            self.addSubview(self.errorIndicator)
        }
        self.messageLabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: DEFAULT.MESSAGE.MARGIN, y: (self.frame.height + DEFAULT.CIRCLE.RADIUS * 2.0 + DEFAULT.CIRCLE.LINE.WIDTH / 2.0) / 2.0 + DEFAULT.MESSAGE.MARGIN, width: self.frame.width - DEFAULT.MESSAGE.MARGIN * 2.0, height: 0), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: DEFAULT.MESSAGE.FONT.SIZE, false)
            argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: DEFAULT.MESSAGE.FONT.COLOR)
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel
        self.addSubview(self.messageLabel)
        self.receiverView = view
        self.setNeedsDisplay()
    }
    
}
