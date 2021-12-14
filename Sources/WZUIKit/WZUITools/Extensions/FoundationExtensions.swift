//
//  FoundationExtensions.swift
//  
//
//  Created by mntechMac on 2021/12/14.
//

import UIKit


extension String {
    
    func width(attributes: [NSAttributedString.Key : Any]?, default height: CGFloat) -> CGFloat {
        return self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.width
    }
    
}
