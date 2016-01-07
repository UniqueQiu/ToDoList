//
//  ToDoListViewController.swift
//  I To Do
//
//  Created by Chuck on 15/12/31.
//  Copyright © 2015年 Chuck. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
//    var rowitmes: [ToDoListItem]
    var list: ToDOlistCategoryItem!

    //初始化对象的属性值
    required init?(coder aDecoder: NSCoder) {
//        rowitmes = [ToDoListItem]()
        super.init(coder: aDecoder)
//        loadToDoListItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = list.name


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ToDoListViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath)
        let rowitem = list.items[indexPath.row]
        configureTextForCell(cell, withItem: rowitem)
        configureCheckmarkForCell(cell, indexPath: indexPath, withItem: rowitem)
        return cell
    }
    //当从一个控制器show到弄一个控制器时都会调用这个方法
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailViewController = navigationController.topViewController as! ToDoItemDetailViewController
            detailViewController.delegate = self

        } else if segue.identifier == "editItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailViewController = navigationController.topViewController as! ToDoItemDetailViewController
            detailViewController.delegate = self
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
            detailViewController.editItem = list.items[indexPath.row]
            }


        }
    }

}

extension ToDoListViewController {
    //tableView 在删除或添加cell的同时需要 更新数扰模型, 这样cell的重用才不会出现问题
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        list.items.removeAtIndex(indexPath.row)

        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        saveToDoListItems()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        let rowitem = list.items[indexPath.row]
        rowitem.toggleCheckitem()
        configureCheckmarkForCell(cell, indexPath: indexPath, withItem:rowitem)
    }
//        saveToDoListItems()
 }

}

    //自定义方法, 当方法需要什么对象, 就将对象做为参数传入方法
    func configureCheckmarkForCell(cell: UITableViewCell, indexPath: NSIndexPath, withItem item: ToDoListItem) {
        var isCheckmark = false
        let label = cell.viewWithTag(1001)
        isCheckmark = item.checkmark
        label?.hidden = !isCheckmark
}

    func configureTextForCell(cell: UITableViewCell, withItem item: ToDoListItem) {
//    cell.textLabel?.text = item.text
        cell.textLabel?.text = "\(item.itemID): \(item.text)"

}

extension ToDoListViewController: TodoItemDetailViewControllerDelegate {
    func addViewControllDidCancel(controller: ToDoItemDetailViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)

    }
    func addViewControllDidDone(controller: ToDoItemDetailViewController, didFinshAddinteItem item: ToDoListItem) {

        list.items.append(item)
        tableView.reloadData()
//        saveToDoListItems()
       controller.dismissViewControllerAnimated(true, completion: nil)
    }

    func addViewControllerDidDone(controller: ToDoItemDetailViewController, didFinshEditingItem item: ToDoListItem) {
        tableView.reloadData()
        if let index = list.items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.textLabel?.text = item.text
            }
        }
//        saveToDoListItems()
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}


