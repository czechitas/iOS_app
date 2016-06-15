//
//  CourseTableViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 08.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import SwiftHEXColors

class CourseTableViewController: UITableViewController {
    
    
    var courses = [Course]()
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nevadi ze tu sa to spravi iba raz? Ci potom budeme robit uz iba update cez ten refresh smerom dole?
        // Když nepůjde data měnit lokálně, tak určitě stačí jen jednou a pak v pull to refresh (standardní komponenta UIRefreshControl nebo jiný framework)
        Model.sharedInstance.fetchCourseData(setTableView(), courseData: {
            (data, data2) -> Void in

            self.courses = data
            self.categories = data2
            
            self.tableView.reloadData()
            
        })
        
        
        // Možnost skrývání prázdných řádků na konci
        tableView.tableFooterView = UIView()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    
    
    func setTableView() -> APIRouter {
        switch navigationController {
        case is PreparedViewController:
            return APIRouter.CoursesPrepared()
        case is OpenViewController:
            return APIRouter.CoursesOpen()
        default:
            return APIRouter.CoursesPrepared()
        }
    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.courses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath) as! CourseTableViewCell
        
        cell.courseDate.text = "\(courses[indexPath.row].courseStartDate!), \(courses[indexPath.row].courseCity)"
        cell.courseDate.font = UIFont.boldSystemFontOfSize(12.0)
        cell.courseTitle.text = courses[indexPath.row].title
        cell.courseDescription.numberOfLines = 30
        cell.courseDescription.lineBreakMode = .ByWordWrapping
        cell.courseDescription.text = courses[indexPath.row].courseDescription
        let color = courses[indexPath.row].courseCategoryColorCode
        cell.courseCategory.textColor = UIColor(hexString : color!)
        cell.courseCategory.text = courses[indexPath.row].courseCategoryTitle

        // Configure the cell...

        return cell
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
