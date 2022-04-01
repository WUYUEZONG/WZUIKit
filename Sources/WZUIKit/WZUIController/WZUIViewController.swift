//
//  WZUIViewController.swift
//  
//
//  Created by mntechMac on 2022/4/1.
//

import UIKit

open class WZUIViewController: UIViewController {
    
    lazy var wzNavgationView: WZUINavgationView = {
        let view = WZUINavgationView(frame: CGRect(x: 0, y: 0, width: CGFloat.wzScreenWidth, height: CGFloat.wzStatusWithNavgationBarHeight))
        view.addBackItem(title: "Back", image: nil, action: nil)
        self.view.addSubview(view)
        return view
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
}

/// WZUINavgationView
public extension WZUIViewController {
    var navgationView: WZUINavgationView {
        return wzNavgationView
    }
    
    @objc func wzPopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension WZUIViewController: UINavigationControllerDelegate {
    
}

/// 接管 interactivePopGestureRecognizer
extension WZUIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navController = self.navigationController, gestureRecognizer.isEqual(navController.interactivePopGestureRecognizer) {
            return navController.viewControllers.count > 1
        }
        return true
    }
}

extension WZUIViewController {
   
}
