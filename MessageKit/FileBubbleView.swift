//
//  FileBubbleView.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol FileBubbleViewStyleProtocol {
    func bubbleImage(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIImage
    func bubbleImageBorder(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIImage?
    func titleFont(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIFont
    func titleColor(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIColor
    func textFont(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIFont
    func textColor(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIColor
}

public final class FileBubbleView: UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {
    
    public var viewContext: ViewContext = .Normal
    public var animationDuration: CFTimeInterval = 0.33
    public var preferredMaxLayoutWidth: CGFloat = 0
    public var fileWidth: CGFloat = 186
    public var fileHeight: CGFloat = 58
    
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
        self.addSubview(self.imageView)
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.autoresizingMask = .None
        imageView.clipsToBounds = true
        imageView.autoresizesSubviews = false
        imageView.autoresizingMask = .None
        imageView.contentMode = .ScaleAspectFill
        imageView.addSubview(self.borderView)
        return imageView
    }()
    
    private lazy var borderView = UIImageView()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    public var fileMessageViewModel: FileMessageViewModelProtocol! {
        didSet {
            self.updateViews()
        }
    }
    
    public var fileMessageStyle: FileBubbleViewStyleProtocol! {
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
        guard let _ = self.fileMessageViewModel else {
            return
        }
        
        let bubbleImage = self.fileMessageStyle.bubbleImage(viewModel: fileMessageViewModel, isSelected: selected)
        
        let borderImage = self.fileMessageStyle.bubbleImageBorder(viewModel: fileMessageViewModel, isSelected: selected)
        
        if imageView != bubbleImage {
            imageView.image = bubbleImage
        }
        if self.borderView.image != borderImage {
            self.borderView.image = borderImage
        }
        self.setNeedsLayout()
    }
    
    // MARK: Layout
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSize(width: fileWidth, height: fileHeight)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
//        let layout = self.calculateTextBubbleLayout(maximumWidth: self.preferredMaxLayoutWidth)
//        //        self.progressIndicatorView.center = layout.visualCenter
//        self.placeholderIconView.center = layout.visualCenter
//        self.placeholderIconView.bounds = CGRect(origin: CGPoint.zero, size: self.placeholderIconView.image?.size ?? CGSize.zero)
//        self.imageView.bma_rect = layout.photoFrame
        self.imageView.frame = CGRect(x: 0, y: 0, width: fileWidth, height: fileHeight)
//        self.imageView.layer.mask?.frame = self.imageView.layer.bounds
//        self.overlayView.bma_rect = self.imageView.bounds
//        self.borderView.bma_rect = self.imageView.bounds
    }
    
//    private func calculateFileBubbleLayout(maximumWidth maximumWidth: CGFloat) -> FileBubbleLayoutModel {
//        let layoutContext = FileBubbleLayoutModel.LayoutContext(photoMessageViewModel: self.fileMessageViewModel, style: self.fileMessageStyle, containerWidth: maximumWidth)
//        
//        FileBubbleLayoutModel.LayoutContext(photoMessageViewModel: <#T##PhotoMessageViewModelProtocol#>, style: <#T##PhotoBubbleViewStyleProtocol#>, containerWidth: <#T##CGFloat#>)
//        let layoutModel = FileBubbleLayoutModel(layoutContext: layoutContext)
//        layoutModel.calculateLayout()
//        return layoutModel
//    }
    
    public var canCalculateSizeInBackground: Bool {
        return true
    }
    
}


private class FileBubbleLayoutModel {
    var photoFrame: CGRect = CGRect.zero
    var visualCenter: CGPoint = CGPoint.zero
    var size: CGSize = CGSize.zero
    
    struct LayoutContext {
        let photoSize: CGSize
        let preferredMaxLayoutWidth: CGFloat
        let isIncoming: Bool
        let tailWidth: CGFloat
        
        init(photoSize: CGSize, tailWidth: CGFloat, isIncoming: Bool, preferredMaxLayoutWidth width: CGFloat) {
            self.photoSize = photoSize
            self.tailWidth = tailWidth
            self.isIncoming = isIncoming
            self.preferredMaxLayoutWidth = width
        }
        
        init(photoMessageViewModel model: PhotoMessageViewModelProtocol, style: PhotoBubbleViewStyleProtocol, containerWidth width: CGFloat) {
            self.init(photoSize: style.bubbleSize(viewModel: model), tailWidth:style.tailWidth(viewModel: model), isIncoming: model.isIncoming, preferredMaxLayoutWidth: width)
        }
    }
    
    let layoutContext: LayoutContext
    init(layoutContext: LayoutContext) {
        self.layoutContext = layoutContext
    }
    
    func calculateLayout() {
        let photoSize = self.layoutContext.photoSize
        self.photoFrame = CGRect(origin: CGPoint.zero, size: photoSize)
        let offsetX: CGFloat = 0.5 * self.layoutContext.tailWidth * (self.layoutContext.isIncoming ? 1.0 : -1.0)
        self.visualCenter = self.photoFrame.bma_center.bma_offsetBy(dx: offsetX, dy: 0)
        self.size = photoSize
    }
}
