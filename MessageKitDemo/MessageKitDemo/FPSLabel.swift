//
//  FPSLabel.swift
//  MessageKitDemo
//
//  Created by ChenHao on 16/2/24.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import UIKit

class FPSLabel: UILabel {
    
    var link: CADisplayLink!
    var lastTime: NSTimeInterval = NSTimeInterval()
    var count: UInt64 = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        link = CADisplayLink(target: self, selector: #selector(tick))
        link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        self.backgroundColor = UIColor.redColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tick(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count += 1
        let delta = link.timestamp - lastTime
        if delta < 1 { return }
        
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count  = 0
        self.text = "FPS:\(Int(round(fps)))"
    }
    
}