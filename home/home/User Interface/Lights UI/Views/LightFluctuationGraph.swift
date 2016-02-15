//
//  LightFluctuationGraph.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-31.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

@IBDesignable
class LightFluctuationGraph: UIView {
    
    var lineWidth = CGFloat(2.0)
    var outerMargin = 50.0
    var lineStrokeColor = UIColor.whiteColor()
    
    var centerOrigin : CGPoint {
        get {
            return CGPoint(x: self.frame.width/2.0, y:self.frame.height/2.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layer = CAShapeLayer()
        let dotSize = CGFloat(14.0);
        layer.path = UIBezierPath(roundedRect: CGRect(x:0 - (dotSize/2), y:0 - (dotSize/2), width:dotSize, height:dotSize), cornerRadius:(dotSize/2)).CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        self.layer.addSublayer(layer)
        
        let path = getFullPath()
        let pathAnimation = CAKeyframeAnimation(keyPath: "position");
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.duration = 4.0;
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.removedOnCompletion = false
        pathAnimation.path = path.CGPath;
        layer.addAnimation(pathAnimation, forKey: "movingAnimation")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        
        let sunPath = getSunPath()
        self.lineStrokeColor.setStroke()
        sunPath.lineWidth = self.lineWidth
        ColorPalette.tungsten().setFill()
        sunPath.stroke()
        sunPath.fill()
        
        let moonPath = getMoonPath()
        self.lineStrokeColor.setStroke()
        moonPath.lineWidth = self.lineWidth
        ColorPalette.candle().setFill()
        moonPath.stroke()
        moonPath.fill()
    }
    
    func getSunPath() -> UIBezierPath {
        let sunPath = getArcPath(180.degreesToRadians, endAngle: 0)
        return sunPath()
    }
    
    func getMoonPath() -> UIBezierPath {
        let moonPath = getArcPath(0, endAngle: 180.degreesToRadians)
        return moonPath()
    }
    
    func getFullPath() -> UIBezierPath {
        let path = getArcPath(0, endAngle: 360.degreesToRadians)
        return path()
    }
    
    func getArcPath(startAngle:CGFloat, endAngle:CGFloat) -> () -> UIBezierPath {
        let closure = { [unowned self] () -> UIBezierPath in
            return UIBezierPath(
                arcCenter: self.centerOrigin,
                radius:(self.frame.size.width - CGFloat(self.outerMargin * 2.0)) / 2,
                startAngle:startAngle,
                endAngle:endAngle,
                clockwise: true)
        }
        return closure;
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}