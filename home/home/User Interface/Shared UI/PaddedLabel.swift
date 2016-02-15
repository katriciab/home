//
//  PaddedView.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-06.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class PaddedLabel : UILabel {
    
    private var currentInset : UIEdgeInsets!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    init(frame:CGRect, padding : UIEdgeInsets) {
        let newWidth = frame.width + padding.left + padding.right
        let newHeight = frame.height + padding.top + padding.bottom
        let newX = frame.origin.x + ((padding.left + padding.right) / 2)
        let newY = frame.origin.y + ((padding.top + padding.bottom) / 2)
        let newOrigin = CGPoint(x: newX, y:newY)
        let newRect = CGRect(origin: newOrigin, size: CGSize(width:newWidth, height: newHeight));
        super.init(frame: newRect)
        self.currentInset = padding
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, self.currentInset))
    }
}
