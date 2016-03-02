//
//  DummyMessageItemPresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

class DummyMessageItemPresenter: ItemPresenterProtocol {
    
    class func registerCells(collectionView: UICollectionView) {
        collectionView.registerClass(DummyCollectionViewCell.self, forCellWithReuseIdentifier: "cell-id-unhandled-message")
    }
    
    var canCalculateHeightInBackground: Bool {
        return true
    }
    
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ItemDecorationAttributesProtocol?) -> CGFloat {
        return 0
    }
    
    func dequeueCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("cell-id-unhandled-message", forIndexPath: indexPath)
    }
    
    func configureCell(cell: UICollectionViewCell, decorationAttributes: ItemDecorationAttributesProtocol?) {
        cell.hidden = true
    }
}

class DummyCollectionViewCell: UICollectionViewCell {}
