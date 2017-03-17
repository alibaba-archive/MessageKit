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

open class FileMessageModel: FileMessageModelProtocol {

    open var messageModel: MessageModelProtocol
    open var fileName: String
    open var fileSize: String
    open var fileFolderColor: UIColor
    open var uid: String {
        get {
            return messageModel.uid
        }
        set {
            messageModel.uid = newValue
        }
    }

    public init(messageModel: MessageModelProtocol, fileName: String, fileSize: String, fileFolderColor: UIColor) {
        self.messageModel = messageModel
        self.fileName = fileName
        self.fileSize = fileSize
        self.fileFolderColor = fileFolderColor
    }

}
