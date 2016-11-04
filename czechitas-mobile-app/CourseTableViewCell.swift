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
    @IBOutlet weak var courseTitle: UILabel!
  
    func configureCell(_ course : Course) {
        let dates = course.convertDate()
        courseDate.text = dates.0 + " - " + course.courseCity
        courseDate.font = UIFont.boldSystemFont(ofSize: 12.0)
        courseTitle.text = course.title
        courseCategory.textColor = course.courseCategoryColorCode
        courseCategory.text = course.courseCategoryTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
