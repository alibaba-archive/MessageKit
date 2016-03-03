//
//  ViewController.swift
//  MessageKitDemo
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit
import MessageKit

class TextMessageTestHandler: BaseMessageInteractionHandlerProtocol {
    typealias ViewModelT = TextMessageViewModel
    
    func userDidTapOnFailIcon(viewModel viewModel: ViewModelT) {
        
    }
    
    func userDidTapOnBubble(viewModel viewModel: ViewModelT) {
        
    }
    
    func userDidLongPressOnBubble(viewModel viewModel: ViewModelT) {
        
    }
}

class FakeDataSource: MessageDataSourceProtocol {
    var hasMoreNext = true
    var hasMorePrevious = true
    var wasRequestedForPrevious = false
    var wasRequestedForMessageCountContention = false
    var chatItemsForLoadNext: [MessageItemProtocol]?
    var chatItems = [MessageItemProtocol]()
    weak var delegate: MessageDataSourceDelegateProtocol?
    
    func loadNext(completion: () -> Void) {
        if let chatItemsForLoadNext = self.chatItemsForLoadNext {
            self.chatItems = chatItemsForLoadNext
        }
        completion()
    }
    
    func loadPrevious(completion: () -> Void) {
        self.wasRequestedForPrevious = true
        completion()
    }
    
    func adjustNumberOfMessages(preferredMaxCount preferredMaxCount: Int?, focusPosition: Double, completion:(didAdjust: Bool) -> Void) {
        self.wasRequestedForMessageCountContention = true
        completion(didAdjust: false)
    }
}

class ddd: MessageItemsDecoratorProtocol {
    func decorateItems(chatItems: [MessageItemProtocol]) -> [DecoratedMessageItem] {
        
        var arr = [DecoratedMessageItem]()
        for c in chatItems {
            let d = DecoratedMessageItem(messageItem: c, decorationAttributes: ItemDecorationAttributes(bottomMargin: 10, showsTail: false))
            arr.append(d)
        }
        return arr
    }
}

class ViewController: MessageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = FPSLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 64))
        self.navigationController?.view.addSubview(label)
        self.title = "聊天测试"
        
        let fake = FakeDataSource()
        let messageModel = MessageModel(uid: "dsfsdf", senderId: "dsfsdfsdf", type: "text-message", isIncoming: false, date: NSDate(), status: .Success)
        let textMessageModel = TextMessageModel(messageModel: messageModel, text: "dsfsdkfskjdhfskdfhkjsdfhjksdfhkjsdfhksdfhjksdfhjksdfhsdkfhskdjfhksdfhksdjfhskdhfsjdkhfksjdhfkjsdhfkjsdhfkjsdhfkjsdfhkjsdhfksfhsjkfhsjkdfhjskdhfkjsdhfjksdhfk")
        
        let messageModelIncoming = MessageModel(uid: "dsfsdf", senderId: "dsfsdfsdf", type: "text-message", isIncoming: true, date: NSDate(), status: .Success)
        let textMessageModelIncoming = TextMessageModel(messageModel: messageModelIncoming, text: "dsfsdkfskjdhfskdfhkjsdfhjksdfhkjsdfhksdfhjksdfhjksdfhsdkfhskdjfhksdfhksdjfhskdhfsjdkhfksjdhfkjsdhf")
        
        fake.chatItems = [textMessageModel, textMessageModelIncoming, textMessageModel, textMessageModel, textMessageModelIncoming, textMessageModel, textMessageModel, textMessageModel, textMessageModel, textMessageModelIncoming, textMessageModel]
        
        fake.delegate = self
        self.messageDataSource = fake
        self.messageItemsDecorator = ddd()
    }
    
    override func createPresenterBuilders() -> [MessageItemType : [ItemPresenterBuilderProtocol]] {
        let builder = TextMessagePresenterBuilder(viewModelBuilder: TextMessageViewModelDefaultBuilder(), interactionHandler: TextMessageTestHandler())
        return [
            "text-message" : [
                builder
            ]
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
