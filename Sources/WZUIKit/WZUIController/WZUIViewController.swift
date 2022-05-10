//
//  WZUIViewController.swift
//  
//
//  Created by mntechMac on 2022/4/1.
//

import UIKit

open class WZUIViewController: UIViewController {
    
    var wzNavViewHeightConstraint: NSLayoutConstraint?
    
    lazy var navView: WZUINavgationView = {
        let view = WZUINavgationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        wzNavViewHeightConstraint = view.heightAnchor.constraint(equalToConstant: .wzStatusWithNavgationBarHeight)
        wzNavViewHeightConstraint!.isActive = true
        return view
    }()
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .wzF8()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navView.addBackItem(title: nil, image: nil) { _ in
            self.wzPopViewController()
        }
//        self.navView.backItem.isHidden = true
    }
    
    
}

/// WZUINavgationView
public extension WZUIViewController {
    var wzNavgationView: WZUINavgationView {
        return navView
    }
    
    @objc func wzPopViewController() {
        
        if self.navigationController == nil || self.navigationController!.viewControllers.count <= 1 {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController!.popViewController(animated: true)
        }
    }
}

extension WZUIViewController: UINavigationControllerDelegate {
    
}

/// 接管 interactivePopGestureRecognizer
extension WZUIViewController: UIGestureRecognizerDelegate {
    /// rootController 时拦截 interactivePopGestureRecognizer
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navController = self.navigationController, gestureRecognizer.isEqual(navController.interactivePopGestureRecognizer) {
            return navController.viewControllers.count > 1
        }
        return true
    }
}

extension WZUIViewController {
    
    func confirmNavigationViewHeight(_ size: CGSize = CGSize(width: .wzScreenWidth, height: .wzScreenHeight)) {
        if let height = self.wzNavViewHeightConstraint {
            height.constant = .wzStatusOrNavgationBarHeight(statusBarHide: self.prefersStatusBarHidden)
            self.navView.rotate()
        }
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        confirmNavigationViewHeight()
        view.bringSubviewToFront(navView)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        confirmNavigationViewHeight(size)
    }
    
    
    
   
}
