//
//  CustomMessagePresenterBuilder.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/16.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public class CustomMessagePresenterBuilder<ViewModelBuilderT, InteractionHandlerT where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: CustomMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: CustomMessageViewModelProtocol,
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
    public lazy var sizingCell: CustomMessageCollectionViewCell = CustomMessageCollectionViewCell.sizingCell()
    public lazy var customCellStyle: CustomMessageCollectionViewCellStyleProtocol = CustomMessageCollectionViewCellDefaultStyle()
    public lazy var baseCellStyle: BaseMessageCollectionViewCellStyleProtocol = BaseMessageCollectionViewCellDefaultSyle()
    
    public func canHandleMessageItem(messageItem: MessageItemProtocol) -> Bool {
        return messageItem is CustomMessageModelProtocol ? true : false
    }
    
    public func createPresenterWithMessageItem(messageItem: MessageItemProtocol) -> ItemPresenterProtocol {
        assert(self.canHandleMessageItem(messageItem))
        return CustomMessagePresenter<ViewModelBuilderT, InteractionHandlerT>(
            messageModel: messageItem as! ModelT,
            viewModelBuilder: self.viewModelBuilder,
            interactionHandler: self.interactionHandler,
            sizingCell: sizingCell,
            baseCellStyle: self.baseCellStyle,
            customCellStyle: self.customCellStyle
        )
    }
    
    public var presenterType: ItemPresenterProtocol.Type {
        return CustomMessagePresenter<ViewModelBuilderT, InteractionHandlerT>.self
    }
}