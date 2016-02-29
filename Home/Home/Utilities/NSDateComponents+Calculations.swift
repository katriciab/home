//
//  NSDateComponents+Calculations.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-27.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

extension NSDateComponents {
    
    class func midnight() -> NSDateComponents {
        let midnight = NSDateComponents()
        midnight.hour = 0
        midnight.minute = 0
        midnight.second = 0
        return midnight
    }
    
    func isTimeLessThan(otherTime: NSDateComponents) -> Bool {
//        print("Time: \(self.hour), \(self.minute), \(self.second)")
//        print("Other time: \(otherTime.hour), \(otherTime.minute), \(otherTime.second)\n---\n")
        
        if self.hour < otherTime.hour {
            return true
        } else if self.hour == otherTime.hour {
            if self.minute < otherTime.minute {
                return true
            } else if self.minute == otherTime.minute {
                if self.second < otherTime.second {
                    return true
                } else if self.second == otherTime.second {
                    return true
                }
            }
        }
        return false
    }
    
    func updateWithDefaultDate(isSameDay: Bool) {
        if isSameDay {
            self.day = 1
        } else {
            self.day = 2
        }
        self.month = 1
        self.year = 2000
    }
}
