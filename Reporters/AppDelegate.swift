//
//  AppDelegate.swift
//  Reporters
//
//  Created by Muhammad Jbara on 14/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit
import Firebase
import OneSignal
import UserNotifications

extension AppDelegate: OSSubscriptionObserver {
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        self.modifyNotificationTokens()
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ContainerControllerDelegate {
    
    var window: UIWindow?
    private var containerController: ContainerController!
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    // MARK: - UIApplicationDelegate Methods
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token: String = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(token, forKey: CONSTANTS.KEYS.USERDEFAULTS.NOTIFICATION.TOKEN)
        self.modifyNotificationTokens()
    }
    
    // MARK: - Public Methods
    
    public func modifyNotificationTokens() {
        if UserDefaults.standard.bool(forKey: CONSTANTS.KEYS.USERDEFAULTS.USER.LOGIN) {
            if let userInfo: [String: Any] = CONSTANTS.GLOBAL.getUserInfo([CONSTANTS.KEYS.JSON.FIELD.ID.USER, CONSTANTS.KEYS.JSON.FIELD.NOTIFICATIONS.SELF]), let userID: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String {
                
                if let oneSignalID: String = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId, let deviceToken: String = UserDefaults.standard.string(forKey: CONSTANTS.KEYS.USERDEFAULTS.NOTIFICATION.TOKEN) {
                    if let oldOneSignalID: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.NOTIFICATIONS.ONESIGNAL] as? String, let oldDeviceToken: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.NOTIFICATIONS.TOKEN] as? String, oneSignalID == oldOneSignalID && deviceToken == oldDeviceToken {
                        return
                    }
                    var notification: [String: Any] = [String: Any]()
                    notification[CONSTANTS.KEYS.JSON.FIELD.NOTIFICATIONS.ONESIGNAL] = oneSignalID
                    notification[CONSTANTS.KEYS.JSON.FIELD.NOTIFICATIONS.TOKEN] = deviceToken
                    notification[CONSTANTS.KEYS.JSON.FIELD.NOTIFICATIONS.ACTIVE] = true
                    Database.database().reference().child("\(CONSTANTS.KEYS.JSON.COLLECTION.USERS)/\(userID)/\(CONSTANTS.KEYS.JSON.FIELD.NOTIFICATIONS.SELF)").setValue(notification) { (error, reference) in
                        if let _ = error {
                            return
                        }
                        var argument: [String: Any] = [String: Any]()
                        argument[CONSTANTS.KEYS.JSON.FIELD.NOTIFICATIONS.SELF] = notification
                        let _ = CONSTANTS.GLOBAL.updateUserInfo(argument)
                    }
                }
            }
        }
    }
        
    public func notificationTransactions(_ completion: (() -> Void)?) {
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            print("dsadsads")
        }
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            print("222222222")
        }
        OneSignal.initWithLaunchOptions(self.launchOptions, appId: CONSTANTS.INFO.APP.ONESIGNAL.ID, handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true])
        OneSignal.add(self as OSSubscriptionObserver)
        OneSignal.inFocusDisplayType = .none
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            UserDefaults.standard.set(accepted, forKey: CONSTANTS.KEYS.USERDEFAULTS.NOTIFICATION.ACCEPTED)
            completion?()
        })
    }
    
    // MARK: - Interstitial AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.launchOptions = launchOptions
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

