//
//  DummyMessageItemPresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

class DummyMessageItemPresenter: ItemPresenterProtocol {

    class func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(DummyCollectionViewCell.self, forCellWithReuseIdentifier: "cell-id-unhandled-message")
    }

    var isCalculateHeightInBackground: Bool {
        return true
    }

    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ItemDecorationAttributesProtocol?) -> CGFloat {
        return 0
    }

    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell-id-unhandled-message", for: indexPath)
    }

    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ItemDecorationAttributesProtocol?) {
        cell.isHidden = true
    }
}

class DummyCollectionViewCell: UICollectionViewCell {}
