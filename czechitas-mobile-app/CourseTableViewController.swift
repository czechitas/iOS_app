//
//  CourseTableViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 08.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import SVProgressHUD
import MessageUI

class CourseTableViewController: UITableViewController, PopUtTableViewControllerDelegate, MFMailComposeViewControllerDelegate {
    var filteredCourses = [Course]()
    var categories = [Category]()
    var courses = [Course]()
    var courseID : Int = 0
    var course : Course?
    var saved : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        SVProgressHUD.show(withStatus: "Stahování kurzů")
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setBackgroundColor(UIColor(red: 47/255.0, green: 52/255.0, blue: 144/255.0, alpha: 1.0))
        Model.sharedInstance.fetchCourseData(setTableView(), courseData: {
            (data, data2) -> Void in
            self.filteredCourses = data
            self.categories = data2
            self.saved = true
            self.tableView.reloadData()
        })
        self.courses = self.filteredCourses
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func sendEmail(_ sender: UIBarButtonItem) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@czechitas.cz"])
            mail.setSubject("Mám zájem o kurz: ")
            mail.setMessageBody("", isHTML: false)
            present(mail, animated: true, completion: nil)
            
        }
    }
    
    func mailComposeController(_ controller : MFMailComposeViewController, didFinishWith didFinishWithResult : MFMailComposeResult, error : Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith:
        MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func controller(_ controller: PopUpTableViewController, sendCategories: [Category]) {
        let titles = sendCategories.map {$0.title}
        self.courses = []
        if sendCategories.count != 0 {
            for title in titles {
                let courseItem = self.filteredCourses.filter { $0.courseCategoryTitle == title }
                self.courses += courseItem
                tableView.reloadData()
            }
        } else {
            self.courses = self.filteredCourses
            tableView.reloadData()
        }
    }
    
    @IBAction func showCategories(_ sender: AnyObject) {
        performSegue(withIdentifier: "showCategories", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if courses.isEmpty == true && !saved {
            SVProgressHUD.show(withStatus: "Stahování kurzů")
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setForegroundColor(.white)
            SVProgressHUD.setBackgroundColor(UIColor(red: 47/255.0, green: 52/255.0, blue: 144/255.0, alpha: 1.0))
            Model.sharedInstance.fetchCourseData(setTableView(), courseData: {
                (data, data2) -> Void in
                self.courses = data
                self.categories = data2
                self.setImageForTableView()
                self.tableView.reloadData()
            })
        }
    }
    
    func setTableView() -> APIRouter {
        switch navigationController {
        case is PreparedViewController:
            return APIRouter.coursesPrepared()
        case is OpenViewController:
            return APIRouter.coursesOpen()
        case is ClosedViewController:
            return APIRouter.coursesClosed()
        default:
            return APIRouter.coursesOpen()
        }
    }

    func setImageForTableView() -> Int {
        TableViewHelper.emptyImage("empty1", viewController: self)
        SVProgressHUD.dismiss()
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if courses.count > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
            SVProgressHUD.dismiss()
            return 1
        } else {
            TableViewHelper.emptyImage("", viewController: self)
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseTableViewCell {
            cell.configureCell(courses[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategories" {
            if let navigationController = segue.destination as? UINavigationController,
            let mc = navigationController.viewControllers.first as? PopUpTableViewController {
                mc.categories = self.categories
                mc.delegate = self
            }
        }
        
        if let index = tableView.indexPathForSelectedRow {
            let courseDetail = courses[index.row]
            if segue.identifier == "courseDetailSegue" {
                if let vc = segue.destination as? CourseDetailViewController {
                    vc.course = courseDetail
                    vc.hidesBottomBarWhenPushed = true
                }
            }
        } else {
            debugPrint ("error")
        }
    }
}

class TableViewHelper {
    class func emptyImage(_ image: String, viewController: UITableViewController) {
        let image = UIImage(named: image)
        if let bgImage = image {
            let imageV = UIImageView(image : bgImage)
            imageV.frame = CGRect(x: 20, y: 100, width: 60, height: 60)
            imageV.contentMode = .scaleAspectFit
            imageV.sizeToFit()
            imageV.clipsToBounds = true
            viewController.tableView.backgroundView = imageV
            viewController.tableView.separatorStyle = .none
        }
    }
}




