//
//  StepControl.swift
//  Reporters
//
//  Created by Muhammad Jbara on 31/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class StepControl: UIView {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {
        
        fileprivate static let MARGIN: CGFloat = 10.0
        
    }
    
    // MARK: - Declare Basic Variables
    
    private var steps: Int!
    private var nextStep: Int = 1
    
    // MARK: - Drawing Methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var widthStep: CGFloat = ((self.frame.width - DEFAULT.MARGIN * CGFloat(self.steps - 1)) / CGFloat(self.steps)).rounded(.down)
        var originX = self.frame.width - widthStep
        for i in 0..<self.steps {
            let contextRef: CGContext! = UIGraphicsGetCurrentContext()
            contextRef.setFillColor(UIColor.white.cgColor)
//
            contextRef.setAlpha((self.nextStep > i) ? 0.2 : 1.0)
            contextRef.fill(CGRect(x: originX, y: 0, width: widthStep, height: self.frame.height))
            contextRef.fillPath()
            originX -= widthStep + DEFAULT.MARGIN
            if i + 1 == self.steps {
                widthStep = self.frame.width - originX
            }
        }
    }
    
    // MARK: - Public Methods
    
    public func next() {
        self.nextStep += 1
        self.setNeedsDisplay()
    }
    
    public func previous() {
        self.nextStep -= 1
        self.setNeedsDisplay()
    }
    
    public func presentStep() -> Int {
        return self.nextStep
    }
    
    public func numSteps() -> Int {
        return self.steps
    }
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, _ numStep: Int) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.steps = numStep
        self.setNeedsDisplay()
    }
    
}
