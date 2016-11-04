//
//  Courses.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 06.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import Foundation
import UIKit


class Course : NSObject {
    var id : Int
    var title : String
    var courseStartDate : String
    var courseEndDate : String
    var courseStartTime : String?
    var courseEndTime : String?
    var courseDescription : String
    var coursePrice : String?
    var courseNotes : String?
    var courseLink : String?
    var interestedLink : String?
    var courseVenueTitle : String = ""
    var courseStreetName : String = ""
    var courseStreetNumber : String = ""
    var courseCouchEmail : String?
    var courseCity : String
    var courseCategoryTitle : String?
    var courseCategoryColorCode : UIColor?
    var courseState : String?
    var open_registration : Bool?
    var publish : Bool?
    var repeatCourse : String?
    var couches : String?
    
    
    
    
    init?(id : Int, title : String, courseStartDate : String, courseEndDate : String,courseDescription : String, courseCity : String, coursePrice : String) {
        
        
        self.id = id
        self.title = title
        self.courseStartDate = String(courseStartDate)
        self.courseEndDate = courseEndDate
        self.courseCity = courseCity
        self.courseDescription = courseDescription
        self.coursePrice = coursePrice
        
        if courseStartDate.isEmpty || courseEndDate.isEmpty {
            self.courseStartDate = String(describing: Date())
            self.courseEndDate = String(describing: Date())
        }
        
        
        
        super.init()
        
        
    }
    
   
    
    func convertDate() -> (String, String, String, String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let startDate = formatter.date(from: courseStartDate)
        let startTime = formatter.date(from: courseStartDate)
        let endTime = formatter.date(from: courseEndDate)
        let endDate = formatter.date(from: courseEndDate)
        formatter.dateFormat = "dd. MM. yyyy"
        let startDate1 = formatter.string(from: startDate ?? Date())
        let endDate1 = formatter.string(from: endDate ?? Date())
        formatter.dateFormat = "HH:mm"
        self.courseStartTime = formatter.string(from: startTime ?? Date())
        self.courseEndTime = formatter.string(from: endTime ?? Date())
        return (startDate1, endDate1, courseStartTime ?? "00:00:00", courseEndTime ?? "00:00:00")
    }
    
    
    
    
    
    func setState(_ courseState : String) {
        self.courseState = courseState
    }
    
    func addCategory(_ courseCategoryTitle : String, colorCode : String) {
        self.courseCategoryTitle = courseCategoryTitle
        self.courseCategoryColorCode = UIColor(hexString: colorCode)
    }
    
    func addDetailInfo(_ coursePrice : String, courseNotes : String, courseLink : String, interestedLink : String, courseVenueTitle : String, courseStreetName : String, courseStreetNumber : String, courseCouchEmail : String, open_registration : Bool, publish : Bool, repeatCourse : String, couches : String) {
        self.coursePrice = coursePrice
        self.courseNotes = courseNotes
        self.courseLink = courseLink
        self.interestedLink = interestedLink
        self.courseVenueTitle = courseVenueTitle
        self.courseStreetName = courseStreetName
        self.courseStreetNumber = courseStreetNumber
        self.courseCouchEmail = courseCouchEmail
        self.open_registration = open_registration
        self.publish = publish
        self.repeatCourse = repeatCourse
        self.couches = couches
        
        if couches == "" ||  couches == "None" {
            self.couches = "Kouč neuveden"
        }
        
        if courseNotes == "" {
            self.courseNotes = "Žádné dodatečné informace"
        }
        
    }
    
    func createFullAddress() -> String {
        let fullAddress = "\(self.courseVenueTitle), \(self.courseStreetName) \(self.courseStreetNumber), \(self.courseCity)"
        
        
        return fullAddress
    }
}


extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

class Category : NSObject {
    var id : Int
    var title : String
    var colorCode : UIColor?
    var isSelected : Bool?
    
    init(id : Int, title : String, colorCode: String) {
        self.id = id
        self.title = title
        
        
        self.colorCode = UIColor(hexString : colorCode)
        
        
        
        
        
        
    }
    
    
    
    
    func chooseCategory(_ state : Bool) {
     isSelected = state 
    }
    
}


