//
//  CoachViewModel.swift
//  SLAPP
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
let coachKey = "coach"
//配合有效时间
let long = 5
//时间有限制作内存缓存，后续换数据库

class CoachViewModel: NSObject {
    
    class func isCanGetData(tag:String)->(Bool){
       
        let last = UserDefaultRead(key: coachKey+tag+UserModel.getUserModel().id!)
        if last != nil {
            if let lastTime = Double(String.noNilStr(str: last)){
                let now = Date().timeIntervalSince1970
                if now-lastTime >= Double(long)*60{
                    return true
                }
                return false
            }
            return true
        }
        
       
       return true
    }
   
    class func saveLastTimeWith(tag:String){
        
        let now = Date().timeIntervalSince1970
        UserDefaultWrite(id: String.noNilStr(str: now), key:coachKey+tag+UserModel.getUserModel().id!)
    }
    
    class func clearCoachKey(){
        
        for i in 1...3 {
            UserDefaults.standard.removeObject(forKey: coachKey+"\(i)"+UserModel.getUserModel().id!)
        }
        
        
    }
}
