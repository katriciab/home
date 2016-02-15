//
//  Networking.swift
//  home
//
//  Created by Katricia Barleta on 2016-02-12.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit
import FutureKit

public protocol Networking {
    func get(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject>;
    func post(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject>;
    func put(urlString : String, parameters : [String : AnyObject]) -> Future<AnyObject>;
}