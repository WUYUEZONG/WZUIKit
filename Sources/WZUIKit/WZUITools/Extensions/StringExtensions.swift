//
//  StringExtensions.swift
//  
//
//  Created by mntechMac on 2021/12/14.
//

import UIKit


public extension String {
    
    func width(attributes: [NSAttributedString.Key : Any]?) -> CGFloat {
        return self.boundingRect(with: .zero, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.width
    }
    
    func toDate(_ format: String, calendar: Calendar = Calendar.current) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
}
