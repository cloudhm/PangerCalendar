//
//  PRTheme.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/26.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

private let s_Instance: PRTheme = PRTheme()

class PRTheme: NSObject {
    // MARK: Font
    var defaultFont: UIFont = UIFont.systemFont(ofSize: 13)
    var smallFont: UIFont = UIFont.systemFont(ofSize: 11)
    var bigFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    // MARK: color
    var redCustomColor: UIColor = RGBCOLOR(r: 187, 36, 13)
    var redCustomLightColor: UIColor = RGBACOLOR(r: 187, 36, 13, 0.25)
    
    var blackCustomColor: UIColor = RGBCOLOR(r: 51, 51, 51)
    var blackCustomLightColor: UIColor = RGBACOLOR(r: 51, 51, 51, 0.25)
 
    var blueCustomColor: UIColor = RGBCOLOR(r: 77, 177, 218)
    var blueCustomLightColor: UIColor = RGBACOLOR(r: 77, 177, 218, 0.25)
    
    var weekendTipColor: UIColor!
    var weekendInMonthColor: UIColor!
    var weekendOutMonthColor: UIColor!
    
    var weekdayTipColor: UIColor!
    var weekdayInMonthColor: UIColor!
    var weekdayOutMonthColor: UIColor!
    
    var sosolarTermInMonthColor: UIColor!
    var sosolarTermOutMonthColor: UIColor!
    var festivalInMonthColor: UIColor!
    var festivalOutMonthColor: UIColor!
    
    class func current() -> PRTheme {
        return s_Instance
    }
    
    override init() {
        super.init()
        weekendTipColor = redCustomColor
        weekendInMonthColor = redCustomColor
        weekendOutMonthColor = redCustomLightColor
        
        weekdayTipColor = blackCustomColor
        weekdayInMonthColor = blackCustomColor
        weekdayOutMonthColor = blackCustomLightColor
        
        sosolarTermInMonthColor = redCustomColor
        sosolarTermOutMonthColor = redCustomLightColor
        
        festivalInMonthColor = blueCustomColor
        festivalOutMonthColor = blueCustomLightColor
    }
    
}