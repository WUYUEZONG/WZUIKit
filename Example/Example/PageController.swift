//
//  PageController.swift
//  Example
//
//  Created by mntechMac on 2021/12/1.
//

import UIKit
import WZUIKit

class PageController: WZUIPageController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleDataSources = ["1", "2", "3", "4", "5", "666666", "7777777", "88888888", "9", "10", "11", "12", "13", "14", "15"]
        
        reloadData(at: 0)//Int(titleDataSources.count / 2))
        
        addTitleRightItem(with: "TSB", with: nil, at: self, with: #selector(testAction))
        
    }
    
    @objc func testAction() {
        debugPrint(#function)
    }
    
}
