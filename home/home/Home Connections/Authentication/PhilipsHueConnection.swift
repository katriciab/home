//
//  PhilipsHueConnection.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-31.
//  Copyright © 2016 Katricia. All rights reserved.
//

import Foundation

enum HueConnectionState {
    case NotConnected
    case AskForPushlink
    case Authenticating
    case Authenticated
}

protocol PHConnectionDelegate {
    func bridgeSearchCompleted(bridges : [NSObject : AnyObject])
    func askForPushLink(session : PushLinkSession)
    func authenticating()
    func authenticated()
    func connectionFailed()
}

class PhilipsHueConnection : PHPushLinkDelegate {
    
    var delegate : PHConnectionDelegate?
    private let phHueSDK : PHHueSDK
    private let phNotificationManager : PHNotificationManager
    private let pushLinkAuthenticator : PhilipsHuePushlinkAuthenticator
    private let notificationPresenter : NotificationPresenter
    
    init(notificationPresenter : NotificationPresenter,
        hueSdk : PHHueSDK,
        notificationManager : PHNotificationManager,
        pushLinkAuthenticator : PhilipsHuePushlinkAuthenticator) {
        self.notificationPresenter = notificationPresenter;
        self.connectionState = .NotConnected
        
        self.phHueSDK = hueSdk;
        self.phHueSDK.startUpSDK()
        
        self.phNotificationManager = notificationManager
        self.pushLinkAuthenticator = pushLinkAuthenticator
        self.pushLinkAuthenticator.delegate = self
        
        self.phNotificationManager.registerObject(self, withSelector:"localConnectionMade:", forNotification: LOCAL_CONNECTION_NOTIFICATION)
        self.phNotificationManager.registerObject(self, withSelector:"noLocalConnectionMade:", forNotification: NO_LOCAL_CONNECTION_NOTIFICATION)
        self.phNotificationManager.registerObject(self, withSelector:"notAuthenticated:", forNotification: NO_LOCAL_AUTHENTICATION_NOTIFICATION)
    }
    
    func enableLocalHeartbeat() {
        self.connectionState = .Authenticating
        if (self.cacheHasBridgeIPAddress()) {
            // Enable heartbeat with interval of 10 seconds
            self.phHueSDK.enableLocalConnection()
        } else {
            self.searchForLocalBridge()
        }
    }
    
    func renableLocalHeartbeat() {
        if (self.cacheHasBridgeIPAddress()) {
            // Enable heartbeat with interval of 10 seconds
            self.phHueSDK.enableLocalConnection()
        }
    }
    
    func disableLocalHeartbeat() {
        self.phHueSDK.disableLocalConnection()
    }
    
    func useBridgeWithId(bridgeId : String, ipAddress : String) {
        self.phHueSDK.setBridgeToUseWithId(bridgeId, ipAddress: ipAddress)
        self.enableLocalHeartbeat()
    }
    
    // MARK: Private
    private func searchForLocalBridge() {
        self.disableLocalHeartbeat()
        
        let bridgeSearch = PHBridgeSearching(upnpSearch: true,
            andPortalSearch: true,
            andIpAdressSearch: true)
        bridgeSearch.startSearchWithCompletionHandler { (bridgesFound :[NSObject : AnyObject]!) -> Void in
            print("Hue -> FOUND \(bridgesFound.count) BRIDGES")
            
            if (bridgesFound.count > 0) {
                self.delegate?.bridgeSearchCompleted(bridgesFound)
            } else {
                self.connectionState = .NotConnected
                print("Hue -> NO BRIDGES FOUND")
                self.notificationPresenter.showInformationalAlert(title: "Bridge Searching", message: "No bridges have been found!")
            }
        }
    }
    
    // MARK: Connection State
    private(set) var connectionState : HueConnectionState = .NotConnected {
        didSet {
            if oldValue != connectionState {
                if connectionState == .Authenticated {
                    self.delegate?.authenticated()
                } else if connectionState == .Authenticating {
                    self.delegate?.authenticating()
                } else if connectionState == .NotConnected {
                    self.delegate?.connectionFailed()
                }
            }
        }
    }
    
    // MARK: PHPushLinkDelegate
    func linkSuccess() {
        self.connectionState = .Authenticated
        self.enableLocalHeartbeat()
    }
    
    func linkFailure(error: PHPushLinkErrorType) {
        self.connectionState = .NotConnected
        self.notificationPresenter.showInformationalAlert(title: "Push link failed!", message: "Something went wrong with your push linking")
    }
    
    // MARK: PH Notification Manager
    @objc private func localConnectionMade(notification: NSNotification) {
        if (self.phHueSDK.localConnected()) {
            print("Hue -> Connection made")
            self.connectionState = .Authenticated
        } else {
            print("Hue -> No connection")
            self.connectionState = .NotConnected
            self.notificationPresenter.showInformationalAlert(title: "No Connection", message: "The connection to the bridge is lost")
            self.phHueSDK.stopSDK()
        }
    }
    
    @objc private func noLocalConnectionMade(notification: NSNotification) {
        print("Hue -> No connection")
        if (!self.phHueSDK.localConnected()) {
            self.connectionState = .NotConnected
            self.notificationPresenter.showInformationalAlert(title: "No Connection", message: "The connection to the bridge is lost")
        }
    }
    
    @objc private func notAuthenticated(notification: NSNotification) {
        // We are not authenticated so we start the authentication process
        print("Hue -> Not authenticated, but auth start process")
        self.connectionState = .AskForPushlink
        self.disableLocalHeartbeat()
        let pushLinkSession = PushLinkSession()
        self.pushLinkAuthenticator.startPushLinking(pushLinkSession)
        self.delegate?.askForPushLink(pushLinkSession)
    }
    
    // MARK: Cache Helpers
    private func cacheHasBridgeIPAddress ()-> Bool {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        return cache != nil && cache.bridgeConfiguration != nil && cache.bridgeConfiguration.ipaddress != nil
    }
}