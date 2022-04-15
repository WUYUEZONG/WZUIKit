//
//  WZHUDUI.swift
//  
//
//  Created by mntechMac on 2022/4/15.
//

import SwiftUI

@available(iOS 13.0.0, *)
public struct WZHUDUI : View {
    
    static var shared = WZHUDUI()
    
    var message: String?
    
    var image: UIImage?
    
    var view: UIView {
        UIHostingController(rootView: self).view
    }
    
    public mutating func show(message: String?, image: UIImage?) {
        self.message = message
        self.image = image
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = scene.windows.first {
            if !keyWindow.subviews.contains(view) {
                keyWindow.addSubview(view)
            } else {
                keyWindow.bringSubviewToFront(view)
            }
        }
    }
    
    public func dismiss() {
        view.removeFromSuperview()
    }
    
    
    public var body: some View {
        
        HStack(spacing: 14) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            if let message = message {
                Text(message)
            }
        }
        .frame(minWidth: .wzScreenWidth * 0.618, maxWidth: .wzScreenWidth * 0.9, minHeight: 44)
        
        
    }
    
    
}
