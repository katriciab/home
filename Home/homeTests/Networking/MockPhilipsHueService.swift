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
    
    var receivedHours : Int?
    var receivedMins : Int?
    var receivedSeconds : Int?
    var receivedLightColor : UIColor?
    var receivedTransitionTime : NSTimeInterval?
    
    func scheduleDailyRecurringAlarmForHours(hours: Int, mins: Int, seconds: Int, forColor: UIColor, transitionTime: NSTimeInterval) {
        self.didReceiveScheduleDailyRecurringAlarmForTime = true
        self.receivedHours = hours
        self.receivedMins = mins
        self.receivedSeconds = seconds
        self.receivedLightColor = forColor
        self.receivedTransitionTime = transitionTime
    }
}
