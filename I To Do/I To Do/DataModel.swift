//
//  DataModel.swift
//  I To Do
//
//  Created by Chuck on 16/1/4.
//  Copyright © 2016年 Chuck. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [ToDOlistCategoryItem]()

    var indexOfSelectedList : Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("ListIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ListIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }

    func dataFilePath() -> String {
        return (documentDirectory() as NSString).stringByAppendingPathComponent("ToDoList.plist")
    }

    func saveToDoLists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "ToDoLists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }

    func loadToDoLists() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("ToDoLists") as! [ToDOlistCategoryItem]
                unarchiver.finishDecoding()
                sortLists()
            }
        }
    }
    func registerDefault() {
        let dict = ["ListIndex":-1, "FirstTime": true, "ListItemID": 0]
        NSUserDefaults.standardUserDefaults().registerDefaults(dict)
    }
    func handleFirstTime() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let firstTime = defaults.boolForKey("FirstTime")
        if firstTime {
            let list = ToDOlistCategoryItem(name: "list")
            lists.append(list)
            indexOfSelectedList = 0
            defaults.setBool(false, forKey: "FirstTime")
            defaults.synchronize()
        }
    }
    
    func sortLists() {
        lists.sortInPlace({list1, list2 in return
                list1.name.localizedCompare(list2.name) == .OrderedAscending})
    }
    class func nextListItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ListItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ListItemID")
        userDefaults.synchronize()
        return itemID

    }
    init() {
        loadToDoLists()
        registerDefault()
        handleFirstTime()
    }
}