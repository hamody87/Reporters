//
//  Stack.swift
//  Reporters
//
//  Created by Muhammad Jbara on 17/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation

public struct Stack<Element> {
    
    fileprivate var array = [Element]()
    
    public var isEmpty: Bool {
        return self.array.isEmpty
    }
    
    public var count: Int {
        return self.array.count
    }
    
    public var top: Element? {
        return self.array.last
    }
    
    public mutating func push(_ element: Element) {
        self.array.append(element)
    }
    
    public mutating func pop() -> Element? {
        return self.array.popLast()
    }
    
}
