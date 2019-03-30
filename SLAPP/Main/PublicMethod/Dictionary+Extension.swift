//
//  Dictionary+Extension.swift
//  SLAPP
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import Foundation

extension Dictionary{
    
    
    /// 添加token
    ///
    /// - Returns: 返回添加token后的参数
    func addToken()->(Dictionary<String,Any>){
        var dic = Dictionary<String,Any>()
        dic.merge(self as! [String : Any]) { (_, new) in new }
        dic.updateValue(UserModel.getUserModel().token!, forKey:"token")
        return dic
    }
    
    
}

