//
//  LoadingView.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-01.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class RectangleLoadingView: UIView, LoadingView {
    
    var percentage = 0.0
    let loadingTextWidth = CGFloat(100)
    let loadingBlockHeight = CGFloat(50)
    var originalOriginX : CGFloat!
    var originalColorBlockFrame : CGRect!
    
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!
    private var loadingLabel: UILabel!
    private var colorBlock : UIView!
    private var boundingContainer : UIView!
    private var startingPointX : CGFloat {
        get {
            return self.bounds.width - 80
        }
    }
    
    var isLoading : Bool! {
        get {
            return !self.hidden
        }
        
        set(isLoading) {
            self.hidden = !isLoading
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isLoading = false
        self.boundingContainer = UIView()
        self.boundingContainer.frame = CGRect(x: 0,
            y: 0,
            width: self.bounds.width,
            height: self.loadingBlockHeight)
        self.addSubview(self.boundingContainer)
        
        self.colorBlock = UIView();
        self.colorBlock.frame = CGRect(x: self.startingPointX, y: 0, width:self.bounds.width, height:self.loadingBlockHeight)
        self.colorBlock.backgroundColor = UIColor.whiteColor()
        self.boundingContainer.addSubview(self.colorBlock)
        self.originalColorBlockFrame = self.colorBlock.frame
        
        let startingFrame = CGRect(x: self.startingPointX,
            y:0,
            width:self.loadingTextWidth,
            height:self.loadingBlockHeight)
        self.loadingLabel = PaddedLabel(frame:startingFrame,
            padding:UIEdgeInsets(top: 2, left: 20, bottom: 0, right: 0))
        self.loadingLabel.text = "LOADING..."
        self.loadingLabel.font = UIFont(name: "Audrey", size: 14.0)
        self.boundingContainer.addSubview(self.loadingLabel)
        self.originalOriginX = self.loadingLabel.center.x
    }
    
    deinit {
        self.loadingLabel.removeObserver(self, forKeyPath: "center")
    }
    
    func updateProgress(percentage: Double) {
        self.percentage = percentage;
        self.loadingLabel.text = String(format:"WAITING %d %", Int(floor(percentage)))
        self.loadingLabel.setNeedsDisplay()
    }
    
    func animate() {
        if !isLoading {
            self.isLoading = true
            self.animator = UIDynamicAnimator(referenceView:self.boundingContainer)
            self.gravity = UIGravityBehavior(items: [self.loadingLabel])
            self.gravity.gravityDirection = CGVector(dx: -1.0, dy: 0.0)
            
            self.collision = UICollisionBehavior(items: [self.loadingLabel])
            self.collision.translatesReferenceBoundsIntoBoundary = true
            self.animator.addBehavior(self.collision)
            
            let itemBehaviour = UIDynamicItemBehavior(items: [self.loadingLabel])
            itemBehaviour.elasticity = 1.0
            itemBehaviour.friction = 0.0
            self.animator.addBehavior(itemBehaviour)
            
            self.animator.addBehavior(self.gravity)
        }
        
        UIView.animateWithDuration(0.1, animations: {
            self.colorBlock.frame = CGRectOffset(self.originalColorBlockFrame, -self.startingPointX, 0)
        });
    }
    
    func stop() {
        self.isLoading = false;
    }
}
