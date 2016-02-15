//
//  PhilipsHuePushlinkAuthenticator.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-31.
//  Copyright © 2016 Katricia. All rights reserved.
//

import Foundation

enum PHPushLinkErrorType : ErrorType {
    case TimeLimitReached
    case NoConnection
    case NoLocalBridgeFound
}

protocol PHPushLinkDelegate {
    func linkSuccess()
    func linkFailure(error: PHPushLinkErrorType)
}

struct PushLinkKeys {
    static let PushLinkProgressNotification = "PushLinkProgressNotification"
    static let PushLinkProgressValue = "PushLinkProgressValue"
}

class PushLinkSession {
}

class PhilipsHuePushlinkAuthenticator {
    
    var delegate : PHPushLinkDelegate?
    var session : PushLinkSession?
    let phHueSDK : PHHueSDK
    let phNotificationManager : PHNotificationManager
    
    init(phHueSDK : PHHueSDK, phNotificationManager : PHNotificationManager) {
            self.phHueSDK = phHueSDK
            self.phNotificationManager = phNotificationManager
            
            self.phNotificationManager.registerObject(self, withSelector:"authenticationSuccess:", forNotification:PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION)
            
            self.phNotificationManager.registerObject(self, withSelector:"authenticationFailed:", forNotification:PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION)
            
            self.phNotificationManager.registerObject(self, withSelector:"noLocalConnection:", forNotification:PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION)
            
            self.phNotificationManager.registerObject(self, withSelector:"noLocalBridge:", forNotification:PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION)
            
            self.phNotificationManager.registerObject(self, withSelector:"buttonNotPressed:", forNotification:PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION)
    }
    
    func startPushLinking(session: PushLinkSession) {
        self.session = session
        self.phHueSDK.startPushlinkAuthentication();
    }
    
    @objc func authenticationSuccess(notification: NSNotification) {
        print("Pushlink success!")
        self.delegate?.linkSuccess()
    }
    
    @objc func authenticationFailed(notification: NSNotification) {
        self.delegate?.linkFailure(.TimeLimitReached)
    }
    
    @objc func noLocalConnection(notification: NSNotification) {
        self.delegate?.linkFailure(.NoConnection)
    }
    
    @objc func noLocalBridge(notification: NSNotification) {
        self.delegate?.linkFailure(.NoLocalBridgeFound)
    }
    
    @objc func buttonNotPressed(notification: NSNotification) {
        if let percentage = notification.userInfo?["progressPercentage"] {
            print("Button not yet pressed with percentage of \(percentage)")
            NSNotificationCenter.defaultCenter().postNotificationName(PushLinkKeys.PushLinkProgressNotification,
                object: self.session,
                userInfo:[PushLinkKeys.PushLinkProgressValue : percentage])
        }
    }
}