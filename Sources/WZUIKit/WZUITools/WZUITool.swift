//
//  WZUITool.swift
//  
//
//  Created by mntechMac on 2021/11/30.
//

import CoreGraphics

class WZUITool {
    
    /// 是否刘海屏
    static var isCamInScreen: Bool {
        CGFloat.standardStatusBarHeight > 20
    }
    
    /// 是否竖屏幕
    static var isPortrait: Bool {
        CGFloat.wzScreenWidth < CGFloat.wzScreenHeight
    }
    
    
    
    
}
