//
//  CourseDetailViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 16.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var courseInfoView: UIView!
    
        @IBOutlet weak var courseTitle: UILabel!
        @IBOutlet weak var courseDates: UILabel!
    
    var courseDate : String?
    var courseT : String?
    var courseD : String?
    var courseDict = [Int : String]()
    var iconArray = [String]()
    var catColor : String = ""
    var courseURL : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseInfoView.backgroundColor = UIColor(hexString: catColor)
        
        courseDates.text = courseDate
        courseTitle.text = courseT
        
        self.courseTableView.delegate = self
        self.courseTableView.dataSource = self
        
        self.courseTableView.tableFooterView = UIView()
        
        
        self.courseTableView.estimatedRowHeight = 15.0
        self.courseTableView.rowHeight = UITableViewAutomaticDimension
        
        iconArray = ["", "time-icon", "pin-icon", "money-icon", "mail-icon", "notes-icon"]
        
        
        self.navigationItem.title = courseT
        
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        
        if courseURL == "" || courseURL == "None" {
        self.buttonAction.setTitle("Remind me", forState: .Normal)
        }
        else {
            self.buttonAction.setTitle("Register", forState: .Normal)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClick(sender: AnyObject) {
        if courseURL != "" || courseURL != "None" {
        
        let myWebView : UIWebView = UIWebView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        myWebView.loadRequest(NSURLRequest(URL: NSURL(string: courseURL)!))
        self.view.addSubview(myWebView)
        }
        else {
            // TODO
        }
    }
    
    func numberOfSectionsInTableView(courseTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(courseTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return courseDict.count + 1
    }
    
    func tableView(courseTableView: UITableView, cellForRowAtIndexPath indexPath : NSIndexPath) -> UITableViewCell {
        
            
        if indexPath.row == 0 {
            
            if let cell = courseTableView.dequeueReusableCellWithIdentifier("courseDesc", forIndexPath: indexPath) as?  CourseDescriptionTableViewCell {
        
        
            cell.courseDescription.text = courseD
            return cell
            }
        } else {
           
                
            if let cell = courseTableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as? InfoTableViewCell {
            
                
                cell.infoCourse.text = courseDict[indexPath.row]
                
            
                cell.imageCourse.image = UIImage(named: iconArray[indexPath.row])
            
            return cell
            }
            
        }
        
        
        
        return UITableViewCell()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
