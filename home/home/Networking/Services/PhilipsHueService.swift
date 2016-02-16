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

class PhilipsHueService {
    var networkClient : Networking
    var philipsHueConnection : PhilipsHueConnection
    var philipsHueCacheWrapper : CacheWrapper
    
    init(networking: Networking, philipsHueConnection: PhilipsHueConnection, philipsHueCacheWrapper: CacheWrapper) {
        self.networkClient = networking
        self.philipsHueConnection = philipsHueConnection
        self.philipsHueCacheWrapper = philipsHueCacheWrapper
    }
    
    func scheduleDailyRecurringAlarmForTime(time: NSDate, timeZone: NSTimeZone, lightColor: UIColor, transitionTime: Int) {
        let calendar = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)
        calendar?.timeZone = timeZone
        
        let dateComponents = calendar?.components([.Hour, .Minute, .Second], fromDate:time)
        if let components = dateComponents {
            setScheduleForColor(lightColor,
                transitionTimeInMs: transitionTime,
                hours: components.hour,
                mins: components.minute,
                seconds: components.second)
        } else {
            print("Error: Failed to schedule alarm because components do not exist.")
        }
    }
    
    private func setScheduleForColor(forColor: UIColor, transitionTimeInMs: Int, hours: Int, mins: Int, seconds: Int) {
        let hue = forColor.toHSLAComponents().h * 65535.0
        if let ipAddress = self.philipsHueCacheWrapper.getBridgeInformation().ipAddress,
            username = self.philipsHueCacheWrapper.getBridgeInformation().username {
                
                let urlString = String(format: "http://%@/api/%@/schedules", ipAddress, username)
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
                        "body" : [
                            "hue" : hue,
                            "on" : true,
                            "bri" : 200,
                            "transitiontime" : transitionTimeInMs
                        ]
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
