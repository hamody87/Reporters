//
//  ContainerController.swift
//  Reporters
//
//  Created by Muhammad Jbara on 16/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

extension ContainerController: OverlapContainerDelegate {
    
    func childOverlapContainerBeganSlide(panGesture: UIPanGestureRecognizer?) {
        if let presentOverlapContainer: OverlapContainerStack = self.stackOverlapContainers.top {
            if presentOverlapContainer.enableSlide {
                self.view.isUserInteractionEnabled = false
            }
        }
    }
    
    func childOverlapContainerDidSliding(panGesture: UIPanGestureRecognizer?) {
        if let presentOverlapContainer: OverlapContainerStack = self.stackOverlapContainers.top {
            if presentOverlapContainer.enableSlide {
                if let panGesture = panGesture {
                    var frameCurrentOverlapContainer: CGRect = self.currentOverlapContainer.view.frame
                    var percentSlide: CGFloat = 0
                    switch presentOverlapContainer.modalTransitionStyle {
                        
                        case .coverVertical:
                            frameCurrentOverlapContainer.origin.y = min(max(panGesture.translation(in: self.currentOverlapContainer.view).y, 0), frameCurrentOverlapContainer.height)
                            percentSlide = min(1.0, max((frameCurrentOverlapContainer.origin.y / frameCurrentOverlapContainer.size.height), 0.0))
                            break
                        
                        case .coverLeft:
                            frameCurrentOverlapContainer.origin.x = min(max(panGesture.translation(in: self.currentOverlapContainer.view).x, -frameCurrentOverlapContainer.width), 0)
                            percentSlide = min(1.0, max((-frameCurrentOverlapContainer.origin.x / frameCurrentOverlapContainer.size.width), 0.0))
                            break
                        
                        case .coverRight:
                            frameCurrentOverlapContainer.origin.x = max(min(panGesture.translation(in: self.currentOverlapContainer.view).x, frameCurrentOverlapContainer.width), 0)
                            percentSlide = min(1.0, max((frameCurrentOverlapContainer.origin.x / frameCurrentOverlapContainer.size.width), 0.0))
                            break
                        
                        default:
                            break
                        
                    }
                    self.currentOverlapContainer.view.frame = frameCurrentOverlapContainer
                    let zoomPresentOverlapContainer: CGFloat = DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM + (1.0 - DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM) * percentSlide
                    switch presentOverlapContainer.modalTransitionStyle {
                        
                        case .coverVertical:
                            presentOverlapContainer.overlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.center.x, y: self.currentOverlapContainer.view.frame.height / 2.0 + DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING - DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING * percentSlide)
                            break
                        
                        case .coverLeft:
                            presentOverlapContainer.overlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.frame.width / 2.0 - DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING + DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING * percentSlide, y: self.currentOverlapContainer.view.center.y)
                            break
                        
                        case .coverRight:
                            presentOverlapContainer.overlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.frame.width / 2.0 + DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING - DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING * percentSlide, y: self.currentOverlapContainer.view.center.y)
                            break
                        
                        default:
                            break
                        
                    }
                    presentOverlapContainer.overlapContainer.view.alpha = 1.0 * percentSlide
                    presentOverlapContainer.overlapContainer.view.transform = CGAffineTransform(scaleX: zoomPresentOverlapContainer, y: zoomPresentOverlapContainer)
                }
            }
        }
    }
    
    func childOverlapContainerEndedSlide(panGesture: UIPanGestureRecognizer?) {
        if let presentOverlapContainer: OverlapContainerStack = self.stackOverlapContainers.top {
            if presentOverlapContainer.enableSlide {
                switch presentOverlapContainer.modalTransitionStyle {
                    
                case .leftDissolve, .rightDissolve:
                    if ((presentOverlapContainer.modalTransitionStyle == .rightDissolve) ? 1.0 : -1.0) * (panGesture?.translation(in: self.currentOverlapContainer.view).x ?? 0) > self.currentOverlapContainer.view.frame.width / 3.0 {
                        self.dismissChildOverlapContainer(nil)
                    } else {
                        self.view.isUserInteractionEnabled = true
                    }
                    break
                        
                case .coverLeft:
                    if -self.currentOverlapContainer.view.frame.origin.x > self.currentOverlapContainer.view.frame.width / 3.0 {
                        self.dismissChildOverlapContainer(nil)
                    } else {
                        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
                            var frameCurrentOverlapContainer: CGRect = self.currentOverlapContainer.view.frame
                            frameCurrentOverlapContainer.origin.x = 0.0
                            self.currentOverlapContainer.view.frame = frameCurrentOverlapContainer
                            presentOverlapContainer.overlapContainer.view.alpha = 0.0
                            presentOverlapContainer.overlapContainer.view.transform = CGAffineTransform(scaleX: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM, y: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM)
                            presentOverlapContainer.overlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.frame.width / 2.0 - DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING, y: presentOverlapContainer.overlapContainer.view.center.y)
                        }, completion: { _ in
                            self.view.isUserInteractionEnabled = true
                        })
                    }
                    break
                            
                case .coverRight:
                    if self.currentOverlapContainer.view.frame.origin.x > self.currentOverlapContainer.view.frame.width / 3.0 {
                        self.dismissChildOverlapContainer(nil)
                    } else {
                        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
                            var frameCurrentOverlapContainer: CGRect = self.currentOverlapContainer.view.frame
                            frameCurrentOverlapContainer.origin.x = 0
                            self.currentOverlapContainer.view.frame = frameCurrentOverlapContainer
                            presentOverlapContainer.overlapContainer.view.alpha = 0.0
                            presentOverlapContainer.overlapContainer.view.transform = CGAffineTransform(scaleX: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM, y: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM)
                            presentOverlapContainer.overlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.frame.width / 2.0 + DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING, y: presentOverlapContainer.overlapContainer.view.center.y)
                        }, completion: { _ in
                            self.view.isUserInteractionEnabled = true
                        })
                    }
                    break
                    
                case .coverVertical:
                    if self.currentOverlapContainer.view.frame.origin.y > self.currentOverlapContainer.view.frame.height / 3.0 {
                        self.dismissChildOverlapContainer(nil)
                    } else {
                        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
                            var frameCurrentOverlapContainer: CGRect = self.currentOverlapContainer.view.frame
                            frameCurrentOverlapContainer.origin.y = 0.0
                            self.currentOverlapContainer.view.frame = frameCurrentOverlapContainer
                            presentOverlapContainer.overlapContainer.view.alpha = 0.0
                            presentOverlapContainer.overlapContainer.view.transform = CGAffineTransform(scaleX: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM, y: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM)
                            presentOverlapContainer.overlapContainer.view.center = CGPoint(x: presentOverlapContainer.overlapContainer.view.center.x, y: self.currentOverlapContainer.view.frame.height / 2.0 + DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING)
                        }, completion: { _ in
                            self.view.isUserInteractionEnabled = true
                        })
                    }
                    break
                    
                default:
                    break
                    
                }
            }
        }
    }
    
    func dismissChildOverlapContainer(_ completion: (() -> Void)?) {
        if let presentOverlapContainer: OverlapContainerStack = self.stackOverlapContainers.top {
            let completionTransition: (() -> Void)? = ({
                self.currentOverlapContainer.willMove(toParent: nil)
                self.currentOverlapContainer.view.removeFromSuperview()
                self.currentOverlapContainer.removeFromParent()
                self.currentOverlapContainer = presentOverlapContainer.overlapContainer
                let _ = self.stackOverlapContainers.pop()
                self.currentOverlapContainer.overlapContainerDidAppear()
                self.view.isUserInteractionEnabled = true
                completion?()
            })
            switch presentOverlapContainer.modalTransitionStyle {
                
            case .leftDissolve, .rightDissolve:
                presentOverlapContainer.overlapContainer.view.alpha = 0
                presentOverlapContainer.overlapContainer.view.transform = CGAffineTransform(scaleX: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM, y: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM)
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveLinear], animations: {
                    self.currentOverlapContainer.view.alpha = 0
                    presentOverlapContainer.overlapContainer.view.alpha = 1.0
                    presentOverlapContainer.overlapContainer.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { _ in
                    completionTransition?()
                })
                break
                
            case .coverVertical, .coverLeft, .coverRight:
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
                    presentOverlapContainer.overlapContainer.view.alpha = 1.0
                    presentOverlapContainer.overlapContainer.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    var frameCurrentOverlapContainer: CGRect = self.currentOverlapContainer.view.frame
                    switch presentOverlapContainer.modalTransitionStyle {
                        
                        case .coverVertical:
                            presentOverlapContainer.overlapContainer.view.center = CGPoint(x: presentOverlapContainer.overlapContainer.view.center.x, y: self.currentOverlapContainer.view.frame.height / 2.0)
                            frameCurrentOverlapContainer.origin.y = self.currentOverlapContainer.view.frame.height + self.currentOverlapContainer.view.frame.height * 0.05
                            break
                            
                        case .coverLeft:
                            presentOverlapContainer.overlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.frame.width / 2.0, y: presentOverlapContainer.overlapContainer.view.center.y)
                            frameCurrentOverlapContainer.origin.x = -(self.currentOverlapContainer.view.frame.width + self.currentOverlapContainer.view.frame.width * 0.05)
                            break
                                
                        case .coverRight:
                            presentOverlapContainer.overlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.frame.width / 2.0, y: presentOverlapContainer.overlapContainer.view.center.y)
                            frameCurrentOverlapContainer.origin.x = self.currentOverlapContainer.view.frame.width + self.currentOverlapContainer.view.frame.width * 0.05
                            break
                                
                        default:
                            break
                    }
                    self.currentOverlapContainer.view.frame = frameCurrentOverlapContainer
                }, completion: { _ in
                    completionTransition?()
                })
                break
                
            default:
                break
                
            }
        }
    }
    
    func dismissChildOverlapContainer() {
        self.dismissChildOverlapContainer(nil)
    }
    
    func transitionToChildOverlapContainer(viewName: String, _ anArgument: Any!, _ modalTransitionStyle: ModalTransitionStyle, _ enableCloseOverlapBySlide: Bool, _ completion: (() -> Void)?) {
        self.view.isUserInteractionEnabled = false
        if let instance = NSClassFromString("\(CONSTANTS.INFO.APP.BUNDLE.NAME).\(viewName)") as? SuperView.Type {
            let presentOverlapContainer: OverlapContainer! = OverlapContainer(withDelegate: self)
            self.addChild(presentOverlapContainer)
            self.view.addSubview(presentOverlapContainer.view)
            let classInst: SuperView! = instance.init(withFrame: presentOverlapContainer.masterView.bounds, delegate: presentOverlapContainer)
            presentOverlapContainer.masterView.addSubview(classInst)
            classInst.loadSuperView(anArgument: anArgument)
            let completionTransition: (() -> Void)? = ({
                self.stackOverlapContainers.push(OverlapContainerStack(overlapContainer: self.currentOverlapContainer, modalTransitionStyle: modalTransitionStyle, enableSlide: enableCloseOverlapBySlide))
                self.currentOverlapContainer = presentOverlapContainer
                self.currentOverlapContainer.overlapContainerDidAppear()
                self.view.isUserInteractionEnabled = true
            })
            switch modalTransitionStyle {
                
                case .leftDissolve, .rightDissolve:
                    presentOverlapContainer.view.frame = CGRect(x: ((modalTransitionStyle == .leftDissolve) ? -1 : 1) * DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING, y: 0, width: presentOverlapContainer.view.frame.width, height: presentOverlapContainer.view.frame.height)
                    presentOverlapContainer.view.alpha = 0
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveLinear], animations: {
                        self.currentOverlapContainer.view.alpha = 0
                    }, completion: nil)
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.curveLinear], animations: {
                        presentOverlapContainer.view.alpha = 1.0
                        presentOverlapContainer.view.frame = CGRect(x: 0, y: 0, width: presentOverlapContainer.view.frame.width, height: presentOverlapContainer.view.frame.height)
                    }, completion: { _ in
                        completion?()
                        completionTransition?()
                    })
                    break
                
                case .coverVertical, .coverLeft, .coverRight:
                    presentOverlapContainer.view.frame = CGRect(x: ((modalTransitionStyle == .coverVertical) ? 0 : (((modalTransitionStyle == .coverLeft) ? -1 : 1) * presentOverlapContainer.view.frame.width)), y: ((modalTransitionStyle == .coverVertical) ? presentOverlapContainer.view.frame.height : 0), width: presentOverlapContainer.view.frame.width, height: presentOverlapContainer.view.frame.height)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
                        self.currentOverlapContainer.view.transform = CGAffineTransform(scaleX: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM, y: DEFAULT.OVERLAPCONTAINER.TRANSITION.ZOOM)
                        switch modalTransitionStyle {
                            
                            case .coverVertical:
                                self.currentOverlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.center.x, y: self.currentOverlapContainer.view.center.y + DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING)
                                break
                                
                            case .coverLeft:
                                self.currentOverlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.center.x - DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING, y:  self.currentOverlapContainer.view.center.y)
                                break
                                    
                            case .coverRight:
                                self.currentOverlapContainer.view.center = CGPoint(x: self.currentOverlapContainer.view.center.x + DEFAULT.OVERLAPCONTAINER.TRANSITION.MOVING, y:  self.currentOverlapContainer.view.center.y)
                                break
                                    
                            default:
                                break
                            
                        }
                        self.currentOverlapContainer.view.alpha = 0
                        presentOverlapContainer.view.frame = CGRect(x: 0, y: 0, width: presentOverlapContainer.view.frame.width, height: presentOverlapContainer.view.frame.height)
                    }, completion: { _ in
                        completion?()
                        completionTransition?()
                    })
                    break
                
                default:
                    break
                
            }
        }
    }
    
}

