//
//  PhilipsHueLightsManager.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-08.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import DynamicColor
import FutureKit

class PhilipsHueLightsManager {
    
    var hueService : HueService
    var circadianLightForTimeUtility : CircadianLightForTimeUtility
    
    init(philipsHueService: HueService, circadianLightForTimeUtility: CircadianLightForTimeUtility) {
        self.hueService = philipsHueService
        self.circadianLightForTimeUtility = circadianLightForTimeUtility
    }
    
    func turnOffLights() {
        self.hueService.turnOffLights();
    }
    
    func scheduleCircadianLights(wakeUpTransitionTime wakeUpTransitionTime: NSTimeInterval, sunDownTransitionTime: NSTimeInterval, bedTimeTransitionTime: NSTimeInterval) -> Future<AnyObject> {
        let p = Promise<AnyObject>()
        var allSuccessIds = Set<String>()
        
        self.scheduleWakeUp(self.circadianLightForTimeUtility.wakeComponents, wakeUpTransitionTime: wakeUpTransitionTime)
            .onComplete(block: { result in
                switch result {
                case .Success(let wakeIds):
                    allSuccessIds.unionInPlace(wakeIds as! Set<String>)
                    break;
                case .Fail(_):
                    break;
                case .Cancelled:
                    break;
                }
                
                self.scheduleSundown(self.circadianLightForTimeUtility.sundownComponents, sunDownTransitionTime: sunDownTransitionTime)
                    .onComplete(block: { result in
                        switch result {
                        case .Success(let sundownIds):
                            allSuccessIds.unionInPlace(sundownIds as! Set<String>)
                            break;
                        case .Fail(let error):
                            print("Sundown schedule failed: \(error)")
                            break;
                        case .Cancelled:
                            break;
                        }
                        
                        self.scheduleBedTime(self.circadianLightForTimeUtility.bedtimeComponents, bedTimeTransitionTime: bedTimeTransitionTime)
                            .onComplete(block: { result in
                                switch result {
                                case .Success(let bedtimeIds):
                                    allSuccessIds.unionInPlace(bedtimeIds as! Set<String>)
                                    break;
                                case .Fail(let error):
                                    print("Bedtime schedule failed: \(error)")
                                    break;
                                case .Cancelled:
                                    break;
                                }
                                
                                print("Successful list of schedule ids: \(allSuccessIds)")
                                p.completeWithSuccess(allSuccessIds)
                            })
                    })
            })
        return p.future
    }
    
    private func scheduleWakeUp(wakeUpTime: NSDateComponents, wakeUpTransitionTime: NSTimeInterval) -> Future<AnyObject> {
        var wakeSuccessIds = Set<String>()
        let p = Promise<AnyObject>()
        
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        if let calendar = gregorianCalendar {
            let date = calendar.dateFromComponents(wakeUpTime)
            let newDate = date!.dateByAddingTimeInterval(-wakeUpTransitionTime);
            let newComponents = calendar.components([.Hour, .Minute, .Second], fromDate: newDate);
            
            self.hueService.scheduleDailyRecurringAlarmForHours(newComponents.hour,
                mins: newComponents.minute,
                seconds: newComponents.second,
                forColor: self.circadianLightForTimeUtility.colorForTimeOfDay(TimeOfDay.Wake),
                brightness: 5,
                transitionTime: wakeUpTransitionTime)
                .onComplete(block: { result in
                    switch result {
                    case .Success(let success):
                        if let successJson = success["success"] as? [String: AnyObject] {
                            wakeSuccessIds.insert(successJson["id"] as! String)
                        }
                        break;
                    case .Fail(let error):
                        print("Wake up schedule 1 failed: \(error)")
                        break;
                    case .Cancelled:
                        break;
                    }
                    
                    self.hueService.scheduleDailyRecurringAlarmForHours(wakeUpTime.hour,
                        mins: wakeUpTime.minute,
                        seconds: wakeUpTime.second,
                        forColor: self.circadianLightForTimeUtility.colorForTimeOfDay(TimeOfDay.Wake),
                        brightness: 254,
                        transitionTime: wakeUpTransitionTime)
                        .onComplete(block: { result in
                            switch result {
                            case .Success(let success):
                                if let successJson = success["success"] as? [String: AnyObject] {
                                    wakeSuccessIds.insert(successJson["id"] as! String)
                                }
                                break;
                            case .Fail(let error):
                                print("Wake up schedule 2 failed: \(error)")
                                break;
                            case .Cancelled:
                                break;
                            }
                            p.completeWithSuccess(wakeSuccessIds)
                        })
                })
        }
        return p.future
    }
    
    private func scheduleSundown(sunDownStartTime: NSDateComponents, sunDownTransitionTime: NSTimeInterval) -> Future<AnyObject> {
        var sundownIds = Set<String>()
        let p = Promise<AnyObject>()
        self.hueService.scheduleDailyRecurringAlarmForHours(sunDownStartTime.hour,
            mins: sunDownStartTime.minute,
            seconds: sunDownStartTime.second,
            forColor: self.circadianLightForTimeUtility.colorForTimeOfDay(TimeOfDay.AfterSundown),
            brightness: 254,
            transitionTime: sunDownTransitionTime)
            .onSuccess(block: { result in
                if let successJson = result["success"] as? [String: AnyObject] {
                    sundownIds.insert(successJson["id"] as! String)
                }
                p.completeWithSuccess(sundownIds)
            })
        return p.future
    }
    
    private func scheduleBedTime(bedTime: NSDateComponents, bedTimeTransitionTime: NSTimeInterval) -> Future<AnyObject> {
        var bedTimeIds = Set<String>()
        let p = Promise<AnyObject>()
        self.hueService.scheduleDailyRecurringAlarmForHours(bedTime.hour,
            mins: bedTime.minute,
            seconds: bedTime.second,
            forColor: self.circadianLightForTimeUtility.colorForTimeOfDay(TimeOfDay.Bedtime),
            brightness: 100,
            transitionTime: bedTimeTransitionTime)
            .onSuccess(block: { result in
                if let successJson = result["success"] as? [String: AnyObject] {
                    bedTimeIds.insert(successJson["id"] as! String)
                }
                p.completeWithSuccess(bedTimeIds)
            })
        return p.future
    }
    
    func removeAllSchedules() {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        print(cache.schedules.count)
        for (_, schedule) in cache.schedules {
            let bridgeSendAPI = PHBridgeSendAPI()
            let sched = schedule as! PHSchedule
            bridgeSendAPI.removeScheduleWithId(sched.identifier) { (errors: [AnyObject]!) -> Void in
                if errors != nil {
                    print("Did not remove schedule because of error: \(errors)")
                } else {
                    print("Remove schedule")
                }
            }
        }
    }
}
