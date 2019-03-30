//
//  SLProvinceModel.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLProvinceModel: SLModel {

     /**id*/
    var id:String?
     /**名称*/
    var name:String?
     /**下辖市*/
    var city: [SLCityeModel]?
    
}

class SLCityeModel: SLModel {
    /**id*/
    var id:String?
    /**名称*/
    var name:String?
    /**父code*/
    var parent:String?
    /**下辖区*/
    var area: [SLAreaModel]?
   
}

class SLAreaModel: SLModel {
    /**id*/
    var id:String?
    /**名称*/
    var name:String?
    /**code*/
    var parent:String?
   
}
