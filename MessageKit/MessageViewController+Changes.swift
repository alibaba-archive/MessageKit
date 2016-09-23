//
//  MessageViewController+Changes.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

typealias UpdateClosure = (_ changes: CollectionChanges, _ updateModelClosure: @escaping () -> Void) -> ()

extension MessageViewController: MessageDataSourceDelegateProtocol {

    public enum UpdateContext {
        case normal
        case firstLoad
        case pagination
        case reload
        case messageCountReduction
    }

    public func MessageDataSourceDidUpdate(_ messageDataSource: MessageDataSourceProtocol) {
        self.enqueueModelUpdate(context: .normal)
    }

    public func enqueueModelUpdate(context: UpdateContext) {
        let newItems = self.messageDataSource?.messageItems ?? []
        self.updateQueue.addTask { (completion) -> () in
            let oldItems = self.decoratedMessageItems.map { $0.messageItem }
            self.updateModels(newItems: newItems, oldItems: oldItems, context: context, completion: {
                if self.updateQueue.isEmpty {
                    self.enqueueMessageCountReductionIfNeeded()
                }
                completion()
            })
        }
    }

    public func enqueueMessageCountReductionIfNeeded() {
        guard let preferredMaxMessageCount = self.constants.preferredMaxMessageCount, (self.messageDataSource?.messageItems.count ?? 0) > preferredMaxMessageCount else { return }
        self.updateQueue.addTask { (completion) -> () in
            self.messageDataSource?.adjustNumberOfMessages(preferredMaxCount: self.constants.preferredMaxMessageCountAdjustment, focusPosition: self.focusPosition, completion: { (didAdjust) -> Void in
                guard didAdjust else {
                    completion()
                    return
                }
                let newItems = self.messageDataSource?.messageItems ?? []
                let oldItems = self.decoratedMessageItems.map { $0.messageItem }
                self.updateModels(newItems: newItems, oldItems: oldItems, context: .messageCountReduction, completion: completion)
            })
        }
    }

    public var focusPosition: Double {
        if self.isCloseToBottom() {
            return 1
        } else if self.isCloseToTop() {
            return 0
        }

        let contentHeight = self.collectionView.contentSize.height
        guard contentHeight > 0 else {
            return 0.5
        }

        // Rough estimation
        let midContentOffset = self.collectionView.contentOffset.y + self.visibleRect().height / 2
        return min(max(0, Double(midContentOffset / contentHeight)), 1.0)
    }

    fileprivate func updateModels(newItems: [MessageItemProtocol], oldItems: [MessageItemProtocol], context: UpdateContext, completion: @escaping () -> Void) {
        let collectionViewWidth = self.collectionView.bounds.width
        let newContext = self.isFirstLayout ? .firstLoad : context
        let performInBackground = newContext != .firstLoad

        self.isAutoLoadingEnabled = false
        let perfomBatchUpdates: UpdateClosure  = { modelUpdate in
            self.performBatchUpdates(
                updateModelClosure: modelUpdate.1,
                changes: modelUpdate.0,
                context: newContext,
                completion: { () -> Void in
                    self.isAutoLoadingEnabled = true
                    completion()
            })
        }

        let createModelUpdate = {
            return self.createModelUpdates(
                newItems: newItems,
                oldItems: oldItems,
                collectionViewWidth:collectionViewWidth)
        }

        if performInBackground {
            DispatchQueue.global(qos: .default).async { () -> Void in
                let modelUpdate = createModelUpdate()
                DispatchQueue.main.async(execute: { () -> Void in
                    perfomBatchUpdates(modelUpdate.changes, modelUpdate.updateModelClosure)
                })
            }
        } else {
            let modelUpdate = createModelUpdate()
            perfomBatchUpdates(modelUpdate.changes, modelUpdate.updateModelClosure)
        }
    }

    func updateVisibleCells(_ changes: CollectionChanges) {
        // Datasource should be already updated!

        let visibleIndexPaths = Set(self.collectionView.indexPathsForVisibleItems.filter { (indexPath) -> Bool in
            return !changes.insertedIndexPaths.contains(indexPath) && !changes.deletedIndexPaths.contains(indexPath)
            })

        var updatedIndexPaths = Set<IndexPath>()
        for move in changes.movedIndexPaths {
            updatedIndexPaths.insert(move.indexPathOld as IndexPath)
            if let cell = self.collectionView.cellForItem(at: move.indexPathOld as IndexPath) {
                self.createPresenter(for: move.indexPathNew).configureCell(cell, decorationAttributes: self.decorationAttributesForIndexPath(move.indexPathNew))
            }
        }

        // Update remaining visible cells
        let remaining = visibleIndexPaths.subtracting(updatedIndexPaths)
        for indexPath in remaining {
            if let cell = self.collectionView.cellForItem(at: indexPath) {
                self.createPresenter(for: indexPath).configureCell(cell, decorationAttributes: self.decorationAttributesForIndexPath(indexPath))
            }
        }
    }

