//
//  PhotoMessagePresenterBuilder.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public class PhotoMessagePresenterBuilder<ViewModelBuilderT, InteractionHandlerT where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: PhotoMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: PhotoMessageViewModelProtocol,
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
    public lazy var sizingCell: PhotoMessageCollectionViewCell = PhotoMessageCollectionViewCell.sizingCell()
    public lazy var photoCellStyle: PhotoMessageCollectionViewCellStyleProtocol = PhotoMessageCollectionViewCellDefaultStyle()
    public lazy var baseCellStyle: BaseMessageCollectionViewCellStyleProtocol = BaseMessageCollectionViewCellDefaultSyle()
    
    public func canHandleMessageItem(messageItem: MessageItemProtocol) -> Bool {
        return messageItem is PhotoMessageModelProtocol ? true : false
    }
    
    public func createPresenterWithMessageItem(messageItem: MessageItemProtocol) -> ItemPresenterProtocol {
        assert(self.canHandleMessageItem(messageItem))
        return PhotoMessagePresenter<ViewModelBuilderT, InteractionHandlerT>(
            messageModel: messageItem as! ModelT,
            viewModelBuilder: self.viewModelBuilder,
            interactionHandler: self.interactionHandler,
            sizingCell: sizingCell,
            baseCellStyle: self.baseCellStyle,
            photoCellStyle: self.photoCellStyle
        )
    }
    
    public var presenterType: ItemPresenterProtocol.Type {
        return PhotoMessagePresenter<ViewModelBuilderT, InteractionHandlerT>.self
    }
}
