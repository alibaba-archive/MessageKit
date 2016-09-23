//
//  MessageViewController+scrolling.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum CellVerticalEdge {
    case top
    case bottom
}

extension CGFloat {
    static let bmaEpsilon: CGFloat = 0.001
}

extension MessageViewController {

    public func isScrolledAtBottom() -> Bool {
        guard self.collectionView.numberOfSections > 0 && self.collectionView.numberOfItems(inSection: 0) > 0 else { return true }
        let sectionIndex = self.collectionView.numberOfSections - 1
        let itemIndex = self.collectionView.numberOfItems(inSection: sectionIndex) - 1
        let lastIndexPath = IndexPath(item: itemIndex, section: sectionIndex)
        return self.isIndexPathVisible(lastIndexPath, atEdge: .bottom)
    }

    public func isScrolledAtTop() -> Bool {
        guard self.collectionView.numberOfSections > 0 && self.collectionView.numberOfItems(inSection: 0) > 0 else { return true }
        let firstIndexPath = IndexPath(item: 0, section: 0)
        return self.isIndexPathVisible(firstIndexPath, atEdge: .top)
    }

    public func isCloseToBottom() -> Bool {
        guard self.collectionView.contentSize.height > 0 else { return true }
        return (self.visibleRect().maxY / self.collectionView.contentSize.height) > (1 - self.constants.autoloadingFractionalThreshold)
    }

    public func isCloseToTop() -> Bool {
        guard self.collectionView.contentSize.height > 0 else { return true }
        return (self.visibleRect().minY / self.collectionView.contentSize.height) < self.constants.autoloadingFractionalThreshold
    }


    public func isIndexPathVisible(_ indexPath: IndexPath, atEdge edge: CellVerticalEdge) -> Bool {
        if let attributes = self.collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) {
            let visibleRect = self.visibleRect()
            let intersection = visibleRect.intersection(attributes.frame)
            if edge == .top {
                return abs(intersection.minY - attributes.frame.minY) < CGFloat.bmaEpsilon
            } else {
                return abs(intersection.maxY - attributes.frame.maxY) < CGFloat.bmaEpsilon
            }
        }
        return false
    }

    public func scrollToBottom(animated: Bool) {
        let offsetY = max(-self.collectionView.contentInset.top, self.collectionView.collectionViewLayout.collectionViewContentSize.height - self.collectionView.bounds.height + self.collectionView.contentInset.bottom)
        if animated {
            UIView.animate(withDuration: self.constants.updatesAnimationDuration, animations: { () -> Void in
                self.collectionView.contentOffset = CGPoint(x: 0, y: offsetY)
            })
        } else {
            self.collectionView.contentOffset = CGPoint(x: 0, y: offsetY)
        }
    }

    public func scrollToPreservePosition(oldRefRect: CGRect?, newRefRect: CGRect?) {
        guard let oldRefRect = oldRefRect, let newRefRect = newRefRect else {
            return
        }
        let diffY = newRefRect.minY - oldRefRect.minY
        self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentOffset.y + diffY)
    }

    public func visibleRect() -> CGRect {
        let contentInset = self.collectionView.contentInset
        let collectionViewBounds = self.collectionView.bounds
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        return CGRect(x: CGFloat(0), y: self.collectionView.contentOffset.y + contentInset.top, width: collectionViewBounds.width, height: min(contentSize.height, collectionViewBounds.height - contentInset.top - contentInset.bottom))
    }
}
