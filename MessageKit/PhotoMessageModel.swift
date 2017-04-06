//
//  PhotoMessageModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol PhotoMessageModelProtocol: DecoratedMessageModelProtocol {

    var imageSize: CGSize { get }
    var imageClosure: PhotoClosure { get }
}

public typealias PhotoClosure =  (_ imageview: UIImageView) -> ()

open class PhotoMessageModel: PhotoMessageModelProtocol {

    open var messageModel: MessageModelProtocol
    open let imageSize: CGSize
    open let imageClosure: PhotoClosure
    open var uid: String {
        get {
            return messageModel.uid
        }
        set {
            messageModel.uid = newValue
        }
    }

    public init(messageModel: MessageModelProtocol, imageSize: CGSize, imageClosure: @escaping PhotoClosure) {
        self.messageModel = messageModel
        self.imageSize = imageSize
        self.imageClosure = imageClosure
    }
}
