//
//  BaseMessageItemPresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum ChatItemVisibility {
    case Hidden
    case Appearing
    case Visible
}

public class BaseMessageItemPresenter<CellT: UICollectionViewCell>: ItemPresenterProtocol {
    public final weak var cell: CellT?
    
    public init() { }
    
    public class func registerCells(collectionView: UICollectionView) {
        assert(false, "Implement in subclass")
    }
    
    public var canCalculateHeightInBackground: Bool {
        return false
    }
    
    public func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ItemDecorationAttributesProtocol?) -> CGFloat {
        assert(false, "Implement in subclass")
        return 0
    }
    
    public func dequeueCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        assert(false, "Implemenent in subclass")
        return UICollectionViewCell()
    }
    
    public func configureCell(cell: UICollectionViewCell, decorationAttributes: ItemDecorationAttributesProtocol?) {
        assert(false, "Implemenent in subclass")
    }
    
    final public private(set) var itemVisibility: ChatItemVisibility = .Hidden
    
    public final func cellWillBeShown(cell: UICollectionViewCell) {
        if let cell = cell as? CellT {
            self.cell = cell
            self.itemVisibility = .Appearing
            self.cellWillBeShown()
            self.itemVisibility = .Visible
        } else {
            assert(false, "Invalid cell was given to presenter!")
        }
    }
    
    public func cellWillBeShown() {
        // Hook for subclasses
    }
    
    public func shouldShowMenu() -> Bool {
        return false
    }
    
    public final func cellWasHidden(cell: UICollectionViewCell) {
        // Carefull!! This doesn't mean that this is no longer visible
        // If cell is replaced (due to a reload for instance) we can have the following sequence:
        //   - New cell is taken from the pool and configured. We'll get cellWillBeShown
        //   - Old cell is removed. We'll get cellWasHidden
        // --> We need to check that this cell is the last one made visible
        if let cell = cell as? CellT {
            if cell === self.cell {
                self.cell = nil
                self.itemVisibility = .Hidden
                self.cellWasHidden()
            }
        } else {
            assert(false, "Invalid cell was given to presenter!")
        }
    }
    
    public func cellWasHidden() {
        // Hook for subclasses. Here we are not visible for real.
    }
    
    public func canPerformMenuControllerAction(action: Selector) -> Bool {
        return false
    }
    
    public func performMenuControllerAction(action: Selector) {
        assert(self.canPerformMenuControllerAction(action))
    }
}