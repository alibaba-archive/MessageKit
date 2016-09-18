//
//  TextMessagePresenterBuilder.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

open class TextMessagePresenterBuilder<ViewModelBuilderT, InteractionHandlerT>
: ItemPresenterBuilderProtocol where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: TextMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: TextMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT {

    typealias ViewModelT = ViewModelBuilderT.ViewModelT
    typealias ModelT = ViewModelBuilderT.ModelT

    public init(
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT? = nil) {
            self.viewModelBuilder = viewModelBuilder
            self.interactionHandler = interactionHandler
    }

    let viewModelBuilder: ViewModelBuilderT
    let interactionHandler: InteractionHandlerT?
    let layoutCache = NSCache<AnyObject, AnyObject>()

    lazy var sizingCell: TextMessageCollectionViewCell = {
        var cell: TextMessageCollectionViewCell? = nil
        if Thread.isMainThread {
            cell = TextMessageCollectionViewCell.sizingCell()
        } else {
            DispatchQueue.main.sync(execute: {
                cell =  TextMessageCollectionViewCell.sizingCell()
            })
        }

        return cell!
    }()

    open lazy var textCellStyle: TextMessageCollectionViewCellStyleProtocol = TextMessageCollectionViewCellDefaultStyle()
    open lazy var baseMessageStyle: BaseMessageCollectionViewCellStyleProtocol = BaseMessageCollectionViewCellDefaultSyle()

    open func canHandle(_ messageItem: MessageItemProtocol) -> Bool {
        return messageItem is TextMessageModelProtocol ? true : false
    }

    open func createPresenter(withMessageItem messageItem: MessageItemProtocol) -> ItemPresenterProtocol {
        assert(canHandle(messageItem))
        return TextMessagePresenter<ViewModelBuilderT, InteractionHandlerT>(
            messageModel: messageItem as! ModelT,
            viewModelBuilder: self.viewModelBuilder,
            interactionHandler: self.interactionHandler,
            sizingCell: sizingCell,
            baseCellStyle: self.baseMessageStyle,
            textCellStyle: self.textCellStyle,
            layoutCache: self.layoutCache
        )
    }

    open var presenterType: ItemPresenterProtocol.Type {
        return TextMessagePresenter<ViewModelBuilderT, InteractionHandlerT>.self
    }
}
