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
        self.scheduleWakeUp(wakeUpTime, wakeUpTransitionTime: wakeUpTransitionTime)
        
        self.scheduleSundown(sunDownStartTime, sunDownTransitionTime: sunDownTransitionTime)
        
        self.scheduleBedTime(bedTime)
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
                forColor: ColorPalette.halogen(),
                brightness: 5,
                transitionTime: wakeUpTransitionTime)
            
            self.hueService.scheduleDailyRecurringAlarmForHours(wakeUpTime.hour,
                mins: wakeUpTime.minute,
                seconds: wakeUpTime.second,
                forColor: ColorPalette.halogen(),
                brightness: 254,
                transitionTime: wakeUpTransitionTime)
        }
    }
    
    private func scheduleSundown(sunDownStartTime: NSDateComponents, sunDownTransitionTime: NSTimeInterval) {
        self.hueService.scheduleDailyRecurringAlarmForHours(sunDownStartTime.hour,
            mins: sunDownStartTime.minute,
            seconds: sunDownStartTime.second,
            forColor: ColorPalette.tungsten(),
            brightness: 254,
            transitionTime: sunDownTransitionTime)
    }

    private func scheduleBedTime(bedTime: NSDateComponents) {
        self.hueService.scheduleDailyRecurringAlarmForHours(bedTime.hour,
            mins: bedTime.minute,
            seconds: bedTime.second,
            forColor: ColorPalette.candle(),
            brightness: 100,
            transitionTime: 60)
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
