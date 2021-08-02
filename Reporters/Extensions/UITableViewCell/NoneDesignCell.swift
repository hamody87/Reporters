//
//  NoneDesignCell.swift
//  Reporters
//
//  Created by Muhammad Jbara on 29/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

class NoneDesignCell: UITableViewCell {

    static let NONE_DESIGN_CELL_REUSE_ID: String = "noneDesignCellReuseId"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    // MARK: - Interstitial StyleNoneCell
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
}
