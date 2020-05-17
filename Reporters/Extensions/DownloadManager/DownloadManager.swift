//
//  DownloadManager.swift
//  Reporters
//
//  Created by Muhammad Jbara on 15/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

extension DownloadManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url, let download = self.activeDownloads[url] else {
            return
        }
        
        
        if let type = self.readDownloadedData(of: location). {
            print(type)
        }
        if let destinationURL = self.localFilePath(forKey: download.key) {
            let fileManager = FileManager.default
            try? fileManager.removeItem(at: destinationURL)
            do {
                try fileManager.copyItem(at: location, to: destinationURL)
            } catch let error {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        download.completionBlock(download)
        self.activeDownloads[url] = nil
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url, let download = self.activeDownloads[url] else {
            return
        }
        download.totalBytesWritten = totalBytesWritten
        download.totalBytesExpectedToWrite = totalBytesExpectedToWrite
        download.progressBlock(download)
    }
    
}

final class DownloadManager: NSObject {
    
    // MARK: - Declare Basic Variables
    
    lazy var activeDownloads: [URL: Download] = [URL: Download]()
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.HalfTunes.bgSession")
        return URLSession(configuration: configuration, delegate: DownloadManager.shared(), delegateQueue: nil)
    }()
    
    // MARK: - Declare Static Variables
    
    private static var sharedInstance: DownloadManager = {
        let instance = DownloadManager()
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

    private func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            return data
        } catch {
            return nil
        }
    }
    
    // MARK: - Public Method
    
    public func cancel(withURL url: URL) {
        guard let download = self.activeDownloads[url] else {
          return
        }
        download.task?.cancel()
        self.activeDownloads[url] = nil
    }
    
    public func pause(withURL url: URL) {
        guard let download = self.activeDownloads[url], download.downloadStatus == .start else {
          return
        }
        download.task?.cancel(byProducingResumeData: { data in
          download.resumeData = data
        })
        download.downloadStatus = .pause
    }
    
    public func resume(withURL url: URL) {
        guard let download = self.activeDownloads[url] else {
          return
        }
        if download.downloadStatus == .start {
            return
        }
        if let resumeData = download.resumeData {
            download.task = self.downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = self.downloadsSession.downloadTask(with: download.previewURL)
        }
        download.task?.resume()
        download.downloadStatus = .start
    }
    
    public func start(withURL url: URL, _ key: String, _ progressBlock: @escaping (Download) -> Void, _ completionBlock: @escaping (Download) -> Void) {
        if let _: Download = self.activeDownloads[url] {
            return
        }
        let download = Download(previewURL: url, key, progressBlock, completionBlock)
        download.task = self.downloadsSession.downloadTask(with: download.previewURL)
        download.task?.resume()
        download.downloadStatus = .start
        self.activeDownloads[download.previewURL] = download
    }
    
    // MARK: - Accessors

    class func shared() -> DownloadManager {
        return self.sharedInstance
    }
    
}
