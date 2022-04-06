//
//  NavgationController.swift
//  Example
//
//  Created by WUYUEZONG on 2022/3/31.
//

import UIKit
import WZUIKit

class NavgationController: UIViewController {
    
    @IBOutlet weak var nav1: WZUINavgationView!
    
    @IBOutlet weak var nav64: WZUINavgationView!
    
    @IBOutlet weak var nav44: WZUINavgationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav1.wzTitleLabel.text = "this is 88"
        nav64.wzTitleLabel.text  = "THIS IS THIS IS THIS IS THIS IS THIS IS"
        nav64.isShowEffect = false
        nav64.wzBackItem.setTitle("返回", for: .normal)
        let btn = UIButton()
        btn.setImage(UIImage(named: "switch-button"), for: .normal)
        nav64.addLeftItem(btn)
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        nav64.addRightItem(view)
        
        let view1 = UIView()
        view1.backgroundColor = .red
        view1.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        nav44.addCustomView(view1)
        
        nav44.addImage(UIImage(named: "simple"))
        nav44.wzRightItem.setImage(UIImage(named: "switch-button"), for: .normal)
        nav44.addBackItem(title: "Back", image: nil) { sender in
            print("tapaction ! ! !")
        }
    }
    
}


class WZUIControllerSub: WZUIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wzNavgationView.wzTitleLabel.text = "Title"
        wzNavgationView.addBackItem(title: "Close", image: nil) { [weak self] sender in
            self?.wzPopViewController()
        }
    }
}

class WZUIControllerSub2: WZUIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wzNavgationView.wzTitleLabel.text = "Title"
        wzNavgationView.addBackItem(title: "Back", image: nil) { [weak self] sender in
            self?.wzPopViewController()
        }
//        if #available(iOS 13.0, *) {
//            let barAppearance = UIBarAppearance()
//            barAppearance.configureWithTransparentBackground()
//            self.navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance(barAppearance: barAppearance)
//            self.navigationController?.navigationBar.compactAppearance = UINavigationBarAppearance(barAppearance: barAppearance)
//        } else {
//            // Fallback on earlier versions
//        }
//        self.navigationController?.navigationBar.backgroundColor = .black
    }
    
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
}
