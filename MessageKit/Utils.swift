/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import Foundation
import CoreGraphics

private let scale = UIScreen.main.scale

public enum HorizontalAlignment {
    case left
    case center
    case right
}

public enum VerticalAlignment {
    case top
    case center
    case bottom
}

public extension CGSize {

    func bmaInsetBy(dx: CGFloat, dy: CGFloat) -> CGSize {
        return CGSize(width: self.width - dx, height: self.height - dy)
    }

    func bmaOutsetBy(dx: CGFloat, dy: CGFloat) -> CGSize {
        return self.bmaInsetBy(dx: -dx, dy: -dy)
    }
}

public extension CGSize {

    func bmaRound() -> CGSize {
        return CGSize(width: ceil(self.width * scale) * (1.0 / scale), height: ceil(self.height * scale) * (1.0 / scale) )
    }

    func bmaRect(inContainer containerRect: CGRect, xAlignament: HorizontalAlignment, yAlignment: VerticalAlignment, dx: CGFloat, dy: CGFloat) -> CGRect {
        var originX, originY: CGFloat

        // Horizontal alignment
        switch xAlignament {
        case .left:
            originX = 0
        case .center:
            originX = containerRect.midX - self.width / 2.0
        case .right:
            originX = containerRect.maxY - self.width
        }

        // Vertical alignment
        switch yAlignment {
        case .top:
            originY = 0
        case .center:
            originY = containerRect.midY - self.height / 2.0
        case .bottom:
            originY = containerRect.maxY - self.height
        }

        return CGRect(origin: CGPoint(x: originX, y: originY).bmaOffsetBy(dx: dx, dy: dy), size: self)
    }
}

public extension CGRect {
    var bmaBounds: CGRect {
        return CGRect(origin: CGPoint.zero, size: self.size)
    }

    var bmaCenter: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }

    var bmaMaxY: CGFloat {
        get {
            return self.maxY
        } set {
            let delta = newValue - self.maxY
            self.origin = self.origin.bmaOffsetBy(dx: 0, dy: delta)
        }
    }

    func bmaRound() -> CGRect {
        let origin = CGPoint(x: ceil(self.origin.x * scale) * (1.0 / scale), y: ceil(self.origin.y * scale) * (1.0 / scale))
        return CGRect(origin: origin, size: self.size.bmaRound())
    }
}


public extension CGPoint {
    func bmaOffsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
}

public extension UIView {
    var bmaRect: CGRect {
        get {
            return CGRect(origin: CGPoint(x: self.center.x - self.bounds.width / 2, y: self.center.y - self.bounds.height), size: self.bounds.size)
        }
        set {
            let roundedRect = newValue.bmaRound()
            self.bounds = roundedRect.bmaBounds
            self.center = roundedRect.bmaCenter
        }
    }
}

public extension UIEdgeInsets {

    public var bmaHorziontalInset: CGFloat {
        return self.left + self.right
    }

    public var bmaVerticalInset: CGFloat {
        return self.top + self.bottom
    }

    public var bmaHashValue: Int {
        return self.top.hashValue ^ self.left.hashValue ^ self.bottom.hashValue ^ self.right.hashValue
    }

}


public extension UIImage {

    public func bmaTintWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(rect)
        self.draw(in: rect, blendMode: .destinationIn, alpha: 1)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!.resizableImage(withCapInsets: self.capInsets)
    }

    public func bmaBlendWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: rect.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        context?.draw(self.cgImage!, in: rect)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.addRect(rect)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!.resizableImage(withCapInsets: self.capInsets)
    }

    public static func bmaImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIColor {
    static func bmaColor(rgb: Int) -> UIColor {
        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0xFF00) >> 8) / 255.0, blue: CGFloat((rgb & 0xFF)) / 255.0, alpha: 1.0)
    }

    public func bmaBlendWithColor(_ color: UIColor) -> UIColor {
        var r1: CGFloat = 0, r2: CGFloat = 0
        var g1: CGFloat = 0, g2: CGFloat = 0
        var b1: CGFloat = 0, b2: CGFloat = 0
        var a1: CGFloat = 0, a2: CGFloat = 0
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let alpha = a2, beta = 1 - alpha
        let r = r1 * beta + r2 * alpha
        let g = g1 * beta + g2 * alpha
        let b = b1 * beta + b2 * alpha
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
