//
//  CustomBubbleView.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/16.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol CustomBubbleViewStyleProtocol {
    func folderImage(viewModel viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIImage
    func bubbleImage(viewModel viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIImage
    func bubbleImageBorder(viewModel viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIImage?
    func titleFont(viewModel viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIFont
    func titleColor(viewModel viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIColor
    func textFont(viewModel viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIFont
    func textColor(viewModel viewModel: CustomMessageViewModelProtocol, isSelected: Bool) -> UIColor
}

public final class CustomBubbleView: UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {
    
    public var viewContext: ViewContext = .Normal
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
    
    private func commonInit() {
        self.autoresizesSubviews = false
        self.addSubview(self.bubbleImageView)
    }
    
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addSubview(self.borderImageView)
        return imageView
    }()

    private var borderImageView: UIImageView = UIImageView()
    
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
    
    private func updateViews() {
        if self.viewContext == .Sizing { return }
        if isUpdating { return }
        guard let _ = self.customMessageViewModel, viewModel = self.customMessageViewModel else {
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
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return self.calculateCustomBubbleLayout(maximumWidth: self.preferredMaxLayoutWidth).size
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let _ = self.calculateCustomBubbleLayout(maximumWidth: self.preferredMaxLayoutWidth)
        
        self.addSubview(self.customMessageViewModel.customView)
    }
    
    private func calculateCustomBubbleLayout(maximumWidth maximumWidth: CGFloat) -> CustomBubbleLayoutModel {
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
        size = layoutContext.customViewSize
    }
}
