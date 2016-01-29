//
//  MessagesBubbleImage.swift
//  MessageKit
//
//  Created by ChenHao on 1/29/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

class MessagesBubbleImage: NSObject {
    private(set) var messageBubbleImage: UIImage
    private(set) var messageBubbleHighlightedImage: UIImage
    
    init(messageBubbleImage: UIImage, messageBubbleHighlightedImage: UIImage) {
        self.messageBubbleImage = messageBubbleImage
        self.messageBubbleHighlightedImage = messageBubbleHighlightedImage
    }
}
