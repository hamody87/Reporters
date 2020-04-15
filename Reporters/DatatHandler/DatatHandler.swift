//
//  DatatHandler.swift
//  Reporters
//
//  Created by Muhammad Jbara on 04/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

final class DatatHandler {
    
    // MARK: - Public Methods
    
    public func initReporterInfoByID(_ reporterID: String) {
        let ref: DatabaseReference! = Database.database().reference()
        ref.child(CONSTANTS.KEYS.JSON.COLLECTION.USERS).child(reporterID).child(CONSTANTS.KEYS.JSON.FIELD.INFO.SELF).removeAllObservers()
        ref.child(CONSTANTS.KEYS.JSON.COLLECTION.USERS).child(reporterID).child(CONSTANTS.KEYS.JSON.FIELD.INFO.SELF).observe(.value, with: { snapshot in
            if let reporterInfo: [String: Any] = snapshot.value as? [String: Any], let newReporterName: String = reporterInfo[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String, let newReporterThumb: String = reporterInfo[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String {
                
                
                
                let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
                if query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'", [CONSTANTS.KEYS.JSON.FIELD.NAME: reporterName, CONSTANTS.KEYS.JSON.FIELD.THUMB: reporterThumb == "" ? nil : reporterThumb]) {
                    let ref: DatabaseReference! = Database.database().reference()
                        
                        
                        
//                        if let newInfo: [String: Any] = snapshot.value as? [String: Any], let newReporterName: String = newInfo[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String, let newReporterThumb: String = newInfo[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String {
//                            print("4444 dddsdsdas")
//                            let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
//                            if newReporterName != reporterName {
//                                if query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'", [CONSTANTS.KEYS.JSON.FIELD.NAME: newReporterName]) {
//                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.DID.REPORTER.CHANGE.NAME), object: [CONSTANTS.KEYS.JSON.FIELD.ID.USER: reporterID], userInfo: nil)
//                                }
//                            }
//                            if newReporterThumb != reporterThumb {
//                                if query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'", [CONSTANTS.KEYS.JSON.FIELD.THUMB: newReporterThumb]) {
//                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.DID.REPORTER.CHANGE.THUMB), object: [CONSTANTS.KEYS.JSON.FIELD.ID.USER: reporterID], userInfo: nil)
//                                }
//                            }
//                        }
                }
            }
        })
    }
    
    public func initReporters() {
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        if let reporters: [Any] = query.fetchRequest([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING]) {
            for reporter in reporters {
                if let info: [String: Any] = reporter as? [String: Any], let reporterID: String = info[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String {
                    self.initReporterInfoByID(reporterID)
                }
            }
        }
    }
    
    public func uploadThmub(_ userID: String, _ image: UIImage, _ imagePath: String, _ quality: CGFloat, _ successHandler: (() -> Void)?, _ failHandler: (() -> Void)?) {
        if let data: Data = image.jpegData(compressionQuality: quality) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.WILL.USER.CHANGE.THUMB), object: nil, userInfo: nil)
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let riversRef = storageRef.child(imagePath)
            let meta = StorageMetadata()
            meta.contentType = "image/jpeg"
            let _ = riversRef.putData(data, metadata: meta) { metadata, error in
                if let _ = error {
                    failHandler?()
                    return
                }
                riversRef.downloadURL { (url, error) in
                    if let _ = error {
                        failHandler?()
                        return
                    }
                    if let imageUrl: String = url?.absoluteString {
                        let db = Firestore.firestore()
                        db.collection(CONSTANTS.KEYS.JSON.COLLECTION.USERS).document(userID).updateData([CONSTANTS.KEYS.JSON.FIELD.THUMB: imageUrl]) { error in
                            let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
                            if query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.USER, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(userID)'", [CONSTANTS.KEYS.JSON.FIELD.THUMB: imageUrl]) {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.DID.USER.CHANGE.THUMB), object: nil, userInfo: nil)
                                successHandler?()
                                return
                            }
                            failHandler?()
                        }
                    }
                }
            }
        }
    }
    
    public func loginUser(withData data: [String: Any], _ successHandler: (() -> Void)?, _ failHandler: (() -> Void)?) {
        var date: [String: Any] = [String: Any]()
        let dateLogin: Date = Date()
        date[CONSTANTS.KEYS.JSON.FIELD.DATE.REGISTER] = dateLogin
        date[CONSTANTS.KEYS.JSON.FIELD.DATE.LOGIN] = dateLogin
        if let dateDic: [String: Any] = data[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] as? [String: Any], let registerDate: Timestamp = dateDic[CONSTANTS.KEYS.JSON.FIELD.DATE.REGISTER] as? Timestamp {
            date[CONSTANTS.KEYS.JSON.FIELD.DATE.REGISTER] = registerDate.dateValue()
        }
        var info: [String: Any] = [String: Any]()
        var app: [String: Any] = [String: Any]()
        app[CONSTANTS.KEYS.JSON.FIELD.INFO.APP.VERSION] = CONSTANTS.INFO.APP.BUNDLE.VERSION
        info[CONSTANTS.KEYS.JSON.FIELD.INFO.APP.SELF] = app
        var device: [String: Any] = [String: Any]()
        device[CONSTANTS.KEYS.JSON.FIELD.INFO.DEVICE.TYPE] = CONSTANTS.DEVICE.MODEL
        device[CONSTANTS.KEYS.JSON.FIELD.INFO.DEVICE.OPERATING_SYSTEM] = "iOS \(CONSTANTS.DEVICE.VERSION)"
        info[CONSTANTS.KEYS.JSON.FIELD.INFO.DEVICE.SELF] = device
        let db = Firestore.firestore()
        db.collection(CONSTANTS.KEYS.JSON.COLLECTION.USERS).document(data[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as! String).updateData([CONSTANTS.KEYS.JSON.FIELD.DATE.SELF: date, CONSTANTS.KEYS.JSON.FIELD.INFO.SELF: info]) { error in
            if let _ = error {
                failHandler?()
                return
            }
            let randomKey: String = CONSTANTS.INFO.GLOBAL.RANDOM_KEY(length: 40)
            Database.database().reference().child("\(CONSTANTS.KEYS.JSON.COLLECTION.USERS)/\(data[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as! String)").setValue([CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY: randomKey]) { (error, reference) in
                if let _ = error {
                    failHandler?()
                    return
                }
                var arg: [String: Any] = [String: Any]()
                arg[CONSTANTS.KEYS.JSON.FIELD.ID.USER] = data[CONSTANTS.KEYS.JSON.FIELD.ID.USER]
                arg[CONSTANTS.KEYS.JSON.FIELD.NAME] = data[CONSTANTS.KEYS.JSON.FIELD.NAME]
                arg[CONSTANTS.KEYS.JSON.FIELD.LEVEL] = data[CONSTANTS.KEYS.JSON.FIELD.LEVEL]
                arg[CONSTANTS.KEYS.JSON.FIELD.PHONE.SELF] = data[CONSTANTS.KEYS.JSON.FIELD.PHONE.SELF]
                arg[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.SELF] = data[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.SELF]
                arg[CONSTANTS.KEYS.JSON.FIELD.THUMB] = data[CONSTANTS.KEYS.JSON.FIELD.THUMB]
                arg[CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY] = randomKey
                if let registerDate: Date = date[CONSTANTS.KEYS.JSON.FIELD.DATE.REGISTER] as? Date, let loginDate: Date = date[CONSTANTS.KEYS.JSON.FIELD.DATE.LOGIN] as? Date {
                    date[CONSTANTS.KEYS.JSON.FIELD.DATE.REGISTER] = "\(Int64((registerDate.timeIntervalSince1970 * 1000.0).rounded()))"
                    date[CONSTANTS.KEYS.JSON.FIELD.DATE.LOGIN] = "\(Int64((loginDate.timeIntervalSince1970 * 1000.0).rounded()))"
                    arg[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] = date
                }
                let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
                if query.deleteContext([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.USER]) && query.deleteContext([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING]) {
                    if query.saveContext(CONSTANTS.KEYS.SQL.ENTITY.USER, arg) {
                        if let reportersIDs: [String] = data[CONSTANTS.KEYS.JSON.FIELD.FOLLOWING] as? [String] {
                            for reporterID: String in reportersIDs {
                                let _ = query.saveContext(CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, [CONSTANTS.KEYS.JSON.FIELD.ID.USER: reporterID])
                            }
                        }
                        UserDefaults.standard.set(true, forKey: CONSTANTS.KEYS.USERDEFAULTS.USER.LOGIN)
                        successHandler?()
                        return
                    }
                }
                failHandler?()
                return
            }
        }
    }
    
}
