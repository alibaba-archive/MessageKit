//
//  CustomBubbleView.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/16.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol CustomBubbleViewStyleProtocol {

    func bubbleImage(viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIImage
    func bubbleImageBorder(viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIImage?
}

public final class CustomBubbleView: UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {

    public var viewContext: ViewContext = .normal
    public var animationDuration: CFTimeInterval = 0.33
    public var preferredMaxLayoutWidth: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    fileprivate func commonInit() {
        self.autoresizesSubviews = false
        self.addSubview(self.bubbleImageView)
    }

    fileprivate lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addSubview(self.borderImageView)
        return imageView
    }()

    fileprivate var borderImageView: UIImageView = UIImageView()

    public var customMessageViewModel: CustomMessageViewModelProtocol! {
        didSet {
            self.updateViews()
        }
    }

    public var customMessageStyle: CustomBubbleViewStyleProtocol! {
        didSet {
            self.updateViews()
        }
    }

    public var selected: Bool = false {
        didSet {
            self.updateViews()
        }
    }

    public fileprivate(set) var isUpdating: Bool = false
    public func performBatchUpdates(_ updateClosure: @escaping () -> Void, animated: Bool, completion: (() ->())?) {
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
        guard let _ = self.customMessageViewModel, let viewModel = self.customMessageViewModel else {
            return
        }
        let bubbleImage = self.customMessageStyle.bubbleImage(viewModel: viewModel, isSelected: self.selected)
        if self.bubbleImageView.image != bubbleImage { self.bubbleImageView.image = bubbleImage }

        if viewModel.showsBorder {
            let borderImage = self.customMessageStyle.bubbleImageBorder(viewModel: viewModel, isSelected: self.selected)
            if self.borderImageView.image != borderImage { self.borderImageView.image = borderImage }
        }
        self.setNeedsLayout()
    }

    // MARK: Layout

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.calculateCustomBubbleLayout(maximumWidth: self.preferredMaxLayoutWidth).size
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let layout = self.calculateCustomBubbleLayout(maximumWidth: self.preferredMaxLayoutWidth)

        self.addSubview(self.customMessageViewModel.customView)
        customMessageViewModel.customView.frame = layout.frame
    }

    fileprivate func calculateCustomBubbleLayout(maximumWidth: CGFloat) -> CustomBubbleLayoutModel {
        let layoutContext = CustomBubbleLayoutModel.LayoutContext(customViewSize: self.customMessageViewModel.customView.frame.size, preferredMaxLayoutWidth: maximumWidth)
        let layoutModel = CustomBubbleLayoutModel(layoutContext: layoutContext)
        layoutModel.calculateLayout()
        return layoutModel
    }

    public var canCalculateSizeInBackground: Bool {
        return true
    }
}

private class CustomBubbleLayoutModel {

    var size: CGSize = CGSize.zero
    var frame: CGRect = CGRect.zero

    struct LayoutContext {
        let customViewSize: CGSize
        let preferredMaxLayoutWidth: CGFloat

        init(customViewSize: CGSize, preferredMaxLayoutWidth width: CGFloat) {
            self.preferredMaxLayoutWidth = width
            self.customViewSize = customViewSize
        }
    }

    let layoutContext: LayoutContext
    init(layoutContext: LayoutContext) {
        self.layoutContext = layoutContext
    }

    func calculateLayout() {
        //adjust X
        var currentX: CGFloat = 0.0
        currentX += 8
        frame.origin.x = currentX
        frame.size = layoutContext.customViewSize
        size = layoutContext.customViewSize
        size.width += 16
    }
}
