//
//  RootNavigationController.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-11.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class RootNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UIStyler.styleNavigationController(self)
    }
}
