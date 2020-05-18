//
//  StorageFile.swift
//  Reporters
//
//  Created by Muhammad Jbara on 14/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

final class StorageFile {
    
    // MARK: - Declare Static Variables
    
    private static var sharedInstance: StorageFile = {
        let instance = StorageFile()
        return instance
    }()
    
    // MARK: - Private Methods
    
    private func localFilePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentURL.appendingPathComponent(key)
    }
    
    // MARK: - Public Methods
    
    public func retrieve(fileWithKey key: String) -> Data? {
        if let filePath = self.localFilePath(forKey: key), let fileData = FileManager.default.contents(atPath: filePath.path) {
            return fileData
        }
        return nil
    }
    
    public func delete(fileWithKey key: String) -> Bool {
        if let filePath = self.localFilePath(forKey: key) {
            do {
                try FileManager.default.removeItem(atPath: filePath.path)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    public func store(fileAtSrcURL srcURL: URL, forKey key: String) -> Bool {
        if let destinationURL = self.localFilePath(forKey: key) {
            let fileManager = FileManager.default
            try? fileManager.removeItem(at: destinationURL)
            do {
                try fileManager.copyItem(at: srcURL, to: destinationURL)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    // MARK: - Accessors

    class func shared() -> StorageFile {
        return self.sharedInstance
    }
    
}

