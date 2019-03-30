//
//  PublicTools.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

// MARK: - 开发模式打印
func DLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
        //想关闭设置成 false
        if true {
            let fileName = (file as NSString).lastPathComponent
            print("文件--\(fileName):位置--\(lineNum)--行--打印文本-\(message)")
        }
        
    #endif
}



/**
 *  NSUserDefaults 存储
 *  @param id  要存储的对象
 *  @param key 对应的key
 */
func UserDefaultWrite(id:Any,key:String) {
    UserDefaults.standard.set(id, forKey: key)
    UserDefaults.standard.synchronize()
}
//读取
func UserDefaultRead(key:String)->Any?{
    return UserDefaults.standard.object(forKey: key)
}

/// 快速读取当前appdelegate
let APPDelegate = UIApplication.shared.delegate as! AppDelegate

/**图片*/
func image(_ name: String) -> UIImage{
    return UIImage.init(named: name)!
}



