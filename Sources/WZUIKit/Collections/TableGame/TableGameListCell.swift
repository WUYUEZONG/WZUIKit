//
//  TableGameListCell.swift
//  
//
//  Created by mntechMac on 2022/4/11.
//

import UIKit

class TableGameListCell: UICollectionViewCell {
    /// 海报图
    @IBOutlet weak var posterImageView: UIImageView!
    /// 评分
    @IBOutlet weak var rateLabel: UILabel!
    /// 标题
    @IBOutlet weak var posterTitle: UILabel!
    /// 版权状态
    @IBOutlet weak var ownerStatus: UIButton!
    /// 标签1
    @IBOutlet weak var tag1: UIButton!
    /// 标签2
    @IBOutlet weak var tag2: UIButton!
    /// 标签3
    @IBOutlet weak var tag3: UIButton!
    /// 标签4
    @IBOutlet weak var tag4: UIButton!
    /// 标签5
    @IBOutlet weak var tag5: UIButton!
    
    /// 不限性别的标识
    @IBOutlet weak var noSexLimit: UIButton!
    /// 女生限制
    @IBOutlet weak var grilLimit: UIButton!
    /// 男生限制
    @IBOutlet weak var boyLimit: UIButton!
    /// 玩家数量
    @IBOutlet weak var playerNum: UIButton!
    /// 游玩时长
    @IBOutlet weak var gameTime: UIButton!
    /// 其他信息: xxx人玩过 | 入门难度
    @IBOutlet weak var otherInfo: UILabel!
    
    /// 价格信息
    @IBOutlet weak var price: UILabel!
    
    /// 组局
    @IBOutlet weak var goPlay: UIButton!
    
    
    var wzContent: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        if let contentView = UIView.initNib(Self.description(), owner: self) {
            self.wzContent = contentView
        } else {
            wzContent = UIView()
        }
        wzContent.frame = bounds
        wzContent.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(wzContent)
    }
    
    
    
    
}
