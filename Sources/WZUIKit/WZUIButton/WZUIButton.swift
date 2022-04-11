//
//  WZUIButton.swift
//  
//
//  Created by mntechMac on 2021/10/8.
//

import UIKit

/// no need set the width and height. it is auto size. you can set `contentInsertEdge` to resize the size.
///
/// `wzAction` 添加事件
///
/// `wzImagePosition` 设置图片位置
///
/// `wzContentPosition` 设置内容对齐位置
///
/// `wzImageTrailingSpacing` 图片右边与文字的间距
///
/// `contentInsertEdge` 内容的内间距
///
open class WZUIButton: UIView {
    
    
    // MARK: - action -
    /// 添加事件
    var wzAction: ((WZUIButton)->())?
    
    // MARK: - custom properties -
    
    /// set image to title spacing default is 10.
    public var wzImageTrailingSpacing: CGFloat = 10 {
        didSet {
            contentStack.spacing = wzImageTrailingSpacing
        }
    }
    
    public var wzContentPosition: WZUIButton.ContentPosition = .center {
        didSet {
            
            contentStackSettings()
            
        }
    }
    
    /// set image position with `WZUIButton.ImagePosition`
    public var wzImagePosition: WZUIButton.ImagePosition = .head {
        didSet {
            
            contentStackSettings()
            
        }
    }
    // MARK: - contentStackSettings -
    func contentStackSettings() {
        
        tapEffectLayer.frame = bounds
        
        contentStack.spacing = wzImageTrailingSpacing
        
        wzImage.isHidden = wzImage.image == nil
        
        contentStack.insertArrangedSubview(wzImage, at: wzImagePosition == .behind ? 1 : 0)
        
        wzTitle.isHidden = wzTitle.text == nil || wzTitle.text!.isEmpty
        wzDetail.isHidden = wzDetail.text == nil || wzDetail.text!.isEmpty
        
        textContentStack.isHidden = wzTitle.isHidden && wzDetail.isHidden
        
        contentStack.axis = wzImagePosition == .top ? .vertical : .horizontal
        
        switch wzImagePosition {
        case .head:
            wzTitle.textAlignment = .left
            wzDetail.textAlignment = .left
        case .behind:
            wzTitle.textAlignment = .right
            wzDetail.textAlignment = .right
        case .top:
            wzTitle.textAlignment = .center
            wzDetail.textAlignment = .center
        }
        
        constraints.forEach { constraint in
            if let item = constraint.firstItem, item.isEqual(self), constraint.secondItem == nil {
                
                /// 设置过高度
                if constraint.firstAttribute == .height {
                    let shouldAllowThisHeight = constraint.constant >= (imageSize.height + contentInsertEdge.top + contentInsertEdge.bottom)
                    contentStackTop.isActive = !shouldAllowThisHeight
                    contentStackBottom.isActive = !shouldAllowThisHeight
                    constraint.isActive = shouldAllowThisHeight
                }
                
                /// 设置过宽度
                if constraint.firstAttribute == .width {
                    let shouldAllowThisWidth = constraint.constant >= (imageSize.width + contentInsertEdge.left + contentInsertEdge.right + wzImageTrailingSpacing)
                    contentStackLeading.isActive = wzContentPosition == .leading || !shouldAllowThisWidth
                    contentStackTrailing.isActive = wzContentPosition == .trailing || !shouldAllowThisWidth
                    constraint.isActive = shouldAllowThisWidth
                }
                
            }
        }
        
        
    }
    
