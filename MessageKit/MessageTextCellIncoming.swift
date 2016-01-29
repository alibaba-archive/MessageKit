//
//  MessageTableViewCellIncomingTableViewCell.swift
//  MessageKit
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

class MessageTextCellIncoming: MessageTableViewCell {
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func nib() -> UINib {
        return UINib(nibName: String(MessageTextCellIncoming), bundle: NSBundle(forClass: MessageTextCellIncoming.self))
    }
    
    class func cellIdentifer() -> String {
        return String(MessageTextCellIncoming)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
