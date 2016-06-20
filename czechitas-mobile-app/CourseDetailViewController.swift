//
//  CourseDetailViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 16.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import EventKit
import MessageUI

class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var courseInfoView: UIView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseDates: UILabel!
    
    var course : Course!
    var courseDict = [Int : String]()
    var iconArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = course?.title
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        
        courseInfoView.backgroundColor = UIColor(hexString: (course?.courseCategoryColorCode)!)
        
        var dates = course?.convertDate()
        courseDates.text = (dates!.0) + " - " +  (dates!.1)
        courseTitle.text = course?.title
        iconArray = ["", "time-icon", "pin-icon", "money-icon", "mail-icon", "notes-icon"]
        
        
        
        
        if course?.courseLink == "" || course?.courseLink == "None" {
            self.buttonAction.setTitle("Remind me", forState: .Normal)
        } else {
            self.buttonAction.setTitle("Register", forState: .Normal)
        }
        
        if course?.courseStartTime != nil && course?.createFullAddress() != nil && course?.coursePrice != nil && course?.courseCouchEmail != nil && course?.courseNotes != nil {
            createDict()
        }
        
        self.courseTableView.delegate = self
        self.courseTableView.dataSource = self
        self.courseTableView.tableFooterView = UIView()
        self.courseTableView.estimatedRowHeight = 15.0
        self.courseTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    func createDict() -> () {
        var dates = course?.convertDate()
        
        var price1 : String = ""
        if let price = course?.coursePrice {
            price1 = price + " CZK"
        }
        
        self.courseDict = [
            1 : dates!.2 ?? "Datum neuvedeny",
            2 : (course?.createFullAddress()) ?? "Adresa neuvedena",
            3 : price1 ?? "Cena neuvedena",
            4 : course?.courseCouchEmail ?? "Email neuvedeny",
            5 : course?.courseNotes ?? "Poznamka neuvedena"
            ]
    }
    
    @IBAction func addToCalendar(sender: UIBarButtonItem) {
        let eventStore = EKEventStore()
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: { granted, error in
            })
        } else {
            print ("Error")
        }
        
        var convertedDate = convertToDate((course?.courseStartDate)!, endDate: (course?.courseEndDate)!)
        createEvent(eventStore, title: course.title, startDate: convertedDate.0, endDate: convertedDate.1)
        
    }
    
    func convertToDate(startDate : String, endDate : String) -> (NSDate, NSDate) {
        let startDate = startDate
        let endDate = endDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        var startDate1 = formatter.dateFromString(startDate)
        var endDate1 = formatter.dateFromString(endDate)
        return (startDate1 ?? NSDate(), endDate1 ?? NSDate())
    }
    
    func createEvent(eventStore : EKEventStore, title : String, startDate : NSDate, endDate : NSDate) {
        let event = EKEvent(eventStore : eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
        } catch {
            print ("Error")
        }
    }
    
    @IBAction func buttonClick(sender: AnyObject) {
        if course.courseLink != "" || course.courseLink != "None" {
        let myWebView : UIWebView = UIWebView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        myWebView.loadRequest(NSURLRequest(URL: NSURL(string: course.courseLink!)!))
        self.view.addSubview(myWebView)
        }
        else {
            // TODO
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients([courseDict[4]!])
            mail.setMessageBody("", isHTML: false)
            presentViewController(mail, animated: true, completion: nil)
            
        } else {
            print ("Error")
        }
    }
    
    func mailComposeController(controller : MFMailComposeViewController, didFinishWithResult : MFMailComposeResult, error : NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
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
                cell.courseDescription.text = course?.courseDescription
                cell.selectionStyle = .None
                return cell
            }
            
        } else {
            if let cell = courseTableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as? InfoTableViewCell {
                cell.infoCourse.text = courseDict[indexPath.row]
                cell.imageCourse.image = UIImage(named: iconArray[indexPath.row])
                cell.selectionStyle = .None
                if indexPath.row == 4 {
                    cell.selectionStyle = .Blue
                }
                return cell
            }
            
        }
        return UITableViewCell()
        
    }
    
    func tableView(courseTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            
            sendEmail()
        }
    }

}
