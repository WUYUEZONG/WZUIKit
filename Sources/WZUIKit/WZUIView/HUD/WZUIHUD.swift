//
//  WZUIHUD.swift
//  
//
//  Created by WUYUEZONG on 2022/4/7.
//

import UIKit

public class WZUIHUD: UIView {
    
    public static var shared = WZUIHUD()
    
    /// contentStack 内边距
    public var padding: CGFloat = 20 {
        didSet {
            stackLeading.constant = padding
            stackTrailing.constant = padding
            stackTop.constant = padding
            stackBottom.constant = padding
        }
    }
    
    
    @IBOutlet weak var stackLeading: NSLayoutConstraint!
    @IBOutlet weak var stackTrailing: NSLayoutConstraint!
    @IBOutlet weak var stackTop: NSLayoutConstraint!
    @IBOutlet weak var stackBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var hudImage: UIImageView!
    @IBOutlet weak var hudText: UILabel!
    
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
        
//        contentView.widthAnchor.constraint(equalToConstant: (CGFloat.wzScreenWidth * 0.88)).isActive = true
        contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.88).isActive = true
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height/2
        contentView.layer.borderColor = UIColor.wzF2.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 2, height: 3)
        contentView.backgroundColor = .wzWhite
        hudText.textColor = .wz666
        activityView.color = .wz666
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
            if !window.subviews.contains(self) {
                self.frame = window.bounds
                self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                window.addSubview(self)
            }
        }
    }
    
    func hideAfterDelay(time: TimeInterval?) {
        if time == nil { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
        self.perform(#selector(dismiss), with: nil, afterDelay: time!)
    }
}

public extension WZUIHUD {
    
    
    func show(message: String? = nil, image: UIImage? = nil, _ delay: TimeInterval? = nil) {
        
        activityView.stopAnimating()
        hudText.text = message
        hudImage.image = image
        hudText.isHidden = message == nil
        hudImage.isHidden = image == nil
        addToWindow()
        hideAfterDelay(time: delay)
    }
    
    func showLoading(message: String? = nil, _ delay: TimeInterval? = nil) {
        hudImage.isHidden = true
        activityView.startAnimating()
        hudText.text = message
        hudText.isHidden = message == nil
        addToWindow()
        hideAfterDelay(time: delay)
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { f in
            self.isHidden = true
        }
    }
    
    func hudStyle(backgroundColor: UIColor = .clear, hudBackgroundColor: UIColor = .white) {
        self.backgroundColor = backgroundColor
        self.contentView.backgroundColor = hudBackgroundColor
    }
    
}
