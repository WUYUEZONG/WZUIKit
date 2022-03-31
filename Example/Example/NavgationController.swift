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
        nav64.wzTitleLabel.text  = "THIS IS"
        nav64.isShowEffect = false
        nav64.wzBackItem.setTitle("返回", for: .normal)
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        nav64.addRightItem(view)
        
//        let image = UIImageView(image: UIImage(named: "switch-button"))
//        image.contentMode = .scaleAspectFit
//        nav44.addCustomView(image)
        
        let view1 = UIView()
        view1.backgroundColor = .red
        view1.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        nav44.addCustomView(view1)
        
        nav44.addImage(UIImage(named: "simple"))
        
    }
    
}
