//
//  ReminderHelper.swift
//  IOTDemoReminder
//
//  Created by  on 9/4/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

import Foundation
import UIKit
import EventKit

typealias ReminderServiceRegist = (Bool, NSError!) -> Void
typealias ReminderServiceListReminder = [AnyObject] -> Void
typealias ReminderServiceListReminderWithCompareDate = ([AnyObject],[AnyObject]) -> Void


class ReminderHelper {
    /**
    Request permission for Reminder access
    
    :returns: granted:Bool
    :returns: error:NSError
    */
    class func registReminderService(onCompletion: ReminderServiceRegist) -> Void {
        let eventStore = EKEventStore()
        var flag : Bool = false
        eventStore.requestAccessToEntityType(EKEntityTypeReminder,
            completion: {(granted: Bool, error:NSError!) in
                onCompletion(granted,error)
        })
    }
    
    /**
    Getting list of reminder
    
    :returns: [AnyObject]
    */
    class func gettingReminderList(onCompletion: ReminderServiceListReminder) -> Void {
        let eventStore = EKEventStore()
        var predicate = eventStore.predicateForRemindersInCalendars(nil)
        // Get an array with all events.
        eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders: [AnyObject]!) -> Void in
            onCompletion(reminders)
        })
    }
    
    /**
    Getting List of reminder with compared date
    
    :returns: [AnyObject][AnyObject]
    */
    class func gettingListReminderWithCompareDate ( dateCompare:NSDate, onCompletion: ReminderServiceListReminderWithCompareDate) -> Void {
        let eventStore = EKEventStore()
        var oldReminders : [AnyObject] = []
        var newReminders : [AnyObject] = []
        
        var predicate = eventStore.predicateForRemindersInCalendars(nil)
        // Get an array with all events.
        eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders: [AnyObject]!) -> Void in
            for reminder : AnyObject in reminders {
                if dateCompare.isGreaterThanDate(reminder.creationDate) {
                    println(reminder)
                    oldReminders.append(reminder)
                } else {
                    println(reminder)
                    newReminders.append(reminder)
                }
            }
            onCompletion(oldReminders,newReminders)
        })
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    func addDays(daysToAdd : Int) -> NSDate {
        var secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        var dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    
    func addHours(hoursToAdd : Int) -> NSDate {
        var secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        var dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}