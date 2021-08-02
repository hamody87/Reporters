//
//  SuperView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 17/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

@objc public protocol SuperViewDelegate {
    
    @objc func transitionToChildOverlapContainer(viewName: String, _ anArgument: Any!, _ modalTransitionStyle: ModalTransitionStyle, _ enableCloseOverlapBySlide: Bool, _ completion: (() -> Void)?)
    @objc func dismissChildOverlapContainer(_ completion: (() -> Void)?)
    @objc func dismissChildOverlapContainer()
    @objc func setStatusBarAnyStyle(statusBarStyle: UIStatusBarStyle)
    @objc func setStatusBarDarkStyle(statusBarStyle: UIStatusBarStyle)
    @objc func setStatusBarIsHidden(hide: Bool)
    @objc func superViewController() -> UIViewController!
    @objc func presentSafariViewController(url: URL!)
    @objc func transferArgumentToPreviousSuperView(anArgument argument: Any!)
    @objc optional func classDir() -> String
    
}

class SuperView: UIView, SuperViewDelegate {
    
    // MARK: - Delegate SuperViewDelegate
    
    func transitionToChildOverlapContainer(viewName: String, _ anArgument: Any!, _ modalTransitionStyle: ModalTransitionStyle, _ enableCloseOverlapBySlide: Bool, _ completion: (() -> Void)?) {
        self.delegate?.transitionToChildOverlapContainer(viewName: viewName, anArgument, modalTransitionStyle, enableCloseOverlapBySlide, completion)
    }
    
    func dismissChildOverlapContainer(_ completion: (() -> Void)?) {
        self.delegate?.dismissChildOverlapContainer(completion)
    }
    
    func dismissChildOverlapContainer() {
        self.delegate?.dismissChildOverlapContainer()
    }
    
    func setStatusBarAnyStyle(statusBarStyle: UIStatusBarStyle) {
        self.delegate?.setStatusBarAnyStyle(statusBarStyle: statusBarStyle)
    }
    
    func setStatusBarDarkStyle(statusBarStyle: UIStatusBarStyle) {
        self.delegate?.setStatusBarDarkStyle(statusBarStyle: statusBarStyle)
    }
    
    func setStatusBarIsHidden(hide: Bool) {
        self.delegate?.setStatusBarIsHidden(hide: hide)
    }
    
    func superViewController() -> UIViewController! {
        return self.delegate?.superViewController()
    }
    
    func presentSafariViewController(url: URL!) {
        self.delegate?.presentSafariViewController(url: url)
    }
    
    func transferArgumentToPreviousSuperView(anArgument argument: Any!) {
        self.delegate?.transferArgumentToPreviousSuperView(anArgument: argument)
    }
    
    public func classDir() -> String {
        if self.className() == "SuperView" {
            return ""
        }
        return "\(String(describing: delegate?.classDir?() ?? ""))\(self.className())/"
    }
    
    // MARK: - Declare Basic Variables
    
    weak private var _delegate: SuperViewDelegate? = nil
    weak open var delegate: SuperViewDelegate? {
        set(delegateValue) {
            self._delegate = delegateValue
        }
        get {
            return self._delegate
        }
    }
    internal var safeAreaView: UIView!
    internal var arguments: Any!
    
    // MARK: - Public Methods
    
    public func loadSuperView(anArgument: Any!) {
        self.arguments = anArgument
    }
    
    public func className() -> String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last! as String
    }
    
    public func superViewDidAppear() {
        for obj in self.subviews {
            if let subview : SuperView = obj as? SuperView {
                subview.superViewDidAppear()
            }
        }
    }
    
    public func transferArgument(anArgument argument: Any!) {
        
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(frame: frame)
        self.delegate = delegate
        let layer = CALayer()
        layer.frame = self.bounds
        self.layer.insertSublayer(layer, at: 0)
        self.safeAreaView = UIView(frame: CGRect(x: CONSTANTS.SCREEN.SAFE_AREA.LEFT(), y: CONSTANTS.SCREEN.SAFE_AREA.TOP(), width: self.frame.width - CONSTANTS.SCREEN.SAFE_AREA.LEFT() - CONSTANTS.SCREEN.SAFE_AREA.RIGHT(), height: self.frame.height - CONSTANTS.SCREEN.SAFE_AREA.TOP() - CONSTANTS.SCREEN.SAFE_AREA.BOTTOM()))
        self.addSubview(safeAreaView)
    }
    
    required convenience init?(withDelegate delegate: SuperViewDelegate?) {
        self.init(withFrame: CGRect.zero, delegate: delegate)
    }
    
    required convenience init?(withFrame frame: CGRect!) {
        self.init(withFrame: frame, delegate: nil)
    }
    
}
