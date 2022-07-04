//
//  WZUIViewController.swift
//  
//
//  Created by mntechMac on 2022/4/1.
//

import UIKit

public protocol WZUIViewControllerUISetting {
    func wzNavNoNeedFitOnHeight() -> CGFloat?
}

///
/// `WZUIViewController`: 项目要使用到的基类，所有`ViewController`继承该类实现统一管理
///
/// 1. 该Controller实现了侧滑返回
/// 2. 自带导航栏
///    - `wzNavgationView`: 导航栏控件，管理导航栏。该导航栏实现了基本的横竖屏，刘海屏的适配
///
open class WZUIViewController: UIViewController {
    
    //open var wzNavNoNeedFitOnHeight: CGFloat? { nil }
    
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

extension WZUIViewController: WZUIViewControllerUISetting {
    public func wzNavNoNeedFitOnHeight() -> CGFloat? {
        return nil
    }
}

open extension WZUIViewController {
    
    func confirmNavigationViewHeight(_ size: CGSize = CGSize(width: .wzScreenWidth, height: .wzScreenHeight)) {
        guard let height = self.wzNavViewHeightConstraint else { return }
        if let fit = wzNavNoNeedFitOnHeight() {
            height.constant = fit
        } else {
            height.constant = .wzStatusOrNavgationBarHeight(statusBarHide: self.prefersStatusBarHidden)
        }
        self.navView.rotate()
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
