//
//  MessageMediaCellIncoming.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public class MessagePhotoCellIncoming: MessageMediaCell {

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func nib() -> UINib {
        return UINib(nibName: String(MessagePhotoCellIncoming), bundle: NSBundle(forClass: MessagePhotoCellIncoming.self))
    }
    
    class func cellIdentifer() -> String {
        return String(MessagePhotoCellIncoming)
    }
    
    func configWithModel(model: PhotoMessage) {
        let size = resizePhoto(model.width, height: model.height)
        photoImageWidthConstraint.constant = size.width
        photoImageHeightConstraint.constant = size.height
        self.avatarImageView.image = UIImage(named: "avatar", inBundle: NSBundle(forClass: MessageViewController.classForCoder()), compatibleWithTraitCollection: nil)!.circularAvatarImageWithDiameter(36)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let image = model.photo.scaleToSize(CGSize(width: model.width, height: model.height)).clipRoundCorner(20)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.photoImageView.image = image
            })
        }
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
