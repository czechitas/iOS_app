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
   
    var courseID : Int = 0
    var course : Course?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Nevadi ze tu sa to spravi iba raz? Ci potom budeme rvart uz iba update cez ten refresh smerom dole?
        // Když nepůjde data měnit lokálně, tak určitě stačí jen jednou a pak v pull to refresh (standardní komponenta UIRefreshControl nebo jiný framework)
        Model.sharedInstance.fetchCourseData(setTableView(), courseData: {
            (data, data2) -> Void in

            self.courses = data
            self.categories = data2
            
            
            
            
            self.tableView.reloadData()
            
            
        })
        
        
        // Možnost skrývání prázdných řádků na konci
        tableView.tableFooterView = UIView()
        
            
        self.refreshControl?.addTarget(self, action: "handleRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func handleRefresh(refreshControl : UIRefreshControl) {
        // volanie api s rozdielovou metodou
    }
    
    



    func setTableView() -> APIRouter {
        switch navigationController {
        case is PreparedViewController:
            return APIRouter.CoursesPrepared()
        case is OpenViewController:
            return APIRouter.CoursesOpen()
        default:
            return APIRouter.CoursesOpen()
        }
    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if courses.count > 0 {
            self.tableView.separatorStyle = .SingleLine
            self.tableView.backgroundView?.hidden = true
            return 1
        } else {
            TableViewHelper.emptyMessage("empty", viewController: self)
            return 0
        }
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.courses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath) as! CourseTableViewCell
        
        
        var dates = courses[indexPath.row].convertDate()
        cell.courseDate.text = "\(dates.0), \(courses[indexPath.row].courseCity)"
        cell.courseDate.font = UIFont.boldSystemFontOfSize(12.0)
        cell.courseTitle.text = courses[indexPath.row].title
        let description = courses[indexPath.row].courseDescription
        let index = description.startIndex.advancedBy(200)
        var desc = description.substringToIndex(index)
        cell.courseDescription.text = desc
        let color = courses[indexPath.row].courseCategoryColorCode
        cell.courseCategory.textColor = UIColor(hexString : color!)
        cell.courseCategory.text = courses[indexPath.row].courseCategoryTitle
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let index = self.tableView.indexPathForSelectedRow
        let courseD = courses[index!.row]
        
        if segue.identifier == "courseDetailSegue" {
            if let vc = segue.destinationViewController as? CourseDetailViewController {
                vc.course = courseD
                vc.hidesBottomBarWhenPushed = true
                
            }
        }
    
        else {
            print ("error")
        }
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

class TableViewHelper {
    class func emptyMessage(image: String, viewController: UITableViewController) {
        
        let image = UIImage(named: image)
        var imageV = UIImageView(image : image!)
        
        imageV.frame = CGRectMake(20, 100, 60, 60)
        imageV.contentMode = .ScaleAspectFit
        imageV.sizeToFit()
        imageV.clipsToBounds = true
        
        
        viewController.tableView.backgroundView = imageV;
        viewController.tableView.separatorStyle = .None
    }
}
