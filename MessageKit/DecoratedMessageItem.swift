//
//  DecoratedChatItem.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public struct DecoratedMessageItem {
    public let messageItem: MessageItemProtocol
    public let decorationAttributes: ItemDecorationAttributesProtocol?
    public init(messageItem: MessageItemProtocol, decorationAttributes: ItemDecorationAttributesProtocol?) {
        self.messageItem = messageItem
        self.decorationAttributes = decorationAttributes
    }
}