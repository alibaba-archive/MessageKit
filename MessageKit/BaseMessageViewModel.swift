//
//  BaseMessageViewModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum MessageViewModelStatus {
    case Success
    case Sending
    case Failed
}

public extension MessageStatus {
    public func viewModelStatus() -> MessageViewModelStatus {
        switch self {
        case .Success:
            return MessageViewModelStatus.Success
        case .Failed:
            return MessageViewModelStatus.Failed
        case .Sending:
            return MessageViewModelStatus.Sending
        }
    }
}

public protocol MessageViewModelProtocol: class {
    var isIncoming: Bool { get }
    var showsTail: Bool { get set }
    var showsFailedIcon: Bool { get }
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

public class MessageViewModel: MessageViewModelProtocol {
    public var isIncoming: Bool {
        return self.messageModel.isIncoming
    }
    
    public var status: MessageViewModelStatus {
        return self.messageModel.status.viewModelStatus()
    }
    
    public var showsTail: Bool
    public lazy var date: String = {
        return self.dateFormatter.stringFromDate(self.messageModel.date)
    }()
    
    public let dateFormatter: NSDateFormatter
    public private(set) var messageModel: MessageModelProtocol
    
    public init(dateFormatter: NSDateFormatter, showsTail: Bool, messageModel: MessageModelProtocol) {
        self.dateFormatter = dateFormatter
        self.showsTail = showsTail
        self.messageModel = messageModel
    }
    
    public var showsFailedIcon: Bool {
        return self.status == .Failed
    }
    
    public var avatarClosure: AvatarClosure? {
        return self.messageModel.avatarClosure
    }
}

public class MessageViewModelDefaultBuilder {
    
    public init() {}
    
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    public func createMessageViewModel(message: MessageModelProtocol) -> MessageViewModelProtocol {
        return MessageViewModel(dateFormatter: self.dynamicType.dateFormatter, showsTail: false, messageModel: message)
    }
}