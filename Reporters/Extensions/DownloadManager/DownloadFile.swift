//
//  DownloadFile.swift
//  Reporters
//
//  Created by Muhammad Jbara on 14/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

final class DownloadFile {
    
    // MARK: - Declare Static Variables
    
    private static var sharedInstance: DownloadFile = {
        let instance = DownloadFile()
        return instance
    }()
    
    // MARK: - Private Methods
    
    // MARK: - Public Methods
    
    public func start(withURL url: URL, withCompletionBlock block: @escaping (Data?) -> Void) {
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            print("--> \(response)")
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                block(nil)
                return
            }
            block(data)
        }
        task.resume()
    }
    
    // MARK: - Accessors

    class func shared() -> DownloadFile {
        return self.sharedInstance
    }
    
}
