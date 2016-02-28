//
//  CircadianViewController.swift
//  home
//
//  Created by Katricia Barleta on 2016-01-30.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Swinject

class CircadianViewController: UIViewController, LightFluctuationGraphDelegate {
    
    var hueLightsManager : PhilipsHueLightsManager!
    var circadianLightForTimeUtility : CircadianLightForTimeUtility!
    
    static func create() -> CircadianViewController {
        let sb = SwinjectStoryboard.create(name: "Main", bundle: nil, container: Injector.container)
        return sb.instantiateViewControllerWithIdentifier(self.nameOfClass) as! CircadianViewController
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.backgroundColor = ColorPalette.coolGray()
    }
    
    func circadianView() -> CircadianView {
        return self.view as! CircadianView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Circadian Lights"
        self.circadianView().lightFluctuationGraph.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupGraphForCurrentTime()
    }
    
    func setupGraphForCurrentTime() {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        if let calendar = gregorianCalendar {
            let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
            if let timezone = NSTimeZone(name:cache.bridgeConfiguration.timeZone.name) {
                calendar.timeZone = timezone
            }
            let now = calendar.components([.Hour, .Minute, .Second], fromDate: NSDate())
            self.circadianView().lightFluctuationGraph.animateDotToTime(now, utility: self.circadianLightForTimeUtility)
        }
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
    
    // MARK: Light Fluctuation Graph Delegate
    func startBedTimeAnimation() {
        self.circadianView().bedTime()
    }
}