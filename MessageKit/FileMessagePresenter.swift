//
//  FileMessagePresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

open class FileMessagePresenter<ViewModelBuilderT, InteractionHandlerT>
: BaseMessagePresenter<FileBubbleView, ViewModelBuilderT, InteractionHandlerT> where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: FileMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: FileMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT {

    public typealias ModelT = ViewModelBuilderT.ModelT
    public typealias ViewModelT = ViewModelBuilderT.ViewModelT

    public init (
        messageModel: ModelT,
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT?,
        sizingCell: FileMessageCollectionViewCell,
        baseCellStyle: BaseMessageCollectionViewCellStyleProtocol,
        fileCellStyle: FileMessageCollectionViewCellStyleProtocol) {
            self.fileCellStyle = fileCellStyle
            super.init(
                messageModel: messageModel,
                viewModelBuilder: viewModelBuilder,
                interactionHandler: interactionHandler,
                sizingCell: sizingCell,
                cellStyle: baseCellStyle
            )
    }

    let fileCellStyle: FileMessageCollectionViewCellStyleProtocol

    open override class func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(FileMessageCollectionViewCell.self, forCellWithReuseIdentifier: "file-message-incoming")
        collectionView.register(FileMessageCollectionViewCell.self, forCellWithReuseIdentifier: "file-message-outcoming")
    }

    open override func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = self.messageViewModel.isIncoming ? "file-message-incoming" : "file-message-outcoming"
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    open override func configureCell(_ cell: BaseMessageCollectionViewCell<FileBubbleView>, decorationAttributes: ItemDecorationAttributes, animated: Bool, additionalConfiguration: (() -> Void)?) {
        guard let cell = cell as? FileMessageCollectionViewCell else {
            assert(false, "Invalid cell received")
            return
        }

        super.configureCell(cell, decorationAttributes: decorationAttributes, animated: animated) { () -> Void in
            cell.fileMessageViewModel = self.messageViewModel
            cell.fileMessageStyle = self.fileCellStyle
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
