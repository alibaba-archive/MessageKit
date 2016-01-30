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
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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

}
