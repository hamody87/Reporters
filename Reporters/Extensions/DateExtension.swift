//
//  DateExtension.swift
//  Reporters
//
//  Created by Muhammad Jbara on 21/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import Foundation

extension Date {

    func stripTime() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.timeZone = TimeZone(abbreviation: "GMT")!
        return Calendar.current.date(from: components)!
    }

}
