//
//  StringExtensions.swift
//  
//
//  Created by mntechMac on 2021/12/14.
//

import UIKit


public extension String {
    
    enum WZDateFormat: String {
        case Y_M = "yyyy-MM"
        case Y_M_D = "yyyy-MM-dd"
        case Y_M_D_H_M = "yyyy-MM-dd HH:mm"
        case Y_M_D_H_M_S = "yyyy-MM-dd HH:mm:ss"
    }
    
    func width(attributes: [NSAttributedString.Key : Any]?) -> CGFloat {
        return self.boundingRect(with: .zero, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.width
    }
    /// String To Date
    ///
    /// format: "yyyy-MM-dd" "yyyy-MM-dd HH:mm" ...and more see: `String.WZDateFormat`
    ///
    /// calendar: your calendar
    func toDate(_ format: String, calendar: Calendar = Calendar.current) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = calendar
        return formatter.date(from: self)
    }
    
}
