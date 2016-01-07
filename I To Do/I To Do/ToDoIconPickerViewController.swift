//
//  ToDoIconPickerViewController.swift
//  I To Do
//
//  Created by Chuck on 16/1/5.
//  Copyright © 2016年 Chuck. All rights reserved.
//

import UIKit

protocol ToDoIconPickerViewControllerDelegate: class {
    func iconPicker(pickerViewController: ToDoIconPickerViewController, didPickIcon iconName: String)
}

class ToDoIconPickerViewController: UITableViewController {

    weak var delegate: ToDoIconPickerViewControllerDelegate?
    let icons = ["No Icon",
                "Appointments",
                "Birthdays",
                "Chores",
                "Drinks",
                "Folder",
                "Groceries",
                "Inbox",
                "Photos",
                "Trips" ]
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return icons.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: indexPath)
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)

        return cell
    }

}
extension ToDoIconPickerViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let iconName = icons[indexPath.row]
        delegate?.iconPicker(self, didPickIcon: iconName )
    }
}
