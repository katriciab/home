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

enum ErrorResponse : ErrorType {
    case NetworkError
}

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
                
                switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    if let jsonResult = JSON as? Array<Dictionary<String,AnyObject>> {
                        if jsonResult[0]["error"] == nil {
                            p.completeWithSuccess(jsonResult[0])
                        } else {
                            print("Success has error JSON: \(JSON)")
                            p.completeWithFail(ErrorResponse.NetworkError)
                        }
                    } else {
                        if let jsonResult = JSON as? Dictionary<String,AnyObject> {
                            if jsonResult["error"] == nil {
                                p.completeWithSuccess(jsonResult)
                            } else {
                                print("Success has error JSON: \(JSON)")
                                p.completeWithFail(ErrorResponse.NetworkError)
                            }
                        }
                    }
                    break;
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    p.completeWithFail(error)
                    break;
                }
        }
        
        return p.future
    }
}
