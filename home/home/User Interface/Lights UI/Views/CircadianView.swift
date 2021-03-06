//
//  CircadianView.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-31.
//  Copyright © 2016 Katricia. All rights reserved.
//

import Foundation

enum BottomActionState {
    case Schedule
    case Sync
}

class CircadianView : UIView {
    
    @IBOutlet weak var lightFluctuationGraph: LightFluctuationGraph!
    @IBOutlet weak var expandedCircleView: ExpandingCircleBedTimeView!
    @IBOutlet weak var sundownBackground: UIView!
    @IBOutlet weak var bedTimeBackground: UIView!
    
    @IBOutlet weak var sunDownTimeContainer: UIView!
    @IBOutlet weak var sunDownTimeView: TimeView!
    
    @IBOutlet weak var wakeUpTimeContainer: UIView!
    @IBOutlet weak var wakeUpLineView: UIView!
    @IBOutlet weak var wakeUpTimeView: TimeView!
    
    @IBOutlet weak var bottomActionButton: UIButton!
    @IBOutlet weak var coffee: CoffeeButton!
    
    var bottomActionState = BottomActionState.Schedule
    
    override func awakeFromNib() {
        self.sundownBackground.backgroundColor = ColorPalette.sundownBlue()
        self.bedTimeBackground.backgroundColor = ColorPalette.bedtimeBlue()
    }
    
    func updateBottomActionLabel(state: BottomActionState) {
        self.bottomActionState = state
        switch state {
        case .Schedule:
            self.bottomActionButton.setTitle("SCHEDULE LIGHTS", forState: .Normal)
            break;
        case .Sync:
            self.bottomActionButton.setTitle("SYNC LIGHTS", forState: .Normal)
            break;
        }
    }
    
    func bedTime() {
        UIView.animateWithDuration(1.0, animations: { [unowned self] () -> Void in
            let oldSundownFrame = self.sunDownTimeContainer.frame
            self.sunDownTimeContainer.frame = CGRect(x: oldSundownFrame.origin.x,
                y: oldSundownFrame.origin.y - 100,
                width: oldSundownFrame.size.width,
                height: CGFloat(self.sunDownTimeView.time.frame.size.height))
            
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