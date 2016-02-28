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
    
    @IBOutlet weak var pushLinkImage: UIImageView!
    
    func loadingView() -> LoadingView? {
        return self.rectangleLoadingView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.pushLinkImage.image = BackgroundEraser.tintedImage(self.pushLinkImage.image, withColor: ColorPalette.boldYellow())
    }
}
