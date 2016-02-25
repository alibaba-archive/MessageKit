//
//  FileMessage.swift
//  MessageKit
//
//  Created by ChenHao on 16/2/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public class FileMessage: BasicMessage {
    
    public init(type: messageType, fileName: String) {
        super.init(type: type)
    }
}