//
//  File.swift
//  
//
//  Created by mntechMac on 2021/11/30.
//

import UIKit


//public extension UIView {
//    
//    static func initNib(_ name: String? = nil, owner: Any?) -> Self? {
//        let nibName = name == nil ? Self.description() : name!
//        return Bundle.module.loadNibNamed(nibName, owner: owner, options: nil)?.first as? Self
//    }
//    
//    
//}

/// 简化坐标
public extension UIView {

    var wzHeight: CGFloat {
        self.frame.height
    }
    
    var wzWidth: CGFloat {
        self.frame.width
    }
    
    var wzMinX: CGFloat {
        self.frame.minX
    }
    
    var wzMinY: CGFloat {
        self.frame.minY
    }
    
    var wzMaxX: CGFloat {
        self.frame.maxX
    }
    
    var wzMaxY: CGFloat {
        self.frame.maxY
    }
    
    var wzCenterX: CGFloat {
        self.center.x
    }
    
    var wzCenterY: CGFloat {
        self.center.y
    }
    
}
