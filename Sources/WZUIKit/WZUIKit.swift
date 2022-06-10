import UIKit

public struct WZUIKit {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

public extension UIView {
    
    static func initNib(_ name: String? = nil, owner: Any?) -> Self? {
        let nibName = name == nil ? Self.description() : name!
        return Bundle.module.loadNibNamed(nibName, owner: owner, options: nil)?.first as? Self
    }
    
    
}
