//
//  BaseMessageModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum MessageStatus {
    case failed
    case sending
    case success
}

public typealias AvatarClosure =  (_ imageview: UIImageView) -> ()

public protocol MessageModelProtocol: MessageItemProtocol {

    var senderId: String { get }
    var isIncoming: Bool { get }
    var showsBorder: Bool { get }
    var dateLabel: String { get }
    var status: MessageStatus { get set }
    var avatarClosure: AvatarClosure? { get }
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

open class MessageModel: MessageModelProtocol {

    open var uid: String
    open var senderId: String
    open var type: String
    open var showsBorder: Bool
    open var isIncoming: Bool
    open var dateLabel: String
    open var status: MessageStatus
    open var avatarClosure: AvatarClosure?

    public init(uid: String, senderId: String, type: String, isIncoming: Bool, showsBorder: Bool, dateLabel: String, status: MessageStatus, avatarClosure: @escaping AvatarClosure) {
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
