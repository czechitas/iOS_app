import UIKit
import Alamofire
import SwiftyJSON



enum APIRouter: URLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    
    
    static let baseURL = "https://czechitas-app.herokuapp.com:443/api/v1"
    case cities()
    case coursesPrepared()
    case coursesOpen()
    case coursesAll()
    case coursesClosed()
    case venues()
    case update(timestamp : Int)
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self
            {
            case .cities:
                return ("/cities/", [:])
            case .coursesPrepared:
                return ("/courses/prepared/", [:])
            case .coursesOpen:
                return ("/courses/open/", [:])
            case .coursesAll:
                return ("/courses/all/", [:])
            case .coursesClosed:
                return ("/courses/closed/", [:])
            case .venues:
                return ("/courses/", [:])
            case .update:
                return ("/update-from=1464889500/", [:])
            }
        }()
        
        let url = try APIRouter.baseURL.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        return try URLEncoding.default.encode(urlRequest, with : result.parameters)
        
        /*
        if let URL = URL(string: "https://czechitas-app.herokuapp.com:443/api/v1") {
            let URLRequest = NSMutableURLRequest(url: URL)
            return URLRequest
        }
        return NSMutableURLRequest()*/
    }
    
    }
    

class APIManager {
    static let sharedInstance = APIManager()
    
    func callAPI(_ method : APIRouter, onComplete : @escaping ((_ data : JSON) -> Void)) {
        Alamofire.request(method)
            .validate()
            .responseJSON { response in
                if let value = response.result.value {
                    let valueJSON = JSON(value)
                    onComplete(valueJSON)
                }
        }
    }
    
    
    
    
}
