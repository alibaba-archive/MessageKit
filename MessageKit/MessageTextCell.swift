//
//  MessageTextCell.swift
//  MessageKit
//
//  Created by ChenHao on 1/29/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public class MessageTextCell: MessageTableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
