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
    var didReceiveScheduleDailyRecurringAlarmForTime = false
    
    var receivedHours = Set<Int>()
    var receivedMins = Set<Int>()
    var receivedSeconds = Set<Int>()
    var receivedLightColor = Set<UIColor>()
    var brightness = Set<Int>()
    var receivedTransitionTime = Set<NSTimeInterval>()
    
    func scheduleDailyRecurringAlarmForHours(hours: Int, mins: Int, seconds: Int, forColor: UIColor, brightness: Int, transitionTime: NSTimeInterval) {
        self.didReceiveScheduleDailyRecurringAlarmForTime = true
        self.receivedHours.insert(hours)
        self.receivedMins.insert(mins)
        self.receivedSeconds.insert(seconds)
        self.receivedLightColor.insert(forColor)
        self.brightness.insert(brightness)
        self.receivedTransitionTime.insert(transitionTime)
    }
    
    func resetMessages() {
        self.receivedHours.removeAll()
        self.receivedMins.removeAll()
        self.receivedSeconds.removeAll()
        self.receivedLightColor.removeAll()
        self.brightness.removeAll()
        self.receivedTransitionTime.removeAll()
    }
}
