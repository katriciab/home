//
//  TimeView.swift
//  home
//
//  Created by Katricia Barleta on 2016-04-02.
//  Copyright © 2016 Katricia. All rights reserved.
//

import UIKit

class TimeView: UIView {
    
    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var time: UIButton!
    @IBOutlet weak var right: UIButton!
    
    var hour: Int = 0
    var minute: Int = 0
    
    func updateTime(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
        displayTime()
    }
    
    override func awakeFromNib() {
        self.right.addTarget(self, action:"forewardTime", forControlEvents:.TouchUpInside)
        self.left.addTarget(self, action:"backwardTime", forControlEvents:.TouchUpInside)
    }
    
    // MARK: Forewards
    func forewardTime() {
        if !forewardMinute() {
            forewardHour()
        }
        displayTime()
    }
    
    func forewardHour() -> Bool {
        let next = hour + 1;
        if next >= 24 {
            hour = 0
            return false
        }
        
        hour = next
        return true
    }
    
    func forewardMinute() -> Bool {
        let next = minute + 5
        if next >= 60 {
            minute = 0
            return false
        }
        
        minute = next
        return true
    }
    
    // MARK: Backwards
    func backwardTime() {
        if !backwardMinute() {
            backwardHour()
        }
        displayTime()
    }
    
    // 2:05 -> 2:00 -> 1:55
    
    func backwardHour() -> Bool {
        let next = hour - 1;
        if next < 0 {
            hour = 23
            return false
        }
        
        hour = next
        return true
    }
    
    func backwardMinute() -> Bool {
        let next = minute - 5
        if next < 0 {
            minute = 55
            return false
        }
        
        minute = next
        return true
    }
    
    // MARK: Display
    func displayTime() {
        let displayHour = hour % 12
        let displayMinute = minute % 60
        let timeClock = hour > 12 ? "PM" : "AM"
        time.setTitle(String(format:"%02d:%02d %@", displayHour, displayMinute, timeClock),
            forState: .Normal)
    }
}
