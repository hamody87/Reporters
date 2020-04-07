//
//  TabBarView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 07/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class TabBarView: SuperView {
    // MARK: - Declare Basic Variables

    private var thumbView: CustomizeImage!
    
    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .default)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
    }
    
    @objc private func startUploadingThumb() {
        self.thumbView.startUploadingImage()
    }
    
    @objc private func showThumb() {
        self.thumbView.endUploadingImage()
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        var sqlInfo: [String: Any] = [String: Any]()
        sqlInfo[CONSTANTS.KEYS.SQL.NAME_ENTITY] = CONSTANTS.KEYS.SQL.ENTITY.USER
        sqlInfo[CONSTANTS.KEYS.SQL.FIELDS] = [CONSTANTS.KEYS.JSON.FIELD.THUMB]
        if let data: [Any] = query.fetchRequest(sqlInfo), data.count == 1, let info: [String: Any] = data[0] as? [String: Any], let urlImage: String = info[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String {
            self.thumbView.imageWithUrl(urlImage)
        }
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: "Background/Basic")
        let topBorder: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 1.0))
        topBorder.backgroundColor = UIColor(named: "Background/Border")
        self.addSubview(topBorder)
        let sizeAllow: CGFloat = self.frame.height - 1.0 - CONSTANTS.SCREEN.MARGIN(2) - CONSTANTS.SCREEN.SAFE_AREA.BOTTOM()
        if let thumbView: CustomizeImage = CONSTANTS.GLOBAL.createCustomThumbElement(withFrame: CGRect(x: CONSTANTS.SCREEN.MARGIN(2), y: CONSTANTS.SCREEN.MARGIN() + 1.0, width: sizeAllow, height: sizeAllow), {
            var argument: [String: Any] = [String: Any]()
            argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] = self
            argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(named: "Background/LoginView/Basic")
            argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] = [CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION: [UIRectCorner.allCorners], CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS: sizeAllow / 2.0]
            return argument
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? CustomizeImage {
            self.thumbView = thumbView
            self.addSubview(self.thumbView)
            let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
            var sqlInfo: [String: Any] = [String: Any]()
            sqlInfo[CONSTANTS.KEYS.SQL.NAME_ENTITY] = CONSTANTS.KEYS.SQL.ENTITY.USER
            sqlInfo[CONSTANTS.KEYS.SQL.FIELDS] = [CONSTANTS.KEYS.JSON.FIELD.NAME, CONSTANTS.KEYS.JSON.FIELD.THUMB]
            if let data: [Any] = query.fetchRequest(sqlInfo), data.count == 1, let info: [String: Any] = data[0] as? [String: Any], let fullName: String = info[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String {
                self.thumbView.imageWithName(fullName)
                print(info)
                if let urlImage: String = info[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String {
                    self.thumbView.imageWithUrl(urlImage)
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.startUploadingThumb), name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.CHANGE.WILL.THUMB), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showThumb), name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.CHANGE.DID.THUMB), object: nil)
    }
    
}
