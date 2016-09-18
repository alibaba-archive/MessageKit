//
//  UIView+Constraint.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

extension UIView {

    func pinSubview(_ subview: UIView, toEdge attribute: NSLayoutAttribute) {
        addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: 0))
    }

    func pinAllEdgesOfSubview(_ subview: UIView) {
        pinSubview(subview, toEdge: .top)
        pinSubview(subview, toEdge: .bottom)
        pinSubview(subview, toEdge: .left)
        pinSubview(subview, toEdge: .right)
    }
}
