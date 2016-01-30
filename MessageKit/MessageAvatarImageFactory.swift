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
        let cgImage = self.CGImage
        let width = Int(size.width)
        let height = Int(size.height)
        let bitsPerComponent = CGImageGetBitsPerComponent(cgImage)
        let bytesPerRow = CGImageGetBytesPerRow(cgImage)
        let colorSpace = CGImageGetColorSpace(cgImage)
        let bitmapInfo = CGImageGetBitmapInfo(cgImage)
        
        let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)
        
        CGContextSetInterpolationQuality(context, .High)
        
        CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(width), height: CGFloat(height))), cgImage)
        
        let scaledImage = CGBitmapContextCreateImage(context).flatMap { UIImage(CGImage: $0) }
        return scaledImage!
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
