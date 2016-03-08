//
//  FileMessageModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol FileMessageModelProtocol: DecoratedMessageModelProtocol {
    var fileName: String { get }
    var fileSize: String { get }
    var fileFolderColor: UIColor { get }
}

public class FileMessageModel: FileMessageModelProtocol {
    public let messageModel: MessageModelProtocol
    public var fileName: String
    public var fileSize: String
    public var fileFolderColor: UIColor
    
    public init(messageModel: MessageModelProtocol, fileName: String, fileSize: String, fileFolderColor: UIColor) {
        self.messageModel = messageModel
        self.fileName = fileName
        self.fileSize = fileSize
        self.fileFolderColor = fileFolderColor
    }
    public var uid: String { return messageModel.uid }
}