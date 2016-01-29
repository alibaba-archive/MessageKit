//
//  NSBundle+Message.swift
//  MessageKit
//
//  Created by ChenHao on 1/29/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

extension NSBundle {
    
    class func messageBudle() -> NSBundle {
        return NSBundle(forClass: MessageViewController.classForCoder())
    }
}
