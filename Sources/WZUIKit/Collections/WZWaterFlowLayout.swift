//
//  WZWaterFlowLayout.swift
//  
//
//  Created by mntechMac on 2022/6/10.
//

import UIKit

@objc public protocol WZWaterFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {
    
    func layoutItemHeight(at indexPath: IndexPath) -> CGFloat
    
    @available(*, unavailable, renamed: "layoutItemHeight(at:)")
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
}

public class WZWaterFlowLayout: UICollectionViewLayout {
    
    public var delegate: WZWaterFlowLayoutDelegate?
    
    public var column: Int = 2 {
        didSet {
            invalidateLayout()
        }
    }
    
    public var columnSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }
    public var rowSpacing: CGFloat = 20 {
        didSet {
            invalidateLayout()
        }
    }
    
    var layoutAttributes: [UICollectionViewLayoutAttributes?] = []
    
    var itemCounts: Int {
        collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    lazy var lastMinMaxys: [CGFloat] = {
        return Array(repeating: 0, count: column)
    }()
    
    public override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView, itemCounts > 0 else { return }
        
        guard let delegate = delegate else { return }
        
        if layoutAttributes.count == 0 {
            layoutAttributes = Array(repeating: nil, count: itemCounts)
        } else {
            layoutAttributes.removeAll(keepingCapacity: true)
        }
        let contentInset = collectionView.contentInset
        let width = (CGFloat.wzScreenWidth - contentInset.left - contentInset.right - columnSpacing * CGFloat(column - 1)) / CGFloat(column)
        
        for index in 0..<itemCounts {
            let indexPath = IndexPath(row: index, section: 0)
            let height = delegate.layoutItemHeight(at: indexPath)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let n = index % column
            var x = CGFloat(n) * (width + columnSpacing)

            var lastMinMaxY = lastMinMaxys[n]
            var col = n
            if lastMinMaxY > 0 {
                lastMinMaxY =  lastMinMaxys.min() ?? 0
                col = lastMinMaxys.firstIndex(of: lastMinMaxY) ?? n
                x = CGFloat(col) * (width + columnSpacing)
            }
            
            
            let y = lastMinMaxY + rowSpacing
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            lastMinMaxys[col] = y + height
            layoutAttributes[index] = attributes
        }
        
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let layoutAttributes = layoutAttributes as? [UICollectionViewLayoutAttributes] else { return super.layoutAttributesForElements(in: rect) }
        
        let rectAttributes = layoutAttributes.filter{ rect.intersects($0.frame) }
//        debugPrint("layoutAttributesForElements offset: \(collectionView?.contentOffset.y)")
//        let rectCenterX = rect.origin.y + rect.self.height / 2
//        let y = collectionView?.contentOffset.y ?? 0
//        let half = (collectionView?.wzHeight ?? 0) / 2
//        let rectCenterX = y + half
//        for attribute in rectAttributes {
//            let attributeFrameX = attribute.frame.minY + attribute.frame.height / 2
//            var scale = abs(attributeFrameX - rectCenterX) / (.wzScreenHeight / 2)
//            if scale > 1 {
//                scale = 1
//            } else if scale < 0.8 {
//                scale = 0.8
//            }
//            attribute.transform = CGAffineTransform(scaleX: 1, y: scale)
//        }
        return rectAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let rect = collectionView

        let attribute = layoutAttributes[indexPath.row]

        return attribute
    }
    
    public override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let contentInset = collectionView.contentInset
        let height = contentInset.top + contentInset.bottom + (lastMinMaxys.max() ?? 0)
        let width = collectionView.wzWidth - contentInset.left - contentInset.right
        return CGSize(width: width, height: height)
    }
    
    
}
