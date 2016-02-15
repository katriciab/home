//
//  UIColor+PhilipsHue.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-31.
//  Copyright © 2016 Katricia. All rights reserved.
//

import Foundation

extension UIColor {
    
    func phXYLightState(modelNumber: String?) -> PHLightState {
        let xy = PHUtilities.calculateXY(self, forModel:modelNumber)
        let newLightState = PHLightState()
        newLightState.x = xy.x
        newLightState.y = xy.y
        return newLightState
    }
}