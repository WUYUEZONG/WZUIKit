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
    
    var datas: [String] = ["WZUIHUD", "TableGameVC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        wzNavgationView.wzTitleLabel.text = "WZUIKit"
        wzNavgationView.backgroundColor = .blue
        wzNavgationView.isShowEffect = false
        
        WZUIHUD.shared.configWZUIHUD(isUserInteractionEnabled: true, position: .bottom)
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

            if #available(iOS 13.0, *) {
                WZHUDUI.shared.show(message: "WZHUDUI TIPS !!!", image: UIImage(systemName: "globe.americas.fill"))
            } else {
                WZUIHUD.shared.showMessage("WZHUD消息提示", delay: 5)
            }
            break
        case 1:
            self.navigationController?.show(TableGameVC(), sender: nil)
            break
            
        default:
            break
        }
    }
    
    
    
    
}

class TableGameVC: WZUIViewController {
    
    lazy var flow: UICollectionViewFlowLayout = {
        let f = UICollectionViewFlowLayout()
        f.itemSize = CGSize(width: view.wzWidth, height: TableGameCollectionCell.heightOfCell)
        f.scrollDirection = .vertical
        f.minimumInteritemSpacing = 0
        f.minimumLineSpacing = 0
        return f
    }()
    
    lazy var tb: UICollectionView = {
        
        let b = UICollectionView(frame: view.bounds, collectionViewLayout: flow)
        b.contentInset.top = .wzNavgationBarHeight
        b.dataSource = self
        b.delegate = self
        b.backgroundColor = .wzWhite()
        b.register(TableGameCollectionCell.self, forCellWithReuseIdentifier: TableGameCollectionCell.identifier)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tb)
        
        wzNavgationView.wzBackItem.setTitle("Back", for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tb.frame = view.bounds
    }
    
}

extension TableGameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TableGameCollectionCell.identifier, for: indexPath) as? TableGameCollectionCell
        cell?.dataSource = self
        return cell!
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: .wzScreenWidth, height: TableGameCollectionCell.heightOfCell)
    }
    
}

extension TableGameVC: TableGameCollectionCellDataSource {
    
    func posterImage() -> UIImage {
        UIImage(named: "simple")!
    }
    
    func posterTitle() -> String {
        "Poster NAME"
    }
    
    func tagInfo(at index: Int) -> (icon: UIImage?, title: String?) {
        (UIImage(named: "icon_topic"), "tag\(index)")
    }
    
//    func tagImage(at index: Int) -> UIImage? {
//        UIImage(named: "icon_topic")
//    }
//
//    func tagTitle(at index: Int) -> String? {
//        "tag"
//    }
    
    func scoreOfPoster() -> NSAttributedString {
        NSAttributedString(string: "8.0", attributes: [.font : UIFont.systemFont(ofSize: 10, weight: .bold), .foregroundColor: UIColor.wz333(true)])
    }
    
    func copyrightInfo() -> String? {
        "OWNER"
    }
    
    func iconInfo(at index: Int) -> (icon: UIImage?, title: String) {
        switch index {
        case 0, 1:
            return (UIImage(named: "icon_fmale"), "2人")
        default:
            return (UIImage(named: "icon_time"), "3人")
        }
        
    }
    
    func isNolimitSex() -> Bool {
        false
    }
    
    func priceTitle() -> NSAttributedString {
        NSAttributedString(string: "$108.0", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .bold)])
    }
    
    func goPlayTitle() -> String? {
        "Goooo!"
    }
    
    func themeColor() -> UIColor {
        UIColor(hex: 0xEEC62F)
    }
    
    func otherInfo() -> String {
        "199人玩过 | 宗师难度"
    }
    
    
}
