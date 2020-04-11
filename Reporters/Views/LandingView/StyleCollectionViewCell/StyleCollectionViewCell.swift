//
//  StyleCollectionViewCell.swift
//  Reporters
//
//  Created by Muhammad Jbara on 11/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class StyleCollectionViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isSelected = false
        self.isHighlighted = false
        self.backgroundColor = .clear
    }
    
    // MARK: - Declare Basic Variables
    
    override open var isSelected: Bool {
        set {
        }
        get {
            return super.isSelected
        }
    }
    
    override open var isHighlighted: Bool {
        set {
        }
        get {
            return super.isHighlighted
        }
    }
    
    // MARK: - Interstitial StyleCollectionViewCell
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
