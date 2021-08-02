//
//  AsyncFile.swift
//  Reporters
//
//  Created by Muhammad Jbara on 14/05/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//


import UIKit

extension AsyncFile: DownloadFileDelegate {
    
    func finishDownload(withKey key: String) {
        DispatchQueue.main.async {
            if let fileData = StorageFile.shared().retrieve(fileWithKey: key), let image = UIImage(data: fileData) {
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
                self.imageView.isHidden = false
            }
        }
    }
    
    func progressDownload(withKey key: String) {
        print("sssss")
    }
    
}

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
            print("44444")
            return true
        }
        return false
    }
    
    // MARK: - Public Methods
    
    public func sync(imageWithUrl url: URL!, _ key: String) {
        self.imageView.isHidden = true
        self.activityIndicator.startAnimating()

            print("-------")
            print("id_\(String(UInt(bitPattern: ObjectIdentifier(self))))")
            print("-------")
        
        print(key)
        guard let _ = url else {
            return
        }
//        if self.fetch(fileWithKey: key) {
//            return
//        }
//        print("1-----> \(self.imageView)")
        DownloadFile.shared().start(withURL: url, key, delegate: self)
//        DownloadFile.shared().start(withURL: url, key, { download in
//
//            print("YESSSS 1111")
////            guard let self = self else {
////                return
////            }
////             [weak self]
////            if self.imageView.isHidden == false {
////                self.imageView.isHidden = true
////            } else {
////
////                self.imageView.isHidden = false
////            }
//        }) { data in
//        print("YESSSS 22222")
//
//
//                                DispatchQueue.main.async {
//                                    if let fileData = StorageFile.shared().retrieve(fileWithKey: key), let image = UIImage(data: fileData) {
//                                        self.activityIndicator.stopAnimating()
//                                        self.imageView.image = image
//                                        self.imageView.isHidden = false
//                                    }
//            }
//                    if let fileData = StorageFile.shared().retrieve(fileWithKey: "rfrfrfrfr.jpg"), let image = UIImage(data: fileData) {
//                        self.activityIndicator.stopAnimating()
//                        self.imageView.image = image
//                        self.imageView.isHidden = false
//                    }
                
//            DispatchQueue.main.async {
//                print("dddd333")
//                if let fileData = StorageFile.shared().retrieve(fileWithKey: key), let image = UIImage(data: fileData) {
//                    self.activityIndicator.stopAnimating()
//                    self.imageView.image = image
//                    self.imageView.isHidden = false
//                    print("44444")
//                }
//            }
//        }
//        DownloadFile.shared().delegate = self
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
//            let _ = self.fetch(fileWithKey: key)
//        }
            
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.activityIndicator?.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        self.imageView?.frame = self.bounds
    }
    // MARK: - Interstitial AsyncImageView

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(withFrame frame: CGRect!) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.activityIndicator = UIActivityIndicatorView(style: .white)
        self.addSubview(self.activityIndicator)
        self.imageView = UIImageView(frame: .zero)
        self.imageView.backgroundColor = .red
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)
    }
    
}
