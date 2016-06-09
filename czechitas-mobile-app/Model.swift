//
//  Model.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 08.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Model {
    static var sharedInstance = Model()
    
    
    
    func fetchCourseData(method : APIRouter, courseData : ((data : [Course], data2 : [Category]) -> Void)) {
        
        var courses = [Course]()
        var categories = [Category]()
        
        
        
        APIManager.sharedInstance.callAPI(method, onComplete: {
            (data) -> [AnyObject] in
            
            
            
            for (index,subJson) : (String, JSON) in data {
                
                if let course = Course(id: subJson["id"].intValue, title: subJson["title"].stringValue, courseStartDate: subJson["course_start_date"].stringValue, courseEndDate: subJson["course_end_date"].stringValue, courseDescription: subJson["course_description"].stringValue, courseCity: subJson["course_venue"]["city"].stringValue) {
                    
                    
                    let category = Category(id: subJson["course_category"]["id"].intValue, title: subJson["course_category"]["title"].stringValue, colorCode: subJson["course_category"]["color_code"].stringValue)
                    
                    if categories.count != 0 {
                        for cat in categories {
                            if cat.id == category.id {
                                continue
                            }
                            else {
                                categories.append(category)
                            }
                        }
                    }
                    else {
                        categories.append(category)
                    }
                    
                    // toto tu finalne nebude , lebo kategorie sa vraj budu este menit
                    course.addCategory(subJson["course_category"]["title"].stringValue, courseCategoryColorCode: subJson["course_category"]["color_code"].stringValue)
                    
                    courses.append(course)
                    
                    
                    
                }
            }
            print ("Number of \(method) courses: \(courses.count)")
            print ("Number of \(method) categories: \(categories.count)")
            courseData(data: courses, data2 : categories)
            
            // toto tiez prerobim, lebo to nie je potrebne, len uz nestiham
            return courses
            
            
        })
    }

}