//
//  CustomMessageCollectionViewCell.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/16.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public typealias CustomMessageCollectionViewCellStyleProtocol = CustomBubbleViewStyleProtocol

public final class CustomMessageCollectionViewCell: BaseMessageCollectionViewCell<CustomBubbleView> {

    static func sizingCell() -> CustomMessageCollectionViewCell {
        let cell = CustomMessageCollectionViewCell(frame: CGRect.zero)
        cell.viewContext = .sizing
        return cell
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createBubbleView() -> CustomBubbleView {
        return CustomBubbleView()
    }

    override public var viewContext: ViewContext {
        didSet {
            self.bubbleView.viewContext = self.viewContext
        }
    }

    var customMessageViewModel: CustomMessageViewModelProtocol! {
        didSet {
            self.messageViewModel = self.customMessageViewModel
            self.bubbleView.customMessageViewModel = self.customMessageViewModel
        }
    }

    public var customMessageStyle: CustomMessageCollectionViewCellStyleProtocol! {
        didSet {
            self.bubbleView.customMessageStyle = self.customMessageStyle
        }
    }

    public override func performBatchUpdates(_ updateClosure: @escaping () -> Void, animated: Bool, completion: (() -> Void)?) {
        super.performBatchUpdates({ () -> Void in
            self.bubbleView.performBatchUpdates(updateClosure, animated: false, completion: nil)
            }, animated: animated, completion: completion)
    }
}
