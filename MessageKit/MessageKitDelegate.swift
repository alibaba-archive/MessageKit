//
//  MessageKitDelegate.swift
//  MessageKit
//
//  Created by ChenHao on 1/29/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

protocol MessageKitDelegate: NSObjectProtocol {
    
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
