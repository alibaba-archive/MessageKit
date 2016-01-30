//
//  MessageMediaCellIncoming.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public class MessagePhotoCellIncoming: MessageMediaCell, NibReusable {

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configWithModel(model: PhotoMessage) {
        let size = resizePhoto(model.width, height: model.height)
        photoImageWidthConstraint.constant = size.width
        photoImageHeightConstraint.constant = size.height
        self.avatarImageView.image = UIImage(named: "avatar", inBundle: NSBundle(forClass: MessageViewController.classForCoder()), compatibleWithTraitCollection: nil)!.circularAvatarImageWithDiameter(36)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let newSize = self.resizePhoto(model.width, height: model.height)
            let image = model.photo.scaleToSize(newSize).clipRoundCorner(12)
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
