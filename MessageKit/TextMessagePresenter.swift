//
//  TextMessagePresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

open class TextMessagePresenter<ViewModelBuilderT, InteractionHandlerT>
: BaseMessagePresenter<TextBubbleView, ViewModelBuilderT, InteractionHandlerT> where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: TextMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: TextMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT {

    public typealias ModelT = ViewModelBuilderT.ModelT
    public typealias ViewModelT = ViewModelBuilderT.ViewModelT

    public init (
        messageModel: ModelT,
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT?,
        sizingCell: TextMessageCollectionViewCell,
        baseCellStyle: BaseMessageCollectionViewCellStyleProtocol,
        textCellStyle: TextMessageCollectionViewCellStyleProtocol,
        layoutCache: NSCache<AnyObject, AnyObject>) {
            self.layoutCache = layoutCache
            self.textCellStyle = textCellStyle
            super.init(
                messageModel: messageModel,
                viewModelBuilder: viewModelBuilder,
                interactionHandler: interactionHandler,
                sizingCell: sizingCell,
                cellStyle: baseCellStyle
            )
    }

    let layoutCache: NSCache<AnyObject, AnyObject>
    let textCellStyle: TextMessageCollectionViewCellStyleProtocol

    open override class func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(TextMessageCollectionViewCell.self, forCellWithReuseIdentifier: "text-message-incoming")
        collectionView.register(TextMessageCollectionViewCell.self, forCellWithReuseIdentifier: "text-message-outcoming")
    }

    open override func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = self.messageViewModel.isIncoming ? "text-message-incoming" : "text-message-outcoming"
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    open override func configureCell(_ cell: BaseMessageCollectionViewCell<TextBubbleView>, decorationAttributes: ItemDecorationAttributes, animated: Bool, additionalConfiguration: (() -> Void)?) {
        guard let cell = cell as? TextMessageCollectionViewCell else {
            assert(false, "Invalid cell received")
            return
        }

        super.configureCell(cell, decorationAttributes: decorationAttributes, animated: animated) { () -> Void in
            cell.layoutCache = self.layoutCache
            cell.textMessageViewModel = self.messageViewModel
            cell.textMessageStyle = self.textCellStyle
            additionalConfiguration?()
        }
    }

    open override func canShowMenu() -> Bool {
        return true
    }

    open override func canPerformMenuControllerAction(_ action: Selector) -> Bool {
        return action.description == "copy:"
    }

    open override func performMenuControllerAction(_ action: Selector) {
        if action.description == "copy:" {
            UIPasteboard.general.string = self.messageViewModel.text
        } else {
            assert(false, "Unexpected action")
        }
    }
}
