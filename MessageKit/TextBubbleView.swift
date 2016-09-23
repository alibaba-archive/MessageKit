//
//  TextBubbleView.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol TextBubbleViewStyleProtocol {

    func bubbleImage(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIImage
    func bubbleImageBorder(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIImage?
    func textFont(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIFont
    func textColor(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIColor
    func textInsets(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIEdgeInsets
}

public final class TextBubbleView: UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {

    public var preferredMaxLayoutWidth: CGFloat = 0
    public var animationDuration: CFTimeInterval = 0.33
    public var viewContext: ViewContext = .normal {
        didSet {
            if self.viewContext == .sizing {
                self.textView.dataDetectorTypes = UIDataDetectorTypes()
                self.textView.isSelectable = false
            } else {
                self.textView.dataDetectorTypes = .all
                self.textView.isSelectable = true
            }
        }
    }

    public var style: TextBubbleViewStyleProtocol! {
        didSet {
            self.updateViews()
        }
    }

    public var textMessageViewModel: TextMessageViewModelProtocol! {
        didSet {
            self.updateViews()
        }
    }

    public var selected: Bool = false {
        didSet {
            self.updateViews()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    fileprivate func commonInit() {
        self.addSubview(self.bubbleImageView)
        self.addSubview(self.textView)
    }

    fileprivate lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addSubview(self.borderImageView)
        return imageView
    }()

    fileprivate var borderImageView: UIImageView = UIImageView()
    fileprivate var textView: UITextView = {
        let textView = ChatMessageTextView()
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = .all
        textView.scrollsToTop = false
        textView.isScrollEnabled = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.layoutManager.allowsNonContiguousLayout = true
        textView.isExclusiveTouch = true
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()

    public fileprivate(set) var isUpdating: Bool = false
    public func performBatchUpdates(_ updateClosure: @escaping () -> Void, animated: Bool, completion: (() -> Void)?) {
        self.isUpdating = true
        let updateAndRefreshViews = {
            updateClosure()
            self.isUpdating = false
            self.updateViews()
            if animated {
                self.layoutIfNeeded()
            }
        }
        if animated {
            UIView.animate(withDuration: self.animationDuration, animations: updateAndRefreshViews, completion: { (finished) -> Void in
                completion?()
            })
        } else {
            updateAndRefreshViews()
        }
    }

    fileprivate func updateViews() {
        if self.viewContext == .sizing { return }
        if isUpdating { return }
        guard let style = self.style, let viewModel = self.textMessageViewModel else { return }
        let font = style.textFont(viewModel: viewModel, isSelected: self.selected)
        let textColor = style.textColor(viewModel: viewModel, isSelected: self.selected)
        let bubbleImage = self.style.bubbleImage(viewModel: self.textMessageViewModel, isSelected: self.selected)
        if viewModel.showsBorder {
            let borderImage = self.style.bubbleImageBorder(viewModel: self.textMessageViewModel, isSelected: self.selected)
            if self.borderImageView.image != borderImage { self.borderImageView.image = borderImage }
        }


        if self.textView.font != font { self.textView.font = font}
        if self.textView.text != viewModel.text {self.textView.text = viewModel.text}
        if self.textView.textColor != textColor {
            self.textView.textColor = textColor
            self.textView.linkTextAttributes = [
                NSForegroundColorAttributeName: textColor,
                NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
            ]
        }
        if self.bubbleImageView.image != bubbleImage { self.bubbleImageView.image = bubbleImage}

    }

    fileprivate func bubbleImage() -> UIImage {
        return self.style.bubbleImage(viewModel: self.textMessageViewModel, isSelected: self.selected)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.calculateTextBubbleLayout(preferredMaxLayoutWidth: size.width).size
    }

    // MARK:  Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        let layout = self.calculateTextBubbleLayout(preferredMaxLayoutWidth: self.preferredMaxLayoutWidth)
        self.textView.bmaRect = layout.textFrame
        self.bubbleImageView.bmaRect = layout.bubbleFrame
        self.borderImageView.bmaRect = self.bubbleImageView.bounds
    }

    public var layoutCache: NSCache<AnyObject, AnyObject>!
    fileprivate func calculateTextBubbleLayout(preferredMaxLayoutWidth: CGFloat) -> TextBubbleLayoutModel {
        let layoutContext = TextBubbleLayoutModel.LayoutContext(
            text: self.textMessageViewModel.text,
            font: self.style.textFont(viewModel: self.textMessageViewModel, isSelected: self.selected),
            textInsets: self.style.textInsets(viewModel: self.textMessageViewModel, isSelected: self.selected),
            preferredMaxLayoutWidth: preferredMaxLayoutWidth
        )

        if let layoutModel = self.layoutCache.object(forKey: layoutContext.hashValue as AnyObject) as? TextBubbleLayoutModel, layoutModel.layoutContext == layoutContext {
            return layoutModel
        }

        let layoutModel = TextBubbleLayoutModel(layoutContext: layoutContext)
        layoutModel.calculateLayout()

        self.layoutCache.setObject(layoutModel, forKey: layoutContext.hashValue as AnyObject)
        return layoutModel
    }

    public var canCalculateSizeInBackground: Bool {
        return true
    }
}


private final class TextBubbleLayoutModel {

    let layoutContext: LayoutContext
    var textFrame: CGRect = CGRect.zero
    var bubbleFrame: CGRect = CGRect.zero
    var size: CGSize = CGSize.zero

    init(layoutContext: LayoutContext) {
        self.layoutContext = layoutContext
    }

    class LayoutContext: Equatable, Hashable {
        let text: String
        let font: UIFont
        let textInsets: UIEdgeInsets
        let preferredMaxLayoutWidth: CGFloat
        init (text: String, font: UIFont, textInsets: UIEdgeInsets, preferredMaxLayoutWidth: CGFloat) {
            self.font = font
            self.text = text
            self.textInsets = textInsets
            self.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        }

        var hashValue: Int {
            get {
                return self.text.hashValue ^ self.textInsets.bmaHashValue ^ self.preferredMaxLayoutWidth.hashValue ^ self.font.hashValue
            }
        }

        static func == (lhs: LayoutContext, rhs: LayoutContext) -> Bool {
            return lhs.text == rhs.text &&
                lhs.textInsets == rhs.textInsets &&
                lhs.font == rhs.font &&
                lhs.preferredMaxLayoutWidth == rhs.preferredMaxLayoutWidth
        }
    }

    func calculateLayout() {
        let textHorizontalInset = self.layoutContext.textInsets.bmaHorziontalInset
        let maxTextWidth = self.layoutContext.preferredMaxLayoutWidth - textHorizontalInset
        let textSize = self.textSizeThatFitsWidth(maxTextWidth)
        let bubbleSize = textSize.bmaOutsetBy(dx: textHorizontalInset, dy: self.layoutContext.textInsets.bmaVerticalInset)
        self.bubbleFrame = CGRect(origin: CGPoint.zero, size: bubbleSize)
        self.textFrame = UIEdgeInsetsInsetRect(self.bubbleFrame, self.layoutContext.textInsets)
        self.size = bubbleSize
    }

    fileprivate func textSizeThatFitsWidth(_ width: CGFloat) -> CGSize {
        return self.layoutContext.text.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSFontAttributeName: self.layoutContext.font], context:  nil
            ).size.bmaRound()
    }
}

/// UITextView with hacks to avoid selection, loupe, define...
private final class ChatMessageTextView: UITextView {

    override var canBecomeFirstResponder: Bool {
        return false
    }

    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if type(of: gestureRecognizer) == UILongPressGestureRecognizer.self && gestureRecognizer.delaysTouchesEnded {
            super.addGestureRecognizer(gestureRecognizer)
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
