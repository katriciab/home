//
//  ColorFadeUtility.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-13.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import DynamicColor

struct ColorFadeUtility {
    
    func colorFade(fromColor fromColor:UIColor, toColor:UIColor, numberOfSteps: Int) -> [UIColor]{
        var arrayOfColors = [UIColor]()
        arrayOfColors.append(fromColor)
        
        for i in 1...numberOfSteps {
            let redDiff = toColor.redComponent - fromColor.redComponent
            let newRed = (CGFloat(i)/CGFloat(numberOfSteps)) * CGFloat(redDiff)
            
            let blueDiff = toColor.blueComponent - fromColor.blueComponent
            let newBlue = (CGFloat(i)/CGFloat(numberOfSteps)) * CGFloat(blueDiff)
            
            let greenDiff = toColor.greenComponent - fromColor.greenComponent
            let newGreen = (CGFloat(i)/CGFloat(numberOfSteps)) * CGFloat(greenDiff)
            
            let newColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
            arrayOfColors.append(newColor)
            print("Red \(arrayOfColors[i].redComponent) Blue \(arrayOfColors[i].blueComponent) ")
        }
        
        return arrayOfColors
    }
}
