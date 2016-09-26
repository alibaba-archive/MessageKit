//
//  MessageViewController+Presenters.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

extension MessageViewController: MessageCollectionViewLayoutDelegate {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decoratedMessageItems.count
    }

    @objc(numberOfSectionsInCollectionView:) public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    @objc(collectionView:cellForItemAtIndexPath:) public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let presenter = createPresenter(for: indexPath)
        let cell = presenter.dequeueCell(collectionView: collectionView, indexPath: indexPath)
        let decorationAttributes = self.decorationAttributesForIndexPath(indexPath)
        presenter.configureCell(cell, decorationAttributes: decorationAttributes)
        return cell
    }

    @objc(collectionView:didEndDisplayingCell:forItemAtIndexPath:) public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let oldPresenterForCell = presentersByCell.object(forKey: cell) as? ItemPresenterProtocol {
            presentersByCell.removeObject(forKey: cell)
            oldPresenterForCell.cellWasHidden(cell)
        }
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:) public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let presenter = createPresenter(for: indexPath)
        presentersByCell.setObject(presenter, forKey: cell)
        presenter.cellWillBeShown(cell)
    }

    @objc(collectionView:shouldShowMenuForItemAtIndexPath:) public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return createPresenter(for: indexPath).shouldShowMenu()
    }

    @objc(collectionView:performAction:forItemAtIndexPath:withSender:) public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        createPresenter(for: indexPath).performMenuControllerAction(action)
    }

    @objc(collectionView:canPerformAction:forItemAtIndexPath:withSender:) public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return createPresenter(for: indexPath).canPerformMenuControllerAction(action)
    }

    public func createPresenter(for indexPath: IndexPath) -> ItemPresenterProtocol {
        return createPresenter(for: indexPath.item, messageItems: decoratedMessageItems)
    }

    func createPresenter(for index: Int, messageItems: [DecoratedMessageItem]) -> ItemPresenterProtocol {
        guard index < messageItems.count else {
            return DummyMessageItemPresenter()
        }

        let messageItem = messageItems[index].messageItem
        if let presenter = presentersByMessageItem.object(forKey: messageItem) as? ItemPresenterProtocol {
            return presenter
        }
        let presenter = createPresenter(for: messageItem)
        presentersByMessageItem.setObject(presenter, forKey: messageItem)
        return presenter
    }

    public func createPresenter(for messageItem: MessageItemProtocol) -> ItemPresenterProtocol {
        for builder in self.presenterBuildersByType[messageItem.type] ?? [] {
            if builder.canHandle(messageItem) {
                return builder.createPresenter(withMessageItem: messageItem)
            }
        }
        return DummyMessageItemPresenter()
    }

    public func decorationAttributesForIndexPath(_ indexPath: IndexPath) -> ItemDecorationAttributesProtocol? {
        return decoratedMessageItems[indexPath.item].decorationAttributes
    }
}
