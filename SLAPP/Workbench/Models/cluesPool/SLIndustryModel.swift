//
//  SLIndustryModel.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLIndustryModel: SLModel {

    /**以此id找到属于该行业二级行业*/
    var index_id:String?
    /**当前行业名称*/
    var name:String?
    /**一级行业*/
    var parent_id:String?
    
    var parent_name:String?
    
    var select:Bool = false
    
    
    var subArray:[SLIndustryModel] = []
    
}
