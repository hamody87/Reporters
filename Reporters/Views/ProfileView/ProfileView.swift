//
//  ProfileView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 10/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class ProfileView: SuperView {
    
    // MARK: - Basic Constants
        
    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .lightContent)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
        self.setStatusBarIsHidden(hide: false)
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: "Background/Basic")
    }
    
}
