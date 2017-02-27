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

public class TextMessageModel: TextMessageModelProtocol {
    public var messageModel: MessageModelProtocol
    public let text: String
    public init(messageModel: MessageModelProtocol, text: String) {
        self.messageModel = messageModel
        self.text = text
    }
    public var uid: String {
        get {
           return self.messageModel.uid
        }
        set {
            messageModel.uid = newValue
        }
    }
}