//
//  ToDoItemDetailViewController.swift
//  I To Do
//
//  Created by Chuck on 16/1/3.
//  Copyright © 2016年 Chuck. All rights reserved.
//

import UIKit

protocol TodoItemDetailViewControllerDelegate: class {

    func addViewControllDidCancel(controller: ToDoItemDetailViewController)
    func addViewControllDidDone(controller: ToDoItemDetailViewController, didFinshAddinteItem item: ToDoListItem)
    func addViewControllerDidDone(controller: ToDoItemDetailViewController, didFinshEditingItem item: ToDoListItem)
}

class ToDoItemDetailViewController: UITableViewController {
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var iteminfoTextFleld: UITextField!
    //协议的声明方式
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: TodoItemDetailViewControllerDelegate?

    var editItem: ToDoListItem?
    var dueDate = NSDate()
    var datePickerVisable = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = editItem {
            navigationItem.title = "编辑列表"
            iteminfoTextFleld.text = item.text
            shouldRemindSwitch.on = item.shouldRindme
            dueDate = item.dueDate
        } else {
            navigationItem.title = "添加列表"

        }

        updateDueDateLabel()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Cancel , target: self, action: Selector("cancel"))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Done, target: self, action: Selector("done"))

        iteminfoTextFleld.delegate = self
        navigationItem.rightBarButtonItem?.enabled = iteminfoTextFleld.hasText()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //自动弹出键盘
        //将textFiedl变成第一响应者
        iteminfoTextFleld.becomeFirstResponder()
    }
    func cancel() {
        delegate?.addViewControllDidCancel(self)

    }

    func done() {
        if let item = editItem {
            item.text = iteminfoTextFleld.text!
            item.shouldRindme = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addViewControllerDidDone(self, didFinshEditingItem: item)
        } else {
            let item = ToDoListItem()
            item.text = iteminfoTextFleld.text!
            item.shouldRindme = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.checkmark = false
            item.scheduleNotification()
            delegate?.addViewControllDidDone(self, didFinshAddinteItem: item)
        }

    }
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }

    func showPickerDate() {
        datePickerVisable = true
        let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
            dateCell.detailTextLabel?.textColor = dateCell.detailTextLabel!.tintColor
        }
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        tableView.endUpdates()
        datePicker.setDate(dueDate, animated: false)
    }
    func hideDatePicker() {
        if datePickerVisable {
            datePickerVisable = false

            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)

            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                cell.detailTextLabel?.textColor = UIColor(white: 0.5, alpha: 0.5)

            }
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    @IBAction func dateChanged(datePicker:UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    @IBAction func shouldRemindtogglled(switchControl: UISwitch){
        iteminfoTextFleld.resignFirstResponder()
        if switchControl.on {
            let userNotificationSettring = UIUserNotificationSettings(forTypes: [.Alert,.Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(userNotificationSettring)
        }
    }
}

extension ToDoItemDetailViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisable {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
}

extension ToDoItemDetailViewController: UITextFieldDelegate {

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
          return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        iteminfoTextFleld.resignFirstResponder()

        if indexPath.section ==  1 && indexPath.row == 1 {
            if !datePickerVisable {

                showPickerDate()
            } else {
                hideDatePicker()
            }
        }
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }

    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        done()
        return true
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        navigationItem.rightBarButtonItem?.enabled = newText.length > 0
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }

}
