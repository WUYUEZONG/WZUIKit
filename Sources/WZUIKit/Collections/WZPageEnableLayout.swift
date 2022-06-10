//
//  WZPageEnableLayout.swift
//  
//
//  Created by mntechMac on 2022/6/10.
//

import UIKit

public class WZPageEnableLayout : WZAlignFlowLayout {
    
    /// no need to set this property.
    final public override var decelerationRate: UIScrollView.DecelerationRate {
        set {
            super.decelerationRate = .fast
        }
        get {
            .fast
        }
    }
}


public class WZAlignFlowLayout: UICollectionViewFlowLayout {
    
    public enum Align {
        /// cell 靠左对齐 |-spacing-cell ... |
        ///
        /// 默认 `spacing` = .leftEdgeInset
        case leading(spacing: CGFloat? = nil)
        /// cell 中间对齐 ｜... cell ... |
        case center
    }
    /// 滚动到目标的对齐方式
    public var targetAlign: Align = .center
    
    /// 默认 .fast 使得更快的减速，到达类似 pageEnable 的效果
    /// .normal 不会有 pageEnable 的效果， 但可以快速滑动
    public var decelerationRate: UIScrollView.DecelerationRate = .fast {
        didSet {
            collectionView?.decelerationRate = decelerationRate
        }
    }
    
    public override func prepare() {
        super.prepare()
        collectionView?.decelerationRate = decelerationRate

    }
    
    /// test, not open
    private var pageEnabe = false
    
    private var lastPage: Int = 0
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if pageEnabe {
            return pageEnable(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        return likePageEnable(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
}

extension WZAlignFlowLayout {
    
    func targetOffset(width: CGFloat, page: Int, itemSpace: CGFloat) -> CGFloat {
        
        var target: CGFloat = 0
        var itemCount = page - 1
        if itemCount < 0 {
            itemCount = 0
        }
        switch targetAlign {
        case .leading(let spacing):
            let spacing: CGFloat = spacing ?? collectionView!.contentInset.left
            target = (width + itemSpace) * CGFloat(page) - spacing
        case .center:
            let halfLength = scrollDirection == .horizontal ? collectionView!.wzWidth / 2 : collectionView!.wzHeight / 2
            target = (width + itemSpace) * CGFloat(page) + width / 2 - halfLength
        }
        let isHorizontal = scrollDirection == .horizontal
        let leftEdge = isHorizontal ? collectionView!.contentInset.left : collectionView!.contentInset.top
        /// 最大可滚动到的位置
        let maxContentLength = isHorizontal ? collectionView!.contentSize.width : collectionView!.contentSize.height
        let endSideEdge = isHorizontal ? collectionView!.contentInset.right : collectionView!.contentInset.bottom
        let maxTarget = maxContentLength - width - endSideEdge
        if target <= 0 {
            target = -leftEdge
        } else if target > maxTarget {
            target = maxTarget
            lastPage = Int((maxTarget - itemSpace * CGFloat(itemCount)) / width) + 1
        }
        return target
    }
    
    func likePageEnable(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard collectionView != nil else { return proposedContentOffset }
        
        let isHorizontal = scrollDirection == .horizontal
        // 分页的 width
        let cellWidth = isHorizontal ? itemSize.width : itemSize.height
        let itemSpace = isHorizontal ? minimumLineSpacing : minimumInteritemSpacing
        let proposeX = isHorizontal ? proposedContentOffset.x : proposedContentOffset.y
        
        /// 除去特例的 第0页 之后的剩余
        let calProposeX = proposeX - (cellWidth / 2)
        
        /// 预计滚动到的页数
        var page: Int = 0
        /// 大于0 表示需要滚动到第二个cell
        if calProposeX > 0 {
            /// 0被特殊处理所以默认 +1
            page = Int(calProposeX / (cellWidth + itemSpace)) + 1
        }
        
        if decelerationRate == .fast {
            if lastPage == page {
                velocityTo(velocity: velocity, page: &page)
            }
            lastPage = page
        }
        /// 目标滚动到的 x
        let target: CGFloat = targetOffset(width: cellWidth, page: page, itemSpace: itemSpace)
        return isHorizontal ? CGPoint(x: target, y: proposedContentOffset.y) : CGPoint(x: proposedContentOffset.x, y: target)
    }
    
    func pageEnable(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
       
        guard collectionView != nil else { return proposedContentOffset }
        
        let isHorizontal = scrollDirection == .horizontal
        // 分页的 width
        let cellWidth = isHorizontal ? itemSize.width : itemSize.height
        let itemSpace = isHorizontal ? minimumLineSpacing : minimumInteritemSpacing
        /// 预计滚动到的页数
        var page: Int = lastPage
        velocityTo(velocity: velocity, page: &page)
        lastPage = page
        
        /// 目标滚动到的 x
        let target: CGFloat = targetOffset(width: cellWidth, page: page, itemSpace: itemSpace)
        return isHorizontal ? CGPoint(x: target, y: proposedContentOffset.y) : CGPoint(x: proposedContentOffset.x, y: target)
    }
    
    func velocityTo(velocity: CGPoint, page: inout Int) {
        let vP = scrollDirection == .horizontal ? velocity.x : velocity.y
        if vP > 0.21 {
            page += 1
        } else if vP < -0.21 {
            page -= 1
        }
        if page < 0 {
            page = 0
        }
    }
    
    
}
