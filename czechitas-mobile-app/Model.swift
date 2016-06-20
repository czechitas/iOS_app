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
    
    
    
    func fetchCourseData(method : APIRouter, courseData : ((data : [Course], data2 : [Category]) -> Void)) {
        
        var courses = [Course]()
        var categories = [Category]()
        
        
        
        APIManager.sharedInstance.callAPI(method, onComplete: {
            (data) -> Void in
            
            
            
            for (index,subJson) : (String, JSON) in data {
                
                if let course = Course(id: subJson["id"].intValue, title: subJson["title"].stringValue, courseStartDate: subJson["course_start_date"].stringValue, courseEndDate: subJson["course_end_date"].stringValue, courseDescription: subJson["course_description"].stringValue, courseCity: subJson["course_venue"]["city"].stringValue) {
                    
                    
                    let category = Category(id: subJson["course_category"]["id"].intValue, title: subJson["course_category"]["title"].stringValue, colorCode: subJson["course_category"]["color_code"].stringValue)
                    
                    
                    // toto tu finalne nebude , lebo kategorie sa vraj budu este menit
                    course.addCategory(subJson["course_category"]["title"].stringValue, courseCategoryColorCode: subJson["course_category"]["color_code"].stringValue)
                    
                    course.convertDate()
                    
                    
                    courses.append(course)
                    
                }
            }
            // Jen drobnost - možná lepší alternativa pro takovéhle věci funkce debugPrint - neloguje v produkční verzi
            debugPrint ("Number of \(method) courses: \(courses.count)")
            
            
            courseData(data: courses, data2 : categories)
            
        })
    }
    
    func fetchCourseDetailData(method : APIRouter, currentCourse : Course) {
        APIManager.sharedInstance.callAPI(method, onComplete: {
            (data) -> Void in
            
            currentCourse.addDetailInfo(data["course_price"].stringValue, courseNotes: data["notes"].stringValue, courseLink: data["registration_form_link"].stringValue, courseVenueTitle: data["course_venue"]["title"].stringValue, courseStreetName: data["course_venue"]["street_name"].stringValue, courseStreetNumber: data["course_venue"]["street_number"].stringValue, courseCouchEmail: data["couch"]["user"].stringValue)
            
            
        
        })
    }

}


