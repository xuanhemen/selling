//
//  Date+Extension.swift
//  SLAPP
//
//  Created by apple on 2018/2/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import Foundation

extension Date {
    
    static func timeIntervalToDateStr(timeInterval:Double)->(String) {
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy年MM月dd日"
        return dateFomatter.string(from: date)
    }
    
    static func timeIntervalToDateDetailStr(timeInterval:Double)->(String) {
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy年MM月dd日  HH:mm"
        return dateFomatter.string(from: date)
    }
    
    static func timeIntervalToDateDetailStrStyle(timeInterval:Double)->(String) {
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd  HH:mm"
        return dateFomatter.string(from: date)
    }
    
    
    
    static func timeIntervalToDateDetailStr(date:Date)->(String) {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy年MM月dd日  HH:mm:ss"
        return dateFomatter.string(from: date)
    }
    
    static func timeIntervalToDateDetailyymmddStr(date:Date)->(String) {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy年MM月dd日"
        return dateFomatter.string(from: date)
    }
    
    static func timeIntervalToDateDetailStrhhmm(date:Date)->(String) {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy年MM月dd日  HH:mm"
        return dateFomatter.string(from: date)
    }
    
    
    static func timeIntervalToDateDetailStrhhmmStyle(date:Date)->(String) {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd  HH:mm"
        return dateFomatter.string(from: date)
    }
    
    //字符串转date
    static func strToDateStyle(str:String)->(Date){
        
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd  HH:mm"
        return dateFomatter.date(from: str)!
    }
    
    
    //字符串转date
    static func strToDate(str:String)->(Date){
        
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy年MM月dd日  HH:mm"
        return dateFomatter.date(from: str)!
    }
    
    
    //时间字符串转时间戳
    static func strToTimeInterval(str:String)->(Double){
        return self.strToDate(str: str).timeIntervalSince1970
    }
    
    //时间字符串转时间戳
    static func strToTimeIntervalyymmdd(str:String)->(Double){
        return self.strToDateyymmdd(str: str).timeIntervalSince1970
    }
    
    
    //时间字符串转时间戳
    static func strToTimeIntervalyymmddStyle(str:String)->(Double){
        return self.strToDateyymmddStyle(str: str).timeIntervalSince1970
    }
    
    //字符串转date
    static func strToDateyymmddStyle(str:String)->(Date){
        
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd  HH:mm"
        return dateFomatter.date(from: str)!
    }
    
    
    //字符串转date
    static func strToDateyymmdd(str:String)->(Date){
        
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy年MM月dd日"
        return dateFomatter.date(from: str)!
    }
    
    // MARK: - 返回 小时 分钟 HH:mm
    static func timeHMStr(timeInterval:Double)->(String) {
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "HH:mm"
        return dateFomatter.string(from: date)
    }
    
}
