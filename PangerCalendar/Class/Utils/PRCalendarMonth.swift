//
//  PRCalendarMonth.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/18.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit
import Foundation

fileprivate let S_HEADLABLEHEIGHTSCALE: CGFloat = 0.7                //日历顶部标签占顶部总高度的比例           年月标签/顶部
fileprivate let S_HEADFOUNTSIZESCALE: CGFloat = 0.4                  //日历顶部标签字体大小与顶部总高度的比例     年月字体/顶部标签
fileprivate let S_HEADWEEKDAYHEIGHTSCALE: CGFloat = 0.6              //星期行的高度占顶部总高度的比例           星期行/顶部
fileprivate let S_HEADWEEKDAYFOUNTSIZESCALE: CGFloat = 0.8           //星期行标签字体大小与星期行总高度的比例     星期字体/星期标签
fileprivate let S_CALENDARDAYFOUNTSIZESCALE: CGFloat = 0.5           //日期按钮标签的字体与日期按钮高度的比例     日期字体/期日按钮
fileprivate let S_CALENDARDAYMARKSCALE: CGFloat = 0.3                //日期按钮的标记与日期按钮大小的比例         日期标记/期日按钮
fileprivate let S_CALENDARDAYMARKHEIGHT: CGFloat = 2                 //日期按钮的条标记高度                    日期标记高度
fileprivate let S_CALENDARDAYBUTTOMFOUNTSIZESCALE: CGFloat = 0.25    //日期按钮底部标签的字体与日期按钮高度的比例   日期底部字体/期日按钮

class PRCalendarMonth: UIView {
    public var calendarLogic: PRCalendarLogic?             // 日历逻辑
    public var datesIndex: Array<Date>?                     // 日期数组
    public var buttonsIndex: Array<UIButton>?                   // 按钮数组
    public var markDict: NSMutableDictionary?          // 标记字典（日期作为索引）
    
    public var numberOfDaysInWeek: Int!                    // 每周几天
    public var numberOfWeeks: Int!                         // 当前月历页面中有几周（行数）
    public var selectedButton: Int?                        // 选中的按钮索引
    public var selectedDate: Date?                         // 选中的日期
    
    public var headerFrame: CGRect!                        // 日历头大小和位置
    public var calendarFrame: CGRect!                      // 日历大小和位置
    public var calendarDayWidth: CGFloat!                  // 日历中天的宽度
    public var calendarDayHeight: CGFloat!                 // 日历中天的高度
    
    
    // MARK: Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 初始化，frame－大小。aLogic－关联的日历逻辑
    public init(frame: CGRect, logic: PRCalendarLogic) {
        super.init(frame: frame)
        // Size is static
        self.numberOfWeeks = 6          //高度（日期个数）
        self.selectedButton = -1        //被选中按钮为－1
        
        // 初始化标记数组
        self.markDict = NSMutableDictionary()
        // 创建一个当前用户的日历对象（NSCalendar用于处理时间相关问题。比如比较时间前后、计算日期所的周别等。）
        let calendar = Calendar.current
        // 创建一个日期组件，并赋予当前日期
        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: Date())
        // 返回components指定的时间
        let todayDate = calendar.date(from: components)!
        // Initialization code
        self.backgroundColor = UIColor.clear            // Red should show up fails.//红色背景，但不显示。
//        self.opaque = true                            //透明
        self.clipsToBounds = true                       //边界裁切
        self.clearsContextBeforeDrawing = false         //不自动清除绘图上下文
        
        // 日历组件的宽度和高度
        //CGFloat headerHeight = frame.size.height/numberOfWeeks;                                   //日历头高度
        let headerHeight: CGFloat = 20.0
        self.headerFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: headerHeight)             //日历头位置和大小
        //日历部分位置和大小
        self.calendarFrame = CGRect(x: 0, y: headerHeight, width: frame.size.width, height: frame.size.height - self.headerFrame.size.height)
        // 创建图像视图，上边栏
        let headerBackground = UIImageView(image: UIImage(named: "CalendarBackground.png"))
        headerBackground.frame = self.headerFrame
        self.addSubview(headerBackground)

        // 创建图像视图，月历内容
        let calendarBackground = UIImageView(image: UIImage(named: "CalendarBackground.png"))
        calendarBackground.frame = self.calendarFrame
        self.addSubview(calendarBackground)
        
        // 创建一个格式化日期类
        let formatter = DateFormatter()
        // 获得星期缩写的数组
        let daySymbols = formatter.shortWeekdaySymbols!
        // 每周几天
        self.numberOfDaysInWeek = daySymbols.count
        
        // 日历中日期的宽度和高度
        self.calendarDayWidth = self.calendarFrame.size.width / CGFloat(self.numberOfDaysInWeek)    //日历中天的宽度
        self.calendarDayHeight = self.calendarFrame.size.height / CGFloat(self.numberOfWeeks)            //日历中天的高度
        // 创建顶部标题，用于显示年份
        var aLabel: UILabel
        /* 不要日历头
        aLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.headerFrame.size.width, height: self.headerFrame.size.height * S_HEADLABLEHEIGHTSCALE))
        aLabel.backgroundColor = UIColor.clear
        //aLabel.textAlignment = UITextAlignmentCenter
        aLabel.textAlignment = NSTextAlignment.center
        aLabel.font = UIFont.boldSystemFont(ofSize: self.headerFrame.size.height * S_HEADFOUNTSIZESCALE)   //字体大小
        aLabel.textColor = UIColor.init(patternImage: UIImage(named: "CalendarTitleColor.png")!) //使用图像填充
        aLabel.shadowColor = UIColor.white      //阴影颜色
        aLabel.shadowOffset = CGSize(width: 0, height: 1.0)  //阴影偏移
        formatter.dateFormat = "yyyy年 MM月"      //日期格式
        aLabel.text = formatter.string(from: logic.referenceDate)   //返回指定格式的日期
        self.addSubview(aLabel)    //添加到视图
        */
        // 分割线视图
