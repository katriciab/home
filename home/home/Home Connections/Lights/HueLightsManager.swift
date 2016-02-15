//
//  HueLightsManager.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-08.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import DynamicColor

class HueLightsManager {
    
    var philipsHueService : PhilipsHueService
    
    init(philipsHueService: PhilipsHueService) {
        self.philipsHueService = philipsHueService
    }
    
    func setLightColor(color: UIColor) {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        let lights = cache.lights
        for (key, light) in lights {
            print("Light with id \(key) and phLight \(light.identifier!)")            
            if (light.identifier == "1") {
                let lightState = color.phXYLightState("LST001")
                let bridgeSendAPI = PHBridgeSendAPI()
                bridgeSendAPI.updateLightStateForId(light.identifier, withLightState: lightState, completionHandler:  { (errors: [AnyObject]!) -> Void in
                    print("UPDATED LIGHT!")
                })
            }
        }
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
    
    func scheduleCircadianLights() {
    }
}
