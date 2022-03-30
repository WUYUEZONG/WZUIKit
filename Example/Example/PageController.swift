//
//  PageController.swift
//  Example
//
//  Created by mntechMac on 2021/12/1.
//

import UIKit
import WZUIKit

class PageController: WZUIPageController {
    
    var testCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleDataSources = ["1", "22", "333", "4444", "5555", "666666", "7777777", "88888888", "999999999", "10101010101010", "11", "12", "13", "14", "15"]
        
        reloadData(at: 0)//Int(titleDataSources.count / 2))
        
        addTitleRightItem(title: "TSB", image: nil, at: self, action: #selector(testAction))
        
    }
    
    @objc func testAction() {
        
        if testCount > 3 {
            testCount = 0
        }
        
        switch testCount {
        case 0:
            titleDataSources = ["1"]
        case 1:
            titleDataSources = ["1", "2222", "33333333333"]
        case 2:
            titleDataSources = ["55555555555", "44444444", "66666"]
        default:
            break
        }
        reloadData(at: testCount)
        testCount += 1
    }
    
    override func initControllerAtIndex(_ index: Int) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .randomColor(88)
        return vc
    }
    
}
