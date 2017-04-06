//
//  MessageItemProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public typealias MessageItemType = String

public protocol MessageItemProtocol: class, UniqueIdentificable {
    var type: MessageItemType { get }
}

public protocol UniqueIdentificable {
    var uid: String { get set }
}
