//
//  BaseMessageItemPresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum ChatItemVisibility {
    case hidden
    case appearing
    case visible
}

open class BaseMessageItemPresenter<CellT: UICollectionViewCell>: ItemPresenterProtocol {
    public final weak var cell: CellT?

    public init() { }

    open class func registerCells(_ collectionView: UICollectionView) {
        assert(false, "Implement in subclass")
    }

    open var isCalculateHeightInBackground: Bool {
        return false
    }

    open func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ItemDecorationAttributesProtocol?) -> CGFloat {
        assert(false, "Implement in subclass")
        return 0
    }

    open func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        assert(false, "Implemenent in subclass")
        return UICollectionViewCell()
    }

    open func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ItemDecorationAttributesProtocol?) {
        assert(false, "Implemenent in subclass")
    }

    final public fileprivate(set) var itemVisibility: ChatItemVisibility = .hidden

    public final func cellWillBeShown(_ cell: UICollectionViewCell) {
        if let cell = cell as? CellT {
            self.cell = cell
            self.itemVisibility = .appearing
            self.cellWillBeShown()
            self.itemVisibility = .visible
        } else {
            assert(false, "Invalid cell was given to presenter!")
        }
    }

    open func cellWillBeShown() {
        // Hook for subclasses
    }

    open func shouldShowMenu() -> Bool {
        return false
    }

    public final func cellWasHidden(_ cell: UICollectionViewCell) {
        if let cell = cell as? CellT {
            if cell === self.cell {
                self.cell = nil
                self.itemVisibility = .hidden
                self.cellWasHidden()
            }
        } else {
            assert(false, "Invalid cell was given to presenter!")
        }
    }

    open func cellWasHidden() {
        // Hook for subclasses. Here we are not visible for real.
    }

    open func canPerformMenuControllerAction(_ action: Selector) -> Bool {
        return false
    }

    open func performMenuControllerAction(_ action: Selector) {
        assert(self.canPerformMenuControllerAction(action))
    }
}
