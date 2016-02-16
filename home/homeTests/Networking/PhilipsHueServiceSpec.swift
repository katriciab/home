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
            let date = NSDate(timeIntervalSinceReferenceDate:0);
            let subject = TestInjector.container.resolve(PhilipsHueService.self, name:"test")
            let networkClientMock = subject!.networkClient as! MockNetworkClient
            
            var parameters = [String: AnyObject]()
            var command = [String: AnyObject]()
            var body = [String: AnyObject]()
            
            beforeEach {
                let utcTimeZone = NSTimeZone(abbreviation: "UTC")
                subject?.scheduleDailyRecurringAlarmForTime(date, timeZone:utcTimeZone!, lightColor: UIColor.redColor(), transitionTime: 500)
                
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
            
            it("should send light hue color information") {
                expect(body["hue"] as? Double).to(equal(0.0))
            }
            
            it("should set transition time") {
                expect(body["transitiontime"] as? Int).to(equal(500))
            }
        }
    }
}
