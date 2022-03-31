//
//  WZUINavgationView.swift
//  
//
//  Created by mntechMac on 2022/3/31.
//

import UIKit


open class WZUINavgationView: UIView {
    
    @IBOutlet public weak var wzTitle: UILabel!
    
    
    public static func initNib() -> WZUINavgationView? {
        return Bundle.module.loadNibNamed("WZUINavgationView", owner: nil)?.first as? WZUINavgationView
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        fatalError("initNib is default desiz")
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        UIButton
    }
    
}
