//
//  SelectBridgeViewController.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-07.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import Swinject

protocol SelectBridgeDelegate {
    func selectedBridgeWithId(id : String, ipAddress : String)
}

class SelectBridgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : SelectBridgeDelegate?
    private var bridges : [Bridge]!
    
    private struct Bridge {
        let id : String
        let ipAddress : String
        init (id : String, ipAddress : String) {
            self.id = id
            self.ipAddress = ipAddress
        }
    }
    
    static func create() -> SelectBridgeViewController {
        let sb = SwinjectStoryboard.create(name: "Main", bundle: nil, container: Injector.container)
        return sb.instantiateViewControllerWithIdentifier(self.nameOfClass) as! SelectBridgeViewController
    }
    
    func setupWithBridges(bridges : [NSObject : AnyObject]) {
        guard bridges.count > 0 else {
            return
        }
        
        self.bridges = []
        for (id, ipAddress) in bridges {
            self.bridges.append(
                Bridge(id: id as! String,
                    ipAddress: ipAddress as! String)
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectBridgeView() -> SelectBridgeView {
        return self.view as! SelectBridgeView
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bridges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.selectBridgeView().tableView .dequeueReusableCellWithIdentifier(BridgeTableViewCell.nameOfClass)! as! BridgeTableViewCell
        cell.ipAddress.text = self.bridges[indexPath.row].ipAddress
        cell.macAddress.text = self.bridges[indexPath.row].id
        cell.selectionStyle = .None
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedBridge = self.bridges[indexPath.row]
        self.delegate?.selectedBridgeWithId(selectedBridge.id, ipAddress: selectedBridge.ipAddress)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
