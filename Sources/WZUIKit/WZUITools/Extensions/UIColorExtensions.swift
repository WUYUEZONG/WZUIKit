//
//  UIColorExtensions.swift
//  
//
//  Created by mntechMac on 2021/11/30.
//

import UIKit


public extension UIColor {
    
    // Init color without divide 255.0
    //
    // - Parameters:
    //   - r: (0 ~ 255) red
    //   - g: (0 ~ 255) green
    //   - b: (0 ~ 255) blue
    //   - a: (0 ~ 1) alpha
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
    
    // Init color with hex code
    //
    // - Parameter hex: hex code (eg. 0x00eeee)
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
