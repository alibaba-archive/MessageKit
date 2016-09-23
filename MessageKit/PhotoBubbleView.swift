//
//  PhotoBubbleView.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol PhotoBubbleViewStyleProtocol {

    func maskingImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage
    func borderImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage?
    func placeholderBackgroundImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage
    func placeholderIconImage(viewModel: PhotoMessageViewModelProtocol) -> (icon: UIImage?, tintColor: UIColor?)
    func tailWidth(viewModel: PhotoMessageViewModelProtocol) -> CGFloat
    func bubbleSize(viewModel: PhotoMessageViewModelProtocol) -> CGSize
    func progressIndicatorColor(viewModel: PhotoMessageViewModelProtocol) -> UIColor
    func overlayColor(viewModel: PhotoMessageViewModelProtocol) -> UIColor?
}

public final class PhotoBubbleView: UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {

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
        self.addSubview(self.imageView)
        self.addSubview(self.placeholderIconView)
    }

    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.autoresizingMask = UIViewAutoresizing()
        imageView.clipsToBounds = true
        imageView.autoresizesSubviews = false
        imageView.autoresizingMask = UIViewAutoresizing()
        imageView.contentMode = .scaleAspectFill
        imageView.addSubview(self.borderView)
        return imageView
    }()

    fileprivate lazy var borderView = UIImageView()

    fileprivate lazy var overlayView: UIView = {
        let view = UIView()
        return view
    }()

    fileprivate var placeholderIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.autoresizingMask = UIViewAutoresizing()
        return imageView
    }()


    public var photoMessageViewModel: PhotoMessageViewModelProtocol! {
        didSet {
            self.updateViews()
        }
    }

    public var photoMessageStyle: PhotoBubbleViewStyleProtocol! {
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
        guard let _ = self.photoMessageViewModel, let _ = self.photoMessageStyle else { return }

        self.updateImages()
        self.setNeedsLayout()
    }

    fileprivate func updateImages() {

        self.photoMessageViewModel.imageClosure(self.imageView)

        if let overlayColor = self.photoMessageStyle.overlayColor(viewModel: self.photoMessageViewModel) {
            self.overlayView.backgroundColor = overlayColor
            self.overlayView.alpha = 1
            if self.overlayView.superview == nil {
                self.imageView.addSubview(self.overlayView)
            }
        } else {
            self.overlayView.alpha = 0
        }
        self.borderView.image = self.photoMessageStyle.borderImage(viewModel: photoMessageViewModel)
        self.imageView.layer.mask = UIImageView(image: self.photoMessageStyle.maskingImage(viewModel: self.photoMessageViewModel)).layer
    }


    // MARK: Layout

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.calculateTextBubbleLayout(maximumWidth: size.width).size
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let layout = self.calculateTextBubbleLayout(maximumWidth: self.preferredMaxLayoutWidth)
        self.placeholderIconView.center = layout.visualCenter
        self.placeholderIconView.bounds = CGRect(origin: CGPoint.zero, size: self.placeholderIconView.image?.size ?? CGSize.zero)
        self.imageView.bmaRect = layout.photoFrame
        self.imageView.layer.mask?.frame = self.imageView.layer.bounds
        self.overlayView.bmaRect = self.imageView.bounds
        self.borderView.bmaRect = self.imageView.bounds
    }

    fileprivate func calculateTextBubbleLayout(maximumWidth: CGFloat) -> PhotoBubbleLayoutModel {
        let layoutContext = PhotoBubbleLayoutModel.LayoutContext(photoMessageViewModel: self.photoMessageViewModel, style: self.photoMessageStyle, containerWidth: maximumWidth)
        let layoutModel = PhotoBubbleLayoutModel(layoutContext: layoutContext)
        layoutModel.calculateLayout()
        return layoutModel
    }

    public var canCalculateSizeInBackground: Bool {
        return true
    }
}

private class PhotoBubbleLayoutModel {

    var photoFrame: CGRect = CGRect.zero
    var visualCenter: CGPoint = CGPoint.zero // Because image is cropped a few points on the side of the tail, the apparent center will be a bit shifted
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
        self.visualCenter = self.photoFrame.bmaCenter.bmaOffsetBy(dx: offsetX, dy: 0)
        self.size = photoSize
    }
}
