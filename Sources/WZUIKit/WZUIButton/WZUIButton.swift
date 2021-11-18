//
//  WZUIButton.swift
//  
//
//  Created by mntechMac on 2021/10/8.
//

import UIKit
/// no need set the width and height. it is auto size. you can set `contentInsertEdge` to resize the size.
open class WZUIButton: UIView {
    
    
    // MARK: - action -
    
    var wzAction: ((WZUIButton)->())?
    
    // MARK: - custom properties -
    
    /// set image to title spacing default is 10.
    public var wzImageTrailingSpacing: CGFloat = 10 {
        didSet {
            contentStack.spacing = wzImageTrailingSpacing
        }
    }
    
    /// set image position with `WZUIButton.ImagePosition`
    public var wzImagePosition: WZUIButton.ImagePosition = .head {
        didSet {
            
            if oldValue != wzImagePosition {
                contentStackSettings()
            }
        }
    }
    
    func contentStackSettings() {
        
        tapEffectLayer.frame = bounds
        
        contentStack.spacing = wzImageTrailingSpacing
        
        wzImage.isHidden = wzImage.image == nil
        
        contentStack.insertArrangedSubview(wzImage, at: wzImagePosition == .behind ? 1 : 0)
        contentStack.axis = wzImagePosition == .top ? .vertical : .horizontal
        
        textContentStack.isHidden = wzTitle.text == nil && wzDetail.text == nil
        
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
        
        
    }
    
    /// set content Inset Edge default is (4, 10, 4, 10)
    public var contentInsertEdge: UIEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10) {
        didSet {
            contentStackLeading.constant = contentInsertEdge.left
            contentStackTop.constant = contentInsertEdge.top
            contentStackTrailing.constant = -contentInsertEdge.right
            contentStackBottom.constant = -contentInsertEdge.bottom
            
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
        if #available(iOS 13.0, *) {
            title.textColor = .label
        } else {
            title.textColor = .darkText
        }
        textContentStack.insertArrangedSubview(title, at: 0)
        return title
    }()
    
    /// more detail of button for description
    public lazy var wzDetail: UILabel = {
        let detail = UILabel()
        detail.font = .systemFont(ofSize: 12, weight: .light)
        detail.textColor = .lightGray
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
        contentStackTrailing = contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsertEdge.right)
        contentStackBottom = contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsertEdge.bottom)
        
        NSLayoutConstraint.activate([contentStackLeading, contentStackTop, contentStackTrailing, contentStackBottom])
        
        
        
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
}


public extension WZUIButton {
    
    /// add an action for button
    func addAction(_ action:@escaping (WZUIButton)->()) {
        wzAction = action
    }
    
}
