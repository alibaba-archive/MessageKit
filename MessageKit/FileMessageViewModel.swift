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

public class FileMessageViewModel: FileMessageViewModelProtocol {
    public var fileName: String
    public var fileSize: String
    public var fileFolderColor: UIColor
    public var messageViewModel: MessageViewModelProtocol
    
    public init(messageViewModel: MessageViewModelProtocol, fileName: String, fileSize: String, fileFolderColor: UIColor) {
        self.fileName = fileName
        self.fileSize = fileSize
        self.fileFolderColor = fileFolderColor
        self.messageViewModel = messageViewModel
    }
}

public class FileMessageViewModelDefaultBuilder: ViewModelBuilderProtocol {
    public init() { }
    
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    public func createViewModel(model: FileMessageModel) -> FileMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let fileMessageViewModel = FileMessageViewModel(messageViewModel: messageViewModel, fileName: model.fileName, fileSize: model.fileSize, fileFolderColor: model.fileFolderColor)
        return fileMessageViewModel
    }
}
