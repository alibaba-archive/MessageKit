//
//  FileMessageCollectionViewCell.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public typealias FileMessageCollectionViewCellStyleProtocol = FileBubbleViewStyleProtocol

public final class FileMessageCollectionViewCell: BaseMessageCollectionViewCell<FileBubbleView> {
    
    static func sizingCell() -> FileMessageCollectionViewCell {
        let cell = FileMessageCollectionViewCell(frame: CGRect.zero)
        cell.viewContext = .Sizing
        return cell
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func createBubbleView() -> FileBubbleView {
        return FileBubbleView()
    }
    
    override public var viewContext: ViewContext {
        didSet {
            self.bubbleView.viewContext = self.viewContext
        }
    }
    
    var fileMessageViewModel: FileMessageViewModelProtocol! {
        didSet {
            self.messageViewModel = self.fileMessageViewModel
            self.bubbleView.fileMessageViewModel = self.fileMessageViewModel
        }
    }
    
    public var fileMessageStyle: FileMessageCollectionViewCellStyleProtocol! {
        didSet {
            self.bubbleView.fileMessageStyle = self.fileMessageStyle
        }
    }
    
    public override func performBatchUpdates(updateClosure: () -> Void, animated: Bool, completion: (() -> Void)?) {
        super.performBatchUpdates({ () -> Void in
            self.bubbleView.performBatchUpdates(updateClosure, animated: false, completion: nil)
            }, animated: animated, completion: completion)
    }
}