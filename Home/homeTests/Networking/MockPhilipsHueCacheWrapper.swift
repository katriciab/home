//
//  MockPhilipsHueCacheWrapper.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-15.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

@testable import home

class MockPhilipsHueCacheWrapper: CacheWrapper {
    
    var didReceiveGetBridgeInformation = false;
    func getBridgeInformation() -> (username: String?, ipAddress: String?) {
        self.didReceiveGetBridgeInformation = true
        return ("Fake Username", "Fake IP Address")
    }
}
