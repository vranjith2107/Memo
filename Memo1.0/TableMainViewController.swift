//
//  TableMainViewController.swift
//  Memo1.0
//
//  Created by Ranjith on 7/16/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import UIKit

class TableMainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate{
    
    let dataloaded = Record.imageSave
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
            return dataloaded.getData().count
    }
    
    //MARK: Tableview Delegate and dataSource Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("favaCell")! as UITableViewCell
        let memeData = dataloaded.getData()[indexPath.row]
        cell.imageView?.image = memeData.image
        cell.textLabel?.text = memeData.textField1 + "..." + memeData.textField2
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            dataloaded.deleteMeme(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Grab the DetailVC from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("detailView")
        let detailVC = object as! detailViewController
        
        //Populate view controller with data from the selected item
        detailVC.memeobject = dataloaded.getData()[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
}
