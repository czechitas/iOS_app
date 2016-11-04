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
    
    
    override func viewWillAppear(_ animated: Bool) {
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
            courses.contains(where: {$0["id"] == course.id})
        })
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if myCourses.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
            return 1
        } else {
            TableViewHelper.emptyImage("empty1", viewController: self)
            return 1
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myCourses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseTableViewCell {
            
            cell.configureCell(myCourses[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = tableView.indexPathForSelectedRow {
        let courseDetail = myCourses[index.row]
        if segue.identifier == "courseDetailSegue" {
            if let vc = segue.destination as? CourseDetailViewController {
                vc.course = courseDetail
                vc.hidesBottomBarWhenPushed = true
                
            }
        }
        }
        else {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Model.sharedInstance.removeCourse(indexPath.row)
            myCourses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

}



