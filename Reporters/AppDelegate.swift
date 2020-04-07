//
//  AppDelegate.swift
//  Reporters
//
//  Created by Muhammad Jbara on 14/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ContainerControllerDelegate {
    
    var window: UIWindow?
    private var containerController: ContainerController!
    
    // MARK: - Interstitial AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
//        self.launchOptions = launchOptions
        
        
//        UserDefaults.standard.set(false, forKey: CONSTANTS.KEYS.USERDEFAULTS.USER.LOGIN)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            self.containerController = ContainerController(withDelegate: self as ContainerControllerDelegate)
            window.backgroundColor = UIColor.clear
                window.rootViewController = self.containerController
            window.makeKeyAndVisible()
        }
        return true
    }

}

