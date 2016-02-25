//
//  CircadianLightForTimeUtilitySpec.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-24.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import home

class CircadianLightForTimeUtilitySpec: QuickSpec {
    
    override func spec() {
        let circadianLightForTimeUtility = CircadianLightForTimeUtility()
        
        describe("when sleep time is same day") {
            beforeEach {
                let wakeTime = NSDateComponents()
                wakeTime.hour = 8
                wakeTime.minute = 0
                wakeTime.second = 0
                
                let sundown = NSDateComponents()
                sundown.hour = 18
                sundown.minute = 30
                sundown.second = 0
                
                let bedTime = NSDateComponents()
                bedTime.hour = 23
                bedTime.minute = 30
                bedTime.second = 0
                
                circadianLightForTimeUtility.updateTimes(wakeTime,
                    sundown: sundown,
                    bedTime: bedTime)
            }
            
            describe("Get color for time of the day") {
                
                it("when time is before wake, return candle") {
                    let time = NSDateComponents()
                    time.hour = 6
                    time.minute = 0
                    time.second = 0
                    expect(circadianLightForTimeUtility.colorForTime(time)).to(equal(ColorPalette.candle()))
                }
                
                it("when time is after wake/before sundown, return halogen") {
                    let time = NSDateComponents()
                    time.hour = 9
                    time.minute = 0
                    time.second = 0
                    expect(circadianLightForTimeUtility.colorForTime(time)).to(equal(ColorPalette.halogen()))
                }
                
                it("when time is after sundown/before bedtime, return tungsten") {
                    let time = NSDateComponents()
                    time.hour = 20
                    time.minute = 0
                    time.second = 0
                    expect(circadianLightForTimeUtility.colorForTime(time)).to(equal(ColorPalette.tungsten()))
                }
                
                it("when time is after bedtime / after midnight, return tungsten") {
                    let time = NSDateComponents()
                    time.hour = 1
                    time.minute = 0
                    time.second = 0
                    expect(circadianLightForTimeUtility.colorForTime(time)).to(equal(ColorPalette.candle()))
                }
                
                it("when time is after bedtime / before midnight, return candle") {
                    let time = NSDateComponents()
                    time.hour = 23
                    time.minute = 50
                    time.second = 0
                    expect(circadianLightForTimeUtility.colorForTime(time)).to(equal(ColorPalette.candle()))
                }
            }
        }
        
        describe("when sleep time is next day") {
            
            beforeEach {
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
                
                circadianLightForTimeUtility.updateTimes(wakeTime,
                    sundown: sundown,
                    bedTime: bedTime)
            }
            
            describe("Get color for time of the day") {
                
                it("when time is before wake, return candle") {
                    let time = NSDateComponents()
                    time.hour = 6
                    time.minute = 0
                    time.second = 0
                    expect(circadianLightForTimeUtility.colorForTime(time)).to(equal(ColorPalette.candle()))
                }
                
                it("when time is after wake/before sundown, return halogen") {
                    let time = NSDateComponents()
                    time.hour = 9
                    time.minute = 0
                    time.second = 0
                    expect(circadianLightForTimeUtility.colorForTime(time)).to(equal(ColorPalette.halogen()))
                }
                
                it("when time is after sundown/before bedtime, return tungsten") {
                    let time = NSDateComponents()
                    time.hour = 20
                    time.minute = 0
                    time.second = 0
                    expect(circadianLightForTimeUtility.colorForTime(time)).to(equal(ColorPalette.tungsten()))
                }
                
                it("when time is after bedtime / after midnight, return candle") {
                    let time = NSDateComponents()
                    time.hour = 1
                    time.minute = 0
                    time.second = 0
                    expect(circadianLightForTimeUtility.colorForTime(time)).to(equal(ColorPalette.candle()))
                }
            }
        }
    }
}
