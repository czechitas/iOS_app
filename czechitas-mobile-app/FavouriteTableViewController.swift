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
    
    
    override func viewWillAppear(animated: Bool) {
        self.course = Model.sharedInstance.allCourses
        
        if let existingCourse = Model.sharedInstance.getCourse() {
            courses = existingCourse
            
        }
        
        myCourses = []
        
        addMyCourse()
        tableView.reloadData()
        
        
    }
    
    
    func addMyCourse() {
        myCourses = course.filter( { (course) in
            courses.contains({$0["id"] == course.id})
        })
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if myCourses.count > 0 {
            tableView.separatorStyle = .SingleLine
            tableView.backgroundView?.hidden = true
            return 1
        } else {
            TableViewHelper.emptyImage("empty", viewController: self)
            return 1
        }

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myCourses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath) as? CourseTableViewCell {
            
            cell.configureCell(myCourses[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let index = tableView.indexPathForSelectedRow {
        let courseDetail = myCourses[index.row]
        if segue.identifier == "courseDetailSegue" {
            if let vc = segue.destinationViewController as? CourseDetailViewController {
                vc.course = courseDetail
                vc.hidesBottomBarWhenPushed = true
                
            }
        }
        }
        else {
            print ("error")
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            Model.sharedInstance.removeCourse(indexPath.row)
            myCourses.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    

}



