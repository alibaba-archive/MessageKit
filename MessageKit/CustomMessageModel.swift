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

public class CustomMessageModel: CustomMessageModelProtocol {
    public var messageModel: MessageModelProtocol
    public var customView: UIView
    
    public init(messageModel: MessageModelProtocol, customView: UIView) {
        self.messageModel = messageModel
        self.customView = customView
    }
    public var uid: String {
        get {
           return messageModel.uid
        }
        set {
            messageModel.uid = newValue
        }
    }
}