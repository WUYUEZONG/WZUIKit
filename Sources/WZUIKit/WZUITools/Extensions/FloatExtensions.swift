//
//  FloatExtensions.swift
//  
//
//  Created by mntechMac on 2022/3/31.
//

import UIKit

extension CGFloat {
    /// 竖屏状态的状态栏
    static var statusPortraitHeight: CGFloat? = nil
}

public extension CGFloat {
    
    static var standardStatusBarHeight: CGFloat {
        return initStatusPortraitHeight(0)
    }
    
    @discardableResult
    static func initStatusPortraitHeight(_ height: CGFloat) -> CGFloat {
        if statusPortraitHeight == nil || statusPortraitHeight == 0 {
            statusPortraitHeight = height
        }
        return statusPortraitHeight!
    }
    
    static var wzScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var wzScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var wzStatusBarHeight: CGFloat {
        
        var l: CGFloat = wzScreenWidth < wzScreenHeight ? 20 : 0
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let statusBarManager = scene.statusBarManager {
                l = statusBarManager.statusBarFrame.height
                if statusBarManager.isStatusBarHidden, initStatusPortraitHeight(l) > 20 {
                    l = initStatusPortraitHeight(l)
                }
            }
            
        } else if #available(iOS 11.0, *) {
            if let key = UIApplication.shared.keyWindow {
                l = key.safeAreaInsets.top
            }
        }
        initStatusPortraitHeight(l)
        return l
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
