//
//  MockNetworkClient.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-13.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import FutureKit

class MockNetworkClient: Networking {
    
    init() {
    }
    
    var receivedParameters : [String : AnyObject]
    
    var didReceiveGet = false
    func get(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        self.didReceiveGet = true
        self.receivedParameters = parameters
    }

    var didReceivePost = false
    func post(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        self.didReceivePost = true
        self.receivedParameters = parameters
    }
    
    var didReceivePut = false
    func put(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        self.didReceivePut = true
        self.receivedParameters = parameters
    }
}
