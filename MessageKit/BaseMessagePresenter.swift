//
//  BaseMessagePresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public struct ItemDecorationAttributes: ItemDecorationAttributesProtocol {

    public let bottomMargin: CGFloat
    public let showsTail: Bool
    public init(bottomMargin: CGFloat, showsTail: Bool) {
        self.bottomMargin = bottomMargin
        self.showsTail = showsTail
    }
}

public protocol ViewModelBuilderProtocol {

    associatedtype ModelT: MessageModelProtocol
    associatedtype ViewModelT: MessageViewModelProtocol
    func createViewModel(_ model: ModelT) -> ViewModelT
}

public protocol BaseMessageInteractionHandlerProtocol {

    associatedtype ViewModelT
    func userDidTapOnFailIcon(_ viewModel: ViewModelT)
    func userDidTapOnBubble(_ viewModel: ViewModelT)
    func userDidLongPressOnBubble(_ viewModel: ViewModelT)
    func userDidTapOnAvatar(_ viewModel: ViewModelT)
}

open class BaseMessagePresenter<BubbleViewT, ViewModelBuilderT, InteractionHandlerT>: BaseMessageItemPresenter<BaseMessageCollectionViewCell<BubbleViewT>> where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: MessageModelProtocol,
    ViewModelBuilderT.ViewModelT: MessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT,
BubbleViewT: UIView, BubbleViewT:MaximumLayoutWidthSpecificable, BubbleViewT: BackgroundSizingQueryable {

    public typealias CellT = BaseMessageCollectionViewCell<BubbleViewT>
    public typealias ModelT = ViewModelBuilderT.ModelT
    public typealias ViewModelT = ViewModelBuilderT.ViewModelT

    let messageModel: ModelT
    let sizingCell: BaseMessageCollectionViewCell<BubbleViewT>
    let viewModelBuilder: ViewModelBuilderT
    let interactionHandler: InteractionHandlerT?
    let cellStyle: BaseMessageCollectionViewCellStyleProtocol

    public init (
        messageModel: ModelT,
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT?,
        sizingCell: BaseMessageCollectionViewCell<BubbleViewT>,
        cellStyle: BaseMessageCollectionViewCellStyleProtocol) {
            self.messageModel = messageModel
            self.sizingCell = sizingCell
            self.viewModelBuilder = viewModelBuilder
            self.cellStyle = cellStyle
            self.interactionHandler = interactionHandler
    }

    public fileprivate(set) final lazy var messageViewModel: ViewModelT = {
        return self.createViewModel()
    }()

    open func createViewModel() -> ViewModelT {
        let viewModel = self.viewModelBuilder.createViewModel(self.messageModel)
        return viewModel
    }

    public final override func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ItemDecorationAttributesProtocol?) {
        guard let cell = cell as? CellT else {
            assert(false, "Invalid cell given to presenter")
            return
        }
        guard let decorationAttributes = decorationAttributes as? ItemDecorationAttributes else {
            assert(false, "Expecting decoration attributes")
            return
        }

        self.decorationAttributes = decorationAttributes
        self.configureCell(cell, decorationAttributes: decorationAttributes, animated: false, additionalConfiguration: nil)
    }

    var decorationAttributes: ItemDecorationAttributes!
    open func configureCell(_ cell: CellT, decorationAttributes: ItemDecorationAttributes, animated: Bool, additionalConfiguration: (() -> Void)?) {
        cell.performBatchUpdates({ () -> Void in
            self.messageViewModel.showsTail = decorationAttributes.showsTail
            cell.bubbleView.isUserInteractionEnabled = true // just in case something went wrong while showing UIMenuController
            cell.baseStyle = self.cellStyle
            cell.messageViewModel = self.messageViewModel
            cell.onBubbleTapped = { [weak self] (cell) in
                guard let sSelf = self else { return }
                sSelf.interactionHandler?.userDidTapOnBubble(sSelf.messageViewModel)
            }
            cell.onBubbleLongPressed = { [weak self] (cell) in
                guard let sSelf = self else { return }
                sSelf.interactionHandler?.userDidLongPressOnBubble(sSelf.messageViewModel)
            }
            cell.onFailedButtonTapped = { [weak self] (cell) in
                guard let sSelf = self else { return }
                sSelf.interactionHandler?.userDidTapOnFailIcon(sSelf.messageViewModel)
            }
            cell.onAvatarTapped = { [weak self] (cell) in
                guard let sSelf = self else { return }
                sSelf.interactionHandler?.userDidTapOnAvatar(sSelf.messageViewModel)
            }
            additionalConfiguration?()
        }, animated: animated, completion: nil)
    }

    open override func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ItemDecorationAttributesProtocol?) -> CGFloat {
        guard let decorationAttributes = decorationAttributes as? ItemDecorationAttributes else {
            assert(false, "Expecting decoration attributes")
            return 0
        }
        self.configureCell(self.sizingCell, decorationAttributes: decorationAttributes, animated: false, additionalConfiguration: nil)
        return self.sizingCell.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }

    open override var isCalculateHeightInBackground: Bool {
        return self.sizingCell.canCalculateSizeInBackground
    }

    open override func shouldShowMenu() -> Bool {
        guard self.canShowMenu() else { return false }
        guard let cell = self.cell else {
            assert(false, "Investigate -> Fix or remove assert")
            return false
        }
        cell.bubbleView.isUserInteractionEnabled = false // This is a hack for UITextView, shouldn't harm to all bubbles

        NotificationCenter.default.addObserver(self, selector: #selector(willShowMenu), name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
        return true
    }

    @objc
    func willShowMenu(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIMenuControllerWillShowMenu, object: nil)
        guard let cell = self.cell, let menuController = notification.object as? UIMenuController else {
            assert(false, "Investigate -> Fix or remove assert")
            return
        }
        cell.bubbleView.isUserInteractionEnabled = true
        menuController.setMenuVisible(false, animated: false)
        menuController.setTargetRect(cell.bubbleView.bounds, in: cell.bubbleView)
        menuController.setMenuVisible(true, animated: true)
    }

    open func canShowMenu() -> Bool {
        // Override in subclass
        return false
    }
}
