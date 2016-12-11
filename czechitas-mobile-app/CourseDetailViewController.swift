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
import SVProgressHUD

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
    var finalLink : String?
    var repeatCourse : String = ""
    var course : Course!
    var savedEventId : String?
    var btnAddTitle : String?
    var courseDetails = [CourseStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = course.title
        navigationController?.navigationBar.tintColor = .white
        courseInfoView.backgroundColor = course.courseCategoryColorCode
        let dates = course.convertDate()
        courseDates.text = (dates.0) + " - " +  (dates.1)
        courseTitle.text = course.title
        courseDetails = createStruct()
        courseTableView.tableFooterView = UIView()
        courseTableView.estimatedRowHeight = 15.0
        courseTableView.rowHeight = UITableViewAutomaticDimension
        savedEventId = "0"
        getCourseState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let image2 = UIImage(named: setBtnTitle())
        addBtn.image = image2
    }
    
    func setBtnTitle() -> String {
        if Model.sharedInstance.getCourse()?.contains(where: {$0["id"] == course.id}) == true {
            return "course-remove"
        } else {
            return "course-add"
        }
    }
    
    func getCourseState() -> String {
        if course.open_registration == true {
            if let finalLink = course.courseLink {
                buttonAction.setTitle("Zaregistrovat se", for: UIControlState())
                return finalLink
            }
        } else {
            if let finalLink = course.interestedLink {
                buttonAction.setTitle("Mám zájem", for: UIControlState())
                return finalLink
            }
        }
        return finalLink ?? "None"
    }
    
    func createStruct() -> [CourseStruct] {
        let dates = course.convertDate()
        var price1 : String = ""
        if let price = course.coursePrice {
            price1 = price + " CZK"
        }
        if let repeatValue = course.repeatCourse {
            self.repeatCourse = repeatValue
        }
        let rowEmpty = CourseStruct(icon: "", description: "")
        let row1 = CourseStruct(icon: "time", description: repeatCourse + " " + dates.2 + " - " + dates.3 )
        let row2 = CourseStruct(icon: "pin", description: (course.createFullAddress()) )
        let row3 = CourseStruct(icon: "money", description: price1 )
        let row4 = CourseStruct(icon: "email", description: "Napiš nám")
        let row5 = CourseStruct(icon: "couch", description: course.couches ?? "Kouč neuveden")
        let row6 = CourseStruct(icon: "notes", description: course.courseNotes ?? "Poznámka neuvedená")
        return [rowEmpty, row1, row2, row3, row4, row5, row6]

    }
    
    @IBAction func addToCalendar(_ sender: UIBarButtonItem) {
        let eventStore = EKEventStore()
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: { granted, error in
                debugPrint (error ?? "Chyba")
                if granted {
                    self.createAlert("Oznam", message : "Autorizace proběhla úspěšně.")
                
                } else {
                    self.createAlert("Oznam", message : "Přístup ke kalendáři odepřen. Toto nastavení je možné v budoucnu změnit v Nastavení telefonu.")
                }
            })
        } else {
            eventStore.requestAccess(to: .event, completion: { granted, error in
            })
        }
        
        let convertedDate = convertToDate((course.courseStartDate), endDate: (course.courseEndDate))
        createEvent(eventStore, title: course.title, startDate: convertedDate.0, endDate: convertedDate.1)
        
        
        
        
        
    }
    
    func convertToDate(_ startDate : String, endDate : String) -> (Date, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let startDate1 = formatter.date(from: startDate)
        let endDate1 = formatter.date(from: endDate)
        return (startDate1 ?? Date(), endDate1 ?? Date())
    }
    
    func getAllEvents(_ eventStore : EKEventStore) -> Bool {
        let oneMonthAgo = Date(timeIntervalSinceNow: -90*24*3600)
        let oneMonthAfter = Date(timeIntervalSinceNow: +90*24*3600)
        
        let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: nil)
        
        let events = eventStore.events(matching: predicate)
        
        return events.contains(where: {$0.title == course.title})
        
    }
    
    func createEvent(_ eventStore : EKEventStore, title : String, startDate : Date, endDate : Date) {
        
        eventStore.requestAccess(to: .event, completion: { granted, error in
            
        })
        
        
        if !getAllEvents(eventStore) {
            
            
            let event = EKEvent(eventStore : eventStore)
            
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
                savedEventId = event.eventIdentifier
                
                self.createAlert("Oznam", message : "Kurz " + course.title + " úspěšně přidaný do kalendáře.")
                
            } catch {
                debugPrint("Error")
            }
        } else {
            self.createAlert("Oznam", message : "Kurz " + course.title + " je už do kalendáře přidaný.")
        }
    }
    
    
    
    @IBAction func buttonClick(_ sender: AnyObject) {
        
        let url = getCourseState()
        
        if url != "None" || url != ""{
            let request = URLRequest(url: URL(string : url)!)
            
            SVProgressHUD.show()
            let webController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            self.navigationController?.pushViewController(webController, animated: true)
            webController.urlRequest = request
        }
        
            
            
            
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            if course.courseCouchEmail == "" {
                course.courseCouchEmail = "info@czechitas.cz"
            }
            mail.setToRecipients([course.courseCouchEmail ?? "info@czechitas.cz"])
            mail.setSubject("Informace o kurzu \(course.title)")
            mail.setMessageBody("", isHTML: false)
            present(mail, animated: true, completion: nil)
            
        } else {
            self.createAlert("Chyba", message: "Email není možné poslat.")
        }
    }
    
    func mailComposeController(_ controller : MFMailComposeViewController, didFinishWith didFinishWithResult : MFMailComposeResult, error : Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
        
    @IBAction func addCourse(_ sender: UIBarButtonItem) {
        
        if let courseIndex = Model.sharedInstance.getCourse()?.index(where: {$0["id"] == course.id}) {
            Model.sharedInstance.removeCourse(courseIndex)
            self.createAlert("Oznam", message : "Kurz " + course.title + " odebraný ze seznamu oblíbených kurzů.")
            viewWillAppear(true)
            
        } else {
            Model.sharedInstance.saveCourse(["id" : course.id])
            self.createAlert("Oznam", message : "Kurz " + course.title + " přidaný do seznamu oblíbených kurzů.")
            viewWillAppear(true)
            
        }
    }
    
    
    
    func tableView(_ courseTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return courseDetails.count
    }
    
    func tableView(_ courseTableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = courseTableView.dequeueReusableCell(withIdentifier: "courseDesc", for: indexPath) as?  CourseDescriptionTableViewCell {
                cell.courseDescription.text = course?.courseDescription
                cell.selectionStyle = .none
                return cell
            }
            
        } else {
            if let cell = courseTableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? InfoTableViewCell {
                
                
                cell.infoCourse.text = courseDetails[indexPath.row].description
                cell.imageCourse.image = UIImage(named: courseDetails[indexPath.row].icon)
                cell.selectionStyle = .none
                
                return cell
            }
            
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ courseTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            sendEmail()
        }
        
        
    }
    
    // MARK: - MFMailComposerViewController Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith:
        MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
