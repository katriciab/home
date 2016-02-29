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
    
    var hueLightsManager : HueLightsManager!
    var schedulesDataController : SchedulesDataController!
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
        if self.schedulesDataController.isCircadianLightSchedulesSet() {
            self.circadianView().updateBottomActionLabel(BottomActionState.Sync)
        } else {
            self.circadianView().updateBottomActionLabel(BottomActionState.Schedule)
        }
        
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
    
    @IBAction func bottomActionTapped(sender: AnyObject) {
        print("Scheduling circadian lights")
        switch(self.circadianView().bottomActionState) {
        case .Schedule:
            self.schedulesDataController.setCircadianLightSchedules()
            .onSuccess(block: { results in
                self.circadianView().updateBottomActionLabel(.Sync)
            })
            break;
        case .Sync:
            self.hueLightsManager.syncLightColorToTimeOfDay()
            break;
        }
    }
    
    @IBAction func goodNightTapped(sender: AnyObject) {
        self.hueLightsManager.turnOffLights()
    }
    
    // MARK: Light Fluctuation Graph Delegate
    func startBedTimeAnimation() {
        self.circadianView().bedTime()
    }
}