//
//  CourseInfoTableViewCell.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 16.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

class CourseInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var infoDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