//        let lineView = UIView(frame: CGRect(x: 0, y: self.headerFrame.size.height - 1, width: self.headerFrame.size.width, height: 1))
//        lineView.backgroundColor = UIColor.lightGray
//        self.addSubview(lineView)
        
        // Setup weekday names
        // 添加星期名称
        // 获得第一个星期索引
        let firstWeekday = calendar.firstWeekday - 1
        for aWeekday in 0...self.numberOfDaysInWeek - 1 {
            // 符号索引为当前循环次数＋第一个星期索引
            var symbolIndex = aWeekday + firstWeekday
            // 如果符号索引大于星期个数，则循环到队列开始位置
            if (symbolIndex >= self.numberOfDaysInWeek) {
                symbolIndex -= self.numberOfDaysInWeek;
            }
            
            // 获得星期符号，并计算显示位置
            let symbol = daySymbols[symbolIndex]
            let positionX = (CGFloat(aWeekday) * self.calendarDayWidth) - 1
            let weekdayHeight = self.headerFrame.size.height * S_HEADWEEKDAYHEIGHTSCALE; //星期高度行
            let aFrame = CGRect(x: positionX, y: self.headerFrame.size.height - weekdayHeight - 2, width: self.calendarDayWidth, height:weekdayHeight)
            // 创建标签，并添加到视图
            aLabel = UILabel(frame: aFrame)
            aLabel.backgroundColor = UIColor.clear
            aLabel.textAlignment = NSTextAlignment.center
            aLabel.text = symbol
            // 周末高亮
            if (aWeekday == 0 || aWeekday == numberOfDaysInWeek-1) {
                aLabel.textColor = UIColor(red: 0.5, green: 0.2, blue: 0, alpha: 1)
            } else {
                aLabel.textColor = UIColor.darkGray
            }
            aLabel.font = UIFont.boldSystemFont(ofSize: weekdayHeight * S_HEADWEEKDAYFOUNTSIZESCALE)    //字体大小
            aLabel.shadowColor = UIColor.white
            aLabel.shadowOffset = CGSize(width: 0, height: 1)
            self.addSubview(aLabel)
        }
        
        // Build calendar buttons (6 weeks of 7 days)
        // 建立日历按钮（宽高：6周7天）
        let aDatesIndex = NSMutableArray()
