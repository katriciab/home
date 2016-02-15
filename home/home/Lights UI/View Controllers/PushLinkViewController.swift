//
//  PushLinkViewController.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-31.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Swinject

class PushLinkViewController: UIViewController {
    
    var session : PushLinkSession!
    
    static func create() -> PushLinkViewController {
        let sb = SwinjectStoryboard.create(name: "Main", bundle: nil, container: Injector.container)
        return sb.instantiateViewControllerWithIdentifier(self.nameOfClass) as! PushLinkViewController
    }
    
    func setupWithSession(session : PushLinkSession) {
        self.session = session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "pushLinkProgressUpdated:",
            name: PushLinkKeys.PushLinkProgressNotification,
            object: self.session)
        self.pushLinkView().startLoading()
    }
    
    func pushLinkView() -> PushLinkView {
        return self.view as! PushLinkView
    }
    
    func pushLinkProgressUpdated(notification: NSNotification) {
        if let progress = notification.userInfo![PushLinkKeys.PushLinkProgressValue] {
            let number = progress as! NSNumber
            self.pushLinkView().loadingView()?.updateProgress(number.doubleValue)
        }
    }
}
