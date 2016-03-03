//
//  BaseMessageModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum MessageStatus {
    case Failed
    case Sending
    case Success
}

public protocol MessageModelProtocol: MessageItemProtocol {
    var senderId: String { get }
    var isIncoming: Bool { get }
    var date: NSDate { get }
    var status: MessageStatus { get set }
}

public protocol DecoratedMessageModelProtocol: MessageModelProtocol {
    var messageModel: MessageModelProtocol { get }
}

public extension DecoratedMessageModelProtocol {
    var uid: String {
        return self.messageModel.uid
    }
    
    var senderId: String {
        return self.messageModel.senderId
    }
    
    var type: String {
        return self.messageModel.type
    }
    
    var isIncoming: Bool {
        return self.messageModel.isIncoming
    }
    
    var date: NSDate {
        return self.messageModel.date
    }
    
    var status: MessageStatus {
        get {
            return self.messageModel.status
        }
        set {
            self.messageModel.status = newValue
        }
    }
}

public class MessageModel: MessageModelProtocol {
    public var uid: String
    public var senderId: String
    public var type: String
    public var isIncoming: Bool
    public var date: NSDate
    public var status: MessageStatus
    
    public init(uid: String, senderId: String, type: String, isIncoming: Bool, date: NSDate, status: MessageStatus) {
        self.uid = uid
        self.senderId = senderId
        self.type = type
        self.isIncoming = isIncoming
        self.date = date
        self.status = status
    }
}