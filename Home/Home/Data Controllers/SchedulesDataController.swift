//
//  SchedulesDataController.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-28.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import FutureKit

class SchedulesDataController {
    var hueLightsManager : PhilipsHueLightsManager!
    var schedulesIds : Set<String>!
    
    init(philipsHueLightsManager: PhilipsHueLightsManager) {
        self.hueLightsManager = philipsHueLightsManager
        self.schedulesIds = Set<String>() // TODO get from cache
    }
    
    func setCircadianLightSchedules() -> Future<AnyObject> {
        let p = Promise<AnyObject>()
        self.hueLightsManager?.scheduleCircadianLights(
            wakeUpTransitionTime: 60,
            sunDownTransitionTime: 60,
            bedTimeTransitionTime: 60)
            .onSuccess(block: { results in
                self.schedulesIds = results as? Set<String> // TODO add to cache
                p.completeWithSuccess(results)
            })
            .onFail(block: { error in
                p.completeWithFail(error)
            })
        
        return p.future
    }
    
    func isCircadianLightSchedulesSet() -> Bool {
        return self.schedulesIds.count > 0
    }
}
