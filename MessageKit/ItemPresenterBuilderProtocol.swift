//
//  MessageItemPresenterBuilderProtocol.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/2.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol ItemPresenterBuilderProtocol {

    var presenterType: ItemPresenterProtocol.Type { get }

    func canHandle(_ messageItem: MessageItemProtocol) -> Bool
    func createPresenter(withMessageItem messageItem: MessageItemProtocol) -> ItemPresenterProtocol

}
