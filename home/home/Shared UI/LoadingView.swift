//
//  LoadingView.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-06.
//  Copyright © 2016 Katricia. All rights reserved.
//

protocol LoadingView {
    func animate()
    func updateProgress(percentage: Double)
    func stop()
}
