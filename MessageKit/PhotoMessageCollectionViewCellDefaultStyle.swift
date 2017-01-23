//
//  PhotoMessageCollectionViewCellDefaultStyle.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

open class PhotoMessageCollectionViewCellDefaultStyle: PhotoMessageCollectionViewCellStyleProtocol {

    fileprivate struct Constants {
        let tailWidth: CGFloat = 6.0
        let aspectRatioIntervalForSquaredSize: ClosedRange<CGFloat> = 0.90...1.10
        let photoSizeLandscape = CGSize(width: 210, height: 136)
        let photoSizePortratit = CGSize(width: 136, height: 210)
        let photoSizeSquare = CGSize(width: 210, height: 210)
        let placeholderIconTintIncoming = UIColor.bmaColor(rgb: 0xced6dc)
        let placeholderIconTintOugoing = UIColor.bmaColor(rgb: 0x508dfc)
        let progressIndicatorColorIncoming = UIColor.bmaColor(rgb: 0x98a3ab)
        let progressIndicatorColorOutgoing = UIColor.white
        let overlayColor = UIColor.black.withAlphaComponent(0.70)
    }

    lazy fileprivate var styleConstants = Constants()
    lazy fileprivate var baseStyle = BaseMessageCollectionViewCellDefaultSyle()

    lazy fileprivate var maskImageIncomingTail: UIImage = {
        return UIImage(named: "bubble-incoming-tail", in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }()

    lazy fileprivate var maskImageIncomingNoTail: UIImage = {
        return UIImage(named: "bubble-incoming", in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }()

    lazy fileprivate var maskImageOutgoingTail: UIImage = {
        return UIImage(named: "bubble-outgoing-tail", in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }()

    lazy fileprivate var maskImageOutgoingNoTail: UIImage = {
        return UIImage(named: "bubble-outgoing", in: Bundle(for: type(of: self)), compatibleWith: nil)!
    }()

    lazy fileprivate var placeholderBackgroundIncoming: UIImage = {
        return UIImage.bmaImageWithColor(self.baseStyle.baseColorIncoming, size: CGSize(width: 1, height: 1))
    }()

    lazy fileprivate var placeholderBackgroundOutgoing: UIImage = {
        return UIImage.bmaImageWithColor(self.baseStyle.baseColorOutgoing, size: CGSize(width: 1, height: 1))
    }()

    open func maskingImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage {
        switch (viewModel.isIncoming, viewModel.showsTail) {
        case (true, true):
            return self.maskImageIncomingTail
        case (true, false):
            return self.maskImageIncomingNoTail
        case (false, true):
            return self.maskImageOutgoingTail
        case (false, false):
            return self.maskImageOutgoingNoTail
        }
    }

    open func borderImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage? {
        return self.baseStyle.borderImage(viewModel: viewModel)
    }

    open func placeholderBackgroundImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage {
        return viewModel.isIncoming ? self.placeholderBackgroundIncoming : self.placeholderBackgroundOutgoing
    }

    open func placeholderIconImage(viewModel: PhotoMessageViewModelProtocol) -> (icon: UIImage?, tintColor: UIColor?) {
        return (nil, nil)
    }

    open func tailWidth(viewModel: PhotoMessageViewModelProtocol) -> CGFloat {
        return self.styleConstants.tailWidth
    }

    open func bubbleSize(viewModel: PhotoMessageViewModelProtocol) -> CGSize {
        let aspectRatio = viewModel.imageSize.height > 0 ? viewModel.imageSize.width / viewModel.imageSize.height : 0

        if aspectRatio == 0 || self.styleConstants.aspectRatioIntervalForSquaredSize.contains(aspectRatio) {
            return self.styleConstants.photoSizeSquare
        } else if aspectRatio < self.styleConstants.aspectRatioIntervalForSquaredSize.lowerBound {
            return self.styleConstants.photoSizePortratit
        } else {
            return self.styleConstants.photoSizeLandscape
        }
    }

    open func progressIndicatorColor(viewModel: PhotoMessageViewModelProtocol) -> UIColor {
        return viewModel.isIncoming ? self.styleConstants.progressIndicatorColorIncoming : self.styleConstants.progressIndicatorColorOutgoing
    }

    open func overlayColor(viewModel: PhotoMessageViewModelProtocol) -> UIColor? {
        return nil
    }

}
