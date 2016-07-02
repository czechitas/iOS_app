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

    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var courseInfoView: UIView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseDates: UILabel!
    
    var course : Course!
    var courseDetails = [String]()
    var iconArray = [String]()
    var myCourses = [Int]()
    var savedEventId : String?
    
    var btnAddTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let image2 = UIImage(named: setBtnTitle())
       
    
        addBtn.image = image2
        
        
        navigationItem.title = course.title
        navigationController?.navigationBar.tintColor = .whiteColor()
        
        courseInfoView.backgroundColor = UIColor(hexString: course.courseCategoryColorCode ?? "#dedede")
        
        let dates = course.convertDate()
        courseDates.text = (dates.0) + " - " +  (dates.1)
        courseTitle.text = course.title
        iconArray = ["", "time", "pin", "money", "email", "notes"]
        
        if course.courseLink == "" || course.courseLink == "None" {
            buttonAction.setTitle("Mám záujem", forState: .Normal)
        } else {
            buttonAction.setTitle("Registrovať sa", forState: .Normal)
        }
        
        createArray()
        
        
        courseTableView.delegate = self
        courseTableView.dataSource = self
        courseTableView.tableFooterView = UIView()
        courseTableView.estimatedRowHeight = 15.0
        courseTableView.rowHeight = UITableViewAutomaticDimension
        
        
        savedEventId = "0"
    }
    
    func setBtnTitle() -> String {
        if let existingCourse = getCourse() {
            
            for c in existingCourse {
            if course.id == c["id"] {
                return "course-remove"
                
                }
            }
            } else {
            return "course-add"
        }
        return "course-add"
    }
    
    
    
    
    func createArray() -> () {
        let dates = course.convertDate()
        
        var price1 : String = ""
        if let price = course.coursePrice {
            price1 = price + " CZK"
        }
        
        courseDetails = [" ", dates.2 + " - " + dates.3 ?? "Datum neuvedeny", (course.createFullAddress()) ?? "Adresa neuvedena", price1 ?? "Cena neuvedena", "Napíš koučovi", course.courseNotes ?? "Poznamka neuvedena"
            ]
    }
    
    @IBAction func addToCalendar(sender: UIBarButtonItem) {
        let eventStore = EKEventStore()
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: { granted, error in
                print (error)
                if granted {
                    
                    
                } else {
                    AlertViewController().createAlert("Oznam", message : "Povolenie sa nepodarilo.")
                }
            })
        } else {
            
            eventStore.requestAccessToEntityType(.Event, completion: { granted, error in
                
            })
        }
        
        let convertedDate = convertToDate((course.courseStartDate), endDate: (course.courseEndDate))
        createEvent(eventStore, title: course.title, startDate: convertedDate.0, endDate: convertedDate.1)
        
        
        
        
        
    }
    
    func convertToDate(startDate : String, endDate : String) -> (NSDate, NSDate) {
        let startDate = startDate
        let endDate = endDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let startDate1 = formatter.dateFromString(startDate)
        let endDate1 = formatter.dateFromString(endDate)
        return (startDate1 ?? NSDate(), endDate1 ?? NSDate())
    }
    
    func getAllEvents(eventStore : EKEventStore) -> Bool {
        let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
        let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
        
        let predicate = eventStore.predicateForEventsWithStartDate(oneMonthAgo, endDate: oneMonthAfter, calendars: nil)
        
        let events = eventStore.eventsMatchingPredicate(predicate)
        
        return events.contains({$0.title == course.title})
        
    }
    
    func createEvent(eventStore : EKEventStore, title : String, startDate : NSDate, endDate : NSDate) {
        
        eventStore.requestAccessToEntityType(.Event, completion: { granted, error in
            
        })
        
       
        if !getAllEvents(eventStore) {
            
            print (!getAllEvents(eventStore))
                let event = EKEvent(eventStore : eventStore)
                
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.saveEvent(event, span: .ThisEvent)
                    savedEventId = event.eventIdentifier
                    
                    AlertViewController().createAlert("Oznam", message : "Udalost pridana do kalendara")
                    
                } catch {
                    AlertViewController().createAlert("Oznam", message : "Chyba")
                }
        } else {
            AlertViewController().createAlert("Oznam", message : "Udalost je uz do kalendara pridana")
        }
    }
    


    @IBAction func buttonClick(sender: AnyObject) {
        if let url = course.courseLink {
        let myWebView : UIWebView = UIWebView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        myWebView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        self.view.addSubview(myWebView)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients([course.courseCouchEmail ?? "czechitas@info.com"])
            mail.setMessageBody("", isHTML: false)
            presentViewController(mail, animated: true, completion: nil)
            
        } else {
            AlertViewController().createAlert("Chyba", message: "Email nie je mozne poslat")
        }
    }
    
    func mailComposeController(controller : MFMailComposeViewController, didFinishWithResult : MFMailComposeResult, error : NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getCourse() -> [[String : Int]]? {
        
        return NSUserDefaults.standardUserDefaults().arrayForKey("Courses") as? [[String : Int]]
        //NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func saveCourse(dict : [String:Int]) {
        
        var newCourses : [[String : Int]]
        if let existingCourse = getCourse() {
            
            newCourses = existingCourse
            newCourses.append(dict)
            
        } else {
            newCourses = [dict]
           
        }
        
        
        NSUserDefaults.standardUserDefaults().setObject(newCourses, forKey: "Courses")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func removeCourse(index : Int) {
        var newCourses : [[String : Int]]
        if let existingCourse = getCourse() {
            newCourses = existingCourse
            newCourses.removeAtIndex(index)
        
        NSUserDefaults.standardUserDefaults().setObject(newCourses, forKey: "Courses")
        NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func hasCourseWithThisID(courseId : Int) -> Bool {
     if let existingCourse = getCourse() {
        for c in existingCourse {
            if c["id"] == courseId {
                return true
            }
        }
        }
        return false
    }
    
    @IBAction func addCourse(sender: UIBarButtonItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var count = 0
        
        if let existingCourse = getCourse() {
            
            if existingCourse == [] {
                saveCourse(["id" : course.id])
            }
            else {
            
            for c in existingCourse {
                if !hasCourseWithThisID(course.id) {
                    saveCourse(["id" : course.id])
                    continue
                    
                }
                else {
                    if course.id == c["id"] {
                    removeCourse(count)
                    continue
                    }
                    
                    count += 1
                    continue
                    
                }
            }
        }
            
    } else {
        saveCourse(["id" : course.id])
    }

    }
    
    
    
    func tableView(courseTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return courseDetails.count
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
                
                print (indexPath.row)
                cell.infoCourse.text = courseDetails[indexPath.row]
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
