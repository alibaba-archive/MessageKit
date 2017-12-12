//
//  MessageViewController.swift
//  MessageKit
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit


open class MessageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    public struct Constants {
        var updatesAnimationDuration: TimeInterval = 0.33
        var defaultContentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        var defaultScrollIndicatorInsets = UIEdgeInsets.zero
        var preferredMaxMessageCount: Int? = 500
        var preferredMaxMessageCountAdjustment: Int = 400
        var autoloadingFractionalThreshold: CGFloat = 0.05 // in [0, 1]
    }

    open var constants = Constants()
    var inputContainer: UIView!
    var decoratedMessageItems = [DecoratedMessageItem]()
    var presenterBuildersByType = [MessageItemType: [ItemPresenterBuilderProtocol]]()
    var isAutoLoadingEnabled: Bool = false
    var layoutModel = MessageCollectionViewLayoutModel.createModel(0, itemsLayoutData: [])
    let presentersByMessageItem = NSMapTable<AnyObject, AnyObject>(keyOptions: [.weakMemory], valueOptions: [.strongMemory])
    let presentersByCell = NSMapTable<AnyObject, AnyObject>(keyOptions: [.weakMemory], valueOptions: [.weakMemory])
    var updateQueue: SerialTaskQueueProtocol = SerialTaskQueue()
    open fileprivate(set) var collectionView: UICollectionView!
    open var inputContainerBottomConstraint: NSLayoutConstraint!
    open var isFirstLayout: Bool = true
    open var messageItemsDecorator: MessageItemsDecoratorProtocol?

    open var messageDataSource: MessageDataSourceProtocol? {
        didSet {
            messageDataSource?.delegate = self
            enqueueModelUpdate(context: .reload)
        }
    }

    open func createPresenterBuilders() -> [MessageItemType: [ItemPresenterBuilderProtocol]] {
        assert(false, "Override in subclass")
        return [MessageItemType: [ItemPresenterBuilderProtocol]]()
    }

    open func createInputView() -> UIView {
        assert(false, "Override in subclass")
        return UIView()
    }

    open func sendNewMessage(_ message: MessageItemProtocol) {
        var newItem = self.messageDataSource?.messageItems
        newItem?.append(message)
        self.messageDataSource?.messageItems = newItem!
        enqueueModelUpdate(context: .normal)
    }

    open func sendNewMessages(_ messages: [MessageItemProtocol]) {
        var newItem = self.messageDataSource?.messageItems
        messages.forEach { (message) in
            newItem?.append(message)
        }
        self.messageDataSource?.messageItems = newItem!
        enqueueModelUpdate(context: .normal)
    }

    var collectionViewLayout: UICollectionViewLayout {
        let layout = MessageCollectionViewLayout()
        layout.delegate = self
        return layout
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        addInputView()
    }

    open override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    }


    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        adjustCollectionViewInsets()
        if self.isFirstLayout {
            updateQueue.start()
            isFirstLayout = false
        }
    }

    fileprivate func addCollectionView() {
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
        self.collectionView.contentInset = self.constants.defaultContentInsets
        self.collectionView.scrollIndicatorInsets = self.constants.defaultScrollIndicatorInsets
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.keyboardDismissMode = .interactive
        self.collectionView.showsVerticalScrollIndicator = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.allowsSelection = false

        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.autoresizingMask = UIViewAutoresizing()
        self.view.addSubview(self.collectionView)
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .top, relatedBy: .equal, toItem: self.collectionView, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: self.collectionView, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.collectionView, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.collectionView, attribute: .trailing, multiplier: 1, constant: 0))
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
        self.inputContainer.autoresizingMask = UIViewAutoresizing()
        self.inputContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.inputContainer)
        self.view.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: self.inputContainer, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.inputContainer, attribute: .trailing, multiplier: 1, constant: 0))
        self.inputContainerBottomConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.inputContainer, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(self.inputContainerBottomConstraint)

        let inputView = createInputView()
        inputView.translatesAutoresizingMaskIntoConstraints = false
        self.inputContainer.addSubview(inputView)
        self.inputContainer.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .top, relatedBy: .equal, toItem: inputView, attribute: .top, multiplier: 1, constant: 0))
        self.inputContainer.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .leading, relatedBy: .equal, toItem: inputView, attribute: .leading, multiplier: 1, constant: 0))
        if #available(iOS 11.0, *) {
            self.inputContainer.backgroundColor = inputView.backgroundColor ?? UIColor.white
            self.inputContainer.addConstraint(NSLayoutConstraint(item: self.inputContainer.safeAreaLayoutGuide, attribute: .bottom, relatedBy: .equal, toItem: inputView, attribute: .bottom, multiplier: 1, constant: 0))
        } else {
            self.inputContainer.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .bottom, relatedBy: .equal, toItem: inputView, attribute: .bottom, multiplier: 1, constant: 0))
        }
        self.inputContainer.addConstraint(NSLayoutConstraint(item: self.inputContainer, attribute: .trailing, relatedBy: .equal, toItem: inputView, attribute: .trailing, multiplier: 1, constant: 0))
    }

    fileprivate func adjustCollectionViewInsets() {
        let isInteracting = self.collectionView.panGestureRecognizer.numberOfTouches > 0
        let isBouncingAtTop = isInteracting && self.collectionView.contentOffset.y < -self.collectionView.contentInset.top
        if isBouncingAtTop { return }

        let inputHeightWithKeyboard = self.view.bounds.height - self.inputContainer.frame.minY
        let newInsetBottom = self.constants.defaultContentInsets.bottom + inputHeightWithKeyboard
        let insetBottomDiff = newInsetBottom - self.collectionView.contentInset.bottom

        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        let allContentFits = self.collectionView.bounds.height - newInsetBottom - (contentSize.height + self.collectionView.contentInset.top) >= 0

        let currentDistanceToBottomInset = max(0, self.collectionView.bounds.height - self.collectionView.contentInset.bottom - (contentSize.height - self.collectionView.contentOffset.y))
        let newContentOffsetY = self.collectionView.contentOffset.y + insetBottomDiff - currentDistanceToBottomInset

        self.collectionView.contentInset.bottom = newInsetBottom
        if #available(iOS 11.0, *) {
            let indicatorBottom = self.constants.defaultScrollIndicatorInsets.bottom + inputHeightWithKeyboard - view.safeAreaInsets.bottom
            self.collectionView.scrollIndicatorInsets.bottom = max(indicatorBottom, 0)
        } else {
            self.collectionView.scrollIndicatorInsets.bottom = self.constants.defaultScrollIndicatorInsets.bottom + inputHeightWithKeyboard
        }
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

    func rectAtIndexPath(_ indexPath: IndexPath?) -> CGRect? {
        if let indexPath = indexPath {
            return self.collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame
        }
        return nil
    }
}

extension MessageViewController {

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let shouldScrollToBottom = self.isScrolledAtBottom()
        let referenceIndexPath = self.collectionView.indexPathsForVisibleItems.first
        let oldRect = self.rectAtIndexPath(referenceIndexPath)
        coordinator.animate(alongsideTransition: { (context) -> Void in
            if shouldScrollToBottom {
                self.scrollToBottom(animated: false)
            } else {
                let newRect = self.rectAtIndexPath(referenceIndexPath)
                self.scrollToPreservePosition(oldRefRect: oldRect, newRefRect: newRect)
            }
        }, completion: nil)
    }
}
