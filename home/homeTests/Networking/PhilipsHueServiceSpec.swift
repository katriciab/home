//
//  PhilipsHueServiceSpec.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-13.
//  Copyright © 2016 Katricia. All rights reserved.
//

import Quick
import Nimble

@testable import home

class PhilipsHueServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("when scheduling recurring alarm for time, light color and transition time") {
            let subject = TestInjector.container.resolve(HueService.self, name:"test") as! PhilipsHueService
            let networkClientMock = subject.networkClient as! MockNetworkClient
            
            var parameters = [String: AnyObject]()
            var command = [String: AnyObject]()
            var body = [String: AnyObject]()
            
            beforeEach {
                subject.scheduleDailyRecurringAlarmForHours(0,
                    mins: 0,
                    seconds: 0,
                    forColor: UIColor.redColor(),
                    brightness:200,
                    transitionTime: 5)
                
                parameters = networkClientMock.receivedParameters
                command = parameters["command"] as! Dictionary<String, AnyObject>
                body = command["body"] as! Dictionary<String, AnyObject>
            }
            
            it("should send request over network") {
                expect(networkClientMock.didReceivePost).to(beTrue())
            }
            
            it("should set schedule for everyday at hour, min and seconds provided") {
                expect(networkClientMock.receivedParameters["localtime"] as? String).to(equal("W127/T00:00:00"))
            }
            
            it("should send light xy color information for light bulb model") {
                let light = PHUtilities.calculateXY(UIColor.redColor(), forModel: "LCT007")
                expect(body["xy"] as? [CGFloat]).to(equal([CGFloat(light.x), CGFloat(light.y)]))
            }
            
            it("should set transition time in milliseconds") {
                expect(body["transitiontime"] as? Int).to(equal(50))
            }
        }
    }
}
