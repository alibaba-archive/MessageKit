//
//  TextMessageModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol TextMessageModelProtocol: DecoratedMessageModelProtocol {

    var text: String { get }
}

open class TextMessageModel: TextMessageModelProtocol {

    open var messageModel: MessageModelProtocol
    open let text: String
    open var uid: String {
        get {
            return messageModel.uid
        }
        set {
            messageModel.uid = newValue
        }
    }

    public init(messageModel: MessageModelProtocol, text: String) {
        self.messageModel = messageModel
        self.text = text
    }
}
