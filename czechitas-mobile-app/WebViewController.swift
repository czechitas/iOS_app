//
//  WebViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 06.07.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlRequest : NSURLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (urlRequest!)
        webView.loadRequest(urlRequest!)
        
        
                
        
    }
    
   
    
   

}
