//
//  PhilipsHueCacheWrapper.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-13.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

protocol CacheWrapper {
    func getBridgeInformation() -> (username : String?, ipAddress : String?)
    func getAllLights() -> [PHLight]
}

class PhilipsHueCacheWrapper: CacheWrapper {

    func getBridgeInformation() -> (username : String?, ipAddress : String?) {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        return (cache.bridgeConfiguration.username, cache.bridgeConfiguration.ipaddress)
    }
    
    func getAllLights() -> [PHLight] {
        var lights = [PHLight]()
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        let myLights = cache.lights;
        for (_, value) in myLights {
            lights.append(value as! PHLight)
        }
        return lights
    }
}
