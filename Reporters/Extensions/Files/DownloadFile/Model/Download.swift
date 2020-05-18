//
//  Download.swift
//  Reporters
//
//  Created by Muhammad Jbara on 17/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation

class Download {
    
    // MARK: - Declare Enums
    
    enum DownloadStatus: Int {
        case standBy = 0
        case start
        case pause
    }
    
    // MARK: - Constants
    
    let previewURL: URL
    let progressBlock: (Download) -> Void
    let completionBlock: (Data?) -> Void
    let key: String
    
    // MARK: - Variables And Properties
    
    var downloadStatus: DownloadStatus = .standBy
    var totalBytesWritten: Int64 = 0
    var totalBytesExpectedToWrite: Int64 = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    
    // MARK: - Initialization
    
    init(previewURL: URL, _ key: String, _ progressBlock: @escaping (Download) -> Void, _ completionBlock: @escaping (Data?) -> Void) {
        self.previewURL = previewURL
        self.key = key
        self.progressBlock = progressBlock
        self.completionBlock = completionBlock
    }
    
}
