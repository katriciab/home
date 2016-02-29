//
//  LightFluctuationGraph.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-31.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

protocol LightFluctuationGraphDelegate {
    func startBedTimeAnimation()
    func updateBottomTimeLabelToBedtime()
}

enum AnimationState {
    case AnimateTopOnly
    case AnimateBottom(Int)
    case AnimateBedtime(Int)
}

@IBDesignable
class LightFluctuationGraph: UIView {
    
    var delegate : LightFluctuationGraphDelegate?
    
    private var lineWidth = CGFloat(2.0)
    private var outerMargin = 50.0
    private var lineStrokeColor = UIColor.whiteColor()
    
    var wakeTimeColor : UIColor?
    var bedTimeColor : UIColor?
    
    private var dotSize = 14.0;
    private var dotLayer : CAShapeLayer!
    var animationState = AnimationState.AnimateTopOnly
    
    private var centerOrigin : CGPoint {
        get {
            return CGPoint(x: self.frame.width/2.0, y:self.frame.height/2.0)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        
        if (self.wakeTimeColor == nil) {
            self.wakeTimeColor = ColorPalette.halogen()
        }
        
        let sunPath = getSunPath()
        self.lineStrokeColor.setStroke()
        sunPath.lineWidth = self.lineWidth
        self.wakeTimeColor?.setFill()
        sunPath.stroke()
        sunPath.fill()
        
        if (self.bedTimeColor == nil) {
            self.bedTimeColor = ColorPalette.tungsten()
        }
        
        let moonPath = getMoonPath()
        self.lineStrokeColor.setStroke()
        moonPath.lineWidth = self.lineWidth
        self.bedTimeColor?.setFill()
        moonPath.stroke()
        moonPath.fill()
    }
    
    func getDotLayer() -> CAShapeLayer {
        if self.dotLayer == nil {
            self.dotLayer = CAShapeLayer()
            
            let dotSize = CGFloat(self.dotSize)
            self.dotLayer.path = UIBezierPath(roundedRect: CGRect(x:0 - (dotSize/2),
                y:0 - (dotSize/2),
                width:dotSize,
                height:dotSize),
                cornerRadius:(dotSize/2)).CGPath
            self.dotLayer!.fillColor = UIColor.whiteColor().CGColor
            
            return self.dotLayer
        } else {
            return self.dotLayer
        }
    }
    
    func hideDot() {
        self.dotLayer.removeFromSuperlayer()
    }
    
    // MARK: Animate Dot
    func addAnimationToDotLayer(animation: CAAnimation) {
        if (self.dotLayer == nil) {
            self.dotLayer = getDotLayer()
            self.layer.addSublayer(self.dotLayer)
        }
        self.dotLayer.addAnimation(animation, forKey: "underAnimation")
    }
    
    func animateDotToTime(time: NSDateComponents, utility: CircadianLightForTimeUtility) {
        let calculator = CircularTimeToAngleCalculator()
        let angle = calculator.angleForCurrentTime(time, withWakeTime: utility.wakeComponents, withSundownTime: utility.sundownComponents, withBedTime: utility.bedtimeComponents)
        
        var path = getSunPath()
        if angle == 360 {
            self.animationState = .AnimateBedtime(360)
        } else if angle > 180 {
            self.animationState = .AnimateBottom(Int(angle) - 180)
        }  else {
            self.animationState = .AnimateTopOnly
            path = getArcPath(180, endAngle: Int(180 + angle).degreesToRadians)()
        }
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position");
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.duration = 1.0;
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.removedOnCompletion = false
        pathAnimation.path = path.CGPath;
        pathAnimation.delegate = self
        addAnimationToDotLayer(pathAnimation)
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        switch self.animationState {
        case .AnimateBottom(let belowAngle):
            let path = getArcPath(0, endAngle: belowAngle.degreesToRadians)()
            let pathAnimation = CAKeyframeAnimation(keyPath: "position");
            pathAnimation.calculationMode = kCAAnimationPaced;
            pathAnimation.duration = 0.5;
            pathAnimation.fillMode = kCAFillModeForwards
            pathAnimation.removedOnCompletion = false
            pathAnimation.path = path.CGPath;
            addAnimationToDotLayer(pathAnimation)
            self.delegate?.updateBottomTimeLabelToBedtime()
            break;
        case .AnimateBedtime(let angleLeft):
            if angleLeft - 180 > 0 {
                self.animationState = .AnimateBedtime(angleLeft - 180)
                let path = getMoonPath()
                let pathAnimation = CAKeyframeAnimation(keyPath: "position");
                pathAnimation.calculationMode = kCAAnimationPaced;
                pathAnimation.duration = 0.8;
                pathAnimation.fillMode = kCAFillModeForwards
                pathAnimation.removedOnCompletion = false
                pathAnimation.path = path.CGPath;
                pathAnimation.delegate = self
                addAnimationToDotLayer(pathAnimation)
                self.delegate?.updateBottomTimeLabelToBedtime()
            } else {
                self.delegate?.startBedTimeAnimation()
            }
            break;
        case .AnimateTopOnly:
            break;
        }
    }
    
    // MARK: Bezier Paths
    func getSunPath() -> UIBezierPath {
        let sunPath = getArcPath(180.degreesToRadians, endAngle: 0)
        return sunPath()
    }
    
    func getMoonPath() -> UIBezierPath {
        let moonPath = getArcPath(0, endAngle: 180.degreesToRadians)
        return moonPath()
    }
    
    func getFullPath() -> UIBezierPath {
        let path = getArcPath(180.degreesToRadians, endAngle: 0.degreesToRadians)
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