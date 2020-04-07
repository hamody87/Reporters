//
//  AsyncImageConnection.swift
//  ArabApps
//
//  Created by Muhammad Jbara on 16/03/2019.
//  Copyright © 2019 Muhammad Jbara. All rights reserved.
//

import UIKit

@objc public protocol AsyncImageConnectionDelegate {
    
    @objc func connectionDidFinish(data: [String: Any])
    
}

final class AsyncImageConnection {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {
        
        static let KEY_IMAGE_ASYNCIMAGECONNECTION: String = "KeyImage"
        static let KEY_URL_ASYNCIMAGECONNECTION: String = "KeyURL"
        
    }
    
    // MARK: - Declare Basic Variables
    
    weak private var _delegate: AsyncImageConnectionDelegate? = nil
    weak public var delegate: AsyncImageConnectionDelegate? {
        set(delegateValue) {
            self._delegate = delegateValue
        }
        get {
            return self._delegate
        }
    }
    
    private var url: NSURL!
    private var target: Any!
    public var isLoading: Bool = false
    public var isFinished: Bool = false
    
    // MARK: - Private Methods
    
    public func postImage(image: UIImage!) {
        let data: [String : Any] = [DEFAULT.KEY_IMAGE_ASYNCIMAGECONNECTION: image!, DEFAULT.KEY_URL_ASYNCIMAGECONNECTION: self.url!]
        self.delegate?.connectionDidFinish(data: data)
        self.isLoading = false
        self.isFinished = true
    }
    
    // MARK: - Public Methods
    
    public func start() {
        if self.isLoading {
            return
        }
        self.isLoading = true
        if self.url == nil {
            self.postImage(image: nil)
            return
        }
        let request: NSMutableURLRequest = NSMutableURLRequest(url: self.url as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                self.isLoading = false
                print ("error: \(String(describing: error))")
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.start()
                }
                return
            }
            if let image: UIImage = UIImage(data: data!) {
                DispatchQueue.main.async {
                    self.postImage(image: image)
                    return
                }
            }
            self.isLoading = false
        }
        task.resume()
    }
    
    // MARK: - Interstitial AsyncImageConnection
    
    required init?(withURL imageURL: NSURL, delegate: AsyncImageConnectionDelegate) {
        self.url = imageURL
        self.delegate = delegate
    }
    
}
