//
//  PhotoMessageViewModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum TransferDirection {
    case Upload
    case Download
}

public enum TransferStatus {
    case Idle
    case Transfering
    case Failed
    case Success
}

public protocol PhotoMessageViewModelProtocol: DecoratedMessageViewModelProtocol {
    var transferDirection: Observable<TransferDirection> { get set }
    var transferProgress: Observable<Double> { get  set} // in [0,1]
    var transferStatus: Observable<TransferStatus> { get set }
    var image: Observable<UIImage?> { get set }
    var imageSize: CGSize { get }
    func willBeShown() // Optional
    func wasHidden() // Optional
}

public extension PhotoMessageViewModelProtocol {
    func willBeShown() {}
    func wasHidden() {}
}

public class PhotoMessageViewModel: PhotoMessageViewModelProtocol {
    public var photoMessage: PhotoMessageModelProtocol
    public var transferStatus: Observable<TransferStatus> = Observable(.Idle)
    public var transferProgress: Observable<Double> = Observable(0)
    public var transferDirection: Observable<TransferDirection> = Observable(.Download)
    public var image: Observable<UIImage?>
    public var imageSize: CGSize {
        return self.photoMessage.imageSize
    }
    public let messageViewModel: MessageViewModelProtocol
    public var showsFailedIcon: Bool {
        return self.messageViewModel.showsFailedIcon || self.transferStatus.value == .Failed
    }
    
    public init(photoMessage: PhotoMessageModelProtocol, messageViewModel: MessageViewModelProtocol) {
        self.photoMessage = photoMessage
        self.image = Observable(photoMessage.image)
        self.messageViewModel = messageViewModel
    }
    
    public func willBeShown() {
        // Need to declare empty. Otherwise subclass code won't execute (as of Xcode 7.2)
    }
    
    public func wasHidden() {
        // Need to declare empty. Otherwise subclass code won't execute (as of Xcode 7.2)
    }
}

public class PhotoMessageViewModelDefaultBuilder: ViewModelBuilderProtocol {
    public init() { }
    
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    public func createViewModel(model: PhotoMessageModel) -> PhotoMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let photoMessageViewModel = PhotoMessageViewModel(photoMessage: model, messageViewModel: messageViewModel)
        return photoMessageViewModel
    }
}
