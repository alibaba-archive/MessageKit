//
//  CustomMessageViewModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/16.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol CustomMessageViewModelProtocol: DecoratedMessageViewModelProtocol {
    var customView: UIView { get }
}

public class CustomMessageViewModel: CustomMessageViewModelProtocol {
    public var customView: UIView
    public var messageViewModel: MessageViewModelProtocol
    
    public init(messageViewModel: MessageViewModelProtocol, customView: UIView) {
        self.customView = customView
        self.messageViewModel = messageViewModel
    }
}

public class CustomMessageViewModelDefaultBuilder: ViewModelBuilderProtocol {
    public init() { }
    
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    public func createViewModel(model: CustomMessageModel) -> CustomMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let customMessageViewModel = CustomMessageViewModel(messageViewModel: messageViewModel, customView: model.customView)
        return customMessageViewModel
    }
}
