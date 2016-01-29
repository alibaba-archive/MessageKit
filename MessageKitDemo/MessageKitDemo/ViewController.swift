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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.dataSource
        messageDataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController {
    
    func messageKitCcontroller(messageViewController: MessageViewController, modelAtRow row: Int) -> BasicMessage {
        return TextMessage(text: "dsfsdfsdfsdf")
    }
}
