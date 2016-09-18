//
//  UIImage+Mask.swift
//  MessageKit
//
//  Created by ChenHao on 1/29/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

extension UIImage {
    func imageMasked(with color: UIColor) -> UIImage {
        let imageRect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)

        var newImage: UIImage
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -(imageRect.size.height))

        context?.clip(to: imageRect, mask: self.cgImage!)
        context?.setFillColor(color.cgColor)
        context?.fill(imageRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
