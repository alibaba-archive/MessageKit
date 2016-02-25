//
//  MessageFileCell.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public class MessageFileCell: MessageTableViewCell {

    @IBOutlet weak var bubbleImageView: UIImageView!
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configFileWithModel(model: FileMessage, withAvatar:Bool) {
        
        let image = UIImage(named: "bubble", inBundle: NSBundle(forClass: MessageViewController.classForCoder()), compatibleWithTraitCollection: nil)!
        let capInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        let bubbleFactory = MessageBubbleImageFactory(bubbleImage: image, capInsets: capInsets)
        
        let messageImages = bubbleFactory.messagesBubbleImageWithColor(UIColor.redColor())
        bubbleImageView.image = messageImages.messageBubbleImage
        
        
        if (withAvatar) {
            self.avatarImageView.image = UIImage(named: "avatar", inBundle: NSBundle(forClass: MessageViewController.classForCoder()), compatibleWithTraitCollection: nil)!.circularAvatarImageWithDiameter(36)
        }
    }

}
