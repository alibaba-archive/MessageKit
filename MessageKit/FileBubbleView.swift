//
//  FileBubbleView.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol FileBubbleViewStyleProtocol {

    func folderImage(viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIImage
    func bubbleImage(viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIImage
    func bubbleImageBorder(viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIImage?
    func titleFont(viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIFont
    func titleColor(viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIColor
    func textFont(viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIFont
    func textColor(viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIColor
}

public final class FileBubbleView: UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {

    public var viewContext: ViewContext = .normal
    public var animationDuration: CFTimeInterval = 0.33
    public var preferredMaxLayoutWidth: CGFloat = 0
    public var fileWidth: CGFloat = 186
    public var fileHeight: CGFloat = 58
    public var fileBubbleViewSize = CGSize(width: 186, height: 58)
    public var fileIconSize = CGSize(width: 32, height: 40)

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
        self.addSubview(self.folderIconView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.sizeLabel)
    }

    fileprivate lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addSubview(self.borderImageView)
        return imageView
    }()

    fileprivate lazy var folderIconView: UIView = {
        let iconView = UIView()
        iconView.addSubview(self.coverImageView)
        iconView.addSubview(self.typeLabel)
        return iconView
    }()

    fileprivate var borderImageView: UIImageView = UIImageView()
    fileprivate var coverImageView: UIImageView = UIImageView()
    fileprivate lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.font = UIFont.systemFont(ofSize: 10)
        typeLabel.textColor = UIColor.white
        return typeLabel
    }()
    fileprivate var titleLabel: UILabel = UILabel()
    fileprivate var sizeLabel: UILabel = UILabel()

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
        guard let _ = self.fileMessageViewModel, let viewModel = self.fileMessageViewModel else {
            return
        }
        let bubbleImage = self.fileMessageStyle.bubbleImage(viewModel: viewModel, isSelected: self.selected)
         if self.bubbleImageView.image != bubbleImage { self.bubbleImageView.image = bubbleImage }

        if viewModel.showsBorder {
            let borderImage = self.fileMessageStyle.bubbleImageBorder(viewModel: viewModel, isSelected: self.selected)
            if self.borderImageView.image != borderImage { self.borderImageView.image = borderImage }
        }

        self.coverImageView.image = self.fileMessageStyle.folderImage(viewModel: viewModel, isSelected: self.selected)
        self.titleLabel.text = viewModel.fileName
        self.titleLabel.font = fileMessageStyle.titleFont(viewModel: viewModel, isSelected: self.selected)
        var size = titleLabel.sizeThatFits(CGSize(width: 40, height: CGFloat.greatestFiniteMagnitude))
        size.width = 120
        self.titleLabel.frame = CGRect(origin: CGPoint.zero, size: size)
        self.sizeLabel.text = viewModel.fileSize
        self.sizeLabel.font = fileMessageStyle.textFont(viewModel: viewModel, isSelected: self.selected)
        self.sizeLabel.sizeToFit()
        self.typeLabel.text = "PSD"
        self.typeLabel.sizeToFit()
        self.setNeedsLayout()
    }

    // MARK: Layout

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: fileWidth, height: fileHeight)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let layout = self.calculateFileBubbleLayout(maximumWidth: self.preferredMaxLayoutWidth)
        self.bubbleImageView.bmaRect = CGRect(x: 0, y: 0, width: fileWidth, height: fileHeight)
        self.folderIconView.bmaRect = layout.folderIconFrame
        self.coverImageView.bmaRect = folderIconView.bounds
        self.borderImageView.bmaRect = self.bubbleImageView.bounds
        self.titleLabel.bmaRect = CGRect(origin: layout.fileTitleLabelFrame, size: titleLabel.frame.size)
        self.sizeLabel.bmaRect = CGRect(origin: layout.fileSizeLabelFrame, size: sizeLabel.frame.size)
        self.typeLabel.center = self.coverImageView.center
    }

    fileprivate func calculateFileBubbleLayout(maximumWidth: CGFloat) -> FileBubbleLayoutModel {
        let layoutContext = FileBubbleLayoutModel.LayoutContext(folderIconSize: fileIconSize, preferredMaxLayoutWidth: maximumWidth)
        let layoutModel = FileBubbleLayoutModel(layoutContext: layoutContext)
        layoutModel.calculateLayout()
        return layoutModel
    }

    public var canCalculateSizeInBackground: Bool {
        return true
    }

}

private class FileBubbleLayoutModel {

    var folderIconFrame: CGRect = CGRect.zero
    var fileTitleLabelFrame: CGPoint = CGPoint.zero
    var fileSizeLabelFrame: CGPoint = CGPoint.zero

    struct LayoutContext {
        let folderIconSize: CGSize
        let preferredMaxLayoutWidth: CGFloat

        init(folderIconSize: CGSize, preferredMaxLayoutWidth width: CGFloat) {
            self.preferredMaxLayoutWidth = width
            self.folderIconSize = folderIconSize
        }
    }

    let layoutContext: LayoutContext
    init(layoutContext: LayoutContext) {
        self.layoutContext = layoutContext
    }

    func calculateLayout() {

        folderIconFrame.size = layoutContext.folderIconSize

        //adjust X
        var currentX: CGFloat = 0.0
        currentX += 15
        folderIconFrame.origin.x = currentX
        currentX += folderIconFrame.size.width
        currentX += 8
        fileTitleLabelFrame.x = currentX
        fileSizeLabelFrame.x = currentX

        //adjust Y
        var currentY: CGFloat = 0.0
        currentY += 9
        folderIconFrame.origin.y = currentY
        fileTitleLabelFrame.y = currentY

        currentY += 22
        fileSizeLabelFrame.y = currentY
    }
}
