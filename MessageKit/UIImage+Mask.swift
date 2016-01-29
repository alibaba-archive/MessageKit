//
//  UIImage+Mask.swift
//  MessageKit
//
//  Created by ChenHao on 1/29/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

extension UIImage {
    func imageMaskedWithColor(color: UIColor) -> UIImage {
        let imageRect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        
        var newImage: UIImage
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        let context: CGContextRef? = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -(imageRect.size.height))
        
        CGContextClipToMask(context, imageRect, self.CGImage)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, imageRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
