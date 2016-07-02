//
//  CourseTableViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 08.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import SwiftHEXColors
import ReachabilitySwift

class CourseTableViewController: UITableViewController {
    
    var reachability: Reachability?
    var courses = [Course]()
    var categories = [Category]()
   
    var courseID : Int = 0
    var course : Course?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Model.sharedInstance.fetchCourseData(setTableView(), courseData: {
            (data, data2) -> Void in

            self.courses = data
            self.categories = data2
            self.tableView.reloadData()
        })
        
        tableView.tableFooterView = UIView()

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


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if courses.count > 0 {
            tableView.separatorStyle = .SingleLine
            tableView.backgroundView?.hidden = true
            return 1
        } else {
            TableViewHelper.emptyImage("empty", viewController: self)
            return 0
        }
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath) as? CourseTableViewCell {
        
        let dates = courses[indexPath.row].convertDate()
        cell.courseDate.text = "\(dates.0), \(courses[indexPath.row].courseCity)"
        cell.courseDate.font = UIFont.boldSystemFontOfSize(12.0)
        cell.courseTitle.text = courses[indexPath.row].title
        let description = courses[indexPath.row].courseDescription
        let index = description.startIndex.advancedBy(200)
        let desc = description.substringToIndex(index)
        cell.courseDescription.text = desc
        let color = courses[indexPath.row].courseCategoryColorCode
        cell.courseCategory.textColor = UIColor(hexString : color ?? "#dedede")
        cell.courseCategory.text = courses[indexPath.row].courseCategoryTitle
        return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let index = tableView.indexPathForSelectedRow {
            let courseDetail = courses[index.row]
            if segue.identifier == "courseDetailSegue" {
                if let vc = segue.destinationViewController as? CourseDetailViewController {
                    vc.course = courseDetail
                    vc.hidesBottomBarWhenPushed = true
                }
            }
        } else {
            print ("error")
        }
    }
}

class TableViewHelper {
    class func emptyImage(image: String, viewController: UITableViewController) {
        
        let image = UIImage(named: image)
        
        if let bgImage = image {
            let imageV = UIImageView(image : bgImage)
            imageV.frame = CGRectMake(20, 100, 60, 60)
            imageV.contentMode = .ScaleAspectFit
            imageV.sizeToFit()
            imageV.clipsToBounds = true
            
            viewController.tableView.backgroundView = imageV;
            viewController.tableView.separatorStyle = .None
        }
    }
}




