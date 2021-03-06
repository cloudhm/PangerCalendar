//
//  PRCalendarLogic.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/15.
//  Copyright © 2016年 panger. All rights reserved.
//

import Foundation

class PRCalendarLogic: NSObject {
 
    weak open var calendarLogicDelegate: PRCalendarLogicDelegate?
    private var _referenceDate: Date?

    var referenceDate: Date! {
        set(newDate) {
            if (newDate == nil) {
                self.calendarLogicDelegate?.calendarLogic(aLogic: self, dateSelected: nil)
                return
            }
            // Calculate direction of month switches
            //计算与当前日期的距离
            let distance = self.distanceOfDateFromCurrentMonth(date: newDate)
        
            // 创建一个创建一个日期组件，并赋予要设置的日期
            let components = Calendar.current.dateComponents([.day, .month, .year], from: newDate!)
            // 返回日期（统一格式）
            _referenceDate = Calendar.current.date(from: components)
            // Message delegate
            // 通知代理 日期被选择为aDate
            self.calendarLogicDelegate?.calendarLogic(aLogic: self, dateSelected: newDate)
            // month switch?
            // 距离不等于0则需要交换月历视图
            if distance != 0 {
                // Changed so tell delegate
                // 通知代理 交换月历到距离distance
                self.calendarLogicDelegate?.calendarLogic(aLogic: self, monthChangeDirection: distance)
            }
        }
        
        get {
            return _referenceDate
        }
    }
 
    /// 初始化，aDelegate－日历逻辑代理。aDate－基准日期
    ///
    /// - Parameters:
    ///   - delegate:
    ///   - aDate:
    init(delegate: PRCalendarLogicDelegate, aDate: Date) {
        super.init()
        self.calendarLogicDelegate = delegate;
        //创建一个创建一个日期组件，并赋予要设置的日期
        let components = Calendar.current.dateComponents([.day, .month, .year], from: aDate)
        // 返回日期（统一格式）
        _referenceDate = Calendar.current.date(from: components)
    }
    
    // MARK: class function
    /// 返回当前日期
    class func dateForToday() -> Date {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        // 返回日期（统一格式）
        return Calendar.current.date(from: components)!
    }
    
    /// 构造一个日期。aWeekday－星期几，aWeek－第几周（今年），aReferenceDate－日期（只含月和年）
    class func date(weekday: Int, week: Int, referenceDate: Date) -> Date {
        // 使用参数aReferenceDate构造日期组件
        let components = Calendar.current.dateComponents([.month, .year], from: referenceDate)
        let month = components.month!
        let year = components.year!
        return self.date(weekday: weekday, week: week, month: month, year: year)
    }
    
    /// 构造一个日期。weekday－星期几，week－第几周（今年），month－月，year－年
    class func date(weekday: Int, week: Int, month: Int, year: Int) -> Date {
        let calendar = Calendar.current
        // Select first 'firstWeekDay' in this month
        // 构造一个NSDateComponents
        var firstStartDayComponents = DateComponents()
        firstStartDayComponents.month = month
        firstStartDayComponents.year = year
        firstStartDayComponents.weekday = calendar.firstWeekday
        firstStartDayComponents.weekdayOrdinal = 1  // 这个月的第几周
        let firstDayDate = calendar.date(from: firstStartDayComponents)
        
        // Grab just the day part.
        firstStartDayComponents = calendar.dateComponents([.day], from: firstDayDate!)
        
        let maxRange = calendar.maximumRange(of: .weekday)
        let numberOfDaysInWeek = maxRange!.upperBound - maxRange!.lowerBound
        
        var firstDay: Int = firstStartDayComponents.day! - numberOfDaysInWeek
        // Correct for day landing on the firstWeekday
        if firstDay - 1 == -numberOfDaysInWeek {
            firstDay = 1
        }
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = week * numberOfDaysInWeek + firstDay + weekday - 1
        return calendar.date(from: components)!
    }
    
    
    // MARK: private mehtod
    
    /// 返回指定日期的索引（在当前日历页中）
    ///
    /// - Parameter date: <#date description#>
    /// - Returns: <#return value description#>
    func indexOfCalendar(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .weekday, .weekOfYear, .year], from: date)
        // Select this month in this year.
        var firstDayComponents = DateComponents()
        firstDayComponents.month = components.month
        firstDayComponents.year = components.year
        let firstDayDate = calendar.date(from: firstDayComponents)
        
        // Turn into week of a year.
        let firstWeekComponents = calendar.dateComponents([.weekOfYear], from: firstDayDate!)
        var firstWeek = firstWeekComponents.weekOfYear!
        if firstWeek > components.weekOfYear! {
            firstWeek -= 52
        }
        var weekday = components.weekday!
        if weekday < calendar.firstWeekday {
            weekday += 7
        }
        
        return (weekday + (components.weekOfYear! - firstWeek) * 7) - calendar.firstWeekday
    }
    
    /// 返回指定日期aDate于当前基准日期的间隔月份（正负＋距离）
    ///
    /// - Parameter date:
    /// - Returns:
    func distanceOfDateFromCurrentMonth(date: Date?) -> Int {
        if date == nil {
            return -1
        }
        var distance = 0
        let calendar = Calendar.current
        var monthComponents = calendar.dateComponents([.month, .year], from: _referenceDate!)
        let firstDayInMonth = calendar.date(from: monthComponents)
        monthComponents.day = (calendar.range(of: .day, in: .month, for: _referenceDate!)?.upperBound)! - 1
        let lastDayInMonth = calendar.date(from: monthComponents)
        
        // Lower
        let distanceFromFirstDay = calendar.dateComponents([.day], from: firstDayInMonth!, to: date!).day!
        if distanceFromFirstDay < 0 {
            distance = distanceFromFirstDay
        }
        // Greater
        let distanceFromLastDay = calendar.dateComponents([.day], from: lastDayInMonth!, to: date!).day!
        if distanceFromLastDay > 0 {
            distance = distanceFromLastDay
        }
        return distance
    }
    
    /// 选择前一个月
    func selectPreviousMonth() {
        var components = DateComponents()
        components.month = -1
        _referenceDate = Calendar.current.date(byAdding: components, to: _referenceDate!)
        self.calendarLogicDelegate?.calendarLogic(aLogic: self, monthChangeDirection: -1)
    }
    
    /// 选择下一个月
    func selectNextMonth() {
        var components = DateComponents()
        components.month = 1
        _referenceDate = Calendar.current.date(byAdding: components, to: _referenceDate!)
        self.calendarLogicDelegate?.calendarLogic(aLogic: self, monthChangeDirection: 1)
    }
    
}



