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
    
    // MARK: - Private Methods
    
    private func getFolderMessage(byDate date: Date) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyy"
        return dateFormatter.string(from: date)
    }
    
    private func getFoldersWithDates(_ lastUpdate: Double) -> [[String: Any]] {
        var foldersArr: [[String: Any]] = [[String: Any]]()
        var dateStart: Date = Date(timeIntervalSince1970: lastUpdate)
        var numDaysBack: Int = CONSTANTS.INFO.GLOBAL.CALCULATION.DAYS.PASSED(fromDate: dateStart)
        if numDaysBack < CONSTANTS.INFO.APP.BASIC.NUM_DAYS_TO_SHOW {
            foldersArr.append(["folder": self.getFolderMessage(byDate: dateStart), "dateToStart": Timestamp(date: dateStart)])
            if numDaysBack == 0 {
                return foldersArr
            }
        } else {
            numDaysBack = CONSTANTS.INFO.APP.BASIC.NUM_DAYS_TO_SHOW
            if let newDateStart: Date = Calendar.current.date(byAdding: .day, value: -CONSTANTS.INFO.APP.BASIC.NUM_DAYS_TO_SHOW, to: Date()) {
                dateStart = newDateStart
            }
        }
        for i in 1...numDaysBack {
            if let nextDate: Date = Calendar.current.date(byAdding: .day, value: i, to: dateStart) {
                foldersArr.append(["folder": self.getFolderMessage(byDate: nextDate)])
            }
        }
        return foldersArr
    }
    
    private func deleteMessages(forReporter reporterID: String, _ messagesID: [String]) {
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        for messageID in messagesID {
            let _ = query.deleteContext([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.MESSAGES, CONSTANTS.KEYS.SQL.WHERE: "\(CONSTANTS.KEYS.JSON.FIELD.ID.MESSAGE) = '\(messageID)'"])
        }
    }
    
    private func saveMessages(forReporter reportersID: [String], _ index: Int, _ messages: [QueryDocumentSnapshot])  {
        guard let reporterID: String = reportersID.getElement(safe: index) else {
            return
        }
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        var dateLastMessage: Timestamp = Timestamp(date: Date().stripTime())
        var messagesID: [String] = [String]()
        for message in messages {
            let messageInfo: [String: Any] = message.data()
            var values: [String: Any] = [String: Any]()
            values[CONSTANTS.KEYS.JSON.FIELD.ID.USER] = reporterID
            messagesID.append(message.documentID)
            values[CONSTANTS.KEYS.JSON.FIELD.ID.MESSAGE] = message.documentID
            if let message: [String: Any] = messageInfo[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF] as? [String: Any], let element: String = message[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.SELF] as? String {
                var messageArr: [String: Any] = [String: Any]()
                messageArr[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.SELF] = element
                switch element {
                case CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.IMAGE:
                    break
                case CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.VIDEO:
                    break
                default:
                    let text: String = (message[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.TEXT] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
                    messageArr[element] = text
                    messageArr[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.HEIGHT] = CONSTANTS.GLOBAL.getHeightLabel(byText: text, CONSTANTS.GLOBAL.createFont(ofSize: LandingView.DEFAULT.TABLENVIEW.CELL.MESSAGE.FONT.SIZE, false), CONSTANTS.SCREEN.MIN_SIZE - LandingView.DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH - LandingView.DEFAULT.TABLENVIEW.CELL.MARGIN - LandingView.DEFAULT.TABLENVIEW.CELL.SHARE.SIZE.BOTH - CONSTANTS.SCREEN.MARGIN(5))
                    break
                }
                values[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF] = messageArr
            }
            if let timestamp: Timestamp = messageInfo[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] as? Timestamp {
                dateLastMessage = timestamp
                values[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] = timestamp.dateValue()
            }
            values[CONSTANTS.KEYS.JSON.FIELD.READ] = false
            values[CONSTANTS.KEYS.JSON.FIELD.STAR] = false
            let _ = query.saveContext(CONSTANTS.KEYS.SQL.ENTITY.MESSAGES, values)
        }
        var sqlInfo: [String: Any] = [String: Any]()
        sqlInfo[CONSTANTS.KEYS.SQL.NAME_ENTITY] = CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING
        sqlInfo[CONSTANTS.KEYS.SQL.WHERE] = "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'"
        sqlInfo[CONSTANTS.KEYS.SQL.FIELDS] = [CONSTANTS.KEYS.JSON.FIELD.DATE.UPDATE]
        if let data: [Any] = query.fetchRequest(sqlInfo), data.count == 1, let reporterInfo: [String: Any] = data[0] as? [String: Any], let oldUpdate: Double = reporterInfo[CONSTANTS.KEYS.JSON.FIELD.DATE.UPDATE] as? Double, oldUpdate > dateLastMessage.dateValue().timeIntervalSince1970 {
            self.initReporterInfoByID(reportersID, index + 1)
            return
        }
        if query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'", [CONSTANTS.KEYS.JSON.FIELD.DATE.UPDATE: dateLastMessage.dateValue().timeIntervalSince1970]) {
            self.initReporterInfoByID(reportersID, index + 1)
        }
    }
    
    private func fetchMessages(forReporter reportersID: [String], _ index: Int, _ folders: [[String: Any]], _ messages: [QueryDocumentSnapshot]!) {
        if folders.count == 0 {
            self.saveMessages(forReporter: reportersID, index, messages)
            return
        }
        guard let reporterID: String = reportersID.getElement(safe: index) else {
            return
        }
        var newMessagesArr: [QueryDocumentSnapshot] = [QueryDocumentSnapshot]()
        if let messages = messages {
            newMessagesArr += messages
        }
        if let nextFolder: [String: Any] = folders.first, let folder: String = nextFolder["folder"] as? String {
            let query: Query!
            if let dateToStart: Timestamp = nextFolder["dateToStart"] as? Timestamp {
                query = Firestore.firestore().collection(CONSTANTS.KEYS.JSON.COLLECTION.MESSAGES).document(reporterID).collection(folder).order(by: CONSTANTS.KEYS.JSON.FIELD.DATE.SELF, descending: false).whereField(CONSTANTS.KEYS.JSON.FIELD.DATE.SELF, isGreaterThan: dateToStart)
            } else {
                query = Firestore.firestore().collection(CONSTANTS.KEYS.JSON.COLLECTION.MESSAGES).document(reporterID).collection(folder).order(by: CONSTANTS.KEYS.JSON.FIELD.DATE.SELF, descending: false)
            }
            query.getDocuments { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    self.initReporterInfoByID(reportersID, index + 1)
                    return
                }
                for document in documents {
                    newMessagesArr.append(document)
                }
                var newFoldersArr: [[String: Any]] = [[String: Any]]()
                newFoldersArr += folders
                if newFoldersArr.count > 0 {
                    newFoldersArr.remove(at: 0)
                }
                self.fetchMessages(forReporter: reportersID, index, newFoldersArr, newMessagesArr)
            }
        }
    }
    
    private func bringReportersID() -> [String] {
        var reportersID: [String] = [String]()
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        if let reporters: [Any] = query.fetchRequest([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING]) {
            for reporter in reporters {
                if let info: [String: Any] = reporter as? [String: Any], let reporterID: String = info[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String {
                    reportersID.append(reporterID)
                    let _ = query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'", [CONSTANTS.KEYS.JSON.FIELD.READY: false])
                }
            }
        }
        return reportersID
    }
    
    // MARK: - Public Methods
    
    public func initReporterInfoByID(_ reportersID: [String], _ index: Int) {
        guard let reporterID: String = reportersID.getElement(safe: index) else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.RELOAD.MESSAGES), object: nil, userInfo: nil)
            for reporterID in reportersID {
                let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
                var sqlInfo: [String: Any] = [String: Any]()
                sqlInfo[CONSTANTS.KEYS.SQL.NAME_ENTITY] = CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING
                sqlInfo[CONSTANTS.KEYS.SQL.WHERE] = "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'"
                sqlInfo[CONSTANTS.KEYS.SQL.FIELDS] = [CONSTANTS.KEYS.JSON.FIELD.DATE.UPDATE, CONSTANTS.KEYS.JSON.FIELD.READY]
                guard let data: [Any] = query.fetchRequest(sqlInfo), data.count == 1, let oldReporterInfo: [String: Any] = data[0] as? [String: Any], let oldUpdate: Double = oldReporterInfo[CONSTANTS.KEYS.JSON.FIELD.DATE.UPDATE] as? Double, let isReady: Bool = oldReporterInfo[CONSTANTS.KEYS.JSON.FIELD.READY] as? Bool, !isReady else {
                    return
                }
                if query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'", [CONSTANTS.KEYS.JSON.FIELD.READY: true]) {
                    let ref: DatabaseReference! = Database.database().reference()
                    ref.child(CONSTANTS.KEYS.JSON.COLLECTION.USERS).child(reporterID).child(CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF).child(CONSTANTS.KEYS.JSON.FIELD.DATE.UPDATE).removeAllObservers()
                    ref.child(CONSTANTS.KEYS.JSON.COLLECTION.USERS).child(reporterID).child(CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF).child(CONSTANTS.KEYS.JSON.FIELD.DATE.UPDATE).observe(.value, with: { snapshot in
                        guard let newUpdate: Double = snapshot.value as? Double else {
                            return
                        }
                        if newUpdate > oldUpdate {
                            self.initReporterInfoByID([reporterID], 0)
                        }
                    })
                }
            }
            return
        }
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        var sqlInfo: [String: Any] = [String: Any]()
        sqlInfo[CONSTANTS.KEYS.SQL.NAME_ENTITY] = CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING
        sqlInfo[CONSTANTS.KEYS.SQL.WHERE] = "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'"
        if let data: [Any] = query.fetchRequest(sqlInfo), data.count == 1, let oldReporterInfo: [String: Any] = data[0] as? [String: Any], let isReady: Bool = oldReporterInfo[CONSTANTS.KEYS.JSON.FIELD.READY] as? Bool {
            if !isReady {
                let ref: DatabaseReference! = Database.database().reference()
                ref.child(CONSTANTS.KEYS.JSON.COLLECTION.USERS).child(reporterID).child(CONSTANTS.KEYS.JSON.FIELD.INFO.SELF).removeAllObservers()
                ref.child(CONSTANTS.KEYS.JSON.COLLECTION.USERS).child(reporterID).child(CONSTANTS.KEYS.JSON.FIELD.INFO.SELF).observe(.value, with: { snapshot in
                    if let newReporterInfo: [String: Any] = snapshot.value as? [String: Any], let newReporterName: String = newReporterInfo[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String {
                        let oldReporterName: String! = oldReporterInfo[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String
                        if newReporterName != oldReporterName {
                            if query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'", [CONSTANTS.KEYS.JSON.FIELD.NAME: newReporterName]) {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.DID.REPORTER.CHANGE.NAME), object: [CONSTANTS.KEYS.JSON.FIELD.ID.USER: reporterID], userInfo: nil)
                            }
                        }
                        let newReporterThumb: String! = newReporterInfo[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String
                        let oldReporterThumb: String! = oldReporterInfo[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String
                        if newReporterThumb != oldReporterThumb {
                            StorageFile.shared().delete(imageWithKey: "thumb_\(reporterID)")
                            if query.updateContext(CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, "\(CONSTANTS.KEYS.JSON.FIELD.ID.USER) = '\(reporterID)'", [CONSTANTS.KEYS.JSON.FIELD.THUMB: newReporterThumb]) {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.DID.REPORTER.CHANGE.THUMB), object: [CONSTANTS.KEYS.JSON.FIELD.ID.USER: reporterID], userInfo: nil)
                            }
                        }
                    }
                })
            }
            var foldersWithDates: [[String: Any]] = [[String: Any]]()
            if let lastUpdate: Double = oldReporterInfo[CONSTANTS.KEYS.JSON.FIELD.DATE.UPDATE] as? Double, lastUpdate != 0 {
                foldersWithDates = self.getFoldersWithDates(lastUpdate)
            } else {
                foldersWithDates.append(["folder": self.getFolderMessage(byDate: Date())])
            }
            self.fetchMessages(forReporter: reportersID, index, foldersWithDates, nil)
        }
    }
    
    public func initReporters() {
        self.initReporterInfoByID(self.bringReportersID(), 0)
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
            Database.database().reference().child(CONSTANTS.KEYS.JSON.COLLECTION.USERS).child(data[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as! String).setValue([CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY: randomKey]) { (error, reference) in
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
                if query.deleteContext([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.USER]) && query.deleteContext([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING]) && query.deleteContext([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.MESSAGES]) {
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
