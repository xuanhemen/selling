//
//  NSDate+Extension.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/2.
//  Copyright © 2017年 柴进. All rights reserved.
//

import Foundation

extension Date {
    // 判断是否是今天
    static func isToday (target : Date) -> Bool {
        let currentDate : Date = Date()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentResult : String = dateFormatter.string(from: currentDate)
        let targetResult : String = dateFormatter.string(from: target)
        
        return currentResult == targetResult
    }
    
    // 判断是否是昨天
    static func isLastDay (target : Date) -> Bool {
        let currentDate : Date = Date()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentResult : String = dateFormatter.string(from: currentDate)
        let targetResult : String = dateFormatter.string(from: target)
    
        let currentD = dateFormatter.date(from: currentResult)
        let targetD = dateFormatter.date(from: targetResult)

        return (currentD?.timeIntervalSince(targetD!))! <= 24 * 60 * 60
    }
    
    // 判断是否是一周内
    static func isOneWeek (target : Date) -> Bool {
        let currentDate : Date = Date()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentResult : String = dateFormatter.string(from: currentDate)
        let targetResult : String = dateFormatter.string(from: target)
        
        let currentD = dateFormatter.date(from: currentResult)
        let targetD = dateFormatter.date(from: targetResult)
        
        return (currentD?.timeIntervalSince(targetD!))! <= 7 * 24 * 60 * 60
    }

    // 日期格式转换yy/MM/dd
    static func formattDay (target : Date) -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/M/d"
        let targetResult : String = dateFormatter.string(from: target)
        
        return targetResult
    }
    
    // 根据日期获取时间戳
    static func getTimestamp (dateString : String) -> TimeInterval {
        if dateString.count <= 0 {
            return 0
        }
        
        var newDateStirng = dateString
        if !dateString.contains(" ") {
            newDateStirng = newDateStirng.appending(" 00:00:00")
        }
        
        let formatter : DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.dateStyle = DateFormatter.Style.short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Beijing")
        print("*** newDateStirng = \(newDateStirng)")
        let dateNow = formatter.date(from: newDateStirng)
        
        return dateNow?.timeIntervalSince1970 ?? 0
    }
    
    // 获取星期
    static func weekWithDateString (target : Date) -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let targetResult : String = dateFormatter.string(from: target)

        let timestamp = Date.getTimestamp(dateString: targetResult)
        let day = Int(timestamp/86400)
        let array : Array = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"];
        return array[(day-3)%7]
        //        return "星期\((day-3)%7))"
    }
    
}
