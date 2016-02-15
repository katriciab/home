//
//  HomeViewController.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-01.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Swinject

class HomeViewController: UIViewController, HasLoadingView, PHConnectionDelegate, SelectBridgeDelegate {
    
    var philipsHueConnection : PhilipsHueConnection?
    var notificationPresenter : NotificationPresenter?
    
    static func create() -> HomeViewController {
        let sb = SwinjectStoryboard.create(name: "Main", bundle: nil, container: Injector.container)
        return sb.instantiateViewControllerWithIdentifier(self.nameOfClass) as! HomeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.philipsHueConnection!.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadingView() -> LoadingView? {
        return (self.view as? HomeView)?.loadingView
    }
    
    // MARK: IBActions
    @IBAction func lightsButtonTapped(sender: AnyObject) {
        self.philipsHueConnection?.enableLocalHeartbeat()
    }
    
    // MARK: PHConnectonDelegate
    func askForPushLink(session: PushLinkSession) {
        print("Home - ask for pushlink")
        let pushLinkViewController = PushLinkViewController.create()
        pushLinkViewController.setupWithSession(session)
        self.presentViewController(pushLinkViewController, animated: true, completion: nil)
    }
    
    func authenticating() {
        print("Home - authenticating")
        self.startLoading()
    }
    
    func bridgeSearchCompleted(bridges: [NSObject : AnyObject]) {
        print("Home - bridge search completion")
        let selectBridgeViewController = SelectBridgeViewController.create()
        selectBridgeViewController.delegate = self
        selectBridgeViewController.setupWithBridges(bridges)
        self.pushViewController(selectBridgeViewController, animated: true)
    }
    
    func authenticated() {
        print("Home - authenticated")
        self.stopLoading()
        let circadianViewController = CircadianViewController.create()
        self.pushViewController(circadianViewController, animated: true)
    }
    
    func connectionFailed() {
        print("Home - connection failed")
        self.stopLoading()
    }
    
    // MARK: SelectBridgeDelegate
    func selectedBridgeWithId(id: String, ipAddress: String) {
        self.philipsHueConnection?.useBridgeWithId(id, ipAddress: ipAddress)
    }
    
    // MARK: View Controller Navigation
    override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if let presenter = self.notificationPresenter {
            presenter.hideNotifications( {() -> Void in
                super.presentViewController(viewControllerToPresent, animated: flag, completion: completion);
            })
        } else {
            super.presentViewController(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    func pushViewController(viewControllerToPush: UIViewController, animated flag: Bool) {
        if let presenter = self.notificationPresenter {
            presenter.hideNotifications( {() -> Void in
                self.navigationController?.pushViewController(viewControllerToPush, animated: true)
            })
        } else {
            self.navigationController?.pushViewController(viewControllerToPush, animated: true)
        }
    }
}
