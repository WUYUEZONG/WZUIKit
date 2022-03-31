//
//  WZUINavgationView.swift
//  
//
//  Created by mntechMac on 2022/3/31.
//

import UIKit


open class WZUINavgationView: UIView {
    
    var contentView: UIView!
    
    /// 默认不隐藏
    public var isShowEffect: Bool = true {
        didSet {
            effectContentView.isHidden = !isShowEffect
        }
    }
    
    /// 背景图片默认隐藏
    @IBOutlet weak var backgroundImageView: UIImageView!
    /// 玻璃蒙版
    @IBOutlet weak var effectContentView: UIVisualEffectView!
    /// 左边默认按钮： 返回按钮
    @IBOutlet weak var backItem: UIButton!
    /// title Label
    @IBOutlet weak var titleLabel: UILabel!
    /// 默认的右边按钮
    @IBOutlet weak var rightItem: UIButton!
    /// 中间 Title Stack
    @IBOutlet weak var centerContentStack: UIStackView!
    /// 布局Stack
    @IBOutlet weak var contentStack: UIStackView!
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        if let contentView = UIView.initNib("WZUINavgationView", owner: self) {
            self.contentView = contentView
        } else {
            contentView = UIView()
        }
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        effectContentView.isHidden = !isShowEffect
    }
    
}

public extension WZUINavgationView {
    
    /// 添加背景图
    func addImage(_ image: UIImage?) {
        effectContentView.isHidden = true
        backgroundImageView.isHidden = image == nil
        backgroundImageView.image = image
    }
    /// 将自定义视图添加到标题处，标题会被隐藏
    func addCustomView(_ view: UIView) {
        titleLabel.isHidden = true
        addWidthCostraint(for: view)
        centerContentStack.addArrangedSubview(view)
    }
    /// 在左边添加 Item
    func addLeftItem(_ view: UIView) {
        addWidthCostraint(for: view)
        contentStack.insertArrangedSubview(view, at: 0)
    }
    /// 在右边添加 Item
    func addRightItem(_ view: UIView) {
        addWidthCostraint(for: view)
        contentStack.addArrangedSubview(view)
    }
    /// 返回按钮
    var wzBackItem: UIButton {
        backItem.isHidden = false
        return backItem
    }
    /// 设置标题
    var wzTitleLabel: UILabel {
        titleLabel.isHidden = false
        return titleLabel
    }
    /// 右边默认按钮
    var wzRightItem: UIButton {
        rightItem.isHidden = false
        return rightItem
    }
    
}


extension WZUINavgationView {
    
    func addWidthCostraint(for view: UIView) {
        if view.frame.width > 0 {
            view.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        }
    }
}
