//
//  UIStyler.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-07.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class UIStyler {
    class func styleNavigationController(navigationController : UINavigationController) {
        navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.translucent = true
        navigationController.view.backgroundColor = UIColor.clearColor()
        navigationController.navigationBar.tintColor = UIColor.whiteColor()
    }
}
