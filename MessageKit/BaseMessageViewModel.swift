//
//  BaseMessageViewModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum MessageViewModelStatus {
    case success
    case sending
    case failed
}

public extension MessageStatus {

    public func viewModelStatus() -> MessageViewModelStatus {
        switch self {
        case .success:
            return MessageViewModelStatus.success
        case .failed:
            return MessageViewModelStatus.failed
        case .sending:
            return MessageViewModelStatus.sending
        }
    }
}

public protocol MessageViewModelProtocol: class {

    var isIncoming: Bool { get }
    var showsTail: Bool { get set }
    var showsFailedIcon: Bool { get }
    var showsBorder: Bool { get }
    var date: String { get }
    var status: MessageViewModelStatus { get }
    var messageModel: MessageModelProtocol { get }
    var avatarClosure: AvatarClosure? { get }
}

public protocol DecoratedMessageViewModelProtocol: MessageViewModelProtocol {

    var messageViewModel: MessageViewModelProtocol { get }
}

extension DecoratedMessageViewModelProtocol {

    public var isIncoming: Bool {
        return self.messageViewModel.isIncoming
    }

    public var showsTail: Bool {
        get {
            return self.messageViewModel.showsTail
        }
        set {
            self.messageViewModel.showsTail = newValue
        }
    }

    public var showsBorder: Bool {
        return self.messageViewModel.showsBorder
    }

    public var date: String {
        return self.messageViewModel.date
    }

    public var status: MessageViewModelStatus {
        return self.messageViewModel.status
    }

    public var showsFailedIcon: Bool {
        return self.messageViewModel.showsFailedIcon
    }

    public var messageModel: MessageModelProtocol {
        return self.messageViewModel.messageModel
    }

    public var avatarClosure: AvatarClosure? {
        return self.messageViewModel.avatarClosure
    }
}

open class MessageViewModel: MessageViewModelProtocol {

    open var isIncoming: Bool {
        return self.messageModel.isIncoming
    }

    open var status: MessageViewModelStatus {
        return self.messageModel.status.viewModelStatus()
    }

    open var showsTail: Bool
    open lazy var date: String = {
        return self.messageModel.dateLabel
    }()

    open fileprivate(set) var messageModel: MessageModelProtocol

    public init(showsTail: Bool, messageModel: MessageModelProtocol) {
        self.showsTail = showsTail
        self.messageModel = messageModel
    }

    open var showsFailedIcon: Bool {
        return self.status == .failed
    }

    open var avatarClosure: AvatarClosure? {
        return self.messageModel.avatarClosure
    }

    open var showsBorder: Bool {
        return self.messageModel.showsBorder
    }
}

open class MessageViewModelDefaultBuilder {

    public init() {}

    open func createMessageViewModel(_ message: MessageModelProtocol) -> MessageViewModelProtocol {
        return MessageViewModel(showsTail: false, messageModel: message)
    }
}
