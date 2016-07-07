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

struct CourseStruct {
    var icon : String
    var description : String
}

class CourseDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var courseInfoView: UIView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseDates: UILabel!
    
    
    var course : Course!
    var savedEventId : String?
    
    var btnAddTitle : String?
    
    var courseDetails = [CourseStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let image2 = UIImage(named: setBtnTitle())
        
        
        
        addBtn.image = image2
        
        
        navigationItem.title = course.title
        navigationController?.navigationBar.tintColor = .whiteColor()
        
        courseInfoView.backgroundColor = course.courseCategoryColorCode
        
        let dates = course.convertDate()
        courseDates.text = (dates.0) + " - " +  (dates.1)
        courseTitle.text = course.title
        
        
        if course.courseLink == "" || course.courseLink == "None" {
            buttonAction.setTitle("Mám záujem", forState: .Normal)
        } else {
            buttonAction.setTitle("Registrovať sa", forState: .Normal)
        }
        
        courseDetails = createStruct()
        
        courseTableView.tableFooterView = UIView()
        courseTableView.estimatedRowHeight = 15.0
        courseTableView.rowHeight = UITableViewAutomaticDimension
        
        
        savedEventId = "0"
    }
    
    func setBtnTitle() -> String {
        
        if Model.sharedInstance.getCourse()?.contains({$0["id"] == course.id}) == true {
            return "course-remove"
        } else {
            return "course-add"
        }
    }
    
    
    
    
    func createStruct() -> [CourseStruct] {
        let dates = course.convertDate()
        
        var price1 : String = ""
        if let price = course.coursePrice {
            price1 = price + " CZK"
        }
        
        let rowEmpty = CourseStruct(icon: "", description: "")
        let row1 = CourseStruct(icon: "time", description: dates.2 + " - " + dates.3 ?? "Datum neuvedeny")
        let row2 = CourseStruct(icon: "pin", description: (course.createFullAddress()) ?? "Adresa neuvedena")
        let row3 = CourseStruct(icon: "money", description: price1 ?? "Cena neuvedena")
        let row4 = CourseStruct(icon: "email", description: "Napíš koučovi")
        let row5 = CourseStruct(icon: "notes", description: course.courseNotes ?? "Poznamka neuvedena")
        
        return [rowEmpty, row1, row2, row3, row4, row5]

    }
    
    @IBAction func addToCalendar(sender: UIBarButtonItem) {
        let eventStore = EKEventStore()
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: { granted, error in
                print (error)
                if granted {
                    
                    
                } else {
                    self.createAlert("Oznam", message : "Povolenie sa nepodarilo.")
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
                
                self.createAlert("Oznam", message : "Udalost pridana do kalendara")
                
            } catch {
                self.createAlert("Oznam", message : "Chyba")
            }
        } else {
            self.createAlert("Oznam", message : "Udalost je uz do kalendara pridana")
        }
    }
    
    
    
    @IBAction func buttonClick(sender: AnyObject) {
        if let url = course.courseLink {
            let request = NSURLRequest(URL: NSURL(string : url)!)
            print (request)
            let webController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            self.navigationController?.pushViewController(webController, animated: true)
            webController.urlRequest = request
            
            
            
            
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([course.courseCouchEmail ?? "czechitas@info.com"])
            mail.setMessageBody("", isHTML: false)
            presentViewController(mail, animated: true, completion: nil)
            
        } else {
            self.createAlert("Chyba", message: "Email nie je mozne poslat")
        }
    }
    
    func mailComposeController(controller : MFMailComposeViewController, didFinishWithResult : MFMailComposeResult, error : NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
        
    @IBAction func addCourse(sender: UIBarButtonItem) {
        
        if let courseIndex = Model.sharedInstance.getCourse()?.indexOf({$0["id"] == course.id}) {
            Model.sharedInstance.removeCourse(courseIndex)
            
        } else {
            Model.sharedInstance.saveCourse(["id" : course.id])
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
                cell.infoCourse.text = courseDetails[indexPath.row].description
                cell.imageCourse.image = UIImage(named: courseDetails[indexPath.row].icon)
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
    
    // MARK: - MFMailComposerViewController Delegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWith:
        MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
