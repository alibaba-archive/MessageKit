//
//  MessageMediaCell.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public class MessageMediaCell: MessageTableViewCell {

    @IBOutlet weak var mediaContainerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoImageHeightConstraint: NSLayoutConstraint!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func resizePhoto(width: Int, height: Int) -> CGSize {
        if width <= 200 {
            if height <= 300 {
                return CGSize(width: width, height: height)
            } else {
                return CGSize(width: width, height: 300)
            }
        } else {
            let newHeight: Int = Int(Double(height) / (Double(width) / 200.0))
            return resizePhoto(200, height: newHeight)
        }
    }
    
    func resizePhotoWithScale(width: Int, height: Int) -> CGSize {
        let scale = Int(UIScreen.mainScreen().scale)
        if width <= (200 * scale) {
            if height <= 300 * scale {
                return CGSize(width: width, height: height)
            } else {
                return CGSize(width: width, height: 300 * scale)
            }
        } else {
            let newHeight: Int = Int(Double(height) / (Double(width) / (200.0 * Double(scale))))
            return resizePhoto(200 * scale, height: newHeight)
        }
    }
    
    func configPhotoWithModel(model: PhotoMessage, withAvatar:Bool) {
        let size = resizePhoto(model.width, height: model.height)
        photoImageWidthConstraint.constant = size.width
        photoImageHeightConstraint.constant = size.height
        if (withAvatar) {
            self.avatarImageView.image = UIImage(named: "avatar", inBundle: NSBundle(forClass: MessageViewController.classForCoder()), compatibleWithTraitCollection: nil)!.circularAvatarImageWithDiameter(36)
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let newSize = self.resizePhoto(model.width, height: model.height)
            let image = model.photo.scaleToSize(newSize).clipRoundCorner(12)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.photoImageView.image = image
            })
        }
    }
}
