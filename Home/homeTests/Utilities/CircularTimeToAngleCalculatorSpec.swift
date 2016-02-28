//
//  CircularTimeToAngleCalculatorSpec.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-27.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import home
class CircularTimeToAngleCalculatorSpec: QuickSpec {
    
    override func spec() {
        
        describe("When calculating angle for time") {
            let wake = NSDateComponents()
            wake.hour = 8
            wake.minute = 0
            wake.second = 0
            
            let sundown = NSDateComponents()
            sundown.hour = 18
            sundown.minute = 0
            sundown.second = 0
            
            let bed = NSDateComponents()
            bed.hour = 0
            bed.minute = 0
            bed.second = 0
            
            context("when time between wake up and sundown") {
                let now = NSDateComponents()
                now.hour = 11
                now.minute = 0
                now.second = 0
                
                let angle = CircularTimeToAngleCalculator().angleForCurrentTime(now, withWakeTime: wake, withSundownTime: sundown, withBedTime: bed)
                
                it("Should return angle in top half of circle") {
//                    let actualAngle = 180.0 * 10800.0/36000.0
                    expect(angle).to(equal(54.0))
                }
            }
            
            context("when time between sundown and bedtime") {
                let now = NSDateComponents()
                now.hour = 21
                now.minute = 0
                now.second = 0
                
                let angle = CircularTimeToAngleCalculator().angleForCurrentTime(now, withWakeTime: wake, withSundownTime: sundown, withBedTime: bed)
                
                it("Should return angle in bottom half of circle") {
                    expect(angle).to(equal(270.0))
                }
            }
            
            context("when time between bedtime and wake up") {
                let now = NSDateComponents()
                now.hour = 3
                now.minute = 0
                now.second = 0
                
                let angle = CircularTimeToAngleCalculator().angleForCurrentTime(now, withWakeTime: wake, withSundownTime: sundown, withBedTime: bed)
                
                it("Should return angle at 360") {
                    expect(angle).to(equal(360.0));
                }
            }
        }
    }
}
