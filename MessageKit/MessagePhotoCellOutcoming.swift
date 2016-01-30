//
//  MessagePhotoCellOutcoming.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

class MessagePhotoCellOutcoming: MessageMediaCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func nib() -> UINib {
        return UINib(nibName: String(MessagePhotoCellOutcoming), bundle: NSBundle(forClass: MessagePhotoCellOutcoming.self))
    }
    
    class func cellIdentifer() -> String {
        return String(MessagePhotoCellOutcoming)
    }
    
    func configWithModel(model: PhotoMessage) {
        let size = resizePhoto(model.width, height: model.height)
        photoImageWidthConstraint.constant = size.width
        photoImageHeightConstraint.constant = size.height
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let image = model.photo.scaleToSize(CGSize(width: model.width, height: model.height)).clipRoundCorner(20)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.photoImageView.image = image
            })
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
