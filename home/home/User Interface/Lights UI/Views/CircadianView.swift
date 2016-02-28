//
//  CircadianView.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-31.
//  Copyright © 2016 Katricia. All rights reserved.
//

import Foundation

class CircadianView : UIView {
    
    @IBOutlet weak var lightFluctuationGraph: LightFluctuationGraph!
    @IBOutlet weak var expandedCircleView: ExpandingCircleBedTimeView!
    @IBOutlet weak var sundownBackground: UIView!
    @IBOutlet weak var bedTimeBackground: UIView!
    
    @IBOutlet weak var sunDownTimeContainer: UIView!
    @IBOutlet weak var sunDownTimeLabel: UIButton!

    @IBOutlet weak var wakeUpTimeContainer: UIView!
    @IBOutlet weak var wakeUpTimeLabel: UIButton!
    @IBOutlet weak var wakeUpLineView: UIView!
    
    override func awakeFromNib() {
        self.sundownBackground.backgroundColor = ColorPalette.sundownBlue()
        self.bedTimeBackground.backgroundColor = ColorPalette.bedtimeBlue()
    }
    
    func bedTime() {
        UIView.animateWithDuration(1.0, animations: { [unowned self] () -> Void in
            let oldSundownFrame = self.sunDownTimeContainer.frame
            self.sunDownTimeContainer.frame = CGRect(x: oldSundownFrame.origin.x,
                y: oldSundownFrame.origin.y - 100,
                width: oldSundownFrame.size.width,
                height: CGFloat(self.sunDownTimeLabel.frame.size.height))
            
            let oldWakeContainerFrame = self.wakeUpTimeContainer.frame
            self.wakeUpTimeContainer.frame = CGRect(x: oldWakeContainerFrame.origin.x,
                y: oldWakeContainerFrame.origin.y + 100,
                width: oldWakeContainerFrame.size.width,
                height: oldWakeContainerFrame.size.height)
            
            let lineFrame = self.wakeUpLineView.frame
            self.wakeUpLineView.frame = CGRect(x: lineFrame.origin.x,
                y: lineFrame.origin.y + 150,
                width: lineFrame.size.width,
                height: CGFloat(0))
            self.wakeUpTimeContainer.alpha = 0
            self.sunDownTimeContainer.alpha = 0
            }) { finished in
                self.wakeUpTimeContainer.hidden = true
                self.sunDownTimeContainer.hidden = true
        }
        
        self.lightFluctuationGraph.hideDot()
        self.bedTimeBackground.hidden = false;
        self.expandedCircleView.expand()
        self.expandedCircleView.userInteractionEnabled = true
    }
}