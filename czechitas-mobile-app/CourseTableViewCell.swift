//
//  CourceTableViewCell.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 15.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseDate: UILabel!
    @IBOutlet weak var courseCategory: UILabel!
    @IBOutlet weak var courseDescription: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    
    func configureCell(course : Course) {
        
        let dates = course.convertDate()
        courseDate.text = dates.0 + " - " + course.courseCity
        courseDate.font = UIFont.boldSystemFontOfSize(12.0)
        courseTitle.text = course.title
        let description = course.courseDescription
        let index = description.startIndex.advancedBy(200)
        let desc = description.substringToIndex(index)
        courseDescription.text = desc
        courseCategory.textColor = course.courseCategoryColorCode
        courseCategory.text = course.courseCategoryTitle
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
