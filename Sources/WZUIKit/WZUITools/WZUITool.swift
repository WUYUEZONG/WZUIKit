//
//  WZUITool.swift
//  
//
//  Created by mntechMac on 2021/11/30.
//

import CoreGraphics

class WZUITool {
    
    static var isCamInScreen: Bool {
        CGFloat.standardStatusBarHeight == 20
    }
    
    static var isPortrait: Bool {
        CGFloat.wzScreenWidth < CGFloat.wzScreenHeight
    }
    
    
    
    
}
