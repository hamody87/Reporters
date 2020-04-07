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
        self.tabBar = TabBarView(withFrame: CGRect(x: 0, y: self.frame.height - 51.0 - CONSTANTS.SCREEN.SAFE_AREA.BOTTOM(), width: self.frame.width, height: 51.0 + CONSTANTS.SCREEN.SAFE_AREA.BOTTOM()))
        self.addSubview(self.tabBar)
    }
    
}
