//
//  UIViewContoller+BackButton.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-22.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

public extension UIViewController {

    @IBAction func backButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
