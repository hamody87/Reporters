//
//  ReachabilityHandler.swift
//  Reporters
//
//  Created by Muhammad Jbara on 21/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation

class ReachabilityHandler: ReachabilityObserverDelegate {
  
  //MARK: Lifecycle
  
    required init() {
        try? addReachabilityObserver()
    }
  
    deinit {
        removeReachabilityObserver()
    }
  
    //MARK: Reachability
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
//            print("No internet connection")
            print("ddddd")
        }
    }
    
}

