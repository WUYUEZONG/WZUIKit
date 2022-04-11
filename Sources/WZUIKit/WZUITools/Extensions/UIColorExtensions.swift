//
//  UIColorExtensions.swift
//  
//
//  Created by mntechMac on 2021/11/30.
//

import UIKit


public extension UIColor {
    
    /// Init color without divide 255.0
    ///
    /// - Parameters:
    ///   - r: (0 ~ 255) red
    ///   - g: (0 ~ 255) green
    ///   - b: (0 ~ 255) blue
    ///   - a: (0 ~ 1) alpha
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
    
    /// Init color with hex code
    ///
    /// - Parameter hex: hex code (eg. 0x00eeee)
    convenience init(hex: Int) {
        self.init(r: (hex & 0xff0000) >> 16, g: (hex & 0xff00) >> 8, b: (hex & 0xff), a: 1)
    }
}


public extension UIColor {
    
    static func randomColor(_ start: UInt32 = 0) -> UIColor {
        var start = start
        let max: UInt32 = 255
        if start > max {
            start = max
        }
        let red = CGFloat(arc4random_uniform(max - start) + start)
        let green = CGFloat(arc4random_uniform(max - start) + start)
        let blue = CGFloat(arc4random_uniform(max - start) + start)
        return colorWithRGB(red: red, green: green, blue: blue, alpha: 1)
    }
    
    /**
     Make color with divide 255.0
     - Parameters:
        - r: (0 ~ 255) red
        - g: (0 ~ 255) green
        - b: (0 ~ 255) blue
        - a: (0 ~ 1) alpha
     - returns: RGB
     */
    static func colorWithRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    /**
     Make color with hex string
     - parameter hex: 16进制字符串(eg. #0x00eeee or #0X00eeee or 0x00eeee or 0X00eeee or 00eeee)
     - returns: RGB
     */
    static func colorWithHexString (hex: String, alpha: CGFloat) -> UIColor {
        
        var cString: NSString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: 1) as NSString
        }
        if (cString.hasPrefix("0X") || cString.hasPrefix("0x")) {
            cString = cString.substring(from: 2) as NSString
        }
        
        if (cString.length != 6) {
            return UIColor.gray
        }
        
        let rString = cString.substring(with: NSMakeRange(0, 2))
        let gString = cString.substring(with: NSMakeRange(2, 2))
        let bString = cString.substring(with: NSMakeRange(4, 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}


public extension UIColor {
    
    /// onlyLight, if true , just return the ligt mode color.
    static func wz333(_ onlyLight: Bool = false) -> UIColor {
        if #available(iOS 13, *), !onlyLight {
            return UIColor { $0.userInterfaceStyle == .light ? UIColor(hex: 0x333333) : UIColor(hex: 0xDEDEDE) }
        }
        return UIColor(hex: 0x333333)
    }
    
    static func wz999(_ onlyLight: Bool = false) -> UIColor {
        if #available(iOS 13, *), !onlyLight {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(hex: 0x999999) : UIColor(hex: 0x838383) }
        }
        return UIColor(hex: 0x999999)
    }
    
    static var wz666: UIColor {
        if #available(iOS 13, *) {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(hex: 0x666666) : UIColor(hex: 0xB8B8B8) }
        }
        return UIColor(hex: 0x666666)
    }
    
    /// 0xD8D8D8
    static var wzExtraLight: UIColor {
        if #available(iOS 13, *) {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(hex: 0xD8D8D8) : UIColor(hex: 0x292929) }
        }
        return UIColor(hex: 0xD8D8D8)
    }
    
    static var wzLight: UIColor {
        if #available(iOS 13, *) {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(hex: 0xC4C4C4) : UIColor(hex: 0x777777) }
        }
        return UIColor(hex: 0xC4C4C4)
    }
    
    
    static var wzF2: UIColor {
        if #available(iOS 13, *) {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(hex: 0xF2F2F2) : UIColor(hex: 0x161616) }
        }
        return UIColor(hex: 0xF2F2F2)
    }
    
    static var wzF8: UIColor {
        if #available(iOS 13, *) {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(hex: 0xF8F8F8) : UIColor(hex: 0x000000) }
        }
        return UIColor(hex: 0xF8F8F8)
    }
    
    static var wzBlack: UIColor {
        if #available(iOS 13, *) {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(hex: 0x000000) : UIColor(hex: 0xFFFFFF) }
        }
        return UIColor(hex: 0x000000)
    }
    
    static func wzBlack(alpha: CGFloat = 1) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(white: 0, alpha: alpha) : UIColor(white: 1, alpha: alpha) }
        }
        return UIColor(white: 0, alpha: alpha)
    }
    
    static var wzWhite: UIColor {
        if #available(iOS 13, *) {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x000000) }
        }
        return UIColor(hex: 0xFFFFFF)
    }
    
    static func wzWhite(alpha: CGFloat = 1) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(white: 1, alpha: alpha) : UIColor(white: 0, alpha: alpha) }
        }
        return UIColor(white: 1, alpha: alpha)
    }
    
    static func wzDark(_ onlyLight: Bool = false) -> UIColor {
        if #available(iOS 13, *), !onlyLight {
            return UIColor  { $0.userInterfaceStyle == .light ? UIColor(hex: 0x1D1D1D) : UIColor(hex: 0xEBEBEB) }
        }
        return UIColor(hex: 0x1D1D1D)
    }
}
