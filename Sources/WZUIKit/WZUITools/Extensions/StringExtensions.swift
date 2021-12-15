//
//  StringExtensions.swift
//  
//
//  Created by mntechMac on 2021/12/14.
//

import UIKit


extension String {
    
    func width(attributes: [NSAttributedString.Key : Any]?) -> CGFloat {
        return self.boundingRect(with: .zero, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.width
    }
    
}
