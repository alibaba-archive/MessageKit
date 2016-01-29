//
//  MessageBubbleImageFactory.swift
//  MessageKit
//
//  Created by ChenHao on 1/29/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

class MessageBubbleImageFactory: NSObject {

    var bubbleImage: UIImage
    var capInsets: UIEdgeInsets
    
    init(bubbleImage: UIImage, capInsets: UIEdgeInsets) {
        self.bubbleImage = bubbleImage
        self.capInsets = capInsets
    }
}

extension MessageBubbleImageFactory {
    
    func messagesBubbleImageWithColor(color: UIColor) -> MessagesBubbleImage {
        var normalBubble = self.bubbleImage.imageMaskedWithColor(color)
        var hignlightBubble = self.bubbleImage.imageMaskedWithColor(color)
        
        normalBubble = stretchableImageFromImage(normalBubble, withCapInsets: capInsets)
        hignlightBubble = stretchableImageFromImage(hignlightBubble, withCapInsets: capInsets)
        return MessagesBubbleImage(messageBubbleImage: normalBubble, messageBubbleHighlightedImage: hignlightBubble)
    }
}

extension MessageBubbleImageFactory {
    private func stretchableImageFromImage(image: UIImage, withCapInsets inset: UIEdgeInsets ) -> UIImage {
        return image.resizableImageWithCapInsets(inset, resizingMode: .Stretch)
    }
}
