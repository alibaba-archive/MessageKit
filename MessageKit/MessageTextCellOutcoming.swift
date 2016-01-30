//
//  MessageTableViewCellOutcoming.swift
//  MessageKit
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

class MessageTextCellOutcoming: MessageTextCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func nib() -> UINib {
        return UINib(nibName: String(MessageTextCellOutcoming), bundle: NSBundle(forClass: MessageTextCellOutcoming.self))
    }
    
    class func cellIdentifer() -> String {
        return String(MessageTextCellOutcoming)
    }
    func configWithBubbleColor(color: UIColor) {
        let image = UIImage(named: "bubble", inBundle: NSBundle(forClass: MessageViewController.classForCoder()), compatibleWithTraitCollection: nil)!
        let capInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        let bubbleFactory = MessageBubbleImageFactory(bubbleImage: image, capInsets: capInsets)
        let messageImages = bubbleFactory.messagesBubbleImageWithColor(color)
        bubbleImageView.image = messageImages.messageBubbleImage
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
