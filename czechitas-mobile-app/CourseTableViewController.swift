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
import SVProgressHUD

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
        
        SVProgressHUD.showWithStatus("Stahovanie dat")
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setForegroundColor(.whiteColor())
        SVProgressHUD.setBackgroundColor(UIColor(hexString: "#283891"))
        Model.sharedInstance.fetchCourseData(setTableView(), courseData: {
            (data, data2) -> Void in
            
            
            self.courses = data
            self.categories = data2
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
        })
        
        
        
        tableView.tableFooterView = UIView()

    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        Model.sharedInstance.checkReachibility()
        
        if courses.isEmpty == true {
            SVProgressHUD.showWithStatus("Stahovanie dat")
            SVProgressHUD.setDefaultStyle(.Custom)
            SVProgressHUD.setForegroundColor(.whiteColor())
            SVProgressHUD.setBackgroundColor(UIColor(hexString: "#283891"))
            Model.sharedInstance.fetchCourseData(setTableView(), courseData: {
                (data, data2) -> Void in
                
                
                self.courses = data
                self.categories = data2
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            })
        }
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
        } else if SVProgressHUD.isVisible() == true && courses.isEmpty {
            TableViewHelper.emptyImage("empty", viewController: self)
            return 1
        }
        else {
            return 1
        }
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath) as? CourseTableViewCell {
        
            cell.configureCell(courses[indexPath.row])
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
            
            viewController.tableView.backgroundView = imageV
            viewController.tableView.separatorStyle = .None
        }
    }
}




