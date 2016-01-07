//
//  ToDOlistCategoryItem.swift
//  I To Do
//
//  Created by Chuck on 16/1/4.
//  Copyright © 2016年 Chuck. All rights reserved.
//

import UIKit

class ToDOlistCategoryItem: NSObject, NSCoding {
    var name = ""
    var iconName: String
    var items = [ToDoListItem]()

    func countUncheckItems() -> Int {
        var count = 0
        for item in items where !item.checkmark {
            count += 1
        }
        return count
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(iconName, forKey: "IconName")
    }
    required init?(coder aDecoder: NSCoder) {
        items = aDecoder.decodeObjectForKey("Items") as! [ToDoListItem]
        name = aDecoder.decodeObjectForKey("Name") as! String
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        super.init()
    }
    init(name: String) {
        self.name = name
        iconName = "No Icon"
        super.init()
    }

}
