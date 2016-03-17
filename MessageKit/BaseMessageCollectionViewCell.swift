//
//  BaseMessageCollectionViewCell.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum ViewContext {
    case Normal
    case Sizing // You may skip some cell updates for faster sizing
}

public protocol MaximumLayoutWidthSpecificable {
    var preferredMaxLayoutWidth: CGFloat { get set }
}

public protocol BackgroundSizingQueryable {
    var canCalculateSizeInBackground: Bool { get }
}


public protocol BaseMessageCollectionViewCellStyleProtocol {
    var failedIcon: UIImage { get }
    var failedIconHighlighted: UIImage { get }
    func attributedStringForDate(date: String) -> NSAttributedString
}

public struct BaseMessageCollectionViewCellLayoutConstants {
    let horizontalMargin: CGFloat = 15
    let avatarWidth: CGFloat = 36
    let horizontalInterspacing: CGFloat = 4
    let maxContainerWidthPercentageForBubbleView: CGFloat = 0.68
}


public class BaseMessageCollectionViewCell<BubbleViewType where BubbleViewType:UIView, BubbleViewType:MaximumLayoutWidthSpecificable, BubbleViewType: BackgroundSizingQueryable>: UICollectionViewCell, BackgroundSizingQueryable, UIGestureRecognizerDelegate {
    
    public var animationDuration: CFTimeInterval = 0.33
    public var viewContext: ViewContext = .Normal
    
