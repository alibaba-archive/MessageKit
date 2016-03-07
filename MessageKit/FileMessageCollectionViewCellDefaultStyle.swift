//
//  FileMessageCollectionViewCellDefaultStyle.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public class FileMessageCollectionViewCellDefaultStyle: FileMessageCollectionViewCellStyleProtocol {
    
    public init () {}
    
    lazy var baseStyle = BaseMessageCollectionViewCellDefaultSyle()
    lazy var images: [String: UIImage] = {
        return [
            "incoming_tail" : UIImage(named: "bubble-incoming-tail", inBundle: NSBundle(forClass: FileMessageCollectionViewCellDefaultStyle.self), compatibleWithTraitCollection: nil)!,
            "incoming_notail" : UIImage(named: "bubble-incoming", inBundle: NSBundle(forClass: FileMessageCollectionViewCellDefaultStyle.self), compatibleWithTraitCollection: nil)!,
            "outgoing_tail" : UIImage(named: "bubble-outgoing-tail", inBundle: NSBundle(forClass: FileMessageCollectionViewCellDefaultStyle.self), compatibleWithTraitCollection: nil)!,
            "outgoing_notail" : UIImage(named: "bubble-outgoing", inBundle: NSBundle(forClass: FileMessageCollectionViewCellDefaultStyle.self), compatibleWithTraitCollection: nil)!,
        ]
    }()
    
    lazy var titleFont = {
        return UIFont.systemFontOfSize(16)
    }()
    
    lazy var textFont = {
        return UIFont.systemFontOfSize(14)
    }()
    
    public func bubbleImage(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIImage {
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
    
    public func bubbleImageBorder(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIImage? {
        return self.baseStyle.borderImage(viewModel: viewModel)
    }
    
    public func titleFont(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIFont {
        return titleFont
    }
    public func titleColor(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIColor {
        return UIColor.blackColor()
    }
    public func textFont(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIFont {
        return textFont
    }
    public func textColor(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIColor {
        return UIColor.grayColor()
    }
    
    private func createImage(templateImage image: UIImage, isIncoming: Bool, status: MessageViewModelStatus, isSelected: Bool) -> UIImage {
        var color = isIncoming ? self.baseStyle.baseColorIncoming : self.baseStyle.baseColorOutgoing
        
        switch status {
        case .Success:
            break
        case .Failed, .Sending:
            color = color.bma_blendWithColor(UIColor.whiteColor().colorWithAlphaComponent(0.70))
        }
        
        if isSelected {
            color = color.bma_blendWithColor(UIColor.blackColor().colorWithAlphaComponent(0.10))
        }
        
        return image.bma_tintWithColor(color)
    }
    
    private func imageKey(isIncoming isIncoming: Bool, status: MessageViewModelStatus, showsTail: Bool, isSelected: Bool) -> String {
        let directionKey = isIncoming ? "incoming" : "outgoing"
        let tailKey = showsTail ? "tail" : "notail"
        let statusKey = self.statusKey(status)
        let highlightedKey = isSelected ? "highlighted" : "normal"
        let key = "\(directionKey)_\(tailKey)_\(statusKey)_\(highlightedKey)"
        return key
    }
    
    private func templateKey(isIncoming isIncoming: Bool, showsTail: Bool) -> String {
        let directionKey = isIncoming ? "incoming" : "outgoing"
        let tailKey = showsTail ? "tail" : "notail"
        return "\(directionKey)_\(tailKey)"
    }
    
    private func statusKey(status: MessageViewModelStatus) -> NSString {
        switch status {
        case .Success:
            return "ok"
        case .Sending:
            return "sending"
        case .Failed:
            return "failed"
        }
    }
}