    func performBatchUpdates(
        updateModelClosure: @escaping () -> Void,
        changes: CollectionChanges,
        context: UpdateContext,
        completion: @escaping () -> Void) {
            let shouldScrollToBottom = context != .pagination && self.isScrolledAtBottom()
            let oldRect = self.rectAtIndexPath(changes.movedIndexPaths.first?.indexPathOld)
            let myCompletion = {
                // Found that cells may not match correct index paths here yet! (see comment below)
                // Waiting for next loop seems to fix the issue
                DispatchQueue.main.async(execute: { () -> Void in
                    completion()
                })
            }

            if context == .normal {

                UIView.animate(withDuration: self.constants.updatesAnimationDuration, animations: { () -> Void in
                    // We want to update visible cells to support easy removal of bubble tail or any other updates that may be needed after a data update
                    // Collection view state is not constistent after performBatchUpdates. It can happen that we ask a cell for an index path and we still get the old one.
                    // Visible cells can be either updated in completion block (easier but with delay) or before, taking into account if some cell is gonna be moved

                    updateModelClosure()
                    self.updateVisibleCells(changes)

                    self.collectionView.performBatchUpdates({ () -> Void in
                        self.collectionView.deleteItems(at: Array(changes.deletedIndexPaths))
                        self.collectionView.insertItems(at: Array(changes.insertedIndexPaths))
                        for move in changes.movedIndexPaths {
                            self.collectionView.moveItem(at: move.indexPathOld, to: move.indexPathNew)
                        }
                        }) { (finished) -> Void in
                            myCompletion()
                    }
                })
            } else {
                updateModelClosure()
                self.collectionView.reloadData()
                self.collectionView.collectionViewLayout.prepare()
                myCompletion()
            }

            if shouldScrollToBottom {
                self.scrollToBottom(animated: context == .normal)
            } else {
                let newRect = self.rectAtIndexPath(changes.movedIndexPaths.first?.indexPathNew)
                self.scrollToPreservePosition(oldRefRect: oldRect, newRefRect: newRect)
            }
    }

    fileprivate func createModelUpdates(newItems: [MessageItemProtocol], oldItems: [MessageItemProtocol], collectionViewWidth: CGFloat) -> (changes: CollectionChanges, updateModelClosure: () -> Void) {

        let newDecoratedItems = self.messageItemsDecorator?.decorateItems(newItems) ?? newItems.map { DecoratedMessageItem(messageItem: $0, decorationAttributes: nil) }
        let changes = generateChanges(
            oldCollection: oldItems.map { $0 },
            newCollection: newDecoratedItems.map { $0.messageItem })
        let layoutModel = self.createLayoutModel(newDecoratedItems, collectionViewWidth: collectionViewWidth)
        let updateModelClosure : () -> Void = { [weak self] in
            self?.layoutModel = layoutModel
            self?.decoratedMessageItems = newDecoratedItems
        }
        return (changes, updateModelClosure)
    }

    fileprivate func createLayoutModel(_ decoratedItems: [DecoratedMessageItem], collectionViewWidth: CGFloat) -> MessageCollectionViewLayoutModel {
        typealias IntermediateItemLayoutData = (height: CGFloat?, bottomMargin: CGFloat)
        typealias ItemLayoutData = (height: CGFloat, bottomMargin: CGFloat)

        func createLayoutModel(intermediateLayoutData: [IntermediateItemLayoutData]) -> MessageCollectionViewLayoutModel {
            let layoutData = intermediateLayoutData.map { (intermediateLayoutData: IntermediateItemLayoutData) -> ItemLayoutData in
                return (height: intermediateLayoutData.height!, bottomMargin: intermediateLayoutData.bottomMargin)
            }
            return MessageCollectionViewLayoutModel.createModel(self.collectionView.bounds.width, itemsLayoutData: layoutData)
        }

        let isInbackground = !Thread.isMainThread
        var intermediateLayoutData = [IntermediateItemLayoutData]()
        var itemsForMainThread = [(index: Int, item: DecoratedMessageItem, presenter: ItemPresenterProtocol?)]()

        for (index, decoratedItem) in decoratedItems.enumerated() {
            let presenter = createPresenter(for: index, messageItems: decoratedItems)
            var height: CGFloat?
            let bottomMargin: CGFloat = decoratedItem.decorationAttributes?.bottomMargin ?? 0
            if !isInbackground || presenter.isCalculateHeightInBackground {
                height = presenter.heightForCell(maximumWidth: collectionViewWidth, decorationAttributes: decoratedItem.decorationAttributes)
            } else {
                itemsForMainThread.append((index: index, item: decoratedItem, presenter: presenter))
            }
            intermediateLayoutData.append((height: height, bottomMargin: bottomMargin))
        }

        if itemsForMainThread.count > 0 {
            DispatchQueue.main.sync(execute: { () -> Void in
                for (index, decoratedItem, presenter) in itemsForMainThread {
                    let height = presenter?.heightForCell(maximumWidth: collectionViewWidth, decorationAttributes: decoratedItem.decorationAttributes)
                    intermediateLayoutData[index].height = height
                }
            })
        }
        return createLayoutModel(intermediateLayoutData: intermediateLayoutData)
    }

    public func messageCollectionViewLayoutModel() -> MessageCollectionViewLayoutModel {
        if self.layoutModel.calculatedForWidth != self.collectionView.bounds.width {
            self.layoutModel = self.createLayoutModel(self.decoratedMessageItems, collectionViewWidth: self.collectionView.bounds.width)
        }
        return self.layoutModel
    }

}
