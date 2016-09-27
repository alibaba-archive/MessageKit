//
//  PhotoMessagePresenterBuilder.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

open class PhotoMessagePresenterBuilder<ViewModelBuilderT, InteractionHandlerT>: ItemPresenterBuilderProtocol where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: PhotoMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: PhotoMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT {

    public typealias ModelT = ViewModelBuilderT.ModelT
    public typealias ViewModelT = ViewModelBuilderT.ViewModelT

    public init(
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT?) {
            self.viewModelBuilder = viewModelBuilder
            self.interactionHandler = interactionHandler
    }

    let viewModelBuilder: ViewModelBuilderT
    let interactionHandler: InteractionHandlerT?
    open lazy var sizingCell: PhotoMessageCollectionViewCell = PhotoMessageCollectionViewCell.sizingCell()
    open lazy var photoCellStyle: PhotoMessageCollectionViewCellStyleProtocol = PhotoMessageCollectionViewCellDefaultStyle()
    open lazy var baseCellStyle: BaseMessageCollectionViewCellStyleProtocol = BaseMessageCollectionViewCellDefaultSyle()

    open func canHandle(_ messageItem: MessageItemProtocol) -> Bool {
        return messageItem is PhotoMessageModelProtocol ? true : false
    }

    open func createPresenter(with messageItem: MessageItemProtocol) -> ItemPresenterProtocol {
        assert(self.canHandle(messageItem))
        return PhotoMessagePresenter<ViewModelBuilderT, InteractionHandlerT>(
            messageModel: messageItem as! ModelT,
            viewModelBuilder: self.viewModelBuilder,
            interactionHandler: self.interactionHandler,
            sizingCell: sizingCell,
            baseCellStyle: self.baseCellStyle,
            photoCellStyle: self.photoCellStyle
        )
    }

    open var presenterType: ItemPresenterProtocol.Type {
        return PhotoMessagePresenter<ViewModelBuilderT, InteractionHandlerT>.self
    }
}
