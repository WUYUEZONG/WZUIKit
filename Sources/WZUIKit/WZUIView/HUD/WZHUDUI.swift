//
//  WZHUDUI.swift
//  
//
//  Created by mntechMac on 2022/4/15.
//

import SwiftUI
import UIKit

class UIKitViewController: UIViewController {
    
}

struct UIKitViewControllerPresenter: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIKitViewController()
    }
    
}

class UIKitHostingController: UIHostingController {
    
    override init(rootView: Content) {
        super.init(rootView: rootView)
    }
    
    
}

@available(iOS 13.0.0, *)
public struct WZHUDUI : View {
    
    public static var shared = WZHUDUI()
    
    var message: String?
    
    var image: UIImage?
    
    var viewController: UIHostingController {
        UIHostingController(rootView: self)
    }
    
    public mutating func show(message: String?, image: UIImage?) {
        self.message = message
        self.image = image
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = scene.windows.first {
            keyWindow.rootViewController?.show(viewController, sender: nil)
//            if !keyWindow.subviews.contains(view) {
//                view.frame = keyWindow.bounds
//                keyWindow.addSubview(view)
                
//                view.translatesAutoresizingMaskIntoConstraints = false;
//                view.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
//                view.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
                
//            } else {
//                keyWindow.bringSubviewToFront(view)
//            }
        }
    }
    
    public func dismiss() {
        viewController.dismiss(animated: true)
        viewController.viewWillAppear(true)
    }
    
    
    public var body: some View {
        
        VStack(alignment: .center) {
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
            .background(Color.white)
            .cornerRadius(10)
        }
        .frame(width: .wzScreenWidth, height: .wzScreenHeight)
        .background(Color.green)
        
        
    }
    
    
}
