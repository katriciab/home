//
//  CircadianViewController.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-30.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Swinject

class CircadianViewController: UIViewController {
    
    var hueLightsManager : PhilipsHueLightsManager?
    
    static func create() -> CircadianViewController {
        let sb = SwinjectStoryboard.create(name: "Main", bundle: nil, container: Injector.container)
        return sb.instantiateViewControllerWithIdentifier(self.nameOfClass) as! CircadianViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Circadian Lights"
        self.circadianView().lightFluctuationGraph.animateDot()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.backgroundColor = ColorPalette.coolGray()
    }
    
    func circadianView() -> CircadianView {
        return self.view as! CircadianView;
    }
    
    @IBAction func circleTapped(sender: AnyObject) {
        print("Circle tapped")
    }
    
    @IBAction func schedule(sender: AnyObject) {
        print("Scheduling circadian lights")
        self.hueLightsManager?.scheduleCircadianLights(
            wakeUpTransitionTime: 60,
            sunDownTransitionTime: 60,
            bedTimeTransitionTime: 60
        )
    }
}