//
//  TextMessageViewModelProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol TextMessageViewModelProtocol: DecoratedMessageViewModelProtocol {

    var text: String { get }
}

open class TextMessageViewModel: TextMessageViewModelProtocol {

    open let text: String
    open let messageViewModel: MessageViewModelProtocol

    public init(text: String, messageViewModel: MessageViewModelProtocol) {
        self.text = text
        self.messageViewModel = messageViewModel
    }
}

open class TextMessageViewModelDefaultBuilder: ViewModelBuilderProtocol {

    public init() { }

    let messageViewModelBuilder = MessageViewModelDefaultBuilder()

    open func createViewModel(_ model: TextMessageModel) -> TextMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let textMessageViewModel = TextMessageViewModel(text: model.text, messageViewModel: messageViewModel)
        return textMessageViewModel

    }
}
