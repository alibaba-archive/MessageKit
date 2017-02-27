//
//  PhotoMessageModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol PhotoMessageModelProtocol: DecoratedMessageModelProtocol {
//    var image: UIImage { get }
    var imageSize: CGSize { get }
    var imageClosure: PhotoClosure { get }
}

public typealias PhotoClosure =  (imageview: UIImageView) -> ()

public class PhotoMessageModel: PhotoMessageModelProtocol {
    
    public var messageModel: MessageModelProtocol
//    public let image: UIImage
    public let imageSize: CGSize
    public let imageClosure: PhotoClosure
    
    public init(messageModel: MessageModelProtocol, imageSize: CGSize, imageClosure: PhotoClosure) {
        self.messageModel = messageModel
        self.imageSize = imageSize
        self.imageClosure = imageClosure
//        self.image = image
    }
    public var uid: String {
        get {
            return messageModel.uid
        }
        set {
            messageModel.uid = newValue
        }
    }
}