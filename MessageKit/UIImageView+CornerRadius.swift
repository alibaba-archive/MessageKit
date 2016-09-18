//
//  UIImageView+CornerRadius.swift
//  MessageKit
//
//  Created by ChenHao on 16/3/4.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import Foundation

extension UIImage {
    func drawRectWithRoundedCorner(radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext(); return output!
    }
}

extension UIImageView { /** / !!!只有当 imageView 不为nil 时，调用此方法才有效果 :param: radius 圆角半径 */
    func addCorner(radius: CGFloat) {
        self.image = self.image?.drawRectWithRoundedCorner(radius: radius, self.bounds.size)
    }
}
