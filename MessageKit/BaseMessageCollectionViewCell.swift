//
//  BaseMessageCollectionViewCell.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public enum ViewContext {
    case normal
    case sizing // You may skip some cell updates for faster sizing
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
    func attributedStringForDate(_ date: String) -> NSAttributedString
}

public struct BaseMessageCollectionViewCellLayoutConstants {

    let horizontalMargin: CGFloat = 15
    let avatarWidth: CGFloat = 36
    let horizontalInterspacing: CGFloat = 4
    let maxContainerWidthPercentageForBubbleView: CGFloat = 0.68
}


open class BaseMessageCollectionViewCell<BubbleViewType>: UICollectionViewCell, BackgroundSizingQueryable, UIGestureRecognizerDelegate where BubbleViewType:UIView, BubbleViewType:MaximumLayoutWidthSpecificable, BubbleViewType: BackgroundSizingQueryable {

    open var animationDuration: CFTimeInterval = 0.33
    open var viewContext: ViewContext = .normal

    open fileprivate(set) var isUpdating: Bool = false
    open func performBatchUpdates(_ updateClosure: @escaping () -> Void, animated: Bool, completion: (() ->())?) {
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

    var messageViewModel: MessageViewModelProtocol! {
        didSet {
            updateViews()
        }
    }

    var failedIcon: UIImage!
    var failedIconHighlighted: UIImage!
    open var baseStyle: BaseMessageCollectionViewCellStyleProtocol! {
        didSet {
            self.failedIcon = self.baseStyle.failedIcon
            self.failedIconHighlighted = self.baseStyle.failedIconHighlighted
            self.updateViews()
        }
    }

    override open var isSelected: Bool {
        didSet {
            if oldValue != self.isSelected {
                self.updateViews()
            }
        }
    }

    var layoutConstants = BaseMessageCollectionViewCellLayoutConstants() {
        didSet {
            self.setNeedsLayout()
        }
    }

    open var canCalculateSizeInBackground: Bool {
        return self.bubbleView.canCalculateSizeInBackground
    }

    open fileprivate(set) var bubbleView: BubbleViewType!
    func createBubbleView() -> BubbleViewType! {
        assert(false, "Override in subclass")
        return nil
    }

    open fileprivate(set) var avatarView: UIImageView!

    func createAvatarView() -> UIImageView! {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    open fileprivate(set) var timestampLabel: UILabel!
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

    open fileprivate(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseMessageCollectionViewCell.bubbleTapped(_:)))
        return tapGestureRecognizer
    }()

