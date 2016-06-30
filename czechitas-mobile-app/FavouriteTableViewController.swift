//
//  FavouriteTableViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 21.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

class FavouriteTableViewController: UITableViewController {
    
    var courses = [[String:Int]]()
    
    var course  = [Course]()
    var myCourses = [Course]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        self.course = Model.sharedInstance.allCourses
        
        
        
        
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
       
        
        
    }
    
    
    func getCourse() -> [[String:Int]]? {
        return NSUserDefaults.standardUserDefaults().arrayForKey("Courses") as? [[String:Int]]
        //NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let existingCourse = getCourse() {
            self.courses = existingCourse
            
        }
        self.myCourses = []
        
        addMyCourse()
        self.tableView.reloadData()
        
        
    }
    
    
    func hasCourseWithThisTitle(courseId : Int) -> Bool {
        for c in self.myCourses {
            if c.id == courseId {
                return true
            }
            
        }
        return false
    }
    
    func addMyCourse() {
        for i in self.course {
            for j in self.courses {
                if i.id == j["id"] ?? 0 {
                    if !hasCourseWithThisTitle(j["id"] ?? 0) {
                        self.myCourses.append(i)
                    }
                    else {
                        print ("Course exists")
                    }
                }
                else {
                    continue
                }
            }
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.myCourses.count > 0 {
            self.tableView.separatorStyle = .SingleLine
            self.tableView.backgroundView?.hidden = true
            return 1
        } else {
            TableViewHelper.emptyImage("empty", viewController: self)
            return 0
        }

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.myCourses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath) as? CourseTableViewCell {
        
        var dates = myCourses[indexPath.row].convertDate()
        cell.courseDate.text = dates.0 + " - " + myCourses[indexPath.row].courseCity
        cell.courseDate.font = UIFont.boldSystemFontOfSize(12.0)
        cell.courseTitle.text = myCourses[indexPath.row].title
        let description = myCourses[indexPath.row].courseDescription
        let index = description.startIndex.advancedBy(200)
        var desc = description.substringToIndex(index)
        cell.courseDescription.text = desc
        let color = myCourses[indexPath.row].courseCategoryColorCode
        cell.courseCategory.textColor = UIColor(hexString : color ?? "#dedede")
        cell.courseCategory.text = myCourses[indexPath.row].courseCategoryTitle
        return cell
        }
        
        return UITableViewCell()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let index = self.tableView.indexPathForSelectedRow {
        var courseD = self.myCourses[index.row]
        if segue.identifier == "courseDetailSegue" {
            if let vc = segue.destinationViewController as? CourseDetailViewController {
                vc.course = courseD
                vc.hidesBottomBarWhenPushed = true
                
            }
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



