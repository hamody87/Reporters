//
//  UnreadBadge.swift
//  Reporters
//
//  Created by Muhammad Jbara on 29/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

final class UnreadBadge {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {

        fileprivate static let TAG: Int = 4342
        fileprivate static let SIZE: CGFloat = 6.0
        
        
    }

    // MARK: - Declare Basic Variables

    private var badgesArray: [String: Date] = [String: Date]()
    
    // MARK: - Declare Static Variables
    
    private static var sharedInstance: UnreadBadge = {
        let instance = UnreadBadge()
        return instance
    }()
    
    // MARK: - Public Methods
    
    public func showUnreadBadge(_ messageView: UIView, _ messageID: String, _ isRead: Bool) {
        if let previousUnreadBadge: UIView = messageView.viewWithTag(DEFAULT.TAG) {
            previousUnreadBadge.removeFromSuperview()
        }
        if isRead {
            return
        }
        var finishDate = Date().addingTimeInterval(5)
        if let date: Date = self.badgesArray[messageID] {
            finishDate = date
            if Date().timeIntervalSinceNow - finishDate.timeIntervalSinceNow >= 0 {
                return
            }
        } else {
            self.badgesArray[messageID] = finishDate
        }
        let unreadBadge: UIView! = UIView(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: messageView.frame.height - CONSTANTS.SCREEN.MARGIN() - DEFAULT.SIZE, width: DEFAULT.SIZE, height: DEFAULT.SIZE))
        unreadBadge.layer.cornerRadius = unreadBadge.frame.width / 2.0
        unreadBadge.backgroundColor = .red
        messageView.addSubview(unreadBadge)
        DispatchQueue.main.asyncAfter(deadline: .now() + finishDate.timeIntervalSinceNow - Date().timeIntervalSinceNow) {
            UIView.animate(withDuration: 0.4, animations: {
                unreadBadge?.alpha = 0
            }, completion: { _ in
                let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
                let _ = query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.MESSAGES, "\(CONSTANTS.KEYS.JSON.FIELD.ID.MESSAGE) = '\(messageID)'", [CONSTANTS.KEYS.JSON.FIELD.READ: true])
            })
        }
    }
    
    // MARK: - Accessors

    class func shared() -> UnreadBadge {
        return self.sharedInstance
    }
    
}
