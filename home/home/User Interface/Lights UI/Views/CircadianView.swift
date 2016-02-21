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
    
    override func awakeFromNib() {
        self.sundownBackground.backgroundColor = ColorPalette.sundownBlue()
        self.bedTimeBackground.backgroundColor = ColorPalette.bedtimeBlue()
    }
    
    func bedTime() {
        self.lightFluctuationGraph.hideDot()
        self.bedTimeBackground.hidden = false;
        self.expandedCircleView.expand()
    }
}