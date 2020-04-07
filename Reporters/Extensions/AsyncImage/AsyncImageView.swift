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
        if let image: UIImage = data[AsyncImageConnection.DEFAULT.KEY_IMAGE_ASYNCIMAGECONNECTION] as? UIImage, let url: NSURL = data[AsyncImageConnection.DEFAULT.KEY_URL_ASYNCIMAGECONNECTION] as? NSURL {
            AsyncImageView.dictImgs[url] = image
            if url == self.imageURL || url.isEqual(self.imageURL) {
                self.imageView.image = image
                self.imageView.isHidden = false
            }
        } else {
            self.imageView.isHidden = true
        }
    }
    
}

class AsyncImageView: UIView {
    
    // MARK: - Declare Basic Variables
    
    private static var dictImgs: [NSURL : UIImage] = [NSURL: UIImage]()
    private static var connections: [Int : AsyncImageConnection] = [Int : AsyncImageConnection]()
    private var imageView: UIImageView!
    private var imageURL: NSURL!
    
    // MARK: - Private Methods
    
    private func updateQueue() {
        for (_, existingConnection) in AsyncImageView.connections {
            if !existingConnection.isLoading && !existingConnection.isFinished {
                existingConnection.start()
            }
        }
    }
    
    // MARK: - Public Methods
    
    public func getImage() -> UIImage? {
        return self.imageView.image
    }
    
    public func setImage(withUrl imageURL: NSURL!) {
        self.imageView.isHidden = true
        if imageURL == nil {
            return
        }
        self.imageURL = imageURL
        if let image = AsyncImageView.dictImgs[self.imageURL] {
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
        self.imageView = UIImageView(frame: self.bounds)
        self.imageView.contentMode = .scaleToFill
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)
    }
    
}
