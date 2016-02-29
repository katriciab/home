//
//  MockHomeUserDefaultSettings.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-28.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

@testable import home

class MockHomeUserDefaultSettings: UserDefaultSettings {

    var didReceiveSaveScheduleIds = false
    func saveScheduleIds(ids: Set<String>) {
        didReceiveSaveScheduleIds = true
    }
    
    var didReceiveGetScheduleIds = false
    var returnedScheduleIds = Set<String>()
    func getScheduleIds() -> Set<String>? {
        didReceiveGetScheduleIds = true
        return returnedScheduleIds
    }
}
