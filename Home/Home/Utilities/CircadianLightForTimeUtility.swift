//
//  CircadianLightForTimeUtility.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-24.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

public enum TimeOfDay {
    case BeforeWake
    case Wake
    case AfterSundown
    case Bedtime
}

class CircadianLightForTimeUtility {
    
    let midnight = NSDateComponents()
    var wakeComponents : NSDateComponents!
    var sundownComponents : NSDateComponents!
    var bedtimeComponents : NSDateComponents!
    
    init() {
        self.midnight.hour = 0
        self.midnight.minute = 0
        self.midnight.second = 0
        
        let wakeTime = NSDateComponents()
        wakeTime.hour = 8
        wakeTime.minute = 0
        wakeTime.second = 0
        
        let sundown = NSDateComponents()
        sundown.hour = 18
        sundown.minute = 30
        sundown.second = 0
        
        let bedTime = NSDateComponents()
        bedTime.hour = 0
        bedTime.minute = 0
        bedTime.second = 0
        
        self.updateTimes(wakeTime, sundown: sundown, bedTime: bedTime)
    }
    
    func updateTimes(wakeTime: NSDateComponents, sundown: NSDateComponents, bedTime: NSDateComponents) {
        
        // TODO Enforce rules:
        // wake time 0 - sundown
        // sundown   16 - 21
        // bedtime   sundown - wake time
        
        self.wakeComponents = wakeTime
        self.sundownComponents = sundown
        self.bedtimeComponents = bedTime
        print("Wake time: \(wakeComponents.hour), \(wakeComponents.minute), \(wakeComponents.second)")
        print("Sundown time: \(sundownComponents.hour), \(sundownComponents.minute), \(sundownComponents.second)")
        print("Bed time: \(bedtimeComponents.hour), \(bedtimeComponents.minute), \(bedtimeComponents.second)")
    }
    
    func colorForTime(time: NSDateComponents) -> UIColor {
        if wakeComponents.isTimeLessThan(bedtimeComponents) {
            // Sleep same day
            if midnight.isTimeLessThan(time) && time.isTimeLessThan(wakeComponents) {
                return colorForTimeOfDay(TimeOfDay.BeforeWake)
            
            } else if wakeComponents.isTimeLessThan(time) && time.isTimeLessThan(sundownComponents ) {
                return colorForTimeOfDay(TimeOfDay.Wake)
                
            } else if sundownComponents.isTimeLessThan(time) && time.isTimeLessThan(bedtimeComponents) {
                return colorForTimeOfDay(TimeOfDay.AfterSundown)
                
            } else if bedtimeComponents.isTimeLessThan(time) {
                return colorForTimeOfDay(TimeOfDay.Bedtime)
            }
        } else {
            // Sleep next day
            if bedtimeComponents.isTimeLessThan(time) && time.isTimeLessThan(wakeComponents) {
                return colorForTimeOfDay(TimeOfDay.BeforeWake)
                
            } else if wakeComponents.isTimeLessThan(time) && time.isTimeLessThan(sundownComponents ) {
                return colorForTimeOfDay(TimeOfDay.Wake)
                
            } else if sundownComponents.isTimeLessThan(time) {
                return colorForTimeOfDay(TimeOfDay.AfterSundown)
                
            } else if midnight.isTimeLessThan(time) && time.isTimeLessThan(bedtimeComponents) {
                return colorForTimeOfDay(TimeOfDay.BeforeWake)
            }
        }
        
        return UIColor.blackColor()
    }
    
    func colorForTimeOfDay(timeOfDay: TimeOfDay) -> UIColor {
        switch timeOfDay {
        case .BeforeWake:
            return ColorPalette.candle()
        case .Wake:
            return ColorPalette.halogen()
        case .AfterSundown:
            return ColorPalette.tungsten()
        case .Bedtime:
            return ColorPalette.candle()
        }
    }
}
