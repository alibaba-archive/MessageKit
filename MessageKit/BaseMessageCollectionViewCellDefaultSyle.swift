//
//  BaseMessageCollectionViewCellDefaultSyle.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public class BaseMessageCollectionViewCellDefaultSyle: BaseMessageCollectionViewCellStyleProtocol {
    
    public init () {}
    
    lazy var baseColorIncoming = UIColor.bma_color(rgb: 0xF2F2F2)
    lazy var baseColorOutgoing = UIColor.bma_color(rgb: 0x03A9F4)
    
    lazy var borderIncomingTail: UIImage = {
        return UIImage(named: "bubble-incoming-border-tail", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!
    }()
    
    lazy var borderIncomingNoTail: UIImage = {
        return UIImage(named: "bubble-incoming-border", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!
    }()
    
    lazy var borderOutgoingTail: UIImage = {
        return UIImage(named: "bubble-outgoing-border-tail", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!
    }()
    
    lazy var borderOutgoingNoTail: UIImage = {
        return UIImage(named: "bubble-outgoing-border", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!
    }()
    
    public lazy var failedIcon: UIImage = {
        return UIImage(named: "base-message-failed-icon", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!
    }()
    
    public lazy var failedIconHighlighted: UIImage = {
        return self.failedIcon.bma_blendWithColor(UIColor.blackColor().colorWithAlphaComponent(0.10))
    }()
    
    private lazy var dateFont = {
        return UIFont.systemFontOfSize(12.0)
    }()
    
    public func attributedStringForDate(date: String) -> NSAttributedString {
        let attributes = [NSFontAttributeName : self.dateFont]
        return NSAttributedString(string: date, attributes: attributes)
    }
    
    func borderImage(viewModel viewModel: MessageViewModelProtocol) -> UIImage? {
        switch (viewModel.isIncoming, viewModel.showsTail) {
        case (true, true):
            return self.borderIncomingTail
        case (true, false):
            return self.borderIncomingNoTail
        case (false, true):
            return self.borderOutgoingTail
        case (false, false):
            return self.borderOutgoingNoTail
        }
    }
}
