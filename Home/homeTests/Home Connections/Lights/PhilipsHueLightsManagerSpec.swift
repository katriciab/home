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
            
            beforeEach {
                philipsHueLightsManager.scheduleCircadianLights(
                    wakeUpTransitionTime: 60,
                    sunDownTransitionTime: 100,
                    bedTimeTransitionTime: 60)
            }
            
            it("should transition to full brightness and color at wake time, using the transition duration") {
                expect(mockHueService.receivedHours).to(contain(7))
                expect(mockHueService.receivedMins).to(contain(59))
                expect(mockHueService.receivedSeconds).to(contain(0))
            }
            
            it("should transition to full brightness and color at wake time, using the transition duration") {
                expect(mockHueService.receivedHours).to(contain(8))
                expect(mockHueService.receivedMins).to(contain(0))
                expect(mockHueService.receivedSeconds).to(contain(0))
                expect(mockHueService.receivedTransitionTime).to(contain(60))
            }
            
            it("should transition to tungsten color at sun down with transtion time") {
                expect(mockHueService.receivedHours).to(contain(18))
                expect(mockHueService.receivedMins).to(contain(30))
                expect(mockHueService.receivedSeconds).to(contain(0))
                expect(mockHueService.receivedTransitionTime).to(contain(100))
            }
            
            it("should transition to deep tungsten color at bed time with transition time") {
                expect(mockHueService.receivedHours).to(contain(0))
                expect(mockHueService.receivedMins).to(contain(0))
                expect(mockHueService.receivedSeconds).to(contain(0))
            }
        }
    }
}
