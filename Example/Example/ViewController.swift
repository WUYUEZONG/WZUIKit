//
//  ViewController.swift
//  Example
//
//  Created by mntechMac on 2021/10/8.
//

import UIKit
import WZUIKit

class ViewController: WZUIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.contentInset.top = .wzNavgationBarHeight
            if #available(iOS 13.0, *) {
                tableView.automaticallyAdjustsScrollIndicatorInsets = false
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
        }
    }
    
    var datas: [String] = ["WZUIHUD"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        wzNavgationView.wzTitleLabel.text = "WZUIKit"
        wzNavgationView.backgroundColor = .blue
        wzNavgationView.isShowEffect = false
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        if #available(iOS 14.0, *) {
            var config = UIListContentConfiguration.subtitleCell()
            config.text = datas[indexPath.row]
            cell.contentConfiguration = config
        } else {
            // Fallback on earlier versions
            cell.textLabel?.text = datas[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            WZUIHUD.shared.showMessage("1234", delay: 5)
            break
        case 1:
            
            break
            
        default:
            break
        }
    }
    
    
    
    
}

