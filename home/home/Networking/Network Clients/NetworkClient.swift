//
//  NetworkClient.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-12.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Alamofire
import FutureKit

class NetworkClient : Networking {
    
    var manager : Manager
    
    init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        manager = Alamofire.Manager(configuration: configuration)
    }
    
    func get(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        return self.executeRequest(.GET, urlString: urlString, parameters: parameters)
    }
    
    func post(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        return self.executeRequest(.POST, urlString: urlString, parameters: parameters)
    }
    
    func put(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        return self.executeRequest(.PUT, urlString: urlString, parameters: parameters)
    }
    
    func executeRequest(httpMethod : Alamofire.Method, urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        let p = Promise<AnyObject>()
        Alamofire.request(httpMethod, urlString, parameters: parameters, encoding:.JSON)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    p.completeWithSuccess(JSON)
                }
        }
        
        return p.future
    }
}