@objc public protocol ContainerControllerDelegate {
}

class ContainerController: UIViewController {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {
        
        struct OVERLAPCONTAINER {
            
            struct TRANSITION {
                
                fileprivate static let ZOOM: CGFloat = 0.95
                fileprivate static let MOVING: CGFloat = 20.0
                
            }
            
        }
        
    }
    
    // MARK: - Declare Structs
    
    struct OverlapContainerStack {
        var overlapContainer: OverlapContainer!
        var modalTransitionStyle: ModalTransitionStyle
        var enableSlide: Bool
    }
    
    // MARK: - Declare Basic Variables
    
    weak private var _delegate: ContainerControllerDelegate? = nil
    weak open var delegate: ContainerControllerDelegate? {
        set(delegateValue) {
            self._delegate = delegateValue
        }
        get {
            return self._delegate
        }
    }
    private var currentOverlapContainer: OverlapContainer!
    private var stackOverlapContainers: Stack! = Stack<OverlapContainerStack>()
    
    // MARK: - Override Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func loadView() {
        super.loadView()
        self.currentOverlapContainer = OverlapContainer(withDelegate: self as OverlapContainerDelegate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black//UIColor(named: "Background/First")
        self.addChild(self.currentOverlapContainer)
        self.view.addSubview(self.currentOverlapContainer.view)
        self.currentOverlapContainer?.didMove(toParent: self)
        if let instance = NSClassFromString("\(CONSTANTS.INFO.APP.BUNDLE.NAME).\(CONSTANTS.INFO.GLOBAL.LANDING_VIEW())") as? SuperView.Type {
            let classInst: SuperView! = instance.init(withFrame: self.currentOverlapContainer.masterView.bounds, delegate: currentOverlapContainer)
            self.currentOverlapContainer.masterView.addSubview(classInst)
            self.currentOverlapContainer.overlapContainerDidAppear()
            classInst.loadSuperView(anArgument: nil)
        }
    }
    
    // MARK: - Override Variables
    
    override var shouldAutorotate: Bool {
        return CONSTANTS.SCREEN.ENABLE_AUTO_ROTATE
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return (self.currentOverlapContainer == nil) ? CONSTANTS.STATUSBAR.DEFAULT.ANIMATION : self.currentOverlapContainer.statusBarAnimation
    }
    
    override var prefersStatusBarHidden: Bool {
        return (self.currentOverlapContainer == nil) ? CONSTANTS.STATUSBAR.DEFAULT.HIDDEN : self.currentOverlapContainer.statusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                return (self.currentOverlapContainer == nil) ? CONSTANTS.STATUSBAR.DEFAULT.STYLE.DARK : self.currentOverlapContainer.statusBarDark
            }
        }
        return (self.currentOverlapContainer == nil) ? CONSTANTS.STATUSBAR.DEFAULT.STYLE.ANY : self.currentOverlapContainer.statusBarAny
    }
    
    // MARK: - Interstitial ContainerController
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(withDelegate delegate: ContainerControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
}
