//
//  MessageItemProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public typealias MessageItemType = String

public protocol MessageItemProtocol: class {
    var type: MessageItemType { get }
}