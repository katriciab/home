//
//  Injector.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-11.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Swinject

public class Injector: NSObject {
    public static let container = Container() { container in
        // Storyboards
        container.registerForStoryboard(HomeViewController.self) { r, c in
            c.philipsHueConnection = r.resolve(PhilipsHueConnection.self)
            c.notificationPresenter = r.resolve(NotificationPresenter.self)
        }
        
        container.registerForStoryboard(PushLinkViewController.self) { r, c in }
        
        container.registerForStoryboard(CircadianViewController.self) { r, c in
            c.hueLightsManager = r.resolve(PhilipsHueLightsManager.self)
        }
        
        container.registerForStoryboard(SelectBridgeViewController.self) { r, c in }
        
        // UI
        container.register(RootNavigationController.self) { _ in RootNavigationController() }
            .inObjectScope(.Container)
        
        container.register(NotificationPresenter.self) { r in
            NotificationPresenter(presenter: r.resolve(RootNavigationController.self)!)
        }
        
        
        // Managers
        container.register(PhilipsHueLightsManager.self) { r in
            PhilipsHueLightsManager(
                philipsHueService: r.resolve(HueService.self)!,
                circadianLightForTimeUtility: r.resolve(CircadianLightForTimeUtility.self)!)
        }
        
        // Networking and Services
        container.register(Networking.self) { _ in
            NetworkClient()
        }
        
        container.register(HueService.self) { r in
            PhilipsHueService(networking: r.resolve(Networking.self)!,
                philipsHueConnection: r.resolve(PhilipsHueConnection.self)!,
                philipsHueCacheWrapper: PhilipsHueCacheWrapper())
        }
        
        // Utilities
        container.register(CircadianLightForTimeUtility.self) { r in
            return CircadianLightForTimeUtility()
        }.inObjectScope(.Container)
        
        // Philips Hue
        container.register(PHHueSDK.self) { _ in
            let sdk = PHHueSDK()
            sdk.enableLogging(true)
            return sdk }
            .inObjectScope(.Container)
        
        container.register(PHNotificationManager.self) { _ in PHNotificationManager.defaultManager() }
        
        container.register(PhilipsHueConnection.self) { r in
            PhilipsHueConnection(notificationPresenter: r.resolve(NotificationPresenter.self)!,
                hueSdk: r.resolve(PHHueSDK.self)!,
                notificationManager: r.resolve(PHNotificationManager.self)!,
                pushLinkAuthenticator: r.resolve(PhilipsHuePushlinkAuthenticator.self)! ) }
            .inObjectScope(.Container)
        
        container.register(PhilipsHuePushlinkAuthenticator.self) { r in
            PhilipsHuePushlinkAuthenticator(phHueSDK: r.resolve(PHHueSDK)!,
                phNotificationManager: PHNotificationManager.defaultManager())
        }
    }
}
