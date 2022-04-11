//
//  WZUIHUD.swift
//  
//
//  Created by WUYUEZONG on 2022/4/7.
//

import UIKit

public class WZUIHUD: UIView {
    
    public enum Position {
        case top
        case center
        case bottom
    }
    
    public static var shared = WZUIHUD()
    
    /// contentStack 内边距
//    public var padding: CGFloat = 15 {
//        didSet {
//            stackLeading.constant = padding
//            stackTrailing.constant = padding
////            stackTop.constant = padding
////            stackBottom.constant = padding
//        }
//    }
    
    
    @IBOutlet weak var stackLeading: NSLayoutConstraint!
    @IBOutlet weak var stackTrailing: NSLayoutConstraint!
    @IBOutlet weak var stackTop: NSLayoutConstraint!
    @IBOutlet weak var stackBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var hudImage: UIImageView!
    @IBOutlet weak var hudText: UILabel!
    
    var contentTopConstraint: NSLayoutConstraint!
    var contentBottomConstraint: NSLayoutConstraint!
    var contentCenterConstraint: NSLayoutConstraint!
    
    var position: Position = .bottom {
        didSet {
            
            contentTopConstraint.isActive = position == .top
            contentCenterConstraint.isActive = position == .center
            contentBottomConstraint.isActive = position == .bottom
            
            let statusH = CGFloat.wzStatusBarHeightWithCamInScreen()
            let controlH = CGFloat.wzControlBarHeight
            contentTopConstraint.constant = statusH > 0 ? statusH : 20.0
            contentBottomConstraint.constant = controlH > 0 ? controlH : 20.0
            
        }
    }
    
    /// hud
    var contentView: UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        
        
        
        if let contentView = UIView.initNib("WZUIHUD", owner: self) {
            self.contentView = contentView
        } else {
            contentView = UIView()
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        contentView.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.618).isActive = true
        contentView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.9).isActive = true
//        contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.618).isActive = true
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentCenterConstraint = contentView.centerYAnchor.constraint(equalTo: centerYAnchor)
        contentTopConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        contentBottomConstraint = bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = contentView.frame.height/2
//        let shadow =
        let path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: cornerRadius)
        
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.borderColor = UIColor.wzExtraLight.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowColor = UIColor.wzBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 2, height: 3)
        contentView.layer.shadowPath = path.cgPath
        contentView.backgroundColor = .wzWhite(alpha: 0.96)
        hudText.textColor = .wz333
        activityView.color = .wz333
    }
}

extension WZUIHUD {
    func addToWindow() {
        self.isHidden = false
        self.alpha = 1
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = scene.windows.first {
                window = keyWindow
            }
        } else {
            if let kWindow = UIApplication.shared.keyWindow {
                window = kWindow
            }
        }
        
        if let window = window {
            let p = position
            self.position = p
            if !window.subviews.contains(self) {
                self.frame = window.bounds
                self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                window.addSubview(self)
            } else {
                window.bringSubviewToFront(self)
            }
        }
    }
    
    func hideAfterDelay(time: TimeInterval?) {
        if time == nil { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
        self.perform(#selector(dismiss), with: nil, afterDelay: time!)
    }
    
    func wzShow(message: String? = nil, image: UIImage? = nil, loading: Bool = false, delay: TimeInterval? = nil) {
        
        if loading {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
        hudText.text = message
        hudImage.image = image
        hudText.isHidden = message == nil
        hudImage.isHidden = image == nil
        hudText.textAlignment = (loading || image != nil) ? .natural : .center
        addToWindow()
        hideAfterDelay(time: delay)
    }
}

public extension WZUIHUD {
    /// 展示文本信息 + 图片
    func show(message: String? = nil, image: UIImage?) {
        wzShow(message: message, image: image, loading: false, delay: nil)
    }
    /// 展示文本信息 + loading
    func showLoading(message: String? = nil, delay: TimeInterval? = nil) {
        wzShow(message: message, image: nil, loading: true, delay: delay)
    }
    /// 只展示文本信息
    func showMessage(_ message: String, delay: TimeInterval? = nil) {
        wzShow(message: message, image: nil, loading: false, delay: delay)
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { f in
            self.isHidden = true
        }
    }
}

public extension WZUIHUD {
    
    /// 点击事件是否可穿透, 显示位置等...
    func configWZUIHUD(isUserInteractionEnabled: Bool = true, position: Position = .bottom) {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.position = position
    }
}
