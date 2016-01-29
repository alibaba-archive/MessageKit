//
//  BasicMessage.swift
//  MessageKit
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public enum messageType {
    case Incoming
    case Outcoming
}

public class BasicMessage {
    
    let type: messageType
    
    public init(type: messageType) {
        self.type = type
    }
}
