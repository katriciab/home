//
//  MockPhilipsHueCacheWrapper.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-15.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

@testable import home

class MockPhilipsHueCacheWrapper: CacheWrapper {
    
    var didReceiveGetBridgeInformation = false
    func getBridgeInformation() -> (username: String?, ipAddress: String?) {
        self.didReceiveGetBridgeInformation = true
        return ("Fake Username", "Fake IP Address")
    }
    
    var didReceiveGetAllLights = false
    var returnedLights = [PHLight]()
    func getAllLights() -> [PHLight] {
        self.didReceiveGetAllLights = true
        
        let light = PHLight()
        light.identifier = "Identifier"
        light.modelNumber = "LCT007"
        self.returnedLights.append(light)
        return self.returnedLights
    }
    
    var didReceiveGetAllSchedules = false
    var returnedAllSchedules = Set<String>()
    func getAllSchedules() -> Set<String> {
        self.didReceiveGetAllSchedules = true
        return returnedAllSchedules
    }
}
