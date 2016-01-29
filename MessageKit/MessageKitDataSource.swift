//
//  MessageKitDataSource.swift
//  MessageKit
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public protocol MessageKitDataSource: NSObjectProtocol {
    
    func messageKitCcontroller(messageViewController: MessageViewController, modelAtRow row: Int) -> BasicMessage
}
