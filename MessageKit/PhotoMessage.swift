//
//  PhotoMessage.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public class PhotoMessage: MediaMessage {

    var photo: UIImage
    public var width: Int = 0
    public var height: Int = 0
    public init(type: messageType, photo: UIImage) {
        self.photo = photo
        super.init(type: type)
    }
}
