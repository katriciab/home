//
//  ColorFadeUtilitySpec.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-13.
//  Copyright © 2016 Katricia. All rights reserved.
//

import Quick
import Nimble

@testable import home

class ColorFadeUtilitySpec: QuickSpec {
    override func spec() {
        describe("when asking to color fade from one color to another") {
            let fromColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
            let toColor = UIColor(red: 0, green: 0, blue: 1.0, alpha: 1.0)
            var colorFadeArray : [UIColor]!
            
            context("given a number of steps to take") {
                beforeEach({
                    colorFadeArray = ColorFadeUtility.colorFade(fromColor: fromColor, toColor: toColor, numberOfSteps: 4)
                })
                
                it("should return a list of all the colors in between") {
                    expect(colorFadeArray.count).to(equal(5))
                }
                
                it("should return the to and from color") {
                    expect(colorFadeArray[0]).to(equal(UIColor.redColor()))
                    expect(colorFadeArray[2]).to(equal(UIColor(red: 0, green: 0, blue: 0.5, alpha: 1.0)))
                    expect(colorFadeArray[4]).to(equal(UIColor.blueColor()))
                }
            }
        }
    }
}
