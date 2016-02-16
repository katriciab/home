//
//  PhilipsHueLightsManager.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-08.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import DynamicColor

class PhilipsHueLightsManager {
    
    var philipsHueService : PhilipsHueService
    
    init(philipsHueService: PhilipsHueService) {
        self.philipsHueService = philipsHueService
    }
    
    func scheduleCircadianLights(wakeUpTime: NSDateComponents, wakeUpTransitionTime: Int, sunDownStartTime: NSDateComponents, sunDownTransitionTime:Int, bedTime:NSDateComponents) {
        // wake - transition to brightness a minute before hand to full brightness of color 1
        // sundown - transition to dark around this time for an hour
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
}
