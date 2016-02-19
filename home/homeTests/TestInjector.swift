//
//  TestInjector.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-13.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Swinject

@testable import home

class TestInjector {
    static let container = Container(parent:Injector.container) { container in
        
        // Services
        container.register(HueService.self, name: "test") { r in
            PhilipsHueService(networking: r.resolve(Networking.self, name: "mock")!,
                philipsHueConnection: r.resolve(PhilipsHueConnection.self)!,
                philipsHueCacheWrapper: MockPhilipsHueCacheWrapper())
            
        }
        
        // Networking
        container.register(Networking.self, name: "mock") { _ in MockNetworkClient() }
    }
}
