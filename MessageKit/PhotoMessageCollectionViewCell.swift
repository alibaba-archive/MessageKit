//
//  PhotoMessageCollectionViewCell.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public typealias PhotoMessageCollectionViewCellStyleProtocol = PhotoBubbleViewStyleProtocol

public final class PhotoMessageCollectionViewCell: BaseMessageCollectionViewCell<PhotoBubbleView> {
    
    static func sizingCell() -> PhotoMessageCollectionViewCell {
        let cell = PhotoMessageCollectionViewCell(frame: CGRect.zero)
        cell.viewContext = .Sizing
        return cell
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func createBubbleView() -> PhotoBubbleView {
        return PhotoBubbleView()
    }
    
    override public var viewContext: ViewContext {
        didSet {
            self.bubbleView.viewContext = self.viewContext
        }
    }
    
    var photoMessageViewModel: PhotoMessageViewModelProtocol! {
        didSet {
            self.messageViewModel = self.photoMessageViewModel
            self.bubbleView.photoMessageViewModel = self.photoMessageViewModel
        }
    }
    
    public var photoMessageStyle: PhotoMessageCollectionViewCellStyleProtocol! {
        didSet {
            self.bubbleView.photoMessageStyle = self.photoMessageStyle
        }
    }
    
    public override func performBatchUpdates(updateClosure: () -> Void, animated: Bool, completion: (() -> Void)?) {
        super.performBatchUpdates({ () -> Void in
            self.bubbleView.performBatchUpdates(updateClosure, animated: false, completion: nil)
            }, animated: animated, completion: completion)
    }
}