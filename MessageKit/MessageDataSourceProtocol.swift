//
//  MessageDataSourceProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol MessageDataSourceDelegateProtocol: class {

    func MessageDataSourceDidUpdate(_ messageDataSource: MessageDataSourceProtocol)
}

public protocol MessageDataSourceProtocol: class {

    var hasMoreNext: Bool { get }
    var hasMorePrevious: Bool { get }
    var messageItems: [MessageItemProtocol] { get set }
    weak var delegate: MessageDataSourceDelegateProtocol? { get set }

    func loadNext(_ completion: () -> Void)
    func loadPrevious(_ completion: () -> Void)
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion:(_ didAdjust: Bool) -> Void) // If you want, implement message count contention for performance, otherwise just call completion(false)
}
