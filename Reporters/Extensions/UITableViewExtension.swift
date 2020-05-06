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
    
    func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool, _ completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        }, completion: { _ in
            completion()
        })
    }
    
}
