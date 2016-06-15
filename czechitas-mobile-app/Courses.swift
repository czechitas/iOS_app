//
//  Courses.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 06.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import Foundation


class Course : NSObject {
    var id : Int
    var title : String
    var courseStartDate : String?
    var courseEndDate : String?
    var courseDescription : String?
    var courseCity : String
    var courseCategoryTitle : String?
    var courseCategoryColorCode : String?
    
    
    
    init?(id : Int, title : String, courseStartDate : String, courseEndDate : String,courseDescription : String, courseCity : String) {
        
        
        self.id = id
        self.title = title
        self.courseStartDate = String(courseStartDate)
        self.courseEndDate = courseEndDate
        self.courseCity = courseCity
        self.courseDescription = courseDescription
        
        if courseStartDate.isEmpty || courseEndDate.isEmpty {
            self.courseStartDate = String(NSDate())
            self.courseEndDate = String(NSDate())
        }
        
        
    }
    
    func convertDate(courseStartDate : String) -> () {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = formatter.dateFromString(courseStartDate)
        formatter.dateFormat = "dd. MM. yyyy"
        self.courseStartDate = formatter.stringFromDate(date!)
    }
    
    func addCategory(courseCategoryTitle : String, courseCategoryColorCode : String) {
        self.courseCategoryTitle = courseCategoryTitle
        self.courseCategoryColorCode = courseCategoryColorCode
    }
}






class Category : NSObject {
    var id : Int
    var title : String
    var colorCode : String
    
    init(id : Int, title : String, colorCode : String) {
        self.id = id
        self.title = title
        self.colorCode = colorCode
        
        // TODO: convert colorCode
        // Možnost vyzkoušet implementace Extension nad UIColor :-)
        
    }
    
    
}


