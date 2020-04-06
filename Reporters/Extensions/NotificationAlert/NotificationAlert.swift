//
//  NotificationAlert.swift
//  Reporters
//
//  Created by Muhammad Jbara on 06/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

final class NotificationAlert {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {

        struct IMAGE {
            fileprivate static let SIZE: CGFloat = 40.0
        }
        
    }
    
    // MARK: - Declare Static Variables
    
    private static var sharedInstance: NotificationAlert = {
        let instance = NotificationAlert()
        return instance
    }()
    
    struct NodeNotification {
        var message: String
        var title: String
        var image: UIImage!
        var isFailAlert: Bool
    }
    
    private var queueNotification: Queue! = Queue<NodeNotification>()
    private var notificationView: UIView!
    private var timer: Timer!
    private var resumeTime: TimeInterval!
    
    // MARK: - Private Methods
        
    @objc private func panGestureNotificationView(_ panGesture: UIPanGestureRecognizer?) {
        switch panGesture!.state {
                
        case UIGestureRecognizer.State.began:
            if let _ = self.timer {
                self.resumeTime = self.timer.fireDate.timeIntervalSinceNow
                self.timer?.invalidate()
                self.timer = nil
            }
            break
                
        case UIGestureRecognizer.State.ended:
            if self.notificationView.frame.origin.y <= (CONSTANTS.SCREEN.SAFE_AREA.TOP() + CONSTANTS.SCREEN.MARGIN(1)) / 2.0 || CGFloat(self.resumeTime) == 0 {
                self.dismissNotification()
            } else {
                self.presentNotification()
            }
            break
                
        default:
            if let panGesture = panGesture {
                var frameNotificationView: CGRect = self.notificationView.frame
                frameNotificationView.origin.y = max(min(((CONSTANTS.SCREEN.SAFE_AREA.TOP() + CONSTANTS.SCREEN.MARGIN(1)) + panGesture.translation(in: self.notificationView).y), CONSTANTS.SCREEN.SAFE_AREA.TOP() + CONSTANTS.SCREEN.MARGIN(1)), -frameNotificationView.height)
                self.notificationView.frame = frameNotificationView
            }
            break
                
        }
    }
    
    @objc private func dismissNotification() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            self.notificationView.frame = CGRect(x: self.notificationView.frame.origin.x, y: -self.notificationView.frame.height * 2.0, width: self.notificationView.frame.width, height: self.notificationView.frame.height)
        }, completion: { _ in
            self.notificationView.removeFromSuperview()
            self.notificationView = nil
            self.resumeTime = 0.5
            self.timer?.invalidate()
            self.timer = nil
            if let nextNodeNotification: NodeNotification = self.queueNotification.dequeue() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    NotificationAlert.shared().nextNotification(nextNodeNotification.message, nextNodeNotification.title, nextNodeNotification.image, nextNodeNotification.isFailAlert)
                }
            }
        })
    }
    
    private func presentNotification() {
        self.timer?.invalidate()
        self.timer = nil
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [.curveEaseIn], animations: {
            self.notificationView.frame = CGRect(x: self.notificationView.frame.origin.x, y: CONSTANTS.SCREEN.SAFE_AREA.TOP() + CONSTANTS.SCREEN.MARGIN(1), width: self.notificationView.frame.width, height: self.notificationView.frame.height)
        }, completion: { _ in
            self.timer = Timer.init(timeInterval: self.resumeTime, target: self, selector: #selector(self.dismissNotification), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: .common)
        })
    }
    
    // MARK: - Public Methods
    
    public func nextNotification(_ message: String, _ title: String, _ image: UIImage!, _ isFailAlert: Bool) {
        if let _ = self.notificationView {
            self.queueNotification.enqueue(NodeNotification(message: message, title: title, image: image, isFailAlert: isFailAlert))
            return
        }
        self.notificationView = UIView(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(1), y: 0, width: CONSTANTS.SCREEN.MIN_SIZE - CONSTANTS.SCREEN.MARGIN(2), height: 0))
        if let backgroundAlertView: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: .zero, {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = isFailAlert ? UIColor(rgb: 0xffcbcb) : UIColor(named: "Background/Extensions/Basic")
            argument[CONSTANTS.KEYS.ELEMENTS.ALPHA] = 0.95
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.notificationView.addSubview(backgroundAlertView)
            let panGestureMasterView: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureNotificationView(_ :)))
            panGestureMasterView.minimumNumberOfTouches = 1
            panGestureMasterView.maximumNumberOfTouches = 1
            self.notificationView.addGestureRecognizer(panGestureMasterView)
            var width: CGFloat = self.notificationView.frame.width - CONSTANTS.SCREEN.MARGIN(2)
            var origin: CGPoint = CGPoint(x: CONSTANTS.SCREEN.MARGIN(), y: CONSTANTS.SCREEN.MARGIN())
            if let _ = image {
                width -= (DEFAULT.IMAGE.SIZE + CONSTANTS.SCREEN.MARGIN())
                if CONSTANTS.SCREEN.LEFT_DIRECTION {
                    origin.x += DEFAULT.IMAGE.SIZE + CONSTANTS.SCREEN.MARGIN()
                }
            }
            if let titleLabel: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: origin.x, y: origin.y, width: width, height: 0), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = title
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, true)
                argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = isFailAlert ? UIColor.black : UIColor(named: "Font/Basic")
                argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                titleLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y, width: titleLabel.frame.width, height: titleLabel.heightOfString())
                self.notificationView.addSubview(titleLabel)
                origin.y += titleLabel.frame.height
            }
            if let messageLabel: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: origin.x, y: origin.y, width: width, height: 0), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = message
                argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 14.0, false)
                argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = CONSTANTS.SCREEN.LEFT_DIRECTION ? NSTextAlignment.left : NSTextAlignment.right
                argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = isFailAlert ? UIColor.black : UIColor(named: "Font/Basic")
                argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                messageLabel.frame = CGRect(x: messageLabel.frame.origin.x, y: messageLabel.frame.origin.y, width: messageLabel.frame.width, height: messageLabel.heightOfString())
                self.notificationView.addSubview(messageLabel)
                origin.y += messageLabel.frame.height
            }
            origin.y += CONSTANTS.SCREEN.MARGIN()
            self.notificationView.frame = CGRect(x: self.notificationView.frame.origin.x, y: -origin.y, width: self.notificationView.frame.width, height: origin.y)
            backgroundAlertView.frame = self.notificationView.bounds
            if let image = image, let imageView: UIImageView = CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? CONSTANTS.SCREEN.MARGIN() : backgroundAlertView.frame.width - CONSTANTS.SCREEN.MARGIN() - DEFAULT.IMAGE.SIZE, y: (backgroundAlertView.frame.height - DEFAULT.IMAGE.SIZE) / 2.0, width: DEFAULT.IMAGE.SIZE, height: DEFAULT.IMAGE.SIZE), {
                var argument: [String: Any] = [String: Any]()
                argument[CONSTANTS.KEYS.ELEMENTS.IMAGE] = image
                return argument
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIImageView {
                self.notificationView.addSubview(imageView)
            }
            CONSTANTS.APPDELEGATE.WINDOW().addSubview(self.notificationView)
            self.resumeTime = 5.0
            self.presentNotification()
        }
    }
    
    // MARK: - Accessors

    class func shared() -> NotificationAlert {
        return self.sharedInstance
    }
    
}
