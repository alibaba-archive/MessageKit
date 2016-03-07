//
//  FileMessagePresenterBuilder.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public class FileMessagePresenterBuilder<ViewModelBuilderT, InteractionHandlerT where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: FileMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: FileMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT
>: ItemPresenterBuilderProtocol {
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
    public lazy var sizingCell: FileMessageCollectionViewCell = FileMessageCollectionViewCell.sizingCell()
    public lazy var fileCellStyle: FileMessageCollectionViewCellStyleProtocol = FileMessageCollectionViewCellDefaultStyle()
    public lazy var baseCellStyle: BaseMessageCollectionViewCellStyleProtocol = BaseMessageCollectionViewCellDefaultSyle()
    
    public func canHandleMessageItem(messageItem: MessageItemProtocol) -> Bool {
        return messageItem is FileMessageModelProtocol ? true : false
    }
    
    public func createPresenterWithMessageItem(messageItem: MessageItemProtocol) -> ItemPresenterProtocol {
        assert(self.canHandleMessageItem(messageItem))
        return FileMessagePresenter<ViewModelBuilderT, InteractionHandlerT>(
            messageModel: messageItem as! ModelT,
            viewModelBuilder: self.viewModelBuilder,
            interactionHandler: self.interactionHandler,
            sizingCell: sizingCell,
            baseCellStyle: self.baseCellStyle,
            fileCellStyle: self.fileCellStyle
        )
    }
    
    public var presenterType: ItemPresenterProtocol.Type {
        return FileMessagePresenter<ViewModelBuilderT, InteractionHandlerT>.self
    }
}
