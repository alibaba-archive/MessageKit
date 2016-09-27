//
//  FileMessagePresenterBuilder.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

open class FileMessagePresenterBuilder<ViewModelBuilderT, InteractionHandlerT>: ItemPresenterBuilderProtocol where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: FileMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: FileMessageViewModelProtocol,
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
    open lazy var sizingCell: FileMessageCollectionViewCell = FileMessageCollectionViewCell.sizingCell()
    open lazy var fileCellStyle: FileMessageCollectionViewCellStyleProtocol = FileMessageCollectionViewCellDefaultStyle()
    open lazy var baseCellStyle: BaseMessageCollectionViewCellStyleProtocol = BaseMessageCollectionViewCellDefaultSyle()

    open func canHandle(_ messageItem: MessageItemProtocol) -> Bool {
        return messageItem is FileMessageModelProtocol ? true : false
    }

    open func createPresenter(with messageItem: MessageItemProtocol) -> ItemPresenterProtocol {
        assert(self.canHandle(messageItem))
        return FileMessagePresenter<ViewModelBuilderT, InteractionHandlerT>(
            messageModel: messageItem as! ModelT,
            viewModelBuilder: self.viewModelBuilder,
            interactionHandler: self.interactionHandler,
            sizingCell: sizingCell,
            baseCellStyle: self.baseCellStyle,
            fileCellStyle: self.fileCellStyle
        )
    }

    open var presenterType: ItemPresenterProtocol.Type {
        return FileMessagePresenter<ViewModelBuilderT, InteractionHandlerT>.self
    }
}
