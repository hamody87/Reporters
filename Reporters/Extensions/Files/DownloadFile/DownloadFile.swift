//
//  DownloadFile.swift
//  Reporters
//
//  Created by Muhammad Jbara on 15/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

@objc public protocol DownloadFileDelegate {

    @objc func progressDownload(withKey key: String)
    @objc func finishDownload(withKey key: String)

}

extension DownloadFile: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url, let download = self.activeDownloads[url] else {
            return
        }
        let _ = StorageFile.shared().store(fileAtSrcURL: location, forKey: download.key)
        if let delegates: [DownloadFileDelegate?] = self.delegateDownloads[url] {
            for delegate in delegates {
                delegate?.finishDownload(withKey: download.key)
            }
        }
        self.activeDownloads[url] = nil
        self.delegateDownloads[url] = nil
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url, let download = self.activeDownloads[url] else {
            return
        }
        download.totalBytesWritten = totalBytesWritten
        download.totalBytesExpectedToWrite = totalBytesExpectedToWrite
        if let delegates: [DownloadFileDelegate?] = self.delegateDownloads[url] {
            for delegate in delegates {
                delegate?.progressDownload(withKey: download.key)
            }
        }
    }
    
}

final class DownloadFile: NSObject {
    
    // MARK: - Declare Basic Variables
    
    lazy var activeDownloads: [URL: Download] = [URL: Download]()
    lazy var delegateDownloads: [URL: [DownloadFileDelegate?]] = [URL: [DownloadFileDelegate?]]()
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.HalfTunes.bgSession")
        return URLSession(configuration: configuration, delegate: DownloadFile.shared(), delegateQueue: nil)
    }()
    
    // MARK: - Declare Static Variables
    
    private static var sharedInstance: DownloadFile = {
        let instance = DownloadFile()
        return instance
    }()
    
    // MARK: - Private Methods

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
    
    public func start(withURL url: URL, _ key: String, delegate: DownloadFileDelegate?) {
        if let download: Download = self.activeDownloads[url] {
            self.delegateDownloads[download.previewURL] = (self.delegateDownloads[download.previewURL] ?? []) + [delegate]
            return
        }
        let download = Download(previewURL: url, key)
        download.task = self.downloadsSession.downloadTask(with: download.previewURL)
        download.task?.resume()
        download.downloadStatus = .start
        self.activeDownloads[download.previewURL] = download
        self.delegateDownloads[download.previewURL] = [delegate]
    }
    
    // MARK: - Accessors

    class func shared() -> DownloadFile {
        return self.sharedInstance
    }
    
}
