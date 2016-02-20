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
    
    var hueService : HueService
    
    init(philipsHueService: HueService) {
        self.hueService = philipsHueService
    }
    
    func scheduleCircadianLights(wakeUpTime: NSDateComponents, wakeUpTransitionTime: NSTimeInterval, sunDownStartTime: NSDateComponents, sunDownTransitionTime:NSTimeInterval, bedTime:NSDateComponents) {
        // wake - transition to brightness a minute before hand to full brightness of color 1
        // sundown - transition to dark around this time for an hour
        self.scheduleWakeUp(wakeUpTime, wakeUpTransitionTime: wakeUpTransitionTime)
    }
    
    private func scheduleWakeUp(wakeUpTime: NSDateComponents, wakeUpTransitionTime: NSTimeInterval) {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        if let calendar = gregorianCalendar {
            let date = calendar.dateFromComponents(wakeUpTime)
            let newDate = date!.dateByAddingTimeInterval(-wakeUpTransitionTime);
            
            let newComponents = calendar.components([.Hour, .Minute, .Second], fromDate: newDate);
            
            self.hueService.scheduleDailyRecurringAlarmForHours(newComponents.hour,
                mins: newComponents.minute,
                seconds: newComponents.second,
                forColor: UIColor.redColor(),
                brightness: 5,
                transitionTime: wakeUpTransitionTime)
            
            self.hueService.scheduleDailyRecurringAlarmForHours(wakeUpTime.hour,
                mins: wakeUpTime.minute,
                seconds: wakeUpTime.second,
                forColor: UIColor.redColor(),
                brightness: 254,
                transitionTime: wakeUpTransitionTime)
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
}
