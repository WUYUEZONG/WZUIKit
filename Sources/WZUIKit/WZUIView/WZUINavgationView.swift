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
            if isShowEffect {
                backgroundImageView.isHidden = true
            }
        }
    }
    
    /// 返回按钮事件Block
    var wzBackActionBlock: ((UIButton)->())?
    /// 右边按钮事件Block
    var wzRightActionBlock: ((UIButton)->())?
    
    @IBOutlet weak var contentStackLeading: NSLayoutConstraint!
    
    @IBOutlet weak var contentStackTrailing: NSLayoutConstraint!
    
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
        
        rotate(to: CGFloat.wzScreenWidth < CGFloat.wzScreenHeight)
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
        contentStack.insertArrangedSubview(view, at: 1)
    }
    /// 在右边添加 Item
    func addRightItem(_ view: UIView) {
        addWidthCostraint(for: view)
        contentStack.addArrangedSubview(view)
    }
    /// 添加返回按钮的点击事件
    ///
    /// 或者通过addTarget(_,action:,for)添加事件
    func addBackItem(title: String?, image: UIImage?, action:((UIButton)->())?) {
        wzBackItem.setTitle(title, for: .normal)
        wzBackItem.setImage(image, for: .normal)
        wzBackActionBlock = action
        wzBackItem.addTarget(self, action: #selector(wzBackAction), for: .touchUpInside)
    }
    /// 添加右边按钮的点击事件
    ///
    /// 或者通过addTarget(_,action:,for)添加事件
    func addRightItem(title: String?, image: UIImage?, action:((UIButton)->())?) {
        wzRightItem.setTitle(title, for: .normal)
        wzRightItem.setImage(image, for: .normal)
        wzRightActionBlock = action
        wzRightItem.addTarget(self, action: #selector(wzRightAction), for: .touchUpInside)
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
    /// 屏幕旋转时调用
    func rotate(to portrait: Bool) {
        // 竖直或横屏，屏幕状态下左右间距调整
        contentStackLeading.constant = portrait || CGFloat.standardStatusBarHeight <= 20 ? 0 : .wzNavgationBarHeight
    }
    
}


extension WZUINavgationView {
    
    func addWidthCostraint(for view: UIView) {
        if view.frame.width > 0 {
            view.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        }
    }
    
    @objc func wzBackAction() {
        self.wzBackActionBlock?(self.backItem)
    }
    @objc func wzRightAction() {
        self.wzRightActionBlock?(self.rightItem)
    }
}
