//
//  FileMessagePresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/7.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public class FileMessagePresenter<ViewModelBuilderT, InteractionHandlerT where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: FileMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: FileMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT>
: BaseMessagePresenter<FileBubbleView, ViewModelBuilderT, InteractionHandlerT> {
    public typealias ModelT = ViewModelBuilderT.ModelT
    public typealias ViewModelT = ViewModelBuilderT.ViewModelT
    
    public init (
        messageModel: ModelT,
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT?,
        sizingCell: FileMessageCollectionViewCell,
        baseCellStyle: BaseMessageCollectionViewCellStyleProtocol,
        fileCellStyle: FileMessageCollectionViewCellStyleProtocol) {
            self.fileCellStyle = fileCellStyle
            super.init(
                messageModel: messageModel,
                viewModelBuilder: viewModelBuilder,
                interactionHandler: interactionHandler,
                sizingCell: sizingCell,
                cellStyle: baseCellStyle
            )
    }
    
    let fileCellStyle: FileMessageCollectionViewCellStyleProtocol
    
    public override class func registerCells(collectionView: UICollectionView) {
        collectionView.registerClass(FileMessageCollectionViewCell.self, forCellWithReuseIdentifier: "file-message-incoming")
        collectionView.registerClass(FileMessageCollectionViewCell.self, forCellWithReuseIdentifier: "file-message-outcoming")
    }
    
    public override func dequeueCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = self.messageViewModel.isIncoming ? "file-message-incoming" : "file-message-outcoming"
        return collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }
    
    public override func configureCell(cell: BaseMessageCollectionViewCell<FileBubbleView>, decorationAttributes: ItemDecorationAttributes,  animated: Bool, additionalConfiguration: (() -> Void)?) {
        guard let cell = cell as? FileMessageCollectionViewCell else {
            assert(false, "Invalid cell received")
            return
        }
        
        super.configureCell(cell, decorationAttributes: decorationAttributes, animated: animated) { () -> Void in
            cell.fileMessageViewModel = self.messageViewModel
            cell.fileMessageStyle = self.fileCellStyle
            additionalConfiguration?()
        }
    }
    
    public override func canShowMenu() -> Bool {
        return true
    }
    
    public override func canPerformMenuControllerAction(action: Selector) -> Bool {
        return action.description == "copy:"
    }
    
//    public override func performMenuControllerAction(action: Selector) {
//        if action == "copy:" {
//            UIPasteboard.generalPasteboard().string = self.messageViewModel.text
//        } else {
//            assert(false, "Unexpected action")
//        }
//    }
}
