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
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentURL.appendingPathComponent(key)
    }
    
    // MARK: - Public Methods
    
    public func retrieveImage(forKey key: String) -> UIImage? {
        if let filePath = self.filePath(forKey: "\(key).png"), let fileData = FileManager.default.contents(atPath: filePath.path), let image = UIImage(data: fileData) {
            return image
        }
        return nil
    }
    
    public func delete(imageWithKey key: String) {
        if let filePath = self.filePath(forKey: "\(key).png") {
            do {
                try FileManager.default.removeItem(atPath: filePath.path)
                print("Local path removed successfully")
            } catch let error as NSError {
                print("Error: ", error.debugDescription)
            }
        }
    }
    
    public func store(image: UIImage, forKey key: String) {
        if let pngRepresentation = image.pngData() {
            if let filePath = filePath(forKey: "\(key).png") {
                do  {
                    try pngRepresentation.write(to: filePath, options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
        }
    }
    
    // MARK: - Accessors

    class func shared() -> StorageFile {
        return self.sharedInstance
    }
    
}
