//
//  AsyncImageView.swift
//  ArabApps
//
//  Created by Muhammad Jbara on 16/03/2019.
//  Copyright © 2019 Muhammad Jbara. All rights reserved.
//

import UIKit

extension AsyncImageView: AsyncImageConnectionDelegate {
    
    func connectionDidFinish(data: [String: Any]) {
        if let image: UIImage = data[AsyncImageConnection.DEFAULT.KEY_IMAGE_ASYNCIMAGECONNECTION] as? UIImage, let imageData: Data = image.pngData(), let url: NSURL = data[AsyncImageConnection.DEFAULT.KEY_URL_ASYNCIMAGECONNECTION] as? NSURL  {
            let data: NSPurgeableData = NSPurgeableData.init(data: imageData)
            AsyncImageView.cacheInstance.setObject(data, forKey: url, cost: imageData.count)
            if url == self.imageURL || url.isEqual(self.imageURL) {
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
                self.imageView.isHidden = false
            }
        } else {
            self.activityIndicator.startAnimating()
            self.imageView.isHidden = true
        }
    }
    
}

class AsyncImageView: UIView {
    
    // MARK: - Declare Basic Variables
    
    private static var cacheInstance: NSCache<NSURL, NSPurgeableData> = {
        let instance = NSCache<NSURL, NSPurgeableData>()
        return instance
    }()
    private static var connections: [Int : AsyncImageConnection] = [Int : AsyncImageConnection]()
    private var imageView: UIImageView!
    private var imageURL: NSURL!
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Methods
    
    private func updateQueue() {
        for (_, existingConnection) in AsyncImageView.connections {
            if !existingConnection.isLoading && !existingConnection.isFinished {
                existingConnection.start()
            }
        }
    }
    
    private func getImageCache(_ url: NSURL) -> UIImage! {
        if let cachedData = AsyncImageView.cacheInstance.object(forKey: url) {
            // As I am going to access now. Don't purge it
            guard cachedData.beginContentAccess() else {
               return nil
            }
            let image = UIImage(data: cachedData as Data)
            cachedData.endContentAccess()
            return image
        }
        return nil
    }
    
    // MARK: - Public Methods
    
    public func getImage() -> UIImage? {
        return self.imageView.image
    }
    
    public func setImage(withUrl imageURL: NSURL!) {
        self.imageView.isHidden = true
        self.activityIndicator.startAnimating()
        if imageURL == nil {
            return
        }
        self.imageURL = imageURL
        if let image = self.getImageCache(imageURL) {
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
            self.imageView.isHidden = false
            return
        }
        let connection: AsyncImageConnection! = AsyncImageConnection(withURL: self.imageURL, delegate: self as AsyncImageConnectionDelegate)
        var added: Bool = false
        for (i, existingConnection) in AsyncImageView.connections {
            if !existingConnection.isLoading && existingConnection.isFinished {
                AsyncImageView.connections[i] = connection
                added = true
                break
            }
        }
        if !added {
            AsyncImageView.connections[AsyncImageView.connections.count] = connection
        }
        self.updateQueue()
    }
    
    // MARK: - Interstitial AsyncImageView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.activityIndicator = UIActivityIndicatorView(style: .white)
        self.activityIndicator.center = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        self.addSubview(self.activityIndicator)
        self.imageView = UIImageView(frame: self.bounds)
        self.imageView.contentMode = .scaleToFill
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)
    }
    
}
