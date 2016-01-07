//
//  ToDoListDetailViewController.swift
//  I To Do
//
//  Created by Chuck on 16/1/4.
//  Copyright © 2016年 Chuck. All rights reserved.
//

import UIKit

protocol ToDoListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(controller: ToDoListDetailViewController)
    func listDetailViewControllerDidDone(controller: ToDoListDetailViewController, didfinshAddingList list: ToDOlistCategoryItem)
    func listDetailViewControllerDidDone(controller: ToDoListDetailViewController, didfinshEditingList list: ToDOlistCategoryItem)
}
class ToDoListDetailViewController: UITableViewController {

    @IBOutlet weak var listTextField: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    weak var delegate: ToDoListDetailViewControllerDelegate?
    var editList: ToDOlistCategoryItem?
    var iconName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        listTextField.delegate = self
        iconName = "Folder"
        if let list = editList {
            navigationItem.title = list.name
            navigationItem.rightBarButtonItem?.enabled = true
            listTextField.text = list.name
            iconName = list.iconName
        } else {
            navigationItem.title = "添加列表"
        }
        iconImage.image = UIImage(named: iconName)


    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destinationViewController as! ToDoIconPickerViewController
            controller.delegate = self
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let list = editList {
            list.name = listTextField.text!
            list.iconName = iconName
            delegate?.listDetailViewControllerDidDone(self, didfinshEditingList: list)
        } else {
            let list = ToDOlistCategoryItem(name: listTextField.text!)
            list.iconName = iconName
            delegate?.listDetailViewControllerDidDone(self, didfinshAddingList: list)
        }

    }
}

extension ToDoListDetailViewController: UITextFieldDelegate, ToDoIconPickerViewControllerDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldtext: NSString = textField.text!
        let newText: NSString = oldtext.stringByReplacingCharactersInRange(range, withString: string)
        navigationItem.rightBarButtonItem?.enabled = newText.length > 0
        return true 
    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    func iconPicker(pickerViewController: ToDoIconPickerViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewControllerAnimated(true)
    }
}
