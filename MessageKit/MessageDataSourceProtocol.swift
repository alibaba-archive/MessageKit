//
//  MessageDataSourceProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol MessageDataSourceDelegateProtocol: class {
    func MessageDataSourceDidUpdate(messageDataSource: MessageDataSourceProtocol)
}

public protocol MessageDataSourceProtocol: class {
    
    var hasMoreNext: Bool { get }
    var hasMorePrevious: Bool { get }
    var chatItems: [MessageItemProtocol] { get }
    weak var delegate: MessageDataSourceDelegateProtocol? { get set }
    
    func loadNext(completion: () -> Void)
    func loadPrevious(completion: () -> Void)
    func adjustNumberOfMessages(preferredMaxCount preferredMaxCount: Int?, focusPosition: Double, completion:(didAdjust: Bool) -> Void) // If you want, implement message count contention for performance, otherwise just call completion(false)
}