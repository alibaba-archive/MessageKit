//
//  CustomMessagePresenter.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/16.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public class CustomMessagePresenter<ViewModelBuilderT, InteractionHandlerT where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ModelT: CustomMessageModelProtocol,
    ViewModelBuilderT.ViewModelT: CustomMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
    InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT>
: BaseMessagePresenter<CustomBubbleView, ViewModelBuilderT, InteractionHandlerT> {
    public typealias ModelT = ViewModelBuilderT.ModelT
    public typealias ViewModelT = ViewModelBuilderT.ViewModelT
    
    public init (
        messageModel: ModelT,
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT?,
        sizingCell: CustomMessageCollectionViewCell,
        baseCellStyle: BaseMessageCollectionViewCellStyleProtocol,
        customCellStyle: CustomMessageCollectionViewCellStyleProtocol) {
            self.customCellStyle = customCellStyle
            super.init(
                messageModel: messageModel,
                viewModelBuilder: viewModelBuilder,
                interactionHandler: interactionHandler,
                sizingCell: sizingCell,
                cellStyle: baseCellStyle
            )
    }
    
    let customCellStyle: CustomMessageCollectionViewCellStyleProtocol
    
    public override class func registerCells(collectionView: UICollectionView) {
        collectionView.registerClass(CustomMessageCollectionViewCell.self, forCellWithReuseIdentifier: "custom-message-incoming")
        collectionView.registerClass(CustomMessageCollectionViewCell.self, forCellWithReuseIdentifier: "custom-message-outcoming")
    }
    
    public override func dequeueCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = self.messageViewModel.isIncoming ? "custom-message-incoming" : "custom-message-outcoming"
        return collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }
    
    public override func configureCell(cell: BaseMessageCollectionViewCell<CustomBubbleView>, decorationAttributes: ItemDecorationAttributes,  animated: Bool, additionalConfiguration: (() -> Void)?) {
        guard let cell = cell as? CustomMessageCollectionViewCell else {
            assert(false, "Invalid cell received")
            return
        }
        
        super.configureCell(cell, decorationAttributes: decorationAttributes, animated: animated) { () -> Void in
            cell.customMessageViewModel = self.messageViewModel
            cell.customMessageStyle = self.customCellStyle
            additionalConfiguration?()
        }
    }
    
    public override func canShowMenu() -> Bool {
        return true
    }
    
    public override func canPerformMenuControllerAction(action: Selector) -> Bool {
        return action == "copy:"
    }
    
    //    public override func performMenuControllerAction(action: Selector) {
    //        if action == "copy:" {
    //            UIPasteboard.generalPasteboard().string = self.messageViewModel.text
    //        } else {
    //            assert(false, "Unexpected action")
    //        }
    //    }
}