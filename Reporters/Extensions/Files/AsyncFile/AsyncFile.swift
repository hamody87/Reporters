//
//  AsyncFile.swift
//  Reporters
//
//  Created by Muhammad Jbara on 14/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class AsyncFile: UIView {
    
    // MARK: - Declare Basic Variables
    
    private var imageView: UIImageView!
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Methods
    
    private func fetch(fileWithKey key: String) -> Bool {
        if let fileData = StorageFile.shared().retrieve(fileWithKey: key), let image = UIImage(data: fileData) { 
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
            self.imageView.isHidden = false
            return true
        }
        return false
    }
    
    // MARK: - Public Methods
    
    public func sync(imageWithUrl url: URL!, _ key: String) {
        self.imageView.isHidden = true
        self.activityIndicator.startAnimating()
        guard let _ = url else {
            return
        }
        if self.fetch(fileWithKey: key) {
            return
        }
        DownloadFile.shared().start(withURL: url, key, { [weak self] Download in
            guard let _ = self else {
                return
            }
        }) { [weak self] data in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                let _ = self.fetch(fileWithKey: key)
            }
        }
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
