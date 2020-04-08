//
//  LandingView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 04/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class LandingView: SuperView {
    
    // MARK: - Declare Basic Variables

    private var tabBar: TabBarView!
    private var listMessages: UICollectionView!
    
    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .default)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: "Background/Secondary")
        if let img_background: UIImage = UIImage(named: "\(self.classDir())Background") {
            let backgroundImage = UIView(frame: self.bounds)
            backgroundImage.backgroundColor = UIColor(patternImage: img_background)
            self.addSubview(backgroundImage)
        }
        self.tabBar = TabBarView(withFrame: CGRect(x: 0, y: self.frame.height - 51.0 - CONSTANTS.SCREEN.SAFE_AREA.BOTTOM(), width: self.frame.width, height: 56.0 + CONSTANTS.SCREEN.SAFE_AREA.BOTTOM()), delegate: self)
        self.addSubview(self.tabBar)
        
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.transitionToChildOverlapContainer(viewName: "EnableRemoteNotifications", nil, .coverVertical, false, nil)
            }
        } else {
            print("yESSSS")
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.notificationTransactions(nil)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
//        self.listMessages = UICollectionView(frame: CGRect(x: 0.0, y: self.navBarView.frame.height, width: self.frame.width, height: self.frame.height - self.navBarView.frame.height - Constants.SCREEN.SAFE_AREA_BOTTOM - 50.0), collectionViewLayout: UICollectionViewFlowLayout())
//        self.listItems.backgroundColor = .clear
//        if #available(iOS 11.0, *) {
//            self.listItems.contentInsetAdjustmentBehavior = .never
//        }
//        self.listItems.dataSource = self as UICollectionViewDataSource
//        self.listItems.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
//        self.listItems.delegate = self as UICollectionViewDelegateFlowLayout
//        self.listItems.register(StyleCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        self.listItems.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
//        self.listItems.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
//        self.coreLandingView.addSubview(self.listItems)
    }
    
}
