//
//  File.swift
//  
//
//  Created by mntechMac on 2021/11/30.
//

import UIKit


public extension UIView {
    
    static func initNib(_ name: String? = nil, owner: Any?) -> Self? {
        let nibName = name == nil ? Self.description() : name!
        return Bundle.module.loadNibNamed(nibName, owner: owner, options: nil)?.first as? Self
    }
    
}
