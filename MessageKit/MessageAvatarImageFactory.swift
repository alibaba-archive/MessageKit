//
//  MessageAvatarImageFactory.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

class MessageImageFactory: NSObject {

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
    
    class func roundImage(image: UIImage, corner: Int) {
        
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
    
    func scaleToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaleImage
    }
    
    func clipRoundCorner(corner: CGFloat) -> UIImage {
        let frame  = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        var newImage: UIImage
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        
        let _: CGContextRef = UIGraphicsGetCurrentContext()!
        let imagePath = UIBezierPath(roundedRect: frame, cornerRadius: corner)
        imagePath.addClip()
        self.drawInRect(frame)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
