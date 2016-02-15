//
//  UIView+LoadingView.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-06.
//  Copyright © 2016 Katricia. All rights reserved.
//

protocol HasLoadingView {
    func loadingView() -> LoadingView?
}

extension HasLoadingView {
    func startLoading() {
        self.loadingView()?.animate()
    }
    
    func stopLoading() {
        self.loadingView()?.stop()
    }
}