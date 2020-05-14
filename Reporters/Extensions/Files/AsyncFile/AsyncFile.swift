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
    
    // MARK: - Public Methods
    
    public func sync(imageWithUrl url: URL!, _ key: String) {
        self.imageView.isHidden = true
        self.activityIndicator.startAnimating()
        guard let _ = url else {
            return
        }
        if let image = StorageFile.shared().retrieveImage(forKey: key) {
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
            self.imageView.isHidden = false
            return
        }
        DownloadFile.shared().start(withURL: url) { data in
            if let imageData = data {
                if let image: UIImage = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        StorageFile.shared().store(image: image, forKey: key)
                        self.activityIndicator.stopAnimating()
                        self.imageView.image = image
                        self.imageView.isHidden = false
                    }
                }
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
