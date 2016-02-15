//
//  AppDelegate.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-30.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import CoreData
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController!
    var philipsHueConnection : PhilipsHueConnection!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //        NSLog("Available fonts: %@", UIFont.familyNames());
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        self.navigationController = Injector.container.resolve(RootNavigationController.self)!
        self.navigationController.setViewControllers([HomeViewController.create()], animated: false)
        
        self.philipsHueConnection = Injector.container.resolve(PhilipsHueConnection.self)
        
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        if let connection = self.philipsHueConnection {
            connection.disableLocalHeartbeat()
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        if let connection = self.philipsHueConnection {
            connection.renableLocalHeartbeat()
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        Injector.container.resolve(PHHueSDK.self)?.stopSDK()
    }
}