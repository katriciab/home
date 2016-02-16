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

    @IBAction func fluxUp(sender: AnyObject) {
    }
    
    @IBAction func fluxDown(sender: AnyObject) {
    }
}