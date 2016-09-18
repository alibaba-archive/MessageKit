//
//  FileMessageViewModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol FileMessageViewModelProtocol: DecoratedMessageViewModelProtocol {

    var fileName: String { get }
    var fileSize: String { get }
    var fileFolderColor: UIColor { get }
}

open class FileMessageViewModel: FileMessageViewModelProtocol {

    open var fileName: String
    open var fileSize: String
    open var fileFolderColor: UIColor
    open var messageViewModel: MessageViewModelProtocol

    public init(messageViewModel: MessageViewModelProtocol, fileName: String, fileSize: String, fileFolderColor: UIColor) {
        self.fileName = fileName
        self.fileSize = fileSize
        self.fileFolderColor = fileFolderColor
        self.messageViewModel = messageViewModel
    }
}

open class FileMessageViewModelDefaultBuilder: ViewModelBuilderProtocol {

    public init() { }

    let messageViewModelBuilder = MessageViewModelDefaultBuilder()

    open func createViewModel(_ model: FileMessageModel) -> FileMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let fileMessageViewModel = FileMessageViewModel(messageViewModel: messageViewModel, fileName: model.fileName, fileSize: model.fileSize, fileFolderColor: model.fileFolderColor)
        return fileMessageViewModel
    }
}
