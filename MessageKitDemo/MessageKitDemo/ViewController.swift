//
//  ViewController.swift
//  MessageKitDemo
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit
import MessageKit

class FakeDataSource: MessageDataSourceProtocol {
    var hasMoreNext = true
    var hasMorePrevious = true
    var wasRequestedForPrevious = false
    var wasRequestedForMessageCountContention = false
    var chatItemsForLoadNext: [MessageItemProtocol]?
    var chatItems = [MessageItemProtocol]()
//    weak var delegate: ChatDataSourceDelegateProtocol?
    
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

class ViewController: MessageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = FPSLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 64))
        self.navigationController?.view.addSubview(label)
        self.title = "聊天测试"
        
        let fake = FakeDataSource()
        let messageModel = MessageModel(uid: "dsfsdf", senderId: "dsfsdfsdf", type: "text-message", isIncoming: false, date: NSDate(), status: .Success)
        let textMessageModel = TextMessageModel(messageModel: messageModel, text: "dsfsdkfskjdhfskdfhkjsdfhjksdfhkjsdfhksdfhjksdfhjksdfhsdkfhskdjfhksdfhksdjfhskdhfsjdkhfksjdhfkjsdhfkjsdhfkjsdhfkjsdfhkjsdhfksfhsjkfhsjkdfhjskdhfkjsdhfjksdhfk")
        fake.chatItems = [textMessageModel]
        
        fake.delegate = self
        self.chatDataSource = fake
        
    
    }
    
    func addNew() {
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
