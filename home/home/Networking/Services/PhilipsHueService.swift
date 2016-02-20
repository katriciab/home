//
//  PhilipsHueService.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-12.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

struct AlarmRecurrence : OptionSetType {
    let rawValue : Int
    init(rawValue : Int) {
        self.rawValue = rawValue
    }
    
    static let Monday = AlarmRecurrence(rawValue: 1 << 6)
    static let Tuesday = AlarmRecurrence(rawValue: 1 << 5)
    static let Wednesday = AlarmRecurrence(rawValue: 1 << 4)
    static let Thursday = AlarmRecurrence(rawValue: 1 << 3)
    static let Friday = AlarmRecurrence(rawValue: 1 << 2)
    static let Saturday = AlarmRecurrence(rawValue: 1 << 1)
    static let Sunday = AlarmRecurrence(rawValue: 1 << 0)
    static let Everyday = [AlarmRecurrence.Monday,
        AlarmRecurrence.Tuesday,
        AlarmRecurrence.Wednesday,
        AlarmRecurrence.Thursday,
        AlarmRecurrence.Friday,
        AlarmRecurrence.Saturday,
        AlarmRecurrence.Sunday]
}

protocol HueService {
    func scheduleDailyRecurringAlarmForHours(hours: Int, mins: Int, seconds: Int, forColor: UIColor, brightness: Int, transitionTime: NSTimeInterval)
}

class PhilipsHueService : HueService {
    var networkClient : Networking
    var philipsHueConnection : PhilipsHueConnection
    var philipsHueCacheWrapper : CacheWrapper
    
    init(networking: Networking, philipsHueConnection: PhilipsHueConnection, philipsHueCacheWrapper: CacheWrapper) {
        self.networkClient = networking
        self.philipsHueConnection = philipsHueConnection
        self.philipsHueCacheWrapper = philipsHueCacheWrapper
    }
    
    func scheduleDailyRecurringAlarmForHours(hours: Int, mins: Int, seconds: Int, forColor: UIColor, brightness: Int, transitionTime: NSTimeInterval) {
        let transitionTimeInMs = transitionTime * 100
        let hue = forColor.toHSLAComponents().h * 65535.0
        if let ipAddress = self.philipsHueCacheWrapper.getBridgeInformation().ipAddress,
            username = self.philipsHueCacheWrapper.getBridgeInformation().username {
                
                let urlString = String(format: "http://%@/api/%@/schedules", ipAddress, username)
                
                let body = [
                    "hue" : hue,
                    "on" : true,
                    "bri" : brightness,
                ]
                
                let mutableBody = body.mutableCopy() as! NSMutableDictionary
                
                if transitionTime > 0 {
                    mutableBody["transitiontime"] = NSNumber(double: transitionTimeInMs)
                }
                
                let request = [ "status" : "enabled",
                    "description" : "",
                    "name" : "Circadian",
                    "localtime" : recurringTimeInLocalTime(hours: hours,
                        mins: mins,
                        seconds: seconds,
                        recurrences: AlarmRecurrence.Everyday
                    ),
                    "command" : [
                        "address" : String(format:"/api/%@/groups/0/action", username),
                        "method" : "PUT",
                        "body" : mutableBody
                    ]
                ]
                
                self.networkClient.post(urlString, parameters:request as! [String : AnyObject])
        }
    }
    
    // MARK : Formatting
    private func recurringTimeInLocalTime(hours hours: Int, mins: Int, seconds: Int, recurrences:[AlarmRecurrence]) -> String {
        var mask = 0
        for r in recurrences {
            mask += r.rawValue
        }
        return String(format: "W%03d/T%02d:%02d:%02d", mask, hours, mins, seconds)
    }
}
