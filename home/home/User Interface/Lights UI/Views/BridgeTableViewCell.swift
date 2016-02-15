//
//  BridgeTableViewCell.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-07.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class BridgeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ipAddress: UILabel!
    
    @IBOutlet weak var macAddress: UILabel!
    
    @IBOutlet weak var lineView: UIView!

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        self.lineView.alpha = highlighted ? 0.5 : 1.0
    }
}
