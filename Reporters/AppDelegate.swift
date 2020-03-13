//
//  AppDelegate.swift
//  Reporters
//
//  Created by Muhammad Jbara on 14/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK: - Interstitial AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//        self.launchOptions = launchOptions
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
//            self.containerController = ContainerController(withDelegate: self as ContainerControllerDelegate)
//            window.backgroundColor = UIColor.clear
//            window.rootViewController = self.containerController
            window.makeKeyAndVisible()
        }
        return true
    }

}

