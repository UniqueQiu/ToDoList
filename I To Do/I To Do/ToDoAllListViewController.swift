//
//  ToDoAllListViewController.swift
//  I To Do
//
//  Created by Chuck on 16/1/4.
//  Copyright © 2016年 Chuck. All rights reserved.
//

import UIKit

class ToDoAllListViewVController: UITableViewController {
    var dataModel: DataModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedList
        if index > 0 && index <= dataModel.lists.count {
            let list = dataModel.lists[index]
            performSegueWithIdentifier("ShowCell", sender: list)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

}

extension ToDoAllListViewVController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView)
        let list = dataModel.lists[indexPath.row]
        cell.textLabel?.text = list.name

        let count = list.countUncheckItems()
        if list.items.count == 0 {
            cell.detailTextLabel?.text = "No Item"
        } else if count == 0 {
            cell.detailTextLabel?.text = "All Done"
        } else {
            cell.detailTextLabel?.text = "\(list.countUncheckItems()) Remaining"
        }
        cell.imageView!.image = UIImage(named: list.iconName)
        cell.accessoryType = .DetailDisclosureButton
        return cell
    }

    func cellForTableView(tableView: UITableView) -> UITableViewCell  {
        let identifier = "cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            return cell
        } else {
            return UITableViewCell(style: .Subtitle, reuseIdentifier: identifier)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCell" {
            let controller = segue.destinationViewController as! ToDoListViewController
            controller.list = sender as! ToDOlistCategoryItem
        } else if segue.identifier == "addList" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ToDoListDetailViewController
            controller.delegate = self
            controller.editList = nil
        }
    }
}

extension ToDoAllListViewVController: ToDoListDetailViewControllerDelegate, UINavigationControllerDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.indexOfSelectedList = indexPath.row
        let list = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowCell", sender: list)
    }

    func listDetailViewControllerDidCancel(controller: ToDoListDetailViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    func listDetailViewControllerDidDone(controller: ToDoListDetailViewController, didfinshAddingList list: ToDOlistCategoryItem) {
//        let index = lists.indexOf(list)
//        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        dataModel.lists.append(list)
        dataModel.sortLists()
        tableView.reloadData()
        controller.dismissViewControllerAnimated(true, completion: nil)

    }

    func listDetailViewControllerDidDone(controller: ToDoListDetailViewController, didfinshEditingList list: ToDOlistCategoryItem) {
        dataModel.sortLists()
        tableView.reloadData()
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ToDoDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ToDoListDetailViewController
        controller.delegate = self
        controller.editList = dataModel.lists[indexPath.row]
        presentViewController(navigationController, animated: true, completion: nil)

    }

     func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if viewController == self {
        dataModel.indexOfSelectedList = -1
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

}
// MARK: 数据持久化
extension ToDoAllListViewVController {
       

    
}
