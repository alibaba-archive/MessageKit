//
//  MessageViewController+scrolling.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum CellVerticalEdge {
    case Top
    case Bottom
}

extension CGFloat {
    static let bma_epsilon: CGFloat = 0.001
}

extension MessageViewController {

    public func isScrolledAtBottom() -> Bool {
        guard self.collectionView.numberOfSections() > 0 && self.collectionView.numberOfItemsInSection(0) > 0 else { return true }
        let sectionIndex = self.collectionView.numberOfSections() - 1
        let itemIndex = self.collectionView.numberOfItemsInSection(sectionIndex) - 1
        let lastIndexPath = NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
        return self.isIndexPathVisible(lastIndexPath, atEdge: .Bottom)
    }
    
    public func isScrolledAtTop() -> Bool {
        guard self.collectionView.numberOfSections() > 0 && self.collectionView.numberOfItemsInSection(0) > 0 else { return true }
        let firstIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        return self.isIndexPathVisible(firstIndexPath, atEdge: .Top)
    }
    
    public func isCloseToBottom() -> Bool {
        guard self.collectionView.contentSize.height > 0 else { return true }
        return (self.visibleRect().maxY / self.collectionView.contentSize.height) > (1 - self.constants.autoloadingFractionalThreshold)
    }
    
    public func isCloseToTop() -> Bool {
        guard self.collectionView.contentSize.height > 0 else { return true }
        return (self.visibleRect().minY / self.collectionView.contentSize.height) < self.constants.autoloadingFractionalThreshold
    }
    
    
    public func isIndexPathVisible(indexPath: NSIndexPath, atEdge edge: CellVerticalEdge) -> Bool {
        if let attributes = self.collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath) {
            let visibleRect = self.visibleRect()
            let intersection = visibleRect.intersect(attributes.frame)
            if edge == .Top {
                return CGFloat.abs(intersection.minY - attributes.frame.minY) < CGFloat.bma_epsilon
            } else {
                return CGFloat.abs(intersection.maxY - attributes.frame.maxY) < CGFloat.bma_epsilon
            }
        }
        return false
    }
    
    public func scrollToBottom(animated animated: Bool) {
        let offsetY = max(-self.collectionView.contentInset.top, self.collectionView.collectionViewLayout.collectionViewContentSize().height - self.collectionView.bounds.height + self.collectionView.contentInset.bottom)
        if animated {
            UIView.animateWithDuration(self.constants.updatesAnimationDuration, animations: { () -> Void in
                self.collectionView.contentOffset = CGPoint(x: 0, y: offsetY)
            })
        } else {
            self.collectionView.contentOffset = CGPoint(x: 0, y: offsetY)
        }
    }
    
    public func scrollToPreservePosition(oldRefRect oldRefRect: CGRect?, newRefRect: CGRect?) {
        guard let oldRefRect = oldRefRect, newRefRect = newRefRect else {
            return
        }
        let diffY = newRefRect.minY - oldRefRect.minY
        self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentOffset.y + diffY)
    }
    
    public func visibleRect() -> CGRect {
        let contentInset = self.collectionView.contentInset
        let collectionViewBounds = self.collectionView.bounds
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize()
        return CGRect(x: CGFloat(0), y: self.collectionView.contentOffset.y + contentInset.top, width: collectionViewBounds.width, height: min(contentSize.height, collectionViewBounds.height - contentInset.top - contentInset.bottom))
    }
}