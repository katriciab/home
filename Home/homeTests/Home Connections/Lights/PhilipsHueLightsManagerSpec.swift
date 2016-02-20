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
        
        let philipsHueLightsManager = PhilipsHueLightsManager(philipsHueService: MockPhilipsHueService())
        let mockHueService = philipsHueLightsManager.hueService as! MockPhilipsHueService
        
        describe("schedule circadian lights") {
            let wakeDateComponents = NSDateComponents()
            wakeDateComponents.hour = 8
            wakeDateComponents.minute = 0
            wakeDateComponents.second = 0
            
            let sundownDateComponents = NSDateComponents()
            sundownDateComponents.hour = 18
            sundownDateComponents.minute = 15
            sundownDateComponents.second = 5
            
            let bedTimeDateComponents = NSDateComponents()
            bedTimeDateComponents.hour = 0
            bedTimeDateComponents.minute = 0
            bedTimeDateComponents.second = 0
            
            beforeEach {
                philipsHueLightsManager.scheduleCircadianLights(wakeDateComponents, wakeUpTransitionTime: 60,
                    sunDownStartTime: sundownDateComponents,
                    sunDownTransitionTime: 100,
                    bedTime: bedTimeDateComponents)
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
                expect(mockHueService.receivedMins).to(contain(15))
                expect(mockHueService.receivedSeconds).to(contain(5))
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