    /// set content Inset Edge default is (4, 10, 4, 10)
    public var contentInsertEdge: UIEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10) {
        didSet {
            contentStackLeading.constant = contentInsertEdge.left
            contentStackTop.constant = contentInsertEdge.top
            contentStackTrailing.constant = contentInsertEdge.right
            contentStackBottom.constant = contentInsertEdge.bottom
            
            greaterContentStackLeading.constant = contentInsertEdge.left
            greaterContentStackTop.constant = contentInsertEdge.top
            greaterContentStackTrailing.constant = contentInsertEdge.right
            greaterContentStackBottom.constant = contentInsertEdge.bottom
            
        }
    }
    
    /// to set  the `wzImage` size
    public var imageSize: CGSize = CGSize(width: 26, height: 26) {
        didSet {
            
            wzImageWidth?.constant = imageSize.width
            wzImageHeight?.constant = imageSize.height
            
        }
    }
    
    var wzImageWidth: NSLayoutConstraint?
    var wzImageHeight: NSLayoutConstraint?
    
    
    lazy var contentStack: UIStackView = {
        let content = UIStackView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.spacing = 10
        content.alignment = .center
        return content
    }()
    
    var contentStackLeading: NSLayoutConstraint!
    var contentStackTop: NSLayoutConstraint!
    var contentStackTrailing: NSLayoutConstraint!
    var contentStackBottom: NSLayoutConstraint!
    
    var greaterContentStackLeading: NSLayoutConstraint!
    var greaterContentStackTop: NSLayoutConstraint!
    var greaterContentStackTrailing: NSLayoutConstraint!
    var greaterContentStackBottom: NSLayoutConstraint!
    
    /// image of button aligment with title and detail
    public lazy var wzImage: UIImageView = {
        let image = UIImageView()
        contentStack.addArrangedSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        wzImageWidth = image.widthAnchor.constraint(equalToConstant: imageSize.width)
        wzImageHeight = image.heightAnchor.constraint(equalToConstant: imageSize.height)
        NSLayoutConstraint.activate([wzImageWidth!, wzImageHeight!])
        return image
    }()
    
    /// the title of button
    public lazy var wzTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 15, weight: .bold)
        title.textColor = .wzDark()
        textContentStack.insertArrangedSubview(title, at: 0)
        return title
    }()
    
    /// more detail of button for description
    public lazy var wzDetail: UILabel = {
        let detail = UILabel()
        detail.font = .systemFont(ofSize: 12, weight: .light)
        detail.textColor = .wz999()
        textContentStack.addArrangedSubview(detail)
        return detail
    }()
    
    /// stack of title or detail
    lazy var textContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        contentStack.addArrangedSubview(stack)
        return stack
    }()
    
    
    // MARK: - interal properties -
    
    lazy var loadingView: UIActivityIndicatorView = {
        let style: UIActivityIndicatorView.Style!
        if #available(iOS 13, *) {
            style = UIActivityIndicatorView.Style.medium
        } else {
            style = UIActivityIndicatorView.Style.white
        }
        let view = UIActivityIndicatorView(style: style)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        return view
    }()

    var lastStyleTuple: (backgroundColor: UIColor?, titleColor: UIColor?, detailColor: UIColor?, boardColor: CGColor?, imageTint: UIColor)?
    
    lazy var tapEffectLayer: CALayer = {
        let view = CALayer()
        view.backgroundColor = UIColor(white: 0, alpha: 0).cgColor
        view.isHidden = true
        return view
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initUI()
    }
    
    func initUI() {
        
        self.clipsToBounds = true
        
        layer.addSublayer(tapEffectLayer)
        
        addSubview(contentStack)
        
        contentStackLeading = contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsertEdge.left)
        contentStackTop = contentStack.topAnchor.constraint(equalTo: topAnchor, constant: contentInsertEdge.top)
        contentStackTrailing = trailingAnchor.constraint(equalTo: contentStack.trailingAnchor, constant: contentInsertEdge.right)
        contentStackBottom = bottomAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: contentInsertEdge.bottom)
        
        greaterContentStackLeading = contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: contentInsertEdge.left)
        greaterContentStackTop = contentStack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: contentInsertEdge.top)
        greaterContentStackTrailing = trailingAnchor.constraint(greaterThanOrEqualTo: contentStack.trailingAnchor, constant: contentInsertEdge.right)
        greaterContentStackBottom = bottomAnchor.constraint(greaterThanOrEqualTo: contentStack.bottomAnchor, constant: contentInsertEdge.bottom)
        
        contentStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        greaterContentStackLeading.isActive = true
        greaterContentStackTop.isActive = true
        greaterContentStackTrailing.isActive = true
        greaterContentStackBottom.isActive = true
        
        contentStackLeading.isActive = true
        contentStackTop.isActive = true
        contentStackTrailing.isActive = true
        contentStackBottom.isActive = true
 
        
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentStackSettings()
        
    }
    
    // MARK: - actions -
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        tapEffectLayer.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.tapEffectLayer.backgroundColor = UIColor(white: 0, alpha: 0.2).cgColor
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
    }
    
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let first = touches.first {
            let location = first.location(in: self)
            if location.x < 0 || location.x > frame.width || location.y < 0 || location.y > frame.height {
                debugPrint("out of view")
            } else {
                wzAction?(self)
            }
        }
        tapEffectLayer.isHidden = true
    }
    
}


/// image arranged
public extension WZUIButton {
    enum ImagePosition {
        /// image at first
        case head
        /// image at behind
        case behind
        /// image on top
        case top
    }
    
    enum ContentPosition {
        
        case center
        
        case leading
        
        case trailing
    }
}


public extension WZUIButton {
    
    /// add an action for button
    func addAction(_ action:@escaping (WZUIButton)->()) {
        wzAction = action
    }
    
    func startLoading() {
        isUserInteractionEnabled = false
        lastStyleTuple = (backgroundColor, wzTitle.textColor, wzDetail.textColor, layer.borderColor, wzImage.tintColor)
        backgroundColor = .wzF2
        wzTitle.textColor = .wzExtraLight
        wzDetail.textColor = .wzExtraLight
        layer.borderColor = UIColor.clear.cgColor
        wzImage.tintColor = .wzExtraLight
        loadingView.color = .wz666
        loadingView.startAnimating()
    }
    
    func stopLoading() {
        isUserInteractionEnabled = true
        loadingView.stopAnimating()
        backgroundColor = lastStyleTuple?.backgroundColor
        wzTitle.textColor = lastStyleTuple?.titleColor
        wzDetail.textColor = lastStyleTuple?.detailColor
        layer.borderColor = lastStyleTuple?.boardColor
        wzImage.tintColor = lastStyleTuple?.imageTint
    }
    
}

// MARK: Constraint actions
extension WZUIButton {
    func turnWidthHeightConstraint(off: Bool) {
        constraints.forEach { constraint in
            if let item = constraint.firstItem, item.isEqual(self), constraint.secondItem == nil {
                if constraint.firstAttribute == .height || constraint.firstAttribute == .width {
                    constraint.isActive = !off
                }
            }
        }
    }
}
