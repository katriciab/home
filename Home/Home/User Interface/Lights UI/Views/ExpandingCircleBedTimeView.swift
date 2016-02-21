//
//  ExpandingCircleBedTimeView.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-20.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class ExpandingCircleBedTimeView: UIButton {
    
    private var outerMargin = 50.0
    private var dotSize = 14.0
    
    private var centerOrigin : CGPoint {
        get {
            return CGPoint(x: self.frame.width/2.0, y:self.frame.height/2.0)
        }
    }
    
    private var startingOrigin : CGPoint {
        get {
            return CGPoint(x: CGFloat(0 + outerMargin), y:self.frame.height/2.0)
        }
    }
    
    func getSmallCirclePath() -> UIBezierPath {
        return UIBezierPath(
            arcCenter: self.startingOrigin,
            radius:CGFloat(self.dotSize / 2),
            startAngle:0,
            endAngle:360,
            clockwise: true)
    }
    
    func getExpandedCirclePath() -> UIBezierPath {
        return UIBezierPath(
            arcCenter: self.centerOrigin,
            radius:(self.frame.size.width - CGFloat(self.outerMargin * 2.0)) / 2,
            startAngle:0,
            endAngle:360,
            clockwise: true)
    }
    
    func getDotLayer() -> CAShapeLayer {
        let dotLayer = CAShapeLayer()
        
        let dotSize = CGFloat(self.dotSize)
        dotLayer.path = UIBezierPath(roundedRect: CGRect(x:0 - (dotSize/2),
            y:0 - (dotSize/2),
            width:dotSize,
            height:dotSize),
            cornerRadius:(dotSize/2)).CGPath
        dotLayer.fillColor = UIColor.whiteColor().CGColor
        
        return dotLayer
    }

    func expand() {
        let colorLayer = CAShapeLayer()
        colorLayer.frame = self.bounds
        colorLayer.backgroundColor = ColorPalette.candle().CGColor

        colorLayer.addSublayer(goodNightTextLayer())
        
        self.layer.addSublayer(colorLayer)
        let expandingDotLayer = getDotLayer();
        expandingDotLayer.fillColor = UIColor.blackColor().CGColor
        colorLayer.mask = expandingDotLayer
        animateExpandingDotLayer(expandingDotLayer)
    }
    
    func animateExpandingDotLayer(expandingDotLayer: CAShapeLayer) {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.delegate = self
        pathAnimation.fromValue = getSmallCirclePath().CGPath
        pathAnimation.toValue = getExpandedCirclePath().CGPath
        pathAnimation.duration = 0.5
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut);
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.removedOnCompletion = false
        expandingDotLayer.path = getSmallCirclePath().CGPath
        expandingDotLayer.addAnimation(pathAnimation, forKey: "pathAnimation")
    }
    
    func goodNightTextLayer() -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: self.bounds.minX, y: self.bounds.maxY / 2 - 25, width: self.bounds.width, height: self.bounds.height)
        textLayer.string = "Good Night."
        let fontName: CFStringRef = "Didot"
        textLayer.font = CTFontCreateWithName(fontName, 50, nil)
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.mainScreen().scale
        textLayer.foregroundColor = UIColor.whiteColor().CGColor
        return textLayer
    }
}
