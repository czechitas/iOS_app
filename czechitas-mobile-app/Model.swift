//
//  Model.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 08.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import Foundation
import SwiftyJSON

class Model {
    static var sharedInstance = Model()
    
    var allCourses = [Course]()
    var categories = [Category]()
    
    
    
    func isCategoryWithThisID(id : Int) -> Bool {
        for cat in self.categories {
            if cat.id == id {
                return true
            }
        }
        return false
    }
    
    func fetchCourseData(method : APIRouter, courseData : ((data : [Course], data2 : [Category]) -> Void)) {
        
        
        var courses = [Course]()
        
        
        APIManager.sharedInstance.callAPI(method, onComplete: {
            (data) -> Void in
            
            
            
            for (index,subJson) : (String, JSON) in data {
                
                if let course = Course(id: subJson["id"].intValue, title: subJson["title"].stringValue, courseStartDate: subJson["course_start_date"].stringValue, courseEndDate: subJson["course_end_date"].stringValue, courseDescription: subJson["course_description"].stringValue, courseCity: subJson["course_venue"]["city"].stringValue) {
                    
                    
                    let category = Category(id: subJson["course_category"]["id"].intValue, title: subJson["course_category"]["title"].stringValue, colorCode: subJson["course_category"]["color_code"].stringValue)
                    
                    if !self.isCategoryWithThisID(category.id) {
                        self.categories.append(category)
                    } else {
                        print ("Category exists")
                    }
                    
                    
                    // toto tu finalne nebude , lebo kategorie sa vraj budu este menit
                    course.addCategory(subJson["course_category"]["title"].stringValue, courseCategoryColorCode: subJson["course_category"]["color_code"].stringValue)
                    
                    //course.convertDate()
                    
                    course.addDetailInfo(subJson["course_price"].stringValue, courseNotes: subJson["notes"].stringValue, courseLink: subJson["registration_form_link"].stringValue, courseVenueTitle: subJson["course_venue"]["title"].stringValue, courseStreetName: subJson["course_venue"]["street_name"].stringValue, courseStreetNumber: subJson["course_venue"]["street_number"].stringValue, courseCouchEmail: subJson["couch"]["user"].stringValue)
                    
                    course.setState(subJson["states"].stringValue)
                    
                    courses.append(course)
                    self.allCourses.append(course)
                    
                }
            }
            // Jen drobnost - možná lepší alternativa pro takovéhle věci funkce debugPrint - neloguje v produkční verzi
            //debugPrint ("Number of \(method) courses: \(self.courses.count)")
            
            
           
            courseData(data: courses, data2 : self.categories)
            
        })
    }
    
    /*
    func UpdateData(method : APIRouter, courseI : [Course], courseData : ((data : [Course], data2 : [Category]) -> Void)) {
        
        
        APIManager.sharedInstance.callAPI(method, onComplete: {
            (data) -> Void in
            
            var coursesU = [Course]()
            
            
            for (index,subJson) : (String, JSON) in data {
                
                if let course = Course(id: subJson["id"].intValue, title: subJson["title"].stringValue, courseStartDate: subJson["course_start_date"].stringValue, courseEndDate: subJson["course_end_date"].stringValue, courseDescription: subJson["course_description"].stringValue, courseCity: subJson["course_venue"]["city"].stringValue) {
                    
                    
                    let category = Category(id: subJson["course_category"]["id"].intValue, title: subJson["course_category"]["title"].stringValue, colorCode: subJson["course_category"]["color_code"].stringValue)
                    
                    if !self.isCategoryWithThisID(category.id) {
                        self.categories.append(category)
                    } else {
                        print ("Category exists")
                    }
                    
                    
                    // toto tu finalne nebude , lebo kategorie sa vraj budu este menit
                    course.addCategory(subJson["course_category"]["title"].stringValue, courseCategoryColorCode: subJson["course_category"]["color_code"].stringValue)
                    
                    //course.convertDate()
                    
                    course.addDetailInfo(subJson["course_price"].stringValue, courseNotes: subJson["notes"].stringValue, courseLink: subJson["registration_form_link"].stringValue, courseVenueTitle: subJson["course_venue"]["title"].stringValue, courseStreetName: subJson["course_venue"]["street_name"].stringValue, courseStreetNumber: subJson["course_venue"]["street_number"].stringValue, courseCouchEmail: subJson["couch"]["user"].stringValue)
                    
                    course.setState(subJson["states"].stringValue)
                    
                    coursesU.append(course)
                    self.allCourses.append(course)
                    
                }
            }
            
        
            // Jen drobnost - možná lepší alternativa pro takovéhle věci funkce debugPrint - neloguje v produkční verzi
            //debugPrint ("Number of \(method) courses: \(self.courses.count)")
                    
            
            
            
            print (coursesU.count)
            for courseD in coursesU {
                if courseD.id != 0  {
                    
                    
                    if courseD.courseState == "U" || courseD.courseState == "O" {
                        for object in courseI {
                            if object.id == courseD.id {
                                
                                var i = courseI.indexOf(object)
                                
                                object.delete(self)
                                
                                
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    else if courseD.courseState == "I" {
                        var courseI = courseI
                        courseI.append(courseD)
                    }
                    else if courseD.courseState == "D" {
                        
                        for object in courseI {
                            if object == courseI {
                                
                                var i = courseI.indexOf(object)
                                var courseI = courseI
                                courseI.removeAtIndex(i!)
                                print ("removed")
                                
                                
                            }
                            print ("removed")
                        }
                        
                        
                        
                        
                    }
                    else {
                        continue
                    }
                    
                }
                else {
                    continue
                }
                
                
                
            }

            
            courseData(data: courseI, data2 : self.categories)
            
        })
    }
 */


}


