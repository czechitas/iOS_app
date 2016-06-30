//
//  AuthManager.swift
//  czechitas-mobile-app
//
//  Created by Svetlana Margetová on 06.06.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import Alamofire

class AuthManager: NSMutableURLRequest {
    let user = "mobile.user"
    let password = "Encoder237"
    
    func getCredentials() {
        Alamofire.request(.GET, "https://httpbin.org/basic-auth/\(user)/\(password)")
            .authenticate(user: user, password: password)
            .responseJSON { response in
                debugPrint(response)
        }
    }
}
