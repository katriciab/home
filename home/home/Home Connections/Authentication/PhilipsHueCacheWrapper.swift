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
    func getAllSchedules() -> Set<String>
}

class PhilipsHueCacheWrapper: CacheWrapper {
    
    func getBridgeInformation() -> (username : String?, ipAddress : String?) {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        return (cache.bridgeConfiguration.username, cache.bridgeConfiguration.ipaddress)
    }
    
    func removeAllSchedules() {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        print(cache.schedules.count)
        for (_, schedule) in cache.schedules {
            let bridgeSendAPI = PHBridgeSendAPI()
            let sched = schedule as! PHSchedule
            bridgeSendAPI.removeScheduleWithId(sched.identifier) { (errors: [AnyObject]!) -> Void in
                if errors != nil {
                    print("Did not remove schedule because of error: \(errors)")
                } else {
                    print("Remove schedule")
                }
            }
        }
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
    
    func getAllSchedules() -> Set<String> {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        var set = Set<String>()
        if let schedules = cache.schedules {
            for (_, schedule) in schedules {
                set.insert((schedule as! PHSchedule).identifier)
            }
        }
        return set;
    }
}
