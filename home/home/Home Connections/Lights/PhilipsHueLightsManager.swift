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
    var circadianLightForTimeUtility : CircadianLightForTimeUtility
    
    init(philipsHueService: HueService, circadianLightForTimeUtility: CircadianLightForTimeUtility) {
        self.hueService = philipsHueService
        self.circadianLightForTimeUtility = circadianLightForTimeUtility
    }
    
    func scheduleCircadianLights(wakeUpTransitionTime wakeUpTransitionTime: NSTimeInterval, sunDownTransitionTime: NSTimeInterval, bedTimeTransitionTime: NSTimeInterval) {
        self.scheduleWakeUp(self.circadianLightForTimeUtility.wakeComponents, wakeUpTransitionTime: wakeUpTransitionTime)
        
        self.scheduleSundown(self.circadianLightForTimeUtility.sundownComponents, sunDownTransitionTime: sunDownTransitionTime)
        
        self.scheduleBedTime(self.circadianLightForTimeUtility.bedtimeComponents, bedTimeTransitionTime: bedTimeTransitionTime)
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
                forColor: self.circadianLightForTimeUtility.colorForTimeOfDay(TimeOfDay.Wake),
                brightness: 5,
                transitionTime: wakeUpTransitionTime)
            
            self.hueService.scheduleDailyRecurringAlarmForHours(wakeUpTime.hour,
                mins: wakeUpTime.minute,
                seconds: wakeUpTime.second,
                forColor: self.circadianLightForTimeUtility.colorForTimeOfDay(TimeOfDay.Wake),
                brightness: 254,
                transitionTime: wakeUpTransitionTime)
        }
    }
    
    private func scheduleSundown(sunDownStartTime: NSDateComponents, sunDownTransitionTime: NSTimeInterval) {
        self.hueService.scheduleDailyRecurringAlarmForHours(sunDownStartTime.hour,
            mins: sunDownStartTime.minute,
            seconds: sunDownStartTime.second,
            forColor: self.circadianLightForTimeUtility.colorForTimeOfDay(TimeOfDay.AfterSundown),
            brightness: 254,
            transitionTime: sunDownTransitionTime)
    }
    
    private func scheduleBedTime(bedTime: NSDateComponents, bedTimeTransitionTime: NSTimeInterval) {
        self.hueService.scheduleDailyRecurringAlarmForHours(bedTime.hour,
            mins: bedTime.minute,
            seconds: bedTime.second,
            forColor: self.circadianLightForTimeUtility.colorForTimeOfDay(TimeOfDay.Bedtime),
            brightness: 100,
            transitionTime: bedTimeTransitionTime)
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
