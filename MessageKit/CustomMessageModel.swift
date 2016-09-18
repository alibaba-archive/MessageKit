//
//  CustomMessageModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/16.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol CustomMessageModelProtocol: DecoratedMessageModelProtocol {

    var customView: UIView { get }
}

open class CustomMessageModel: CustomMessageModelProtocol {

    open let messageModel: MessageModelProtocol
    open var customView: UIView
    open var uid: String { return messageModel.uid }

    public init(messageModel: MessageModelProtocol, customView: UIView) {
        self.messageModel = messageModel
        self.customView = customView
    }
}
