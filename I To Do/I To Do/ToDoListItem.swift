//
//  ToDoListItem.swift
//  I To Do
//
//  Created by Chuck on 15/12/31.
//  Copyright © 2015年 Chuck. All rights reserved.
//

import UIKit

class ToDoListItem: NSObject, NSCoding {
    var text = ""
    var checkmark = false
    var dueDate = NSDate()
    var shouldRindme = false
    var itemID: Int
    func toggleCheckitem() {
        checkmark = !checkmark
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checkmark, forKey: "Checkmark")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRindme, forKey: "ShouldRindme")
        aCoder.encodeInteger(itemID, forKey: "ItemID")

    }

    func scheduleNotification() {
        let existingNotification = notificationForItem()
        if let notification = existingNotification {
            print("找到一个通知")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }

        if shouldRindme && dueDate.compare(NSDate()) != .OrderedAscending {
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            print("We should schedule a notification!")
        }
    }

    func notificationForItem() -> UILocalNotification? {
        let allNotification = UIApplication.sharedApplication().scheduledLocalNotifications!
        for notification in allNotification  {
            if let number = notification.userInfo?["ItemID"] as? Int where number == itemID {
                return notification
            }
        }
        return nil
    }
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checkmark = aDecoder.decodeBoolForKey("Checkmark")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRindme = aDecoder.decodeBoolForKey("ShouldRindme")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        super.init()
    }

    override init() {
        itemID = DataModel.nextListItemID()
        super.init()
    }

    deinit {
        if let notification = notificationForItem() {
            print("移除通知")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
}