    open fileprivate(set) lazy var tapAvatarGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseMessageCollectionViewCell.avatarTapped(_:)))
        return tapGestureRecognizer
    }()

    open fileprivate (set) lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let longpressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(BaseMessageCollectionViewCell.bubbleLongPressed(_:)))
        longpressGestureRecognizer.delegate = self
        return longpressGestureRecognizer
    }()

    fileprivate func commonInit() {
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
        self.contentView.isExclusiveTouch = true
        self.isExclusiveTouch = true
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return self.bubbleView.bounds.contains(touch.location(in: self.bubbleView))
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer === self.longPressGestureRecognizer
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
    }

    fileprivate lazy var failedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(failedButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: View model binding

    final fileprivate func updateViews() {
        if self.viewContext == .sizing { return }
        if self.isUpdating { return }
        guard let viewModel = self.messageViewModel, let style = self.baseStyle else { return }
        if viewModel.showsFailedIcon {
            self.failedButton.setImage(self.failedIcon, for: UIControlState())
            self.failedButton.setImage(self.failedIconHighlighted, for: .highlighted)
            self.failedButton.alpha = 1
        } else {
            self.failedButton.alpha = 0
        }
        self.timestampLabel.attributedText = style.attributedStringForDate(self.messageViewModel.date)
        self.timestampLabel.textColor = UIColor.bmaColor(rgb: 0xAAAAAA)
        if let avatar = self.messageViewModel.avatarClosure {
            avatar(self.avatarView)
        }

        self.setNeedsLayout()
    }

    // MARK: layout
    open override func layoutSubviews() {
        super.layoutSubviews()
        let layoutModel = self.calculateLayout(availableWidth: self.contentView.bounds.width)
        self.failedButton.bmaRect = layoutModel.failedViewFrame
        self.bubbleView.bmaRect = layoutModel.bubbleViewFrame
        self.timestampLabel.frame = layoutModel.timestampLabelFrame
        if self.messageViewModel.isIncoming {
            self.avatarView.alpha = 1
            self.avatarView.frame = CGRect(x: layoutConstants.horizontalMargin, y: 0, width: layoutConstants.avatarWidth, height: layoutConstants.avatarWidth)
            avatarView.addCorner(radius: 18)
        } else {
            self.avatarView.alpha = 0
        }

        self.bubbleView.preferredMaxLayoutWidth = layoutModel.preferredMaxWidthForBubble
        self.bubbleView.layoutIfNeeded()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.calculateLayout(availableWidth: size.width).size
    }

    fileprivate func calculateLayout(availableWidth: CGFloat) -> BaseMessageLayoutModel {
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
    open var onFailedButtonTapped: ((_ cell: BaseMessageCollectionViewCell) -> Void)?
    @objc
    func failedButtonTapped() {
        self.onFailedButtonTapped?(self)
    }

    open var onBubbleTapped: ((_ cell: BaseMessageCollectionViewCell) -> Void)?
    @objc
    func bubbleTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.onBubbleTapped?(self)
    }

    open var onBubbleLongPressed: ((_ cell: BaseMessageCollectionViewCell) -> Void)?
    @objc
    fileprivate func bubbleLongPressed(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == .began {
            self.bubbleLongPressed()
        }
    }

    func bubbleLongPressed() {
        self.onBubbleLongPressed?(self)
    }

    open var onAvatarTapped: ((_ cell: BaseMessageCollectionViewCell) -> Void)?
    @objc
    fileprivate func avatarTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.onAvatarTapped?(self)
    }
}

struct BaseMessageLayoutModel {

    fileprivate (set) var size = CGSize.zero
    fileprivate (set) var failedViewFrame = CGRect.zero
    fileprivate (set) var bubbleViewFrame = CGRect.zero
    fileprivate (set) var timestampLabelFrame = CGRect.zero
    fileprivate (set) var avatarViewFrame = CGRect.zero
    fileprivate (set) var preferredMaxWidthForBubble: CGFloat = 0

    mutating func calculateLayout(parameters: BaseMessageLayoutModelParameters) {
        let baseConstants = parameters.baseConstanst
        let containerWidth = parameters.containerWidth
        let isIncoming = parameters.isIncoming
        let isFailed = parameters.isFailed
        let failedButtonSize = parameters.failedButtonSize
        let bubbleView = parameters.bubbleView
        let timestampView = parameters.timestampLabel

        let preferredWidthForBubble = containerWidth * parameters.maxContainerWidthPercentageForBubbleView
        let avatarSize = CGSize(width: baseConstants.avatarWidth, height: baseConstants.avatarWidth)
        let bubbleSize = bubbleView.sizeThatFits(CGSize(width: preferredWidthForBubble, height: CGFloat.greatestFiniteMagnitude))
        let timestampSize = timestampView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20))
        let containerRect = CGRect(origin: CGPoint.zero, size: CGSize(width: containerWidth, height: bubbleSize.height))

        self.avatarViewFrame.size = avatarSize
        self.bubbleViewFrame = bubbleSize.bmaRect(inContainer: containerRect, xAlignament: .center, yAlignment: .center, dx: 0, dy: 0)
        self.failedViewFrame = failedButtonSize.bmaRect(inContainer: containerRect, xAlignament: .center, yAlignment: .center, dx: 0, dy: 0)
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