    public private(set) var isUpdating: Bool = false
    public func performBatchUpdates(updateClosure: () -> Void, animated: Bool, completion: (() ->())?) {
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
            UIView.animateWithDuration(self.animationDuration, animations: updateAndRefreshViews, completion: { (finished) -> Void in
                completion?()
            })
        } else {
            updateAndRefreshViews()
        }
    }
    
    var messageViewModel: MessageViewModelProtocol! {
        didSet {
            updateViews()
        }
    }
    
    var failedIcon: UIImage!
    var failedIconHighlighted: UIImage!
    public var baseStyle: BaseMessageCollectionViewCellStyleProtocol! {
        didSet {
            self.failedIcon = self.baseStyle.failedIcon
            self.failedIconHighlighted = self.baseStyle.failedIconHighlighted
            self.updateViews()
        }
    }
    
    override public var selected: Bool {
        didSet {
            if oldValue != self.selected {
                self.updateViews()
            }
        }
    }
    
    var layoutConstants = BaseMessageCollectionViewCellLayoutConstants() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var canCalculateSizeInBackground: Bool {
        return self.bubbleView.canCalculateSizeInBackground
    }
    
    public private(set) var bubbleView: BubbleViewType!
    func createBubbleView() -> BubbleViewType! {
        assert(false, "Override in subclass")
        return nil
    }
    
    public private(set) var avatarView: UIImageView!
    
    func createAvatarView() -> UIImageView! {
        let imageView = UIImageView()
        imageView.userInteractionEnabled = true
        return imageView
    }
    
    public private(set) var timestampLabel: UILabel!
    func createTimestampView() -> UILabel! {
        let label = UILabel()
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "bubbleTapped:")
        return tapGestureRecognizer
    }()
    
    public private(set) lazy var tapAvatarGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "avatarTapped:")
        return tapGestureRecognizer
    }()
    
    public private (set) lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let longpressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "bubbleLongPressed:")
        longpressGestureRecognizer.delegate = self
        return longpressGestureRecognizer
    }()
    
    private func commonInit() {
        self.bubbleView = createBubbleView()
        self.bubbleView.addGestureRecognizer(self.tapGestureRecognizer)
        self.bubbleView.addGestureRecognizer(self.longPressGestureRecognizer)
        self.avatarView = createAvatarView()
        self.avatarView.addGestureRecognizer(self.tapAvatarGestureRecognizer)
        self.timestampLabel = createTimestampView()
        self.contentView.addSubview(self.bubbleView)
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.failedButton)
        self.contentView.addSubview(self.timestampLabel)
        self.contentView.exclusiveTouch = true
        self.exclusiveTouch = true
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return self.bubbleView.bounds.contains(touch.locationInView(self.bubbleView))
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer === self.longPressGestureRecognizer
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private lazy var failedButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.addTarget(self, action: "failedButtonTapped", forControlEvents: .TouchUpInside)
        return button
    }()
    
    // MARK: View model binding
    
    final private func updateViews() {
        if self.viewContext == .Sizing { return }
        if self.isUpdating { return }
        guard let viewModel = self.messageViewModel, style = self.baseStyle else { return }
        if viewModel.showsFailedIcon {
            self.failedButton.setImage(self.failedIcon, forState: .Normal)
            self.failedButton.setImage(self.failedIconHighlighted, forState: .Highlighted)
            self.failedButton.alpha = 1
        } else {
            self.failedButton.alpha = 0
        }
        self.timestampLabel.attributedText = style.attributedStringForDate(self.messageViewModel.date)
        self.timestampLabel.textColor = UIColor.bma_color(rgb: 0xAAAAAA)
        if let avatar = self.messageViewModel.avatarClosure {
            avatar(imageview: self.avatarView)
        }
        
        self.setNeedsLayout()
    }
    
    // MARK: layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        let layoutModel = self.calculateLayout(availableWidth: self.contentView.bounds.width)
        self.failedButton.bma_rect = layoutModel.failedViewFrame
        self.bubbleView.bma_rect = layoutModel.bubbleViewFrame
        self.timestampLabel.frame = layoutModel.timestampLabelFrame
        if self.messageViewModel.isIncoming {
            self.avatarView.alpha = 1
            self.avatarView.frame = CGRect(x: layoutConstants.horizontalMargin, y: 0, width: layoutConstants.avatarWidth, height: layoutConstants.avatarWidth)
            avatarView.kt_addCorner(radius: 18)
        } else {
            self.avatarView.alpha = 0
        }
        
        self.bubbleView.preferredMaxLayoutWidth = layoutModel.preferredMaxWidthForBubble
        self.bubbleView.layoutIfNeeded()
}
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return self.calculateLayout(availableWidth: size.width).size
    }
    
    private func calculateLayout(availableWidth availableWidth: CGFloat) -> BaseMessageLayoutModel {
        let parameters = BaseMessageLayoutModelParameters(
            baseConstanst: self.layoutConstants,
            containerWidth: availableWidth,
            failedButtonSize: self.failedIcon.size,
            maxContainerWidthPercentageForBubbleView: self.layoutConstants.maxContainerWidthPercentageForBubbleView,
            bubbleView: self.bubbleView,
            timestampLabel: self.timestampLabel,
            isIncoming: self.messageViewModel.isIncoming,
            isFailed: self.messageViewModel.showsFailedIcon
        )
        var layoutModel = BaseMessageLayoutModel()
        layoutModel.calculateLayout(parameters: parameters)
        return layoutModel
    }
    
    
    // MARK: User interaction
    public var onFailedButtonTapped: ((cell: BaseMessageCollectionViewCell) -> Void)?
    @objc
    func failedButtonTapped() {
        self.onFailedButtonTapped?(cell: self)
    }
    
    public var onBubbleTapped: ((cell: BaseMessageCollectionViewCell) -> Void)?
    @objc
    func bubbleTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.onBubbleTapped?(cell: self)
    }
    
    public var onBubbleLongPressed: ((cell: BaseMessageCollectionViewCell) -> Void)?
    @objc
    private func bubbleLongPressed(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == .Began {
            self.bubbleLongPressed()
        }
    }
    
    func bubbleLongPressed() {
        self.onBubbleLongPressed?(cell: self)
    }
    
    public var onAvatarTapped: ((cell: BaseMessageCollectionViewCell) -> Void)?
    @objc
    private func avatarTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.onAvatarTapped?(cell: self)
    }
}

struct BaseMessageLayoutModel {
    private (set) var size = CGSize.zero
    private (set) var failedViewFrame = CGRect.zero
    private (set) var bubbleViewFrame = CGRect.zero
    private (set) var timestampLabelFrame = CGRect.zero
    private (set) var avatarViewFrame = CGRect.zero
    private (set) var preferredMaxWidthForBubble: CGFloat = 0
    
    mutating func calculateLayout(parameters parameters: BaseMessageLayoutModelParameters) {
        let baseConstants = parameters.baseConstanst
        let containerWidth = parameters.containerWidth
        let isIncoming = parameters.isIncoming
        let isFailed = parameters.isFailed
        let failedButtonSize = parameters.failedButtonSize
        let bubbleView = parameters.bubbleView
        let timestampView = parameters.timestampLabel
        
        let preferredWidthForBubble = containerWidth * parameters.maxContainerWidthPercentageForBubbleView
        let avatarSize = CGSize(width: baseConstants.avatarWidth, height: baseConstants.avatarWidth)
        let bubbleSize = bubbleView.sizeThatFits(CGSize(width: preferredWidthForBubble, height: CGFloat.max))
        let timestampSize = timestampView.sizeThatFits(CGSize(width: CGFloat.max, height: 20))
        let containerRect = CGRect(origin: CGPoint.zero, size: CGSize(width: containerWidth, height: bubbleSize.height))
        
        self.avatarViewFrame.size = avatarSize
        self.bubbleViewFrame = bubbleSize.bma_rect(inContainer: containerRect, xAlignament: .Center, yAlignment: .Center, dx: 0, dy: 0)
        self.failedViewFrame = failedButtonSize.bma_rect(inContainer: containerRect, xAlignament: .Center, yAlignment: .Center, dx: 0, dy: 0)
        self.timestampLabelFrame.size = timestampSize
        
        // Adjust horizontal positions
        
        var currentX: CGFloat = 0
        if isIncoming {
            currentX = baseConstants.horizontalMargin
            self.avatarViewFrame.origin.x = currentX
            
            currentX += baseConstants.avatarWidth
            currentX += baseConstants.horizontalInterspacing
            
            self.bubbleViewFrame.origin.x = currentX
            self.timestampLabelFrame.origin.x = currentX + 15
            
            currentX += bubbleViewFrame.width
            
            if isFailed {
                self.failedViewFrame.origin.x = currentX + 10
                currentX += failedButtonSize.width
            } else {
                self.failedViewFrame.origin.x = -failedButtonSize.width
            }
        } else {
            currentX = containerRect.maxX - baseConstants.horizontalMargin
            self.timestampLabelFrame.origin.x = currentX - timestampSize.width - 15
            currentX -= bubbleSize.width
            self.bubbleViewFrame.origin.x = currentX
            if isFailed {
                currentX -= failedButtonSize.width + 10
                self.failedViewFrame.origin.x = currentX
                currentX -= baseConstants.horizontalInterspacing
            } else {
                self.failedViewFrame.origin.x = containerRect.width - -failedButtonSize.width
            }
        }
        
        //adjust vertical position
        
        self.timestampLabelFrame.origin.y = bubbleSize.height + 5
        
        self.size = containerRect.size
        self.preferredMaxWidthForBubble = preferredWidthForBubble
    }
}

struct BaseMessageLayoutModelParameters {
    let baseConstanst: BaseMessageCollectionViewCellLayoutConstants
    let containerWidth: CGFloat
    let failedButtonSize: CGSize
    let maxContainerWidthPercentageForBubbleView: CGFloat // in [0, 1]
    let bubbleView: UIView
    let timestampLabel: UILabel
    let isIncoming: Bool
    let isFailed: Bool
}
