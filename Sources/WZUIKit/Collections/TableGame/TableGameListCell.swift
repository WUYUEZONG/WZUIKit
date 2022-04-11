//
//  TableGameListCell.swift
//  
//
//  Created by mntechMac on 2022/4/11.
//

import UIKit

public protocol TableGameListCellDataSource {
    /// 海报图
    func posterImage() -> UIImage
    ///
    func posterTitle() -> String
    /// tag1...5的图标
    func tagImage(at index: Int) -> UIImage?
    /// tag1...5的标题
    func tagTitle(at index: Int) -> String?
    /// 评分
    func scoreOfPoster() -> NSAttributedString
    /// 版权信息, 返回空则隐藏
    func copyrightInfo() -> String?
    /// 设置剧本基本信息的元组 (图片, 标题)
    ///
    /// 0 女生
    ///
    /// 1 男生
    ///
    /// 2 人数: eg. 5人
    ///
    /// 3 时间: eg. 4小时
    func iconInfo(at index: Int) -> (icon: UIImage?, title: String)
    /// 性别要求
    func isNolimitSex() -> Bool
    /// 价格
    func priceTitle() -> NSAttributedString
    /// 组局
    func goPlayTitle() -> String?
    /// 主题色
    func themeColor() -> UIColor
    /// 其他信息 - 格式:  xxx人玩过 | 入门难度
    func otherInfo() -> String
    
}

open class TableGameListCell: UICollectionViewCell {
    
    /// cell的数据源
    public var dataSource: TableGameListCellDataSource?
    
    /// 海报图
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.layer.borderWidth = 2
            posterImageView.layer.cornerRadius = imageCornerRadius
        }
    }
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
    
    var bottomLine: CALayer = CALayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        if let contentView = UIView.initNib("TableGameListCell", owner: self) {
            self.wzContent = contentView
        } else {
            wzContent = UIView()
        }
        wzContent.frame = bounds
        wzContent.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(wzContent)
        
        bottomLine.backgroundColor = UIColor.wzF2.cgColor
        self.layer.addSublayer(bottomLine)
    }
    
    lazy var tags: [UIButton] = {
        return [tag1, tag2, tag3, tag4, tag5]
    }()
    
    lazy var icons: [UIButton] = {
        return [grilLimit, boyLimit, playerNum, gameTime]
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth: CGFloat = 1
        bottomLine.frame = CGRect(x: posterTitle.wzMinX, y: self.wzHeight - lineWidth, width: self.wzWidth - posterTitle.wzMinX, height: lineWidth)
        
        posterTitle.textColor = .wzDark()
        ownerStatus.backgroundColor = .wzLight
        ownerStatus.setTitleColor(.wzWhite, for: .normal)
        
        otherInfo.textColor = .wz333
        
        goPlay.backgroundColor = .wz333
        
        if let dataSource = dataSource {
            
            goPlay.setTitleColor(dataSource.themeColor(), for: .normal)
            posterImageView.layer.borderColor = dataSource.themeColor().cgColor
            posterImageView.image = dataSource.posterImage()
            rateLabel.backgroundColor = dataSource.themeColor()
            rateLabel.attributedText = dataSource.scoreOfPoster()
            posterTitle.text = dataSource.posterTitle()
            ownerStatus.setTitle(dataSource.copyrightInfo(), for: .normal)
            ownerStatus.isHidden = dataSource.copyrightInfo() == nil
            
            for (index, tag) in tags.enumerated() {
                let title = dataSource.tagTitle(at: index)
                tag.isHidden = title == nil
                tag.tintColor = .wz999
                tag.setTitleColor(.wz999, for: .normal)
                tag.setImage(dataSource.tagImage(at: index), for: .normal)
                tag.setTitle(title, for: .normal)
            }
            
            noSexLimit.isHidden = !dataSource.isNolimitSex()
            grilLimit.isHidden = dataSource.isNolimitSex()
            boyLimit.isHidden = dataSource.isNolimitSex()
            
            noSexLimit.setTitle("不限性别", for: .normal)
            noSexLimit.backgroundColor = dataSource.themeColor().withAlphaComponent(0.1)
            noSexLimit.setTitleColor(dataSource.themeColor(), for: .normal)
            
            for (index, icon) in icons.enumerated() {
                icon.setTitleColor(.wz666, for: .normal)
                icon.setImage(dataSource.iconInfo(at: index).icon, for: .normal)
                icon.setTitle(dataSource.iconInfo(at: index).title, for: .normal)
            }
            
            otherInfo.text = dataSource.otherInfo()
            
            price.attributedText = dataSource.priceTitle()
            
        }
        
        
    }
    
    
    
}


extension TableGameListCell {
    
    var imageCornerRadius: CGFloat { 6 }
}
