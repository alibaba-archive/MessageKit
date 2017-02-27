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

public typealias AvatarClosure =  (imageview: UIImageView) -> ()

public protocol MessageModelProtocol: MessageItemProtocol {
    
    var senderId: String { get }
    var isIncoming: Bool { get }
    var showsBorder: Bool { get }
    var dateLabel: String { get }
    var status: MessageStatus { get set }
    var avatarClosure: AvatarClosure? { get }
}

public protocol DecoratedMessageModelProtocol: MessageModelProtocol {
    var messageModel: MessageModelProtocol { get set }
    var uid: String { get set }
}

public extension DecoratedMessageModelProtocol {
    var uid: String {
        get {
            return self.messageModel.uid
        }
        set {
            self.messageModel.uid = newValue
        }
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
    
    var showsBorder: Bool {
        return self.messageModel.showsBorder
    }
    
    var dateLabel: String {
        return self.messageModel.dateLabel
    }
    
    var status: MessageStatus {
        get {
            return self.messageModel.status
        }
        set {
            self.messageModel.status = newValue
        }
    }
    
    var avatarClosure: AvatarClosure? {
        return self.messageModel.avatarClosure
    }
}

public class MessageModel: MessageModelProtocol {
    public var uid: String
    public var senderId: String
    public var type: String
    public var showsBorder: Bool
    public var isIncoming: Bool
    public var dateLabel: String
    public var status: MessageStatus
    public var avatarClosure: AvatarClosure?
    
    public init(uid: String, senderId: String, type: String, isIncoming: Bool, showsBorder: Bool, dateLabel: String, status: MessageStatus, avatarClosure: AvatarClosure) {
        self.uid = uid
        self.senderId = senderId
        self.type = type
        self.isIncoming = isIncoming
        self.showsBorder = showsBorder
        self.dateLabel = dateLabel
        self.status = status
        self.avatarClosure = avatarClosure
    }
}