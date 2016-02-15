//
//  MockNetworkClient.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-13.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import FutureKit

@testable import home

class MockNetworkClient: Networking {
    
    var receivedParameters : [String : AnyObject]
    
    init() {
        self.receivedParameters = [:]
    }
    
    var didReceiveGet = false
    func get(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        self.didReceiveGet = true
        self.receivedParameters = parameters
        return Promise<AnyObject>().future
    }

    var didReceivePost = false
    func post(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        self.didReceivePost = true
        self.receivedParameters = parameters
        return Promise<AnyObject>().future
    }
    
    var didReceivePut = false
    func put(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject> {
        self.didReceivePut = true
        self.receivedParameters = parameters
        return Promise<AnyObject>().future
    }
}
