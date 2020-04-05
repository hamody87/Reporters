//
//  Queue.swift
//  Reporters
//
//  Created by Muhammad Jbara on 06/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation

public struct Queue<Element> {
    
    fileprivate var array = [Element]()
    
    public var isEmpty: Bool {
        return self.array.isEmpty
    }
    
    public var count: Int {
        return self.array.count
    }
    
    public mutating func enqueue(_ element: Element) {
        self.array.append(element)
    }
    
    public mutating func dequeue() -> Element? {
        if self.isEmpty {
            return nil
        }
        let tempElement = self.array.first
        self.array.remove(at: 0)
        return tempElement
    }
    
}
