//
//  PhotoMessagePresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

open class PhotoMessagePresenter<ViewModelBuilderT, InteractionHandlerT>
: BaseMessagePresenter<PhotoBubbleView, ViewModelBuilderT, InteractionHandlerT> where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: PhotoMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: PhotoMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT {

    public typealias ModelT = ViewModelBuilderT.ModelT
    public typealias ViewModelT = ViewModelBuilderT.ViewModelT

    public init (
        messageModel: ModelT,
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT?,
        sizingCell: PhotoMessageCollectionViewCell,
        baseCellStyle: BaseMessageCollectionViewCellStyleProtocol,
        photoCellStyle: PhotoMessageCollectionViewCellStyleProtocol) {
            self.photoCellStyle = photoCellStyle
            super.init(
                messageModel: messageModel,
                viewModelBuilder: viewModelBuilder,
                interactionHandler: interactionHandler,
                sizingCell: sizingCell,
                cellStyle: baseCellStyle
            )
    }

    let photoCellStyle: PhotoMessageCollectionViewCellStyleProtocol

    open override class func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(PhotoMessageCollectionViewCell.self, forCellWithReuseIdentifier: "photo-message")
    }

    open override func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "photo-message", for: indexPath)
    }

    open override func createViewModel() -> ViewModelBuilderT.ViewModelT {
        let viewModel = self.viewModelBuilder.createViewModel(self.messageModel)
        let updateClosure = { [weak self] (old: Any, new: Any) -> () in
            self?.updateCurrentCell()
        }

        viewModel.imageClosure = messageModel.imageClosure
        viewModel.transferDirection.observe(self, closure: updateClosure)
        viewModel.transferProgress.observe(self, closure: updateClosure)
        viewModel.transferStatus.observe(self, closure: updateClosure)
        return viewModel
    }

    var photoCell: PhotoMessageCollectionViewCell? {
        if let cell = self.cell {
            if let photoCell = cell as? PhotoMessageCollectionViewCell {
                return photoCell
            } else {
                assert(false, "Invalid cell was given to presenter!")
            }
        }
        return nil
    }

    open override func configureCell(_ cell: BaseMessageCollectionViewCell<PhotoBubbleView>, decorationAttributes: ItemDecorationAttributes, animated: Bool, additionalConfiguration: (() -> Void)?) {
        guard let cell = cell as? PhotoMessageCollectionViewCell else {
            assert(false, "Invalid cell received")
            return
        }

        super.configureCell(cell, decorationAttributes: decorationAttributes, animated: animated) { () -> Void in
            cell.photoMessageViewModel = self.messageViewModel
            cell.photoMessageStyle = self.photoCellStyle
            additionalConfiguration?()
        }
    }

    open override func cellWillBeShown() {
        self.messageViewModel.willBeShown()
    }


    open override func cellWasHidden() {
        self.messageViewModel.wasHidden()
    }

    open func updateCurrentCell() {
        if let cell = self.photoCell, let decorationAttributes = self.decorationAttributes {
            self.configureCell(cell, decorationAttributes: decorationAttributes, animated: self.itemVisibility != .appearing, additionalConfiguration: nil)
        }
    }
}
