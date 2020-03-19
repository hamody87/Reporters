//
//  OverlapContainer.swift
//  Reporters
//
//  Created by Muhammad Jbara on 16/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit
import SafariServices

extension OverlapContainer: SuperViewDelegate {
    
    func transitionToChildOverlapContainer(viewName: String, _ anArgument: Any!, _ modalTransitionStyle: ModalTransitionStyle, _ enableCloseOverlapBySlide: Bool, _ completion: (() -> Void)?) {
        delegate?.transitionToChildOverlapContainer(viewName: viewName, anArgument, modalTransitionStyle, enableCloseOverlapBySlide, completion)
    }
    
    func dismissChildOverlapContainer(_ completion: (() -> Void)?) {
        delegate?.dismissChildOverlapContainer(completion)
    }
    
    func dismissChildOverlapContainer() {
        delegate?.dismissChildOverlapContainer()
    }
    
    func presentSafariViewController(url: URL) {
        if url.absoluteString.contains("mailto:") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let sfvc: SFSafariViewController = SFSafariViewController(url: url)
            self.present(sfvc, animated: true, completion: nil)
        }
    }
    
    func setStatusBarAnyStyle(statusBarStyle: UIStatusBarStyle) {
        self.statusBarAny = statusBarStyle
    }
    
    func setStatusBarDarkStyle(statusBarStyle: UIStatusBarStyle) {
        self.statusBarDark = statusBarStyle
    }
    
    func superViewController() -> UIViewController! {
        return self
    }
    
}

extension OverlapContainer: UIGestureRecognizerDelegate {
}

@objc public protocol OverlapContainerDelegate {
    
    @objc func transitionToChildOverlapContainer(viewName: String, _ anArgument: Any!, _ modalTransitionStyle: ModalTransitionStyle, _ enableCloseOverlapBySlide: Bool, _ completion: (() -> Void)?)
    @objc func dismissChildOverlapContainer(_ completion: (() -> Void)?)
    @objc func dismissChildOverlapContainer()
    @objc func childOverlapContainerBeganSlide(panGesture: UIPanGestureRecognizer?)
    @objc func childOverlapContainerDidSliding(panGesture: UIPanGestureRecognizer?)
    @objc func childOverlapContainerEndedSlide(panGesture: UIPanGestureRecognizer?)
    
}

class OverlapContainer: UIViewController {
    
    // MARK: - Declare Basic Variables
    
    weak private var _delegate: OverlapContainerDelegate? = nil
    weak open var delegate: OverlapContainerDelegate? {
        set(delegateValue) {
            self._delegate = delegateValue
        }
        get {
            return self._delegate
        }
    }
    
    public var statusBarAny: UIStatusBarStyle! = CONSTANTS.STATUSBAR.DEFAULT.STYLE.ANY {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    public var statusBarDark: UIStatusBarStyle! = CONSTANTS.STATUSBAR.DEFAULT.STYLE.DARK {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    public var statusBarHidden: Bool! = CONSTANTS.STATUSBAR.DEFAULT.HIDDEN {
        didSet {
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    public var statusBarAnimation: UIStatusBarAnimation! = CONSTANTS.STATUSBAR.DEFAULT.ANIMATION {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    internal var masterView: SuperView!
    
    // MARK: - Private Methods
    
    @objc private func panGestureMasterView(_ panGesture: UIPanGestureRecognizer?) {
        switch panGesture!.state {
            
        case UIGestureRecognizer.State.began:
            delegate?.childOverlapContainerBeganSlide(panGesture: panGesture)
            break
            
        case UIGestureRecognizer.State.ended:
//            self.scrollView?.isScrollEnabled = true
            delegate?.childOverlapContainerEndedSlide(panGesture: panGesture)
            break
            
        default:
            delegate?.childOverlapContainerDidSliding(panGesture: panGesture)
            break
            
        }
    }
    
    @objc private func panGestureOverlapView(_ panGesture: UIPanGestureRecognizer?) {
    }
    
    // MARK: - Public Methods
    
    public func overlapContainerDidAppear() {
        self.masterView?.superViewDidAppear()
    }
    
    // MARK: - Override Methods
    
    override func loadView() {
        super.loadView()
        self.masterView = SuperView(withFrame: CGRect(x: CONSTANTS.SCREEN.SAFE_AREA.LEFT(), y: 0, width: self.view.frame.width - CONSTANTS.SCREEN.SAFE_AREA.LEFT() - CONSTANTS.SCREEN.SAFE_AREA.RIGHT(), height: self.view.frame.height), delegate: self as SuperViewDelegate)
        self.masterView.clipsToBounds = true
        self.view.addSubview(self.masterView)
        let panGestureMasterView: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureMasterView(_ :)))
        panGestureMasterView.delegate = self as UIGestureRecognizerDelegate
        panGestureMasterView.minimumNumberOfTouches = 1
        panGestureMasterView.maximumNumberOfTouches = 1
        self.masterView.addGestureRecognizer(panGestureMasterView)
    }
    
    // MARK: - Interstitial OverlapContainer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(withDelegate delegate: OverlapContainerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
}

