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
        dataSource.append(TextMessage(type: .Outcoming, text: " Apple Watch 开发时间长达三年. 这和 2011 年开始的 iWatch 传言相符合. 当时 2011 年, 纽约时报第一个报道苹果 正在试验类似腕表的设备, 配置曲面玻璃."))
        dataSource.append(TextMessage(type: .Incoming, text: "苹果希望给开发者时间, 来为 Apple Watch 开发应用. 我们在正式上市之前就发布 Apple Watch, 一个原因是这样开发者就有时间来为它开发应用.现在 Twitter 和 Facebook 这样的大公司, 还有很多小公司, 都已经加入了开发行列. 每个开发者拿到 WatchKit 以后, 都有机会为 Apple Watch 开发应用."))
        dataSource.append(TextMessage(type: .Outcoming, text: "dsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdfdsfsdfsdfsdfsdf"))
        dataSource.append(TextMessage(type: .Incoming, text: "Tim Cook 对说的人不感兴趣. 经常有评论称苹果给用户洗脑, 不管是否属实, Tim Cook 就此事回应说, 我们并没有打算把人们丢进一个洗涤机器, 让他们外表类似, 谈吐类似, 最后思想都类似. 我们争吵和辩论"))
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
