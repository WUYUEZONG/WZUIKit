//
//  File.swift
//  
//
//  Created by August on 2022/5/7.
//

import Foundation


extension Date {
    
    func toString(_ format: String, calendar: Calendar = Calendar.current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
