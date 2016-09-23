//
//  CustomMessagePresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/16.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

open class CustomMessagePresenter<ViewModelBuilderT, InteractionHandlerT>
: BaseMessagePresenter<CustomBubbleView, ViewModelBuilderT, InteractionHandlerT> where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: CustomMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: CustomMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT {

    public typealias ModelT = ViewModelBuilderT.ModelT
    public typealias ViewModelT = ViewModelBuilderT.ViewModelT

    public init (
        messageModel: ModelT,
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT?,
        sizingCell: CustomMessageCollectionViewCell,
        baseCellStyle: BaseMessageCollectionViewCellStyleProtocol,
        customCellStyle: CustomMessageCollectionViewCellStyleProtocol) {
            self.customCellStyle = customCellStyle
            super.init(
                messageModel: messageModel,
                viewModelBuilder: viewModelBuilder,
                interactionHandler: interactionHandler,
                sizingCell: sizingCell,
                cellStyle: baseCellStyle
            )
    }

    let customCellStyle: CustomMessageCollectionViewCellStyleProtocol

    open override class func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(CustomMessageCollectionViewCell.self, forCellWithReuseIdentifier: "custom-message-incoming")
        collectionView.register(CustomMessageCollectionViewCell.self, forCellWithReuseIdentifier: "custom-message-outcoming")
    }

    open override func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = self.messageViewModel.isIncoming ? "custom-message-incoming" : "custom-message-outcoming"
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    open override func configureCell(_ cell: BaseMessageCollectionViewCell<CustomBubbleView>, decorationAttributes: ItemDecorationAttributes, animated: Bool, additionalConfiguration: (() -> Void)?) {
        guard let cell = cell as? CustomMessageCollectionViewCell else {
            assert(false, "Invalid cell received")
            return
        }

        super.configureCell(cell, decorationAttributes: decorationAttributes, animated: animated) { () -> Void in
            cell.customMessageViewModel = self.messageViewModel
            cell.customMessageStyle = self.customCellStyle
            additionalConfiguration?()
        }
    }

    open override func canShowMenu() -> Bool {
        return true
    }

    open override func canPerformMenuControllerAction(_ action: Selector) -> Bool {
        return action.description == "copy:"
    }
}
