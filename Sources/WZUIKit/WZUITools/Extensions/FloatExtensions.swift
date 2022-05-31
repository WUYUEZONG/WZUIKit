//
//  FloatExtensions.swift
//  
//
//  Created by mntechMac on 2022/3/31.
//

import UIKit


extension CGFloat {
    
    
    /// 竖屏状态的状态栏
    private static var statusPortraitHeight: CGFloat = 0
}

public extension CGFloat {
    
    static var standardStatusBarHeight: CGFloat {
        if statusPortraitHeight > 0 { return statusPortraitHeight }
        let h = wzStatusBarHeight
        return initStatusPortraitHeight(h)
    }
    
    @discardableResult
    static func initStatusPortraitHeight(_ height: CGFloat = 0) -> CGFloat {
        if statusPortraitHeight == 0 {
            statusPortraitHeight = height
        }
        return statusPortraitHeight
    }
    
    static var wzScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var ignoreSafeAreaScreenWidth: CGFloat {
        let appSafeAreaInsets = appSafeAreaInsets
        return .wzScreenWidth - appSafeAreaInsets.left - appSafeAreaInsets.right
    }
    
    static var wzScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var wzStatusBarHeight: CGFloat {
        
        var l: CGFloat = 0
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let statusBarManager = scene.statusBarManager {
                l = statusBarManager.statusBarFrame.height
            }
            
        } else {
            l = UIApplication.shared.statusBarFrame.height
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
        return appSafeAreaInsets.bottom
    }
    
    static var appSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = scene.windows.first {
                return keyWindow.safeAreaInsets
            }
            
        } else if #available(iOS 11.0, *) {
            if let key = UIApplication.shared.keyWindow { return key.safeAreaInsets }
        }
        return .zero
    }
    
    static var wzTabWithControlBarHeight: CGFloat {
        return wzTabBarHeight + wzControlBarHeight
    }
    /// 当前！状态栏和导航栏的高度之和，旋转过程中无法提前确定高度
    ///
    /// 高度 = 状态栏（隐藏为0） + 导航栏
    static var wzStatusWithNavgationBarHeight: CGFloat {
        return wzStatusBarHeight + wzNavgationBarHeight
    }
    /// 状态栏和导航栏的高度之和，旋转过程中可以提前确定高度
    ///
    /// 横屏 = 导航栏高度
    ///
    /// 刘海屏，竖屏幕 = 状态栏 + 导航栏，不论状态栏隐不隐藏。
    ///
    /// 非刘海屏，竖屏幕 = 状态栏（不隐藏） + 导航栏
    static func wzStatusOrNavgationBarHeight(statusBarHide: Bool) -> CGFloat {
        return wzStatusBarHeightWithCamInScreen(statusBarHide: statusBarHide) + wzNavgationBarHeight
    }
    /// 根据是否刘海屏返回状态栏高度
    ///
    /// 刘海屏:不管隐藏不隐藏, 都返回有值的状态栏高度
    ///
    /// 非刘海屏: 根据隐藏显示返回状态栏高度
    ///
    static func wzStatusBarHeightWithCamInScreen(statusBarHide: Bool? = nil) -> CGFloat {
        
        if let statusBarHide = statusBarHide {
            if statusBarHide {
                return WZUITool.isCamInScreen && WZUITool.isPortrait ? standardStatusBarHeight : 0
            }
            return standardStatusBarHeight
        }
        
        if WZUITool.isPortrait {
            return WZUITool.isCamInScreen ? standardStatusBarHeight : wzStatusBarHeight
        }
        return 0
    }
    
    /// 返回屏幕较小的一边
    static var wzMinScreenSide: CGFloat {
        return wzScreenWidth < wzScreenHeight ? wzScreenWidth : wzScreenHeight
    }
    
}
