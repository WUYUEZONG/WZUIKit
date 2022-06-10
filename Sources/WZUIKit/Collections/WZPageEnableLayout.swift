//
//  WZPageEnableLayout.swift
//  
//
//  Created by mntechMac on 2022/6/10.
//

import UIKit

public class WZPageEnableLayout: UICollectionViewFlowLayout {
    
    public override var scrollDirection: UICollectionView.ScrollDirection {
        set {
            super.scrollDirection = .horizontal
        }
        get {
            .horizontal
        }
    }
    
    /// 默认 .fast 使得更快的减速，到达类似 pageEnable的效果
    public var decelerationRate: UIScrollView.DecelerationRate = .fast {
        didSet {
            if decelerationRate == .normal {
                pageEnabe = false
            }
        }
    }
    
    public override func prepare() {
        super.prepare()
        collectionView?.decelerationRate = decelerationRate

    }
    
    public var pageEnabe = false
    
    private var lastPage: Int = 0
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if pageEnabe {
            return pageEnable(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        return likePageEnable(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
}

extension WZPageEnableLayout {
    
    var stepSpace: CGFloat {
        itemSize.width + minimumInteritemSpacing
    }
    
    func likePageEnable(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        // 分页的 width
        let cellWidth = itemSize.width
        let itemSpace = minimumInteritemSpacing
        let proposeX = proposedContentOffset.x
        let leftEdge = collectionView.contentInset.left
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
                if velocity.x > 0.21 {
                    page += 1
                } else if velocity.x < -0.21 {
                    page -= 1
                }
                if page < 0 {
                    page = 0
                }
            }
            
            lastPage = page
        }
        
        var itemCount = page - 1
        if itemCount < 0 {
            itemCount = 0
        }
        /// 目标滚动到的 x
        var targetX: CGFloat = cellWidth * CGFloat(page) + itemSpace * CGFloat(itemCount)
        /// 最大可滚动到的位置
        let maxTarget = collectionView.contentSize.width - cellWidth - collectionView.contentInset.right
        if targetX <= 0 {
            targetX = -leftEdge
        } else if targetX > maxTarget {
            targetX = maxTarget
        }
        
        return CGPoint(x: targetX, y: proposedContentOffset.y)
    }
    
    func pageEnable(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        // 分页的 width
        let cellWidth = itemSize.width
        let itemSpace = minimumInteritemSpacing

        let leftEdge = collectionView.contentInset.left
        /// 预计滚动到的页数
        var page: Int = lastPage
        if velocity.x > 0.21 {
            page += 1
        } else if velocity.x < -0.21 {
            page -= 1
        }
        if page < 0 {
            page = 0
        }
        
        lastPage = page
        
        var itemCount = page - 1
        if itemCount < 0 {
            itemCount = 0
        }
        /// 目标滚动到的 x
        var targetX: CGFloat = cellWidth * CGFloat(page) + itemSpace * CGFloat(itemCount)
        /// 最大可滚动到的位置
        let maxTarget = collectionView.contentSize.width - cellWidth - collectionView.contentInset.right
        if targetX <= 0 {
            targetX = -leftEdge
        } else if targetX > maxTarget {
            targetX = maxTarget
            lastPage = Int((maxTarget - itemSpace * CGFloat(itemCount)) / cellWidth) + 1
        }
        
        return CGPoint(x: targetX, y: proposedContentOffset.y)
    }
    
    
}
