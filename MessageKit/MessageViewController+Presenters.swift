//
//  MessageViewController+Presenters.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

extension MessageViewController: MessageCollectionViewLayoutDelegate {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decoratedMessageItems.count
    }
   
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let presenter = presenterForIndexPath(indexPath)
        let cell = presenter.dequeueCell(collectionView: collectionView, indexPath: indexPath)
        let decorationAttributes = self.decorationAttributesForIndexPath(indexPath)
        presenter.configureCell(cell, decorationAttributes: decorationAttributes)
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let oldPresenterForCell = presentersByCell.objectForKey(cell) as? ItemPresenterProtocol {
            presentersByCell.removeObjectForKey(cell)
            oldPresenterForCell.cellWasHidden(cell)
        }
    }
    
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let presenter = self.presenterForIndexPath(indexPath)
        presentersByCell.setObject(presenter, forKey: cell)
        presenter.cellWillBeShown(cell)
    }
    
    public func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return presenterForIndexPath(indexPath).shouldShowMenu() ?? false
    }
    
    public func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        presenterForIndexPath(indexPath).performMenuControllerAction(action)
    }
    
    public func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return presenterForIndexPath(indexPath).canPerformMenuControllerAction(action)
    }
    
    public func presenterForIndexPath(indexPath: NSIndexPath) -> ItemPresenterProtocol {
        return presenterForIndex(indexPath.item, messageItems: decoratedMessageItems)
    }
    
    func presenterForIndex(index: Int, messageItems: [DecoratedMessageItem]) -> ItemPresenterProtocol {
        guard index < messageItems.count else {
            return DummyMessageItemPresenter()
        }
        
        let messageItem = messageItems[index].messageItem
        if let presenter = presentersByMessageItem.objectForKey(messageItem) as? ItemPresenterProtocol {
            return presenter
        }
        let presenter = createPresenterForMessageItem(messageItem)
        presentersByMessageItem.setObject(presenter, forKey: messageItem)
        return presenter
    }
    
    public func createPresenterForMessageItem(messageItem: MessageItemProtocol) -> ItemPresenterProtocol {
        for builder in self.presenterBuildersByType[messageItem.type] ?? [] {
            if builder.canHandleMessageItem(messageItem) {
                return builder.createPresenterWithMessageItem(messageItem)
            }
        }
        return DummyMessageItemPresenter()
    }
    
    public func decorationAttributesForIndexPath(indexPath: NSIndexPath) -> ItemDecorationAttributesProtocol? {
        return decoratedMessageItems[indexPath.item].decorationAttributes
    }
}
