//
//  WZWaterFlowLayout.swift
//  
//
//  Created by mntechMac on 2022/6/10.
//

import UIKit

public protocol WZWaterFlowLayoutDelegate {
    /// 返回对应`indexPath`的高度
    func layoutItemHeight(at indexPath: IndexPath) -> CGFloat
    
}
/// 瀑布流
///
/// 1. 不支持多section，所以collection的section只能等于1
///
/// 2. 暂不支持 section header / footer
///
/// 3. 实现 `delegate: WZWaterFlowLayoutDelegate` 返回对应高度即可
///
/// 
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
    public var rowSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }
    
    var layoutAttributes: [UICollectionViewLayoutAttributes?] = []
    
    var itemCounts: Int {
        collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    /// 记录当所有列的 最大y坐标
    lazy var lastMinMaxys: [CGFloat] = {
        return Array(repeating: 0, count: column)
    }()
    
    public override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView, itemCounts > 0 else { return }
        
        guard let delegate = delegate else { return }
        
        /// 一次性申请全部内存
        layoutAttributes = Array(repeating: nil, count: itemCounts)
        
        let contentInset = collectionView.contentInset
        ///  根据列间距和列数获取item的宽度
        let width = (collectionView.wzWidth - contentInset.left - contentInset.right - columnSpacing * CGFloat(column - 1)) / CGFloat(column)
        /// 计算全部item的 `attributes.frame`
        for index in 0..<itemCounts {
            let indexPath = IndexPath(row: index, section: 0)
            let height = delegate.layoutItemHeight(at: indexPath)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            /// n = 当前列
            let n = index % column
            /// 确定item的 `attributes.frame..x`
            var x = CGFloat(n) * (width + columnSpacing)

            var lastMinMaxY = lastMinMaxys[n]
            var col = n
            // 为了底部能尽量对齐，不考虑这个，可以注释这段代码 --- start
            if lastMinMaxY > 0 {
                // 找到最后一列的最短y坐标
                lastMinMaxys.enumerated().forEach { e in
                    let index = e.offset.self, y = e.element.self
                    if lastMinMaxY > y {
                        lastMinMaxY = y
                        col = index
                    }
                }
                x = CGFloat(col) * (width + columnSpacing)
            }
            // 为了底部能尽量对齐，不考虑这个，可以注释这段代码 --- end
            /// 确定item的 `attributes.frame..y`
            let y = lastMinMaxY + rowSpacing
            attributes.frame = CGRect(x: x, y: y, width: width, height: height)
            // 记录当前列的 最大y坐标
            lastMinMaxys[col] = y + height
            /// 存储 `attributes.frame`
            layoutAttributes[index] = attributes
        }
        
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let layoutAttributes = layoutAttributes as? [UICollectionViewLayoutAttributes] else { return super.layoutAttributesForElements(in: rect) }
        
        let rectAttributes = layoutAttributes.filter{ rect.intersects($0.frame) }
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
        let height = lastMinMaxys.max() ?? 0
        let width = collectionView.wzWidth - contentInset.left - contentInset.right
        return CGSize(width: width, height: height)
    }
    
    
}
