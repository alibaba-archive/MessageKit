//
//  MessageViewController.swift
//  MessageKit
//
//  Created by ChenHao on 1/28/16.
//  Copyright © 2016 HarriesChen. All rights reserved.
//

import UIKit

public class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTableView: MessageTableView!
    public var messageDataSource: MessageKitDataSource?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    
        NSBundle(forClass: MessageViewController.self).loadNibNamed("MessageViewController", owner: self, options: nil)
        // Do any additional setup after loading the view.
        messageTableView.dataSource = self
        messageTableView.delegate = self
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCellWithIdentifier(MessageTextCellIncoming.cellIdentifer()) as! MessageTextCellIncoming
        //cell!.textLabel?.text = "row\(indexPath.row)"
        let model = messageDataSource?.messageKitCcontroller(self, modelAtRow: indexPath.row)
        
        switch model {
        case is TextMessage:
            let model = model as! TextMessage
            cell.contentLabel.text = model.messageText
        default:
            break
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let ss: NSString = "dfdf"
        
        let size = ss.boundingRectWithSize(CGSizeMake(200, CGFloat.max), options: .UsesFontLeading, attributes: nil, context: nil)
        return size.height;
    }
}
