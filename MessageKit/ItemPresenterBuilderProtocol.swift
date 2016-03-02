//
//  MessageItemPresenterBuilderProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol ItemPresenterBuilderProtocol {
    func canHandleMessageItem(messageItem: MessageItemProtocol) -> Bool
    func createPresenterWithMessageItem(messageItem: MessageItemProtocol) -> ItemPresenterProtocol
}