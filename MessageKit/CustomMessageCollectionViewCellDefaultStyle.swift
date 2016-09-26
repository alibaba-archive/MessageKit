//
//  CustomMessageCollectionViewCellDefaultStyle.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/16.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation


open class CustomMessageCollectionViewCellDefaultStyle: CustomMessageCollectionViewCellStyleProtocol {

    public init () {}

    lazy var baseStyle = BaseMessageCollectionViewCellDefaultSyle()
    lazy var images: [String: UIImage] = {
        return [
            "incoming_tail" : UIImage(named: "bubble-incoming-tail", in: Bundle(for: CustomMessageCollectionViewCellDefaultStyle.self), compatibleWith: nil)!,
            "incoming_notail" : UIImage(named: "bubble-incoming", in: Bundle(for: CustomMessageCollectionViewCellDefaultStyle.self), compatibleWith: nil)!,
            "outgoing_tail" : UIImage(named: "bubble-outgoing-tail", in: Bundle(for: CustomMessageCollectionViewCellDefaultStyle.self), compatibleWith: nil)!,
            "outgoing_notail" : UIImage(named: "bubble-outgoing", in: Bundle(for: CustomMessageCollectionViewCellDefaultStyle.self), compatibleWith: nil)!,
        ]
    }()

    lazy var folderCoverImage: UIImage = {
        return UIImage(named: "folder-cover", in: Bundle(for: CustomMessageCollectionViewCellDefaultStyle.self), compatibleWith: nil)!
    }()

    lazy var titleFont = {
        return UIFont.systemFont(ofSize: 16)
    }()

    lazy var textFont = {
        return UIFont.systemFont(ofSize: 14)
    }()

    open func folderImage(viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIImage {
        return folderCoverImage
    }

    open func bubbleImage(viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIImage {
        let key = self.imageKey(isIncoming: viewModel.isIncoming, status: viewModel.status, showsTail: viewModel.showsTail, isSelected: isSelected)

        if let image = self.images[key] {
            return image
        } else {
            let templateKey = self.templateKey(isIncoming: viewModel.isIncoming, showsTail: viewModel.showsTail)
            if let image = self.images[templateKey] {
                let image = self.createImage(templateImage: image, isIncoming: viewModel.isIncoming, status: viewModel.status, isSelected: isSelected)
                self.images[key] = image
                return image
            }
        }

        assert(false, "coulnd't find image for this status. ImageKey: \(key)")
        return UIImage()
    }

    open func bubbleImageBorder(viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIImage? {
        return self.baseStyle.borderImage(viewModel: viewModel)
    }

    open func titleFont(viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIFont {
        return titleFont
    }
    open func titleColor(viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIColor {
        return UIColor.black
    }
    open func textFont(viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIFont {
        return textFont
    }
    open func textColor(viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIColor {
        return UIColor.gray
    }

    fileprivate func createImage(templateImage image: UIImage, isIncoming: Bool, status: MessageViewModelStatus, isSelected: Bool) -> UIImage {
        var color = self.baseStyle.baseColorIncoming

        switch status {
        case .success:
            break
        case .failed, .sending:
            color = color.bmaBlendWithColor(UIColor.white.withAlphaComponent(0.70))
        }

        if isSelected {
            color = color.bmaBlendWithColor(UIColor.black.withAlphaComponent(0.10))
        }

        return image.bmaTintWithColor(color)
    }

    fileprivate func imageKey(isIncoming: Bool, status: MessageViewModelStatus, showsTail: Bool, isSelected: Bool) -> String {
        let directionKey = isIncoming ? "incoming" : "outgoing"
        let tailKey = showsTail ? "tail" : "notail"
        let statusKey = self.statusKey(status)
        let highlightedKey = isSelected ? "highlighted" : "normal"
        let key = "\(directionKey)_\(tailKey)_\(statusKey)_\(highlightedKey)"
        return key
    }

    fileprivate func templateKey(isIncoming: Bool, showsTail: Bool) -> String {
        let directionKey = isIncoming ? "incoming" : "outgoing"
        let tailKey = showsTail ? "tail" : "notail"
        return "\(directionKey)_\(tailKey)"
    }

    fileprivate func statusKey(_ status: MessageViewModelStatus) -> String {
        switch status {
        case .success:
            return "ok"
        case .sending:
            return "sending"
        case .failed:
            return "failed"
        }
    }
}
