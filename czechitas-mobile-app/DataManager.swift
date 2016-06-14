//
//  DataManager.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 06.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension Manager {
    static let baseURL = "https://czechitas-app.herokuapp.com:443/api/v1"
}

enum APIRouter: URLRequestConvertible {
    
    case Cities()
    case CoursesPrepared()
    case CoursesOpen()
    case CourseDetail(Int)
    case Venues()
    
    var URLRequest: NSMutableURLRequest {
        let result: (path: String, parameters: [String: AnyObject]) = {
            switch self
            {
            case .Cities():
                return ("/cities/", [:])
            case .CoursesPrepared():
                return ("/courses/prepared/", [:])
            case .CoursesOpen():
                return ("/courses/open/", [:])
            case .CourseDetail(let id):
                return ("/courses/\(id)/", [:])
            default:
                return ("/courses/", [:])
            }
        }()

        let URL = NSURL(string: Alamofire.Manager.baseURL)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        return URLRequest
    }
}

class APIManager {
    static let sharedInstance = APIManager()
    
    
    func callAPI(method : APIRouter, onComplete : ((data : JSON) -> Void)) {
        switch method {
        case .Cities():
            Alamofire.request(APIRouter.Cities())
                .validate()
                .responseJSON{ response in
                    if let value = response.result.value {
                        let cityJson = JSON(value)
                        onComplete(data : cityJson)
                        
                        
                    }
            }
        case .CoursesOpen():
            Alamofire.request(APIRouter.CoursesOpen())
                .validate()
                .responseJSON{ response in
                    if let value = response.result.value {
                        let courseOpenJson = JSON(value)
                        onComplete(data: courseOpenJson)
                    }
            }
        case .CoursesPrepared():
            Alamofire.request(APIRouter.CoursesPrepared())
                .validate()
                .responseJSON{ response in
                    if let value = response.result.value {
                        let coursePreparedJson = JSON(value)
                        onComplete(data: coursePreparedJson)
                    }
            }
        case .CourseDetail(let id):
            Alamofire.request(APIRouter.CourseDetail(id))
                .validate()
                .responseJSON{ response in
                    if let value = response.result.value {
                        let courseDetailJson = JSON(value)
                        onComplete(data: courseDetailJson)
                    }
            }
        default:
            break
            
        }
    }
    
    
    
    
}


