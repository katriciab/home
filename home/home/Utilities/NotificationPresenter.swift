//
//  NotificationPresenter.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-31.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class NotificationPresenter: NSObject {
    
    let presenter : UIViewController
    
    init(presenter : UIViewController) {
        self.presenter = presenter
    }
    
    func showInformationalAlert(title title : String, message : String) {
        self.presenter.dismissViewControllerAnimated(true, completion: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { [unowned self] (action: UIAlertAction) -> Void in
            self.presenter.dismissViewControllerAnimated(true, completion: nil);
        }
        
        alertController.addAction(OKAction)
        self.presenter.presentViewController(alertController, animated: true, completion:nil)
    }
    
    func hideNotifications(completion : () -> Void) {
        if (self.presenter.presentedViewController == nil) {
            completion()
        } else {
            self.presenter.dismissViewControllerAnimated(true) { () -> Void in
                completion()
            }
        }
    }
}
