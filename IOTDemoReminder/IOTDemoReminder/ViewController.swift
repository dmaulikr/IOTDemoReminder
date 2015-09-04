//
//  ViewController.swift
//  IOTDemoReminder
//
//  Created by  on 9/4/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //view:
    @IBOutlet weak var viewListReminderTableView: UITableView!
    
    
    //data:
    var nsmarrListReminderTask_OLD : NSMutableArray = []
    var nsmarrListReminderTask_NEW : NSMutableArray = []
    var eventStore = EKEventStore()
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        weak var wSelf = self
        ReminderHelper.registReminderService { (granted: Bool, error: NSError!) -> Void in
            if granted {
                wSelf!.gettingReminderList()
            } else {
            //TODO: debug
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: TableView Delegate - Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return nsmarrListReminderTask_NEW.count
        } else {
            return nsmarrListReminderTask_OLD.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nsstrCellIdentifier = "ReminderTaskTableViewCell"
        let cell : ReminderTaskTableViewCell = tableView.dequeueReusableCellWithIdentifier(nsstrCellIdentifier, forIndexPath: indexPath) as! ReminderTaskTableViewCell

        if indexPath.section == 0 {
            cell.backgroundColor = UIColor.greenColor()
            cell.fetchingDataToView(nsmarrListReminderTask_NEW[indexPath.row] as! EKReminder)
        } else {
            cell.backgroundColor = UIColor.grayColor()
            cell.fetchingDataToView(nsmarrListReminderTask_OLD[indexPath.row] as! EKReminder)
        }
    
        return cell
    }
    

    //MARK: Data Utils
    func gettingReminderList() {
        if nsmarrListReminderTask_NEW.count > 0 {
            nsmarrListReminderTask_NEW.removeAllObjects()
        }
        if nsmarrListReminderTask_OLD.count > 0 {
            nsmarrListReminderTask_OLD.removeAllObjects()
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var oldDate : NSDate
        if let tempDate: AnyObject = defaults.objectForKey("ReminderStartUsing") {
            oldDate = tempDate as! NSDate
        } else {
            oldDate = NSDate()
        }
        defaults.setObject(NSDate(), forKey: "ReminderStartUsing")
        
        weak var wSelf = self
        ReminderHelper.gettingListReminderWithCompareDate(oldDate, onCompletion: { (oldReminders, newReminders) -> Void in
            wSelf!.nsmarrListReminderTask_OLD.addObjectsFromArray(oldReminders)
            wSelf!.nsmarrListReminderTask_NEW.addObjectsFromArray(newReminders)
            dispatch_async(dispatch_get_main_queue(),{
                self.viewListReminderTableView.reloadData()
                MBProgressHUD.hideHUDForView(wSelf!.view, animated: true)
            })
        })
    }
}
