//
//  FileBubbleView.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol FileBubbleViewStyleProtocol {
    func folderImage(viewModel viewModel: FileMessageViewModelProtocol, isSelected: Bool) -> UIImage
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
    
    private func commonInit() {
        self.autoresizesSubviews = false
        self.addSubview(self.bubbleImageView)
        self.addSubview(self.folderIconView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.sizeLabel)
    }
    
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addSubview(self.borderImageView)
        return imageView
    }()
    
    private lazy var folderIconView: UIView = {
        let iconView = UIView()
        iconView.addSubview(self.coverImageView)
        iconView.addSubview(self.typeLabel)
        return iconView
    }()
    
    private var borderImageView: UIImageView = UIImageView()
    private var coverImageView: UIImageView = UIImageView()
    private lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.font = UIFont.systemFontOfSize(10)
        typeLabel.textColor = UIColor.whiteColor()
        return typeLabel
    }()
    private var titleLabel: UILabel = UILabel()
    private var sizeLabel: UILabel = UILabel()
    
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
        guard let _ = self.fileMessageViewModel, viewModel = self.fileMessageViewModel else {
            return
        }
        let bubbleImage = self.fileMessageStyle.bubbleImage(viewModel: viewModel, isSelected: self.selected)
        let borderImage = self.fileMessageStyle.bubbleImageBorder(viewModel: viewModel, isSelected: self.selected)
        if self.bubbleImageView.image != bubbleImage { self.bubbleImageView.image = bubbleImage }
        if self.borderImageView.image != borderImage { self.borderImageView.image = borderImage }
        self.coverImageView.image = self.fileMessageStyle.folderImage(viewModel: viewModel, isSelected: self.selected)
        self.titleLabel.text = viewModel.fileName
        self.titleLabel.font = fileMessageStyle.titleFont(viewModel: viewModel, isSelected: self.selected)
        var size = titleLabel.sizeThatFits(CGSize(width: 40, height: CGFloat.max))
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
 
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSize(width: fileWidth, height: fileHeight)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let layout = self.calculateFileBubbleLayout(maximumWidth: self.preferredMaxLayoutWidth)
        self.bubbleImageView.bma_rect = CGRect(x: 0, y: 0, width: fileWidth, height: fileHeight)
        self.folderIconView.bma_rect = layout.folderIconFrame
        self.coverImageView.bma_rect = folderIconView.bounds
        self.borderImageView.bma_rect = self.bubbleImageView.bounds
        self.titleLabel.bma_rect = CGRect(origin: layout.fileTitleLabelFrame, size: titleLabel.frame.size)
        self.sizeLabel.bma_rect = CGRect(origin: layout.fileSizeLabelFrame, size: sizeLabel.frame.size)
        self.typeLabel.center = self.coverImageView.center
    }
    
    private func calculateFileBubbleLayout(maximumWidth maximumWidth: CGFloat) -> FileBubbleLayoutModel {
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
