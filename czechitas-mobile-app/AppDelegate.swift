//
//  AppDelegate.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 06.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        

        // Override point for customization after application launch.
        
        if Reachability.isConnectedToNetwork() == true {
            print ("OK")
            Model.sharedInstance.fetchCourseData(APIRouter.CoursesOpen(), courseData: {
                (data, data2) -> Void in
                
                return data
                
            })
            
            Model.sharedInstance.fetchCourseData(APIRouter.CoursesPrepared(), courseData: {
                (data, data2) -> Void in
                
                return data
                
            })
            
        } else {
            AlertViewController().createAlert("Chyba", message : "Nie ste pripojeny k netu")
        }
        
        
        UINavigationBar.appearance().barStyle = .BlackTranslucent
        
        return true
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if Reachability.isConnectedToNetwork() == true {
            print ("OK")
            Model.sharedInstance.fetchCourseData(APIRouter.CoursesOpen(), courseData: {
                (data, data2) -> Void in
                
                return data
                
            })
            
            Model.sharedInstance.fetchCourseData(APIRouter.CoursesPrepared(), courseData: {
                (data, data2) -> Void in
                
                return data
                
            })
            
        } else {
            AlertViewController().createAlert("Chyba", message : "Nie ste pripojeny k netu")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        if Reachability.isConnectedToNetwork() == true {
            print ("OK")
            Model.sharedInstance.fetchCourseData(APIRouter.CoursesOpen(), courseData: {
                (data, data2) -> Void in
                
                return data
                
            })
            
            Model.sharedInstance.fetchCourseData(APIRouter.CoursesPrepared(), courseData: {
                (data, data2) -> Void in
                
                return data
                
            })
            
        } else {
            AlertViewController().createAlert("Chyba", message : "Nie ste pripojeny k netu")
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
            }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidFinishLaunching(application: UIApplication) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultValue = ["Courses" : [[String:Int]]()]
        defaults.registerDefaults(defaultValue)
    }


}

