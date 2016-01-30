//
//  MessageKitDelegate.swift
//  MessageKit
//
//  Created by ChenHao on 1/29/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public protocol MessageKitDelegate: NSObjectProtocol {
    
    /**
     
     
     - parameter messageViewController: <#messageViewController description#>
     
     - returns: <#return value description#>
     */
    func bubbleIncomingWithMessageKitCcontroller(messageViewController: MessageViewController) -> UIColor
    
    /**
     <#Description#>
     
     - parameter messageViewController: <#messageViewController description#>
     
     - returns: <#return value description#>
     */
    func bubbleOutcomingWithMessageKitCcontroller(messageViewController: MessageViewController) -> UIColor
    
}

extension MessageViewController: MessageKitDelegate {

    public func bubbleIncomingWithMessageKitCcontroller(messageViewController: MessageViewController) -> UIColor {
        return UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
    }
    
    
    public func bubbleOutcomingWithMessageKitCcontroller(messageViewController: MessageViewController) -> UIColor {
        return UIColor(red: 3/255.0, green: 169/255.0, blue: 244/155.0, alpha: 1)
    }
}