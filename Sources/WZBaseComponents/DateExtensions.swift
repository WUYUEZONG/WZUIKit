//
//  File.swift
//  
//
//  Created by August on 2022/5/7.
//

import Foundation


public extension Date {
    /// Date to String
    ///
    /// format: "yyyy-MM-dd" "yyyy-MM-dd HH:mm" ...and more
    ///
    /// calendar: your calendar
    func toString(_ format: String, calendar: Calendar = Calendar.current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = calendar
        return formatter.string(from: self)
    }
}
