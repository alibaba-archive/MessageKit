//
//  BaseMessageCollectionViewCellDefaultSyle.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

open class BaseMessageCollectionViewCellDefaultSyle: BaseMessageCollectionViewCellStyleProtocol {

    public init () {}

    lazy var baseColorIncoming = UIColor.bmaColor(rgb: 0xF2F2F2)
    lazy var baseColorOutgoing = UIColor.bmaColor(rgb: 0x03A9F4)
    open lazy var baseColorTimestampText = UIColor.bmaColor(rgb: 0xAAAAAA)

    lazy var borderIncomingTail: UIImage = {
        return UIImage(named: "bubble-incoming-border-tail", in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }()

    lazy var borderIncomingNoTail: UIImage = {
        return UIImage(named: "bubble-incoming-border", in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }()

    lazy var borderOutgoingTail: UIImage = {
        return UIImage(named: "bubble-outgoing-border-tail", in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }()

    lazy var borderOutgoingNoTail: UIImage = {
        return UIImage(named: "bubble-outgoing-border", in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }()

    open lazy var failedIcon: UIImage = {
        return UIImage(named: "base-message-failed-icon", in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }()

    open lazy var failedIconHighlighted: UIImage = {
        return self.failedIcon.bmaBlendWithColor(UIColor.black.withAlphaComponent(0.10))
    }()

    fileprivate lazy var dateFont = {
        return UIFont.systemFont(ofSize: 12.0)
    }()

    open func attributedStringForDate(_ date: String) -> NSAttributedString {
        let attributes = [NSFontAttributeName : self.dateFont]
        return NSAttributedString(string: date, attributes: attributes)
    }

    func borderImage(viewModel: MessageViewModelProtocol) -> UIImage? {
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
