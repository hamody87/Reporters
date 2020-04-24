//
//  UITableViewExtension.swift
//  Reporters
//
//  Created by Muhammad Jbara on 24/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
}
