//
//  UIView+Constraint.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

extension UIView{
    
    func pinSubview(subview: UIView, toEdge attribute: NSLayoutAttribute) {
        addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: 0))
    }
    
    func pinAllEdgesOfSubview(subview: UIView) {
        pinSubview(subview, toEdge: .Top)
        pinSubview(subview, toEdge: .Bottom)
        pinSubview(subview, toEdge: .Left)
        pinSubview(subview, toEdge: .Right)
    }
}
