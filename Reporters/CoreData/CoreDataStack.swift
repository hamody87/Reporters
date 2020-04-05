//
//  CoreDataStack.swift
//  Reporters
//
//  Created by Muhammad Jbara on 05/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    // MARK: - Declare Basic Variables
    
    private var coreDataName: String!
    
    // MARK: - Lazy Variables
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.coreDataName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Private Methods

    private func fetchRequestWithResultType(_ sqlInfo: [String: Any], _ resultType: NSFetchRequestResultType) -> [Any]! {
        if let nameEntity: String = sqlInfo[CONSTANTS.KEYS.SQL.NAME_ENTITY] as? String {
            let context = self.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
            request.resultType = resultType
            if let fields: [String] = sqlInfo[CONSTANTS.KEYS.SQL.FIELDS] as? [String] {
                request.propertiesToFetch = fields
            }
            if let clauseWhere: String = sqlInfo[CONSTANTS.KEYS.SQL.WHERE] as? String {
                request.predicate = NSPredicate(format: clauseWhere)
            }
            if let orderBy: [[String: Any]] = sqlInfo[CONSTANTS.KEYS.SQL.ORDER_BY.SELF] as? [[String: Any]] {
                var sort: [NSSortDescriptor] = [NSSortDescriptor]()
                for dic: [String: Any] in orderBy {
                    if let keyword: String = dic[CONSTANTS.KEYS.SQL.ORDER_BY.KEYWORD] as? String {
                        var isAscending: Bool = true
                        if let sort: String = dic[CONSTANTS.KEYS.SQL.ORDER_BY.SORT] as? String {
                            if sort == CONSTANTS.KEYS.SQL.ORDER_BY.DESC {
                                isAscending = false
                            }
                        }
                        sort.append(NSSortDescriptor(key: keyword, ascending: isAscending))
                    }
                }
                request.sortDescriptors = sort
            }
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                return result
            } catch {
                return nil
            }
        }
        return nil
    }
    
    // MARK: - Public Methods

    public func deleteContext(_ sqlInfo: [String: Any]) -> Bool {
        guard let result = self.fetchRequestWithResultType(sqlInfo, .managedObjectResultType) else {
            return false
        }
        let context = self.persistentContainer.viewContext
        for obj in result {
            context.delete(obj as! NSManagedObject)
        }
        do {
            try context.save() 
        } catch {
            return false
        }
        return true
    }
    
    public func fetchRequest(_ sqlInfo: [String: Any]) -> [Any]! {
        return self.fetchRequestWithResultType(sqlInfo, .dictionaryResultType)
    }
    
    public func saveContext(_ nameEntity: String, _ values: [String : Any]) -> Bool {
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: nameEntity, in: context) else {
            return false
        }
        let newField = NSManagedObject(entity: entity, insertInto: context)
        for (key, value) in values {
            newField.setValue(value, forKey: key)
        }
        do {
            try context.save()
        } catch {
            return false
        }
        return true
    }
    
    // MARK: - Interstitial CoreDataStack
    
    init(withCoreData coreDataName: String) {
        self.coreDataName = coreDataName
    }
    
}

