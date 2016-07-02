//
//  AlertViewController.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 26.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

class AlertViewController: UIAlertController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    private func presentViewController(alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: flag, completion: completion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAlert(title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title : "OK", style: .Default) { (action) in
            print (action)
            
        }
        
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated : true, completion: nil)
            
        
    }
    
    func createAlert2(title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        var settingsAction = UIAlertAction(title: "Nastavenia", style: .Default) { (_) -> Void in
            let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsURL {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        let cancelAction = UIAlertAction(title : "Zrusit", style: .Default) { (action) in
            print (action)
            
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated : true, completion: nil)
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
