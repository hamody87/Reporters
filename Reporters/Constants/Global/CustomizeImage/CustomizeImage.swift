//
//  CustomizeImage.swift
//  Reporters
//
//  Created by Muhammad Jbara on 08/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

extension CustomizeImage: UINavigationControllerDelegate {
}

extension CustomizeImage: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var imageRequest: UIImage!
        if let image = info[.editedImage] as? UIImage {
            imageRequest = image
        } else if let image = info[.originalImage] as? UIImage {
            imageRequest = image
        }
        if let imageRequest = imageRequest {
            self.imageView.isHidden = false
            self.imageView.image = imageRequest

        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

class CustomizeImage: SuperView {
    
    // MARK: - Declare Basic Variables
    
    private var labelImage: UILabel!
    private var updateView: SuperView!
    private var imageView: UIImageView!
    private var asyncImageView: AsyncImageView!
    private var uploadIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Methods
    
    @objc private func uploadPhoto(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let _ = self.imageView.image {
            let deletePhoto = UIAlertAction(title: "DELETE_PHOTO".localized, style: .default, handler: { _ in
                self.imageView.image = nil
            })
            deletePhoto.setValue(UIColor.red, forKey: "titleTextColor")
            alertController.addAction(deletePhoto)
        }
        alertController.addAction(UIAlertAction(title: "TAKE_PHOTO".localized, style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .camera
                pickerController.allowsEditing = true
                DispatchQueue.main.async {
                    self.superViewController()?.present(pickerController, animated: true, completion: nil)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "CHOOSE_PHOTO".localized, style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                pickerController.allowsEditing = true
                DispatchQueue.main.async {
                    self.superViewController()?.present(pickerController, animated: true, completion: nil)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        self.superViewController().present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Public Methods
    
    public func getImage() -> UIImage! {
        return imageView.image
    }
    
    public func imageWithUrl(_ url: String) {
        self.asyncImageView.isHidden = false
        self.asyncImageView.setImage(withUrl: NSURL(string: url)!)
    }
    
    public func imageWithName(_ name: String) {
        self.labelImage.text = name.prefix(1).uppercased()
        self.asyncImageView.isHidden = true
        self.asyncImageView.setImage(withUrl: nil)
    }
    
    public func startUploadingImage() {
        self.uploadIndicator.startAnimating()
    }
    
    @objc public func endUploadingImage() {
        self.uploadIndicator.stopAnimating()
    }
    
    // MARK: - Interstitial CustomizeButton
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
    }

    required convenience init?(withFrame frame: CGRect!, argument: [String: Any]! = nil) {
        self.init(withFrame: frame, delegate: argument[CONSTANTS.KEYS.ELEMENTS.DELEGATE] as? SuperViewDelegate)
        self.backgroundColor = UIColor.white

        if let corner: [String: Any] = argument[CONSTANTS.KEYS.ELEMENTS.CORNER.SELF] as? [String: Any], let direction: [UIRectCorner] = corner[CONSTANTS.KEYS.ELEMENTS.CORNER.DIRECTION] as? [UIRectCorner], let radius: NSNumber = corner[CONSTANTS.KEYS.ELEMENTS.CORNER.RADIUS] as? NSNumber {
            var cornersToRound: UIRectCorner = []
            for next in direction {
                cornersToRound.insert(next)
            }
            self.roundCorners(corners: cornersToRound, radius: CGFloat(radius.floatValue))
        }
        if let labelImage: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: self.bounds, {
            var arg: [String: Any] = [String: Any]()
            arg[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: self.bounds.width * 0.7, true)
            arg[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            arg[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT]
            return arg
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            self.labelImage = labelImage
            self.addSubview(self.labelImage)
        }
        if let imageView: UIImageView = CONSTANTS.GLOBAL.createImageViewElement(withFrame: self.bounds, {
            var arg: [String: Any] = [String: Any]()
            arg[CONSTANTS.KEYS.ELEMENTS.HIDDEN] = true
            return arg
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UIImageView {
            self.imageView = imageView
            self.addSubview(self.imageView)
        }
        if let updateView: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 0, y: self.labelImage.frame.height * (2 / 3), width: self.labelImage.frame.width, height: self.labelImage.frame.height * (1 / 3)), {
            var arg: [String: Any] = [String: Any]()
            arg[CONSTANTS.KEYS.ELEMENTS.HIDDEN] = true
            return arg
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? SuperView {
            self.updateView = updateView
            self.addSubview(self.updateView)
            self.updateView.isHidden = true
            if let allow: Bool = argument[CONSTANTS.KEYS.ELEMENTS.ALLOW.UPDATE] as? Bool {
                self.updateView.isHidden = !allow
            }
            self.updateView.addSubview(CONSTANTS.GLOBAL.createSuperViewElement(withFrame: self.updateView.bounds, {
                var arg: [String: Any] = [String: Any]()
                arg[CONSTANTS.KEYS.ELEMENTS.ALPHA] = 0.3
                arg[CONSTANTS.KEYS.ELEMENTS.COLOR.BACKGROUND] = UIColor.black
                return arg
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! SuperView)
            if let img_camera: UIImage = UIImage(named: "CameraIcon") {
                self.updateView.addSubview(CONSTANTS.GLOBAL.createImageViewElement(withFrame: CGRect(x: (self.updateView.frame.width - img_camera.size.width) / 2.0, y: 5.0, width: img_camera.size.width, height: img_camera.size.height), {
                    var arg: [String: Any] = [String: Any]()
                    arg[CONSTANTS.KEYS.ELEMENTS.IMAGE] = img_camera
                    return arg
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIImageView)
                self.updateView.addSubview(CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: img_camera.size.height, width: self.updateView.frame.width, height: self.updateView.frame.height - img_camera.size.height), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = "UPDATE".localized
                    argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, false)
                    argument[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
                    argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = UIColor(rgb: 0x3b3b3b)
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UILabel)
            }
            self.updateView.addSubview(CONSTANTS.GLOBAL.createButtonElement(withFrame: self.updateView.bounds, {
                var arg: [String: Any] = [String: Any]()
                arg[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = [CONSTANTS.KEYS.ELEMENTS.BUTTON.TARGET: self, CONSTANTS.KEYS.ELEMENTS.BUTTON.SELECTOR: #selector(self.uploadPhoto(_ :))]
                return arg
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIButton)
        }
        if let btnElements: [String: Any] = argument[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] as? [String: Any] {
            self.addSubview(CONSTANTS.GLOBAL.createButtonElement(withFrame: self.bounds, {
                var arg: [String: Any] = [String: Any]()
                arg[CONSTANTS.KEYS.ELEMENTS.BUTTON.SELF] = btnElements
                return arg
            }())[CONSTANTS.KEYS.ELEMENTS.SELF] as! UIButton)
        }
        self.asyncImageView = AsyncImageView(withFrame: self.bounds)
        self.addSubview(self.asyncImageView)
        self.uploadIndicator = UIActivityIndicatorView(style: .gray)
        self.uploadIndicator.center = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        self.addSubview(self.uploadIndicator)
    }
    
}
