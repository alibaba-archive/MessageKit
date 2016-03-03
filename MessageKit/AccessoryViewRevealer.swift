//
//  AccessoryViewRevealer.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

public protocol AccessoryViewRevealable {
    func revealAccessoryView(maximumOffset offset: CGFloat, animated: Bool)
}

class AccessoryViewRevealer: NSObject, UIGestureRecognizerDelegate {
    
    private let panRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    private let collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.addGestureRecognizer(self.panRecognizer)
        self.panRecognizer.addTarget(self, action: "handlePan:")
        self.panRecognizer.delegate = self
    }
    
    @objc
    private func handlePan(panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .Began:
            break
        case .Changed:
            let translation = panRecognizer.translationInView(self.collectionView)
            self.revealAccessoryView(atOffset: -translation.x)
        case .Ended, .Cancelled, .Failed:
            self.revealAccessoryView(atOffset: 0)
        default:
            break
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != self.panRecognizer {
            return true
        }
        
        let translation = self.panRecognizer.translationInView(self.collectionView)
        let x = CGFloat.abs(translation.x), y = CGFloat.abs(translation.y)
        let angleRads = atan2(y, x)
        let threshold: CGFloat = 0.0872665 // ~5 degrees
        return angleRads < threshold
    }
    
    private func revealAccessoryView(atOffset offset: CGFloat) {
        for cell in self.collectionView.visibleCells() {
            if let cell = cell as? AccessoryViewRevealable {
                cell.revealAccessoryView(maximumOffset: offset, animated: offset == 0)
            }
        }
    }
}