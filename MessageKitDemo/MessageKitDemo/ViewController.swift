//
//  ViewController.swift
//  MessageKitDemo
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit
import MessageKit

class ViewController: MessageViewController, MessageKitDataSource {

    var dataSource: [BasicMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.dataSource
        messageDataSource = self
        dataSource.append(TextMessage(type: .Incoming, text: "123456"))
        dataSource.append(TextMessage(type: .Incoming, text: "www.baidu.com"))
        dataSource.append(TextMessage(type: .Outcoming, text: "dsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Incoming, text: "纵观移动市场，一款移动app，要想长期在移动市场立足，最起码要包含以下几个要素：实用的功能、极强的用户体验、华丽简洁的外观。华丽外观的背后，少不了美工的辛苦设计，但如果开发人员不懂得怎么合理展示这些设计好的图片，将会糟蹋了这些设计，功亏一篑。比如下面张图片，本来是设计来做按钮背景的"))
        dataSource.append(TextMessage(type: .Outcoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Incoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Outcoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Incoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Outcoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Incoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Outcoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Incoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Outcoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Incoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Outcoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Incoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Outcoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController {
    
    func messageKitCcontroller(messageViewController: MessageViewController, modelAtRow row: Int) -> BasicMessage {
        return dataSource[row]
    }
    
    func numberOfROwinMessageKitCcontroller(messageViewController: MessageViewController) -> Int {
        return dataSource.count
    }
}
