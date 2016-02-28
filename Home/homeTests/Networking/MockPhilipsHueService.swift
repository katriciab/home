//
//  MockPhilipsHueService.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-17.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

@testable import home

class MockPhilipsHueService : HueService {
    
    var receivedLightColor = Set<UIColor>()
    var receivedLightBrightness = Set<Int>()
    var receivedLightTransitionTime = Set<NSTimeInterval>()
    var didReceiveSetLightsToColor = false
    func setLightsToColor(color: UIColor, brightness: Int, transitionTime: NSTimeInterval) {
        self.didReceiveTurnOffLights = true
        self.receivedLightColor.insert(color)
        self.receivedLightBrightness.insert(brightness)
        self.receivedLightTransitionTime.insert(transitionTime)
    }
    
    var didReceiveTurnOffLights = false
    func turnOffLights() {
        self.didReceiveTurnOffLights = true
    }
    
    var didReceiveScheduleDailyRecurringAlarmForTime = false
    var receivedScheduleHours = Set<Int>()
    var receivedScheduleMins = Set<Int>()
    var receivedScheduleSeconds = Set<Int>()
    var receivedScheduleLightColor = Set<UIColor>()
    var receivedScheduleBrightness = Set<Int>()
    var receivedScheduleTransitionTime = Set<NSTimeInterval>()
    func scheduleDailyRecurringAlarmForHours(hours: Int, mins: Int, seconds: Int, forColor: UIColor, brightness: Int, transitionTime: NSTimeInterval) {
        self.didReceiveScheduleDailyRecurringAlarmForTime = true
        self.receivedScheduleHours.insert(hours)
        self.receivedScheduleMins.insert(mins)
        self.receivedScheduleSeconds.insert(seconds)
        self.receivedScheduleLightColor.insert(forColor)
        self.receivedScheduleBrightness.insert(brightness)
        self.receivedScheduleTransitionTime.insert(transitionTime)
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
