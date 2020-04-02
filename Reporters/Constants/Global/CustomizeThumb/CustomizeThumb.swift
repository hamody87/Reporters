//
//  CustomizeThumb.swift
//  Reporters
//
//  Created by Muhammad Jbara on 02/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

extension CustomizeThumb: UINavigationControllerDelegate {
}

extension CustomizeThumb: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        var imageRequest: UIImage!
//        if let image = info[.editedImage] as? UIImage {
//            imageRequest = image
//        } else if let image = info[.originalImage] as? UIImage {
//            imageRequest = image
//        }
//        if let _ = imageRequest {
//            for i: Int in 0..<self.photos.count {
//                guard let _: UIImage = self.photos[i] else {
//                    if let imageView: UIImageView = self.photoView[i].viewWithTag(DEFAULT.PHOTOS.TAGS.IMAGE) as? UIImageView, let btnAdd: UIButton = self.photoView[i].viewWithTag(DEFAULT.PHOTOS.TAGS.BTN.ADD) as? UIButton, let btnRemove: UIButton = self.photoView[i].viewWithTag(DEFAULT.PHOTOS.TAGS.BTN.REMOVE) as? UIButton {
//                        imageView.image = imageRequest
//                        imageView.isHidden = false
//                        btnAdd.isHidden = true
//                        btnRemove.isHidden = false
//                        self.photos[i] = imageRequest
//                    }
//                    self.customizeButtonReference[self.stepControl.presentStep() - 1].enableTouch(true)
//                    picker.dismiss(animated: true, completion: nil)
//                    return
//                }
//            }
//        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

class CustomizeThumb: SuperView {
    
    // MARK: - Declare Basic Variables
    
    private var labelThumb: UILabel!
    private var updateView: SuperView!
    
    // MARK: - Private Methods
    
    @objc private func uploadPhoto(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "TAKE_PHOTO".localized, style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .camera
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
                DispatchQueue.main.async {
                    self.superViewController()?.present(pickerController, animated: true, completion: nil)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        self.superViewController().present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Public Methods
    
    public func thumbWithPath(_ path: String) {
    }
    
    public func thumbWithName(_ name: String) {
        self.labelThumb.text = name.prefix(1).uppercased()
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
        if let labelThumb: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: self.bounds, {
            var arg: [String: Any] = [String: Any]()
            arg[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: self.bounds.width / 2.0 + 15.0, true)
            arg[CONSTANTS.KEYS.ELEMENTS.ALIGNMENT] = NSTextAlignment.center
            arg[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT] = argument[CONSTANTS.KEYS.ELEMENTS.COLOR.TEXT]
            return arg
        }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
            self.labelThumb = labelThumb
            self.addSubview(self.labelThumb)
        }
        if let updateView: SuperView = CONSTANTS.GLOBAL.createSuperViewElement(withFrame: CGRect(x: 0, y: self.labelThumb.frame.height * (2 / 3), width: self.labelThumb.frame.width, height: self.labelThumb.frame.height * (1 / 3)), {
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
    }
    
}
