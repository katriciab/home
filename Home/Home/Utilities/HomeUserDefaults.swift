//
//  HomeUserDefaults.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-28.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

protocol UserDefaultSettings {
    func saveScheduleIds(ids: Set<String>)
    func getScheduleIds() -> Set<String>?
}

class HomeUserDefaultSettings : UserDefaultSettings {
    
    struct Key {
        static let ScheduleIds = "Home_ScheduleIds"
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func saveScheduleIds(ids: Set<String>) {
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(ids), forKey: Key.ScheduleIds)
    }
    
    func getScheduleIds() -> Set<String>? {
        if let data = userDefaults.objectForKey(Key.ScheduleIds) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Set<String>;
        } else {
            return nil
        }
    }
}
