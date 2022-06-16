//
//  WZUITool.swift
//  
//
//  Created by mntechMac on 2021/11/30.
//

import CoreGraphics
import Foundation

public class WZUITool {
    
    public static var shared = WZUITool()
    
    public lazy var utcCalendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()
}

public extension WZUITool {
    /// 是否刘海屏
    static var isCamInScreen: Bool {
        CGFloat.standardStatusBarHeight > 20
    }
    
    /// 是否竖屏幕
    static var isPortrait: Bool {
        CGFloat.wzScreenWidth < CGFloat.wzScreenHeight
    }
}
