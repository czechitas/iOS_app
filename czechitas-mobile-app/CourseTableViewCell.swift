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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
