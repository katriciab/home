//
//  CircularTimeToAngleCalculator.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-27.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

struct CircularTimeToAngleCalculator {
    
    // Where angle 0 is the wake time
    func angleForCurrentTime(time: NSDateComponents,
        withWakeTime wakeTime: NSDateComponents,
        withSundownTime sundownTime: NSDateComponents,
        withBedTime bedTime: NSDateComponents) -> Double {
            time.updateWithDefaultDate(true)
            wakeTime.updateWithDefaultDate(true)
            sundownTime.updateWithDefaultDate(true)
            if (bedTime.isTimeLessThan(NSDateComponents.midnight()) && bedTime.isTimeLessThan(wakeTime)) {
                bedTime.updateWithDefaultDate(false)
            }
            
            if time.isTimeLessThan(wakeTime) && NSDateComponents.midnight().isTimeLessThan(time) {
                return 360.0;
            }
            
            let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            if let calendar = gregorianCalendar {
                let currentTime = calendar.dateFromComponents(time)
                let wakeTime = calendar.dateFromComponents(wakeTime)
                let sundownTime = calendar.dateFromComponents(sundownTime)
                let bedTime = calendar.dateFromComponents(bedTime)
                

                
                let isInTopHalfOfCircle = currentTime?.earlierDate(wakeTime!) == wakeTime && currentTime?.earlierDate(sundownTime!) == currentTime
                 let isInBottomHalfOfCircle = currentTime?.earlierDate(bedTime!) == currentTime && currentTime?.earlierDate(sundownTime!) == sundownTime
                
                if isInTopHalfOfCircle {
                    let differenceBetweenWakeAndSundown = sundownTime?.timeIntervalSinceDate(wakeTime!)
                    let differenceToCurrentTime = currentTime?.timeIntervalSinceDate(wakeTime!)
                    let ratio = differenceToCurrentTime! / differenceBetweenWakeAndSundown!
                    return 180.0 * ratio
                    
                } else if isInBottomHalfOfCircle {
                    let differenceBetweenSundownAndBedtime = bedTime?.timeIntervalSinceDate(sundownTime!)
                    let differenceToCurrentTime = currentTime?.timeIntervalSinceDate(sundownTime!)
                    let ratio = differenceToCurrentTime! / differenceBetweenSundownAndBedtime!
                    return (180.0 * ratio) + 180.0
                }
            }
            return -1
    }
}
