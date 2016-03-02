//
//  MessageItemPresenterProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol ItemPresenterProtocol: class {
    static func registerCells(collectionView: UICollectionView)
    var canCalculateHeightInBackground: Bool { get } // Default is false
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ItemDecorationAttributesProtocol?) -> CGFloat
    func dequeueCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell
    func configureCell(cell: UICollectionViewCell, decorationAttributes: ItemDecorationAttributesProtocol?)
    func cellWillBeShown(cell: UICollectionViewCell) // optional
    func cellWasHidden(cell: UICollectionViewCell) // optional
    func shouldShowMenu() -> Bool // optional. Default is false
    func canPerformMenuControllerAction(action: Selector) -> Bool // optional. Default is false
    func performMenuControllerAction(action: Selector) // optional
}

public extension ItemPresenterProtocol { // Optionals
    var canCalculateHeightInBackground: Bool { return false }
    func cellWillBeShown(cell: UICollectionViewCell) {}
    func cellWasHidden(cell: UICollectionViewCell) {}
    func shouldShowMenu() -> Bool { return false }
    func canPerformMenuControllerAction(action: Selector) -> Bool { return false }
    func performMenuControllerAction(action: Selector) {}
}