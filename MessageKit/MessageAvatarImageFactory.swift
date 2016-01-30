//
//  MessageAvatarImageFactory.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

class MessageAvatarImageFactory: NSObject {

    class func circularAvatarImage(image: UIImage, WithDiameter diameter: Int) -> UIImage {
        let frame  = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        var newImage: UIImage
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        
        let _: CGContextRef = UIGraphicsGetCurrentContext()!
        let imagePath = UIBezierPath(ovalInRect: frame)
        imagePath.addClip()
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIImage {
    func circularAvatarImageWithDiameter(diameter: Int) -> UIImage {
        let frame  = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        var newImage: UIImage
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        
        let _: CGContextRef = UIGraphicsGetCurrentContext()!
        let imagePath = UIBezierPath(ovalInRect: frame)
        imagePath.addClip()
        self.drawInRect(frame)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
