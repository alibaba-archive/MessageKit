//
//  PhotoMessageModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol PhotoMessageModelProtocol: DecoratedMessageModelProtocol {
    var image: UIImage { get }
    var imageSize: CGSize { get }
}

public class PhotoMessageModel: PhotoMessageModelProtocol {
    public let messageModel: MessageModelProtocol
    public let image: UIImage
    public let imageSize: CGSize
    
    public init(messageModel: MessageModelProtocol, imageSize: CGSize, image: UIImage) {
        self.messageModel = messageModel
        self.imageSize = imageSize
        self.image = image
    }
    public var uid: String { return messageModel.uid }
}