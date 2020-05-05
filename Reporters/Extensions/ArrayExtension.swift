//
//  ArrayExtension.swift
//  Reporters
//
//  Created by Muhammad Jbara on 13/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation

extension Array {
    
    func getElement(safe index: Int) -> Element! {
        return self.indices.contains(index) ? self[index] : nil
    }
    
}
