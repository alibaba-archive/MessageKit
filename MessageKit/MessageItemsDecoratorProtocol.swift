//
//  MessageItemsDecoratorProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol MessageItemsDecoratorProtocol {
     func decorateItems(chatItems: [MessageItemProtocol]) -> [DecoratedMessageItem]
}