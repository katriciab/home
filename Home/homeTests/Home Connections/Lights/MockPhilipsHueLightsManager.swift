//
//  MockPhilipsHueLightsManager.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-28.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import FutureKit

@testable import home

class MockPhilipsHueLightsManager: HueLightsManager {
    
    var didReceiveSyncLightColorToTimeOfDay = false
    func syncLightColorToTimeOfDay() {
        didReceiveSyncLightColorToTimeOfDay = true
    }
    
    var didReceiveTurnOffLights = false
    func turnOffLights() {
        didReceiveTurnOffLights = true
    }
    
    var didReceiveScheduleCircadianLights = false
    var returnedScheduleIds = Set<String>(["1", "2", "3"])
    func scheduleCircadianLights(wakeUpTransitionTime wakeUpTransitionTime: NSTimeInterval, sunDownTransitionTime: NSTimeInterval, bedTimeTransitionTime: NSTimeInterval) -> Future<AnyObject> {
        didReceiveScheduleCircadianLights = true
        let p = Promise<AnyObject>()
        p.completeWithSuccess(returnedScheduleIds)
        return p.future
    }
}
