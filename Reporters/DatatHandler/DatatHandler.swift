//
//  DatatHandler.swift
//  Reporters
//
//  Created by Muhammad Jbara on 04/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation
import Firebase

final class DatatHandler {
    
    // MARK: - Public Methods
    
    public func uploadThmub(_ userID: String, _ photo: UIImage, _ quality: CGFloat, _ successHandler: (() -> Void)?, _ failHandler: (() -> Void)?) {
        

        let urlPhoto: String = "Thumbs/\(userID)/\(Int64((Date().timeIntervalSince1970 * 1000.0).rounded()))"
        if let data: Data = photo.jpegData(compressionQuality: quality) {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let riversRef = storageRef.child(urlPhoto)
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
                    if let urlPhoto: String = url?.absoluteString {
                        print(urlPhoto)

                        NotificationAlert.shared().nextNotification("Your photo has successfully uploaded".localized, "Great".localized, photo)
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
            Database.database().reference().child("\(CONSTANTS.KEYS.JSON.COLLECTION.USERS)/\(data[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as! String)/\(CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY)").setValue(randomKey) { (error, reference) in
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
                arg[CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY] = randomKey
                if let registerDate: Date = date[CONSTANTS.KEYS.JSON.FIELD.DATE.REGISTER] as? Date, let loginDate: Date = date[CONSTANTS.KEYS.JSON.FIELD.DATE.LOGIN] as? Date {
                    date[CONSTANTS.KEYS.JSON.FIELD.DATE.REGISTER] = "\(Int64((registerDate.timeIntervalSince1970 * 1000.0).rounded()))"
                    date[CONSTANTS.KEYS.JSON.FIELD.DATE.LOGIN] = "\(Int64((loginDate.timeIntervalSince1970 * 1000.0).rounded()))"
                    arg[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] = date
                }
                let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
                if query.deleteContext([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.USER]) {
                    if query.saveContext(CONSTANTS.KEYS.SQL.ENTITY.USER, arg) {
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
