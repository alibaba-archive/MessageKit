//
//  MessageViewController.swift
//  MessageKit
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit


public class MessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    public struct Constants {
        var updatesAnimationDuration: NSTimeInterval = 0.33
        var defaultContentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        var defaultScrollIndicatorInsets = UIEdgeInsetsZero
        var preferredMaxMessageCount: Int? = 500
        var preferredMaxMessageCountAdjustment: Int = 400
        var autoloadingFractionalThreshold: CGFloat = 0.05 // in [0, 1]
    }
    
    public var constants = Constants()
    var inputContainer: UIView!
    var decoratedMessageItems = [DecoratedMessageItem]()
    var presenterBuildersByType = [MessageItemType: [ItemPresenterBuilderProtocol]]()
    var autoLoadingEnabled: Bool = false
    var layoutModel = MessageCollectionViewLayoutModel.createModel(0, itemsLayoutData: [])
    let presentersByMessageItem = NSMapTable(keyOptions: .WeakMemory, valueOptions: .StrongMemory)
    let presentersByCell = NSMapTable(keyOptions: .WeakMemory, valueOptions: .WeakMemory)
    var updateQueue: SerialTaskQueueProtocol = SerialTaskQueue()
    public private(set) var collectionView: UICollectionView!
    private var inputContainerBottomConstraint: NSLayoutConstraint!
    public var isFirstLayout: Bool = true
    public var messageItemsDecorator: MessageItemsDecoratorProtocol?
    
    public var messageDataSource: MessageDataSourceProtocol? {
        didSet {
            messageDataSource?.delegate = self
            enqueueModelUpdate(context: .Reload)
        }
    }
    
    public func createPresenterBuilders() -> [MessageItemType: [ItemPresenterBuilderProtocol]] {
        assert(false, "Override in subclass")
        return [MessageItemType: [ItemPresenterBuilderProtocol]]()
    }
    
    public func createInputView() -> UIView {
        assert(false, "Override in subclass")
        return UIView()
    }
    
    public func sendNewMessage(message: MessageItemProtocol) {
        var newItem = self.messageDataSource?.messageItems
        newItem?.append(message)
        self.messageDataSource?.messageItems = newItem!
        enqueueModelUpdate(context: .Normal)
    }
    
    
    var collectionViewLayout: UICollectionViewLayout {
        let layout = MessageCollectionViewLayout()
        layout.delegate = self
        return layout
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        addInputView()
    }

    public override func viewDidAppear(animated: Bool) {
       super.viewDidAppear(animated)
    }
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustCollectionViewInsets()
        if self.isFirstLayout {
            updateQueue.start()
            isFirstLayout = false
        }
    }
    
    private func addCollectionView() {
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
        self.collectionView.contentInset = self.constants.defaultContentInsets
        self.collectionView.scrollIndicatorInsets = self.constants.defaultScrollIndicatorInsets
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.keyboardDismissMode = .Interactive
        self.collectionView.showsVerticalScrollIndicator = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.allowsSelection = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.autoresizingMask = .None
        self.view.addSubview(self.collectionView)
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Top, relatedBy: .Equal, toItem: self.collectionView, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Leading, relatedBy: .Equal, toItem: self.collectionView, attribute: .Leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: self.collectionView, attribute: .Bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: self.collectionView, attribute: .Trailing, multiplier: 1, constant: 0))
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.presenterBuildersByType = self.createPresenterBuilders()
        for presenterBuilder in self.presenterBuildersByType.flatMap({ $0.1 }) {
            presenterBuilder.presenterType.registerCells(self.collectionView)
        }
        DummyMessageItemPresenter.registerCells(self.collectionView)
    }
    
    func addInputView() {
        self.inputContainer = UIView(frame: CGRect.zero)
        self.inputContainer.autoresizingMask = .None
        self.inputContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.inputContainer)
        self.view.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Leading, relatedBy: .Equal, toItem: self.inputContainer, attribute: .Leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: self.inputContainer, attribute: .Trailing, multiplier: 1, constant: 0))
        self.inputContainerBottomConstraint = NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: self.inputContainer, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(self.inputContainerBottomConstraint)
        
        let inputView = createInputView()
        inputView.translatesAutoresizingMaskIntoConstraints = false
        self.inputContainer.addSubview(inputView)
        self.inputContainer.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .Top, relatedBy: .Equal, toItem: inputView, attribute: .Top, multiplier: 1, constant: 0))
        self.inputContainer.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .Leading, relatedBy: .Equal, toItem: inputView, attribute: .Leading, multiplier: 1, constant: 0))
        self.inputContainer.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .Bottom, relatedBy: .Equal, toItem: inputView, attribute: .Bottom, multiplier: 1, constant: 0))
        self.inputContainer.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .Trailing, relatedBy: .Equal, toItem: inputView, attribute: .Trailing, multiplier: 1, constant: 0))
        
