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

public class TextMessageViewModel: TextMessageViewModelProtocol {
    public let text: String
    public let messageViewModel: MessageViewModelProtocol
    
    public init(text: String, messageViewModel: MessageViewModelProtocol) {
        self.text = text
        self.messageViewModel = messageViewModel
    }
}

public class TextMessageViewModelDefaultBuilder: ViewModelBuilderProtocol {
    public init() { }
    
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    public func createViewModel(model: TextMessageModel) -> TextMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let textMessageViewModel = TextMessageViewModel(text: model.text, messageViewModel: messageViewModel)
        return textMessageViewModel
        
    }
}
