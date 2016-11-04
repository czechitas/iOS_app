//
//  PopUpTableViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 17.07.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

protocol PopUtTableViewControllerDelegate {
    func controller(_ controller : PopUpTableViewController, sendCategories : [Category])
}

class PopUpTableViewController: UITableViewController {
    
    var categories = [Category]()
    var delegate : PopUtTableViewControllerDelegate?
    
    var selectedCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.reloadData()
        
        
        
        let tblView =  UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor(colorLiteralRed: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.9)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getSelectedCategories() {
        self.selectedCategories = self.categories.filter {$0.isSelected == true}
        
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        
        delegate?.controller(self, sendCategories: self.selectedCategories)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.accessoryView = UIImageView(image: UIImage(named: ""))
        cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        cell.textLabel?.text = categories[indexPath.row].title
        cell.textLabel?.textColor = categories[indexPath.row].colorCode
        
        
        self.categories[indexPath.row].isSelected = false
        
        getSelectedCategories()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print (cell?.isSelected)
        
        cell?.accessoryView = UIImageView(image: UIImage(named: "check"))
        cell?.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        self.categories[indexPath.row].isSelected = true
        getSelectedCategories()
        
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        print (cell?.isSelected)
        cell?.accessoryView = UIImageView(image: UIImage(named: ""))
        cell?.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
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