//        self.keyboardTracker = KeyboardTracker(viewController: self, inputContainer: self.inputContainer, inputContainerBottomContraint: self.inputContainerBottomConstraint, notificationCenter: self.notificationCenter)
    }
    
    private func adjustCollectionViewInsets() {
        let isInteracting = self.collectionView.panGestureRecognizer.numberOfTouches() > 0
        let isBouncingAtTop = isInteracting && self.collectionView.contentOffset.y < -self.collectionView.contentInset.top
        if isBouncingAtTop { return }
        
        let inputHeightWithKeyboard = self.view.bounds.height - self.inputContainer.frame.minY
        let newInsetBottom = self.constants.defaultContentInsets.bottom + inputHeightWithKeyboard
        let insetBottomDiff = newInsetBottom - self.collectionView.contentInset.bottom
        
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize()
        let allContentFits = self.collectionView.bounds.height - newInsetBottom - (contentSize.height + self.collectionView.contentInset.top) >= 0
        
        let currentDistanceToBottomInset = max(0, self.collectionView.bounds.height - self.collectionView.contentInset.bottom - (contentSize.height - self.collectionView.contentOffset.y))
        let newContentOffsetY = self.collectionView.contentOffset.y + insetBottomDiff - currentDistanceToBottomInset
        
        self.collectionView.contentInset.bottom = newInsetBottom
        self.collectionView.scrollIndicatorInsets.bottom = self.constants.defaultScrollIndicatorInsets.bottom + inputHeightWithKeyboard
        let inputIsAtBottom = self.view.bounds.maxY - self.inputContainer.frame.maxY <= 0
        
        if allContentFits {
            self.collectionView.contentOffset.y = -self.collectionView.contentInset.top
        } else if !isInteracting || inputIsAtBottom {
            self.collectionView.contentOffset.y = newContentOffsetY
        }
        
        self.workaroundContentInsetBugiOS_9_0_x()
    }
    
    func workaroundContentInsetBugiOS_9_0_x() {
        // Fix for http://www.openradar.me/22106545
        self.collectionView.contentInset.top = self.topLayoutGuide.length + self.constants.defaultContentInsets.top
        self.collectionView.scrollIndicatorInsets.top = self.topLayoutGuide.length + self.constants.defaultScrollIndicatorInsets.top
    }
    
    func rectAtIndexPath(indexPath: NSIndexPath?) -> CGRect? {
        if let indexPath = indexPath {
            return self.collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath)?.frame
        }
        return nil
    }
}

extension MessageViewController {
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        let shouldScrollToBottom = self.isScrolledAtBottom()
        let referenceIndexPath = self.collectionView.indexPathsForVisibleItems().first
        let oldRect = self.rectAtIndexPath(referenceIndexPath)
        coordinator.animateAlongsideTransition({ (context) -> Void in
            if shouldScrollToBottom {
                self.scrollToBottom(animated: false)
            } else {
                let newRect = self.rectAtIndexPath(referenceIndexPath)
                self.scrollToPreservePosition(oldRefRect: oldRect, newRefRect: newRect)
            }
            }, completion: nil)
    }
}
