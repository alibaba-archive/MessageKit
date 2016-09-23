//
//  PhotoMessageViewModel.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum TransferDirection {
    case upload
    case download
}

public enum TransferStatus {
    case idle
    case transfering
    case failed
    case success
}

public protocol PhotoMessageViewModelProtocol: DecoratedMessageViewModelProtocol {
    var transferDirection: Observable<TransferDirection> { get set }
    var transferProgress: Observable<Double> { get  set} // in [0,1]
    var transferStatus: Observable<TransferStatus> { get set }
    var imageClosure: PhotoClosure { get set }
    var imageSize: CGSize { get }
    func willBeShown() // Optional
    func wasHidden() // Optional
}

public extension PhotoMessageViewModelProtocol {
    func willBeShown() {}
    func wasHidden() {}
}

open class PhotoMessageViewModel: PhotoMessageViewModelProtocol {
    open var photoMessage: PhotoMessageModelProtocol
    open var transferStatus: Observable<TransferStatus> = Observable(.idle)
    open var transferProgress: Observable<Double> = Observable(0)
    open var transferDirection: Observable<TransferDirection> = Observable(.download)
    open var imageClosure: PhotoClosure
    open var imageSize: CGSize {
        return self.photoMessage.imageSize
    }
    open let messageViewModel: MessageViewModelProtocol
    open var showsFailedIcon: Bool {
        return self.messageViewModel.showsFailedIcon || self.transferStatus.value == .failed
    }

    public init(photoMessage: PhotoMessageModelProtocol, messageViewModel: MessageViewModelProtocol) {
        self.photoMessage = photoMessage
        self.imageClosure = photoMessage.imageClosure
        self.messageViewModel = messageViewModel
    }

    open func willBeShown() {
        // Need to declare empty. Otherwise subclass code won't execute (as of Xcode 7.2)
    }

    open func wasHidden() {
        // Need to declare empty. Otherwise subclass code won't execute (as of Xcode 7.2)
    }
}

open class PhotoMessageViewModelDefaultBuilder: ViewModelBuilderProtocol {

    public init() { }

    let messageViewModelBuilder = MessageViewModelDefaultBuilder()

    open func createViewModel(_ model: PhotoMessageModel) -> PhotoMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let photoMessageViewModel = PhotoMessageViewModel(photoMessage: model, messageViewModel: messageViewModel)
        return photoMessageViewModel
    }
}
