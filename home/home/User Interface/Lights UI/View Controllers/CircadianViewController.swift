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
         print("Scheduling something")
        let wakeComponents = NSDateComponents()
        wakeComponents.hour = 8
        wakeComponents.minute = 0
        wakeComponents.second = 0
        
        let sundownComponents = NSDateComponents()
        sundownComponents.hour = 18
        sundownComponents.minute = 30
        sundownComponents.second = 0
        
        let bedTimeComponents = NSDateComponents()
        bedTimeComponents.hour = 0
        bedTimeComponents.minute = 0
        bedTimeComponents.second = 0
        
        self.hueLightsManager?.scheduleCircadianLights(wakeComponents,
            wakeUpTransitionTime: 60,
            sunDownStartTime: sundownComponents,
            sunDownTransitionTime: 60,
            bedTime: bedTimeComponents)
    }
}