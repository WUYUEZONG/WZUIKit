//
//  ViewController.swift
//  Example
//
//  Created by mntechMac on 2021/10/8.
//

import UIKit
import WZUIKit

class ViewController: UIViewController {
    
    lazy var testButton: WZUIButton = {
        let btn = WZUIButton()
        btn.wzTitle.text = "This is title"
        btn.wzDetail.text = "here show some detail"
        btn.tintColor = .systemBlue
        return btn
    }()
    
    
    @IBOutlet weak var otherButton: WZUIButton!
    
    var otherButtonStyle = 0
    
    func setupOtherButton() {
        
        var buttonImage = UIImage(named: "switch-button")
        if #available(iOS 13.0, *) {
            buttonImage = UIImage(systemName: "pencil.circle")
        }
        
        
        otherButton.wzImage.image = buttonImage
        
        otherButton.wzTitle.text = "BUTTON TITLE"
        otherButton.wzDetail.text = "here I can set detail of button description."
        
        otherButton.backgroundColor = .systemBlue
        otherButton.layer.cornerRadius = 6
        
        otherButton.imageSize = CGSize(width: 28, height: 28)
        
        otherButton.wzTitle.font = .systemFont(ofSize: 15, weight: .medium)
        
        otherButton.wzTitle.textColor = .white
        otherButton.wzDetail.textColor = .white
        
        otherButton.wzImage.tintColor = .white
        
        otherButton.contentInsertEdge = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        otherButton.addAction { [weak self] sender in
//            let alert = UIAlertController(title: sender.wzTitle.text, message: sender.wzDetail.text, preferredStyle: .alert)
//            let ok = UIAlertAction(title: "Oooook!", style: .default) { action in
//                alert.dismiss(animated: true, completion: nil)
//            }
//            alert.addAction(ok)
//            self.present(alert, animated: true, completion: nil)
            
            switch self?.otherButtonStyle {
            case 0:
                self?.otherButtonStyle = 1
                sender.wzImage.image = nil
                sender.wzImage.isHidden = true
                sender.startLoading()
                
            case 1:
                self?.otherButtonStyle = 2
                sender.wzTitle.text = nil
                
            case 2:
                self?.otherButtonStyle = 3
                sender.wzImage.image = buttonImage
                sender.wzImage.isHidden = false
                sender.wzDetail.text = nil
                
            case 3:
                self?.otherButtonStyle = 4
                sender.wzImage.image = nil
                sender.wzImage.isHidden = true
                sender.wzTitle.text = "BUTTON TITLE"
                
            default:
                self?.otherButtonStyle = 0
                sender.wzImage.image = buttonImage
                sender.wzImage.isHidden = false
                sender.wzTitle.text = "BUTTON TITLE"
                sender.wzDetail.text = "here I can set detail of button description."
                sender.stopLoading()
            }
            
//            if sender.wzImage.image != nil {
//                sender.wzImage.image = nil
//                sender.wzImage.isHidden = true
//            } else if sender.wzTitle.text != nil  {
//                sender.wzTitle.text = nil
//            } else {
//                sender.wzImage.image = buttonImage
//                sender.wzImage.isHidden = false
//                sender.wzTitle.text = "BUTTON TITLE"
//                sender.wzDetail.text = "here I can set detail of button description."
//            }
            
        }
        
        otherButton.wzImageTrailingSpacing = 20
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupOtherButton()
        
        view.addSubview(testButton)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        let x = testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let y = testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([x, y])
        
        var buttonImage = UIImage(named: "switch-button")
        if #available(iOS 13.0, *) {
            buttonImage = UIImage(systemName: "pencil.circle")
        }
        testButton.wzImage.image = buttonImage
        
        testButton.layer.borderColor = UIColor.systemGray.cgColor
        testButton.layer.borderWidth = 1
        testButton.layer.cornerRadius = 6
        
        testButton.addAction { [weak self] button in
            
            let page = PageController()
            
            self?.present(page, animated: true, completion: nil)
            
//            switch button.wzImagePosition {
//            case .head:
//
//                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 14, options: UIView.AnimationOptions.curveEaseInOut) {
//                    button.wzImagePosition = .behind
//                } completion: { f in
//
//                }
//
//            case .behind:
//
//                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 8, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseInOut) {
//                    button.wzImagePosition = .top
//                } completion: { f in
//
//                }
//            case .top:
//
//                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 14, options: UIView.AnimationOptions.curveEaseInOut) {
//                    button.wzImagePosition = .head
//                } completion: { f in
//
//                }
//
//            }
        }
        
        
        
        testButton.contentInsertEdge = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)

        testButton.imageSize = CGSize(width: 28, height: 28)
        
    }


}

