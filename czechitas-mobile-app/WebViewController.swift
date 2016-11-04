//
//  WebViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 06.07.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import SVProgressHUD

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlRequest : URLRequest?
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        
        SVProgressHUD.show()
        webView.loadRequest(urlRequest!)
        SVProgressHUD.dismiss()
        
        
                
        
    }
    
   
    
   

}
