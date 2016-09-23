//
//  TextMessageCollectionViewCell.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public typealias TextMessageCollectionViewCellStyleProtocol = TextBubbleViewStyleProtocol

public final class TextMessageCollectionViewCell: BaseMessageCollectionViewCell<TextBubbleView> {

    public static func sizingCell() -> TextMessageCollectionViewCell {
        let cell = TextMessageCollectionViewCell(frame: CGRect.zero)
        cell.viewContext = .sizing
        return cell
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Subclassing (view creation)

    override func createBubbleView() -> TextBubbleView {
        return TextBubbleView()
    }

    public override func performBatchUpdates(_ updateClosure: @escaping () -> Void, animated: Bool, completion: (() -> Void)?) {
        super.performBatchUpdates({ () -> Void in
            self.bubbleView.performBatchUpdates(updateClosure, animated: false, completion: nil)
            }, animated: animated, completion: completion)
    }

    // MARK: Property forwarding

    override public var viewContext: ViewContext {
        didSet {
            self.bubbleView.viewContext = self.viewContext
        }
    }

    public var textMessageViewModel: TextMessageViewModelProtocol! {
        didSet {
            self.messageViewModel = self.textMessageViewModel
            self.bubbleView.textMessageViewModel = self.textMessageViewModel
        }
    }

    public var textMessageStyle: TextMessageCollectionViewCellStyleProtocol! {
        didSet {
            self.bubbleView.style = self.textMessageStyle
        }
    }

    override public var isSelected: Bool {
        didSet {
            self.bubbleView.selected = self.isSelected
        }
    }

    public var layoutCache: NSCache<AnyObject, AnyObject>! {
        didSet {
            self.bubbleView.layoutCache = self.layoutCache
        }
    }
}
