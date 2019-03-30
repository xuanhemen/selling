//
//  SLBottomAreaView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
var instance:SLBottomAreaView? = nil
class SLBottomAreaView: UIWindow {

   
   
    //lazy var bottomView = SLAreaBottomView()
    
    static func showArray(array:[SLProvinceModel]){
        instance = SLBottomAreaView.init(frame: UIScreen.main.bounds)
        instance?.backgroundColor = RGBA(R: 0, G: 0, B: 0, A: 0.5)
        instance?.windowLevel = UIWindowLevelAlert
        instance?.isHidden = false
        
        let clearView = UIView()
        clearView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NAV_HEIGHT)
        clearView.backgroundColor = UIColor.purple
        instance?.addSubview(clearView)
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        clearView.addGestureRecognizer(ges)
        let bottomView = SLAreaBottomView()
        bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT-350, width: SCREEN_WIDTH, height: 350)
        bottomView.dataArr = array
        bottomView.provinceTV.reloadData()
        instance?.addSubview(bottomView)
       
    }
    @objc func dismissView(ges: UITapGestureRecognizer){
       // instance?.isHidden = true
        //instance = nil
    }
    @objc func ceshi(){
        print("来了")
    }

}
