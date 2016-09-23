//
//  MessageItemPresenterProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol ItemPresenterProtocol: class {
    var isCalculateHeightInBackground: Bool { get } // Default is false

    static func registerCells(_ collectionView: UICollectionView)
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ItemDecorationAttributesProtocol?) -> CGFloat
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ItemDecorationAttributesProtocol?)
    func cellWillBeShown(_ cell: UICollectionViewCell) // optional
    func cellWasHidden(_ cell: UICollectionViewCell) // optional
    func shouldShowMenu() -> Bool // optional. Default is false
    func canPerformMenuControllerAction(_ action: Selector) -> Bool // optional. Default is false
    func performMenuControllerAction(_ action: Selector) // optional
}

public extension ItemPresenterProtocol { // Optionals
    var isCalculateHeightInBackground: Bool { return false }

    func cellWillBeShown(_ cell: UICollectionViewCell) {}
    func cellWasHidden(_ cell: UICollectionViewCell) {}
    func shouldShowMenu() -> Bool { return false }
    func canPerformMenuControllerAction(_ action: Selector) -> Bool { return false }
    func performMenuControllerAction(_ action: Selector) {}
}
