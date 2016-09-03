//
//  PopUpViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 29.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
