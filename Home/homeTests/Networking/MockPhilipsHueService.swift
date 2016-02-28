//
//  MockPhilipsHueService.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-17.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import FutureKit

@testable import home

class MockPhilipsHueService : HueService {
    
    var receivedLightColor = Set<UIColor>()
    var receivedLightBrightness = Set<Int>()
    var receivedLightTransitionTime = Set<NSTimeInterval>()
    var didReceiveSetLightsToColor = false
    func setLightsToColor(color: UIColor, brightness: Int, transitionTime: NSTimeInterval) -> Future<AnyObject> {
        self.didReceiveTurnOffLights = true
        self.receivedLightColor.insert(color)
        self.receivedLightBrightness.insert(brightness)
        self.receivedLightTransitionTime.insert(transitionTime)
        return Promise().future
    }
    
    var didReceiveTurnOffLights = false
    func turnOffLights() -> Future<AnyObject> {
        self.didReceiveTurnOffLights = true
        return Promise().future
    }
    
    var didReceiveScheduleDailyRecurringAlarmForTime = false
    var receivedScheduleHours = Set<Int>()
    var receivedScheduleMins = Set<Int>()
    var receivedScheduleSeconds = Set<Int>()
    var receivedScheduleLightColor = Set<UIColor>()
    var receivedScheduleBrightness = Set<Int>()
    var receivedScheduleTransitionTime = Set<NSTimeInterval>()
    var scheduleCount = 0
    var scheduleSet = Set<String>()
    func scheduleDailyRecurringAlarmForHours(hours: Int, mins: Int, seconds: Int, forColor: UIColor, brightness: Int, transitionTime: NSTimeInterval) -> Future<AnyObject> {
        self.didReceiveScheduleDailyRecurringAlarmForTime = true
        self.receivedScheduleHours.insert(hours)
        self.receivedScheduleMins.insert(mins)
        self.receivedScheduleSeconds.insert(seconds)
        self.receivedScheduleLightColor.insert(forColor)
        self.receivedScheduleBrightness.insert(brightness)
        self.receivedScheduleTransitionTime.insert(transitionTime)
        let p = Promise<AnyObject>()
        let successJson = [
            "success" : [
                "id" : String(scheduleCount)
            ]
        ]
        
        p.completeWithSuccess(successJson)
        scheduleCount++
        return p.future
    }
    
    func resetMessages() {
        didReceiveTurnOffLights = false
        didReceiveSetLightsToColor = false
        self.receivedLightBrightness.removeAll()
        self.receivedLightColor.removeAll()
        self.receivedLightTransitionTime.removeAll()
        didReceiveScheduleDailyRecurringAlarmForTime = false
        self.receivedScheduleHours.removeAll()
        self.receivedScheduleMins.removeAll()
        self.receivedScheduleSeconds.removeAll()
        self.receivedScheduleLightColor.removeAll()
        self.receivedScheduleBrightness.removeAll()
        self.receivedScheduleTransitionTime.removeAll()
    }
}
