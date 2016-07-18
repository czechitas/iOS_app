//
//  PopUpTableViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 17.07.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

protocol PopUtTableViewControllerDelegate {
    func controller(controller : PopUpTableViewController, sendCategories : [Category])
}

class PopUpTableViewController: UITableViewController {
    
    var categories = [Category]()
    var delegate : PopUtTableViewControllerDelegate?
    
    var selectedCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.reloadData()
        
        
        
        var tblView =  UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.hidden = true
        tableView.backgroundColor = UIColor(colorLiteralRed: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.9)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getSelectedCategories() {
        self.selectedCategories = self.categories.filter {$0.isSelected == true}
        
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        
        delegate?.controller(self, sendCategories: self.selectedCategories)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return categories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
        
        cell.accessoryView = UIImageView(image: UIImage(named: ""))
        cell.accessoryView?.frame = CGRectMake(0, 0, 22, 22)
        cell.textLabel?.text = categories[indexPath.row].title
        cell.textLabel?.textColor = UIColor(hexString: categories[indexPath.row].colorCode)
        self.categories[indexPath.row].isSelected = false
        
        getSelectedCategories()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        print (cell?.selected.boolValue)
        
        cell?.accessoryView = UIImageView(image: UIImage(named: "check"))
        cell?.accessoryView?.frame = CGRectMake(0, 0, 22, 22)
        self.categories[indexPath.row].isSelected = true
        getSelectedCategories()
        
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        print (cell?.selected.boolValue)
        cell?.accessoryView = UIImageView(image: UIImage(named: ""))
        cell?.accessoryView?.frame = CGRectMake(0, 0, 22, 22)
        self.categories[indexPath.row].isSelected = false
        
        getSelectedCategories()
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
