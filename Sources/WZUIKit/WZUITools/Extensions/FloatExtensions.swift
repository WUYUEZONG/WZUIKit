//
//  FloatExtensions.swift
//  
//
//  Created by mntechMac on 2022/3/31.
//

import UIKit

extension CGFloat {
    
    static var wzStatusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let statusBarManager = scene.statusBarManager {
                return statusBarManager.statusBarFrame.height
            }
            
        } else if #available(iOS 11.0, *) {
            if let key = UIApplication.shared.keyWindow { return key.safeAreaInsets.top }
        }
        return 20
    }
    
    static var wzNavgationBarHeight: CGFloat {
        return 44
    }
    
    static var wzTabBarHeight: CGFloat {
        return 49
    }
    
    static var wzControlBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = scene.windows.first {
                return keyWindow.safeAreaInsets.bottom
            }
            
        } else if #available(iOS 11.0, *) {
            if let key = UIApplication.shared.keyWindow { return key.safeAreaInsets.bottom }
        }
        return 0
    }
    
    static var wzTabWithControlBarHeight: CGFloat {
        return wzTabBarHeight + wzControlBarHeight
    }
    
    static var wzStatusWithNavgationBarHeight: CGFloat {
        return wzStatusBarHeight + wzNavgationBarHeight
    }
    
}