//            NSMutableArray()      //日期索引
        let aButtonsIndex = NSMutableArray()    //按钮索引
        
        //每次循环绘制一列
        for aWeek in 0...self.numberOfWeeks - 1 {
            //当前行y坐标
            let positionY = (CGFloat(aWeek) * self.calendarDayHeight) + self.headerFrame.size.height
            //每次循环绘制一行
            for aWeekday in 1...self.numberOfDaysInWeek {
                //当前列x坐标
                let positionX = (CGFloat(aWeekday - 1) * self.calendarDayWidth) - 1
                //当前日期位置
                let dayFrame = CGRect(x: positionX, y: positionY, width: self.calendarDayWidth, height: self.calendarDayHeight)
                //根据行列获得日期
                let dayDate = PRCalendarLogic.date(weekday: aWeekday, week: aWeek, referenceDate: logic.referenceDate)
                //转换成格式化日期
                var dayComponents = calendar.dateComponents([Calendar.Component.day], from: dayDate)
                //创建一个日期按钮，样式为UIButtonTypeCustom
                let dayButton = UIButton()
                dayButton.isOpaque = true
                dayButton.clipsToBounds = false
                dayButton.clearsContextBeforeDrawing = false
                dayButton.frame = dayFrame
                dayButton.titleLabel?.shadowOffset = CGSize(width: 0, height: 1)
                dayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.calendarDayHeight * S_CALENDARDAYFOUNTSIZESCALE)
                dayButton.tag = aDatesIndex.count                            //tag(当前个数)
                dayButton.adjustsImageWhenHighlighted = false                     //变化时发光
                dayButton.adjustsImageWhenDisabled = false                        //变化时禁用
                //dayButton.showsTouchWhenHighlighted = true                    //点击时发光
                //设置日期颜色
                var titleColor = UIColor(patternImage: UIImage(named: "CalendarTitleColor.png")!)
                //如果日期和当前日期间隔大于1个月（不是本月的日期），则使用不同的颜色
                if logic.distanceOfDateFromCurrentMonth(date: dayDate) != 0 {
                    titleColor = UIColor(patternImage: UIImage(named: "CalendarTitleDimColor.png")!)
                    //取消标题阴影
                    dayButton.titleLabel?.shadowOffset = CGSize(width: 0, height: 0)
                }
                
                // Normal
                //添加 UIControlStateNormal－正常状态 时的标题
                dayButton.setTitle(String.init(format: "%i", dayComponents.day!), for: UIControlState.normal)

                // Selected
                //选中状态时标题颜色和阴影颜色
                dayButton.setTitleColor(titleColor, for: UIControlState.selected)
                dayButton.setTitleShadowColor(UIColor.black, for: UIControlState.selected)
                
                //是否是今天
                if (dayDate.compare(todayDate) != ComparisonResult.orderedSame) {
                    // Normal
                    //正常状态时，按钮标题颜色，阴影。按钮背景
                    dayButton.setTitleColor(titleColor, for: UIControlState.normal)
                    dayButton.setTitleShadowColor(UIColor.black, for: UIControlState.normal)
                    dayButton.setBackgroundImage(UIImage(named: "CalendarDayTile.png"), for: UIControlState.normal)
                    
                    // Selected
                    //选中状态时，按钮背景
                    dayButton.setBackgroundImage(UIImage(named: "CalendarDaySelected.png"), for: UIControlState.selected)
                } else {
                    // Normal
                    //正常状态时，按钮标题颜色，阴影。按钮背景
                    dayButton.setTitleColor(titleColor, for: UIControlState.normal)
                    dayButton.setTitleShadowColor(UIColor.black, for: UIControlState.normal)
                    dayButton.setBackgroundImage(UIImage(named: "CalendarDayToday.png"), for: UIControlState.normal)
        
                    //创建图像视图，今天
                    let todayMark = UIImageView(image: UIImage(named: "CalendarDayTodayMark.png"))
                    //[todayMark setFrame:];
                    todayMark.contentMode = UIViewContentMode.topLeft
                    todayMark.frame = dayButton.frame
                    self.addSubview(todayMark)
                
                    // Selected
                    //选中状态时，按钮背景
                    dayButton.setBackgroundImage(UIImage(named: "CalendarDayTodaySelected.png"), for: UIControlState.selected)
                }
                //添加阴历和节日信息
                let bottomLabel = UILabel()
                let bottomLabelHeight = self.calendarDayHeight * S_CALENDARDAYBUTTOMFOUNTSIZESCALE
                bottomLabel.text = PRLunarDate.lunarDateWithNSDate(date: dayDate).priorityLabel
                
                bottomLabel.font = UIFont.boldSystemFont(ofSize: bottomLabelHeight)
                bottomLabel.frame = CGRect(x: 0, y: dayButton.frame.size.height - bottomLabelHeight - 2, width: dayButton.frame.size.width, height: bottomLabelHeight+2)
                bottomLabel.textAlignment = NSTextAlignment.center;
                //根据标签类型修改文本颜色
                if(PRLunarDate.lunarDateWithNSDate(date: dayDate).priorityLabelType == PRDatePriorityLabelType.day) {
                    bottomLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
                } else {
                    bottomLabel.textColor = UIColor(red: 0.5, green: 0.2, blue: 0, alpha: 1)
                }
                bottomLabel.backgroundColor = UIColor.clear
                //插入到视图
                dayButton.insertSubview(bottomLabel, at: 0)
                //给按钮添加响应动作
                dayButton.addTarget(self, action: "dayButtonPressed:", for: UIControlEvents.touchUpInside)
                //添加到视图
                self.addSubview(dayButton)
                
                // Save
                aDatesIndex.add(dayDate)        //日期添加到日期数组
                aButtonsIndex.add(dayButton)    //按钮添加到按钮数组
            }
        }
        // save
        //保存日历逻辑
        self.calendarLogic = logic
        //保存日期数组
        self.datesIndex = NSArray(array: aDatesIndex) as? Array<Date> 
        //保存按钮数组
        self.buttonsIndex = NSArray(array: aButtonsIndex) as? Array<UIButton>
    }
    
    //日期被点击
    private func dayButtonPressed(sender: UIButton) {
        //设置日历逻辑的参考日期为被选择的日期（被选择按钮的tag对应的日期）
        self.calendarLogic?.referenceDate = self.datesIndex?[sender.tag];
    }
    
}