//
//  Reusable.swift
//  MessageKit
//
//  Created by ChenHao on 1/30/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

protocol NibReusable: Reusable {
    static var nib: UINib { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(self)
    }
}

extension NibReusable {
    static var nib: UINib {
        return UINib(nibName: String(self), bundle: NSBundle(forClass: MessageViewController.classForCoder()))
    }
}

extension UITableView {
    
    
    func dequeueReusableCell<T: UITableViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
}