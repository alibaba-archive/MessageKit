//
//  NSBundle+Message.swift
//  MessageKit
//
//  Created by ChenHao on 1/29/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

extension Bundle {

    class func messageBudle() -> Bundle {
        return Bundle(for: MessageViewController.classForCoder())
    }
}
