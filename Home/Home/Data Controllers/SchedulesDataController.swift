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
    var hueLightsManager : HueLightsManager!
    var hueCacheWrapper : CacheWrapper!
    var schedulesIds : Set<String>!
    var userDefaults : UserDefaultSettings
    
    init(philipsHueLightsManager: HueLightsManager,
        philipsHueCacheWrapper: CacheWrapper,
        userDefaults: UserDefaultSettings) {
            self.hueLightsManager = philipsHueLightsManager
            self.hueCacheWrapper = philipsHueCacheWrapper
            self.userDefaults = userDefaults
    }
    
    func setCircadianLightSchedules() -> Future<AnyObject> {
        let p = Promise<AnyObject>()
        self.hueLightsManager?.scheduleCircadianLights(
            wakeUpTransitionTime: 60,
            sunDownTransitionTime: 60,
            bedTimeTransitionTime: 60)
            .onSuccess(block: { results in
                self.schedulesIds = results as? Set<String>
                self.userDefaults.saveScheduleIds(self.schedulesIds)
                p.completeWithSuccess(results)
            })
            .onFail(block: { error in
                p.completeWithFail(error)
            })
        
        return p.future
    }
    
    func isCircadianLightSchedulesSet() -> Bool {
        if let schedulesIds = self.userDefaults.getScheduleIds() {
            let bridgeSchedules = self.hueCacheWrapper.getAllSchedules()
            var schedulesStillExist = true
            for scheduleId in schedulesIds {
                if(!bridgeSchedules.contains(scheduleId)) {
                    schedulesStillExist = false
                    break;
                }
            }
            return schedulesStillExist
        } else {
            return false
        }
    }
}
