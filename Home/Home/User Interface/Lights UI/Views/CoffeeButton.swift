//
//  CoffeeButton.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-28.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class CoffeeButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorPalette.sundownBlue().colorWithAlphaComponent(0.5)
        self.layer.cornerRadius = self.bounds.height / 2
    }
}
