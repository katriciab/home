//
//  SchedulesDataControllerSpec.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-28.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import home

class SchedulesDataControllerSpec: QuickSpec {
    
    override func spec() {
        
        let schedulesDataController = SchedulesDataController(
            philipsHueLightsManager: MockPhilipsHueLightsManager(),
            philipsHueCacheWrapper: MockPhilipsHueCacheWrapper(),
            userDefaults: MockHomeUserDefaultSettings()
        )
        
        let mockUserDefaultSettings = schedulesDataController.userDefaults as! MockHomeUserDefaultSettings
        let mockPhilipsCacheWrapper = schedulesDataController.hueCacheWrapper as! MockPhilipsHueCacheWrapper
        
        describe("setting circadian lights schedules") {
            beforeEach {
                schedulesDataController.setCircadianLightSchedules()
            }
            
            it("should save schedule to user defaults") {
                expect(mockUserDefaultSettings.didReceiveSaveScheduleIds).to(beTruthy())
            }
        }
        
        describe("check if schedules for circadian lights have been set") {
            
            context("saved schedules are the same as schedules cached on bridge") {
                var isCircadianLightSchedulesSet = false
                
                beforeEach {
                    let userDefaultsSchedules = Set<String>(["1", "2", "3"])
                    mockUserDefaultSettings.returnedScheduleIds = userDefaultsSchedules
                    
                    let bridgeSchedules = Set<String>(["1", "2", "3"])
                    mockPhilipsCacheWrapper.returnedAllSchedules = bridgeSchedules
                    
                    isCircadianLightSchedulesSet = schedulesDataController.isCircadianLightSchedulesSet()
                }
                
                it("should return true for schedules being set") {
                    expect(isCircadianLightSchedulesSet).to(beTruthy())
                }
            }
            
            context("saved schedules are different as schedules cached on bridge") {
                var isCircadianLightSchedulesSet = false
                
                beforeEach {
                    let userDefaultsSchedules = Set<String>(["1", "2"])
                    mockUserDefaultSettings.returnedScheduleIds = userDefaultsSchedules
                    
                    let bridgeSchedules = Set<String>(["1", "3", "4"])
                    mockPhilipsCacheWrapper.returnedAllSchedules = bridgeSchedules
                    
                    isCircadianLightSchedulesSet = schedulesDataController.isCircadianLightSchedulesSet()
                }
                
                it("should return true for schedules being set") {
                    expect(isCircadianLightSchedulesSet).to(beFalsy())
                }
            }
        }
    }
}
