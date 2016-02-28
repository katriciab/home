//
//  PhilipsHueLightsManagerSpec.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-17.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import home

class PhilipsHueLightsManagerSpec: QuickSpec {
    
    override func spec() {
        let philipsHueLightsManager = PhilipsHueLightsManager(philipsHueService: MockPhilipsHueService(), circadianLightForTimeUtility: CircadianLightForTimeUtility())
        let mockHueService = philipsHueLightsManager.hueService as! MockPhilipsHueService
        
        describe("schedule circadian lights") {
            var returnedSet = Set<String>()
            
            beforeEach {
                philipsHueLightsManager.scheduleCircadianLights(
                    wakeUpTransitionTime: 60,
                    sunDownTransitionTime: 100,
                    bedTimeTransitionTime: 60)
                .onSuccess(block: { result in
                    returnedSet = result as! Set<String>
                })
            }
            
            it("when everything succeeds, return set of all ids") {
                let expectedSet = Set(["0", "1", "2", "3"])
                expect(returnedSet).to(equal(expectedSet))
            }
            
            it("should transition to full brightness and color at wake time, using the transition duration") {
                expect(mockHueService.receivedScheduleHours).to(contain(7))
                expect(mockHueService.receivedScheduleMins).to(contain(59))
                expect(mockHueService.receivedScheduleSeconds).to(contain(0))
            }
            
            it("should transition to full brightness and color at wake time, using the transition duration") {
                expect(mockHueService.receivedScheduleHours).to(contain(8))
                expect(mockHueService.receivedScheduleMins).to(contain(0))
                expect(mockHueService.receivedScheduleSeconds).to(contain(0))
                expect(mockHueService.receivedScheduleTransitionTime).to(contain(60))
            }
            
            it("should transition to tungsten color at sun down with transtion time") {
                expect(mockHueService.receivedScheduleHours).to(contain(18))
                expect(mockHueService.receivedScheduleMins).to(contain(30))
                expect(mockHueService.receivedScheduleSeconds).to(contain(0))
                expect(mockHueService.receivedScheduleTransitionTime).to(contain(100))
            }
            
            it("should transition to deep tungsten color at bed time with transition time") {
                expect(mockHueService.receivedScheduleHours).to(contain(0))
                expect(mockHueService.receivedScheduleMins).to(contain(0))
                expect(mockHueService.receivedScheduleSeconds).to(contain(0))
            }
        }
    }
}
