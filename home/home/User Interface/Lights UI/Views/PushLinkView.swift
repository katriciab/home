//
//  PushLinkView.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-06.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class PushLinkView: UIView, HasLoadingView {

    @IBOutlet weak var rectangleLoadingView: RectangleLoadingView!
    
    func loadingView() -> LoadingView? {
        return self.rectangleLoadingView
    }
}
