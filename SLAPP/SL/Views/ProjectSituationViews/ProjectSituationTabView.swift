//
//  ProjectSituationTabView.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import YBPopupMenu

 protocol ProjectSituationDelegate : NSObjectProtocol {
    
    func tabViewClick(tabView:ProjectSituationTabView,selectBtn:ProjectTabBtn)->(Bool);
    
    func tabViewDidSelect(tabView:ProjectSituationTabView,selectBtn:ProjectTabBtn);
}


class ProjectSituationTabView: UIView {

    weak open var delegate:ProjectSituationDelegate?
    
    var tempBtn:ProjectTabBtn?
    let titleArray = ["概况","跟进","分析","计划","讨论","辅导"]
    
    /// 选中某某一个
    ///
    /// - Parameter tag:
    func selectWithTag(tag:Int){
        guard tag < titleArray.count else {
            return
        }
        DLog(self.viewWithTag(tag))
         let btn:ProjectTabBtn = self.viewWithTag(tag+1000) as! ProjectTabBtn
        if tempBtn != nil {
            tempBtn?.isSelected = false
           
            tempBtn = btn 
            tempBtn?.isSelected = true
        }
        self.delegate?.tabViewDidSelect(tabView: self, selectBtn: btn)
        
    }
    
    //显示红点提示
    func showPoint(num:Int,tag:Int,isRed:Bool){
        let btn:ProjectTabBtn = self.viewWithTag(tag+1000) as! ProjectTabBtn
        btn.badgeCenterOffset = CGPoint.init(x:-20, y:5)
        if isRed {
            btn.showBadge(with: .redDot, value: num, animationType: .none)
        }else{
            btn.showBadge(with: .number, value:num, animationType: .none)
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
        self.layer.shadowColor = UIColor.lightGray.cgColor;
        self.layer.shadowOffset = CGSize.init(width: 0, height: -0.3);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 0.3;
    }
    
    func configUI(){
        self.backgroundColor = UIColor.white
        let width = MAIN_SCREEN_WIDTH/6
        for i in 0...5 {
            let btn = ProjectTabBtn.init(frame: CGRect(x: 0+CGFloat(i)*width, y: 0, width: width, height: 49))
            btn.setImage(UIImage.init(named: "projectS-Nomal".appending("\(i)")), for: .normal)
            btn.setImage(UIImage.init(named: "projectS-Select".appending("\(i)")), for: .selected)
            btn.setTitle(titleArray[i], for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.setTitleColor(kGreenColor, for: .selected)
            self.addSubview(btn)
            btn.tag = i+1000
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            if i == 0 {
                btn.isSelected = true
                tempBtn = btn
            }
        }
        
    }
    
    @objc func btnClick(btn:ProjectTabBtn){
        
        
        if btn.tag == 1001 {
            btn.showBadge(with: .number, value:0, animationType: .none)
        }
        
        if (self.delegate?.tabViewClick(tabView: self, selectBtn: btn))! {
            
            if btn.tag != 1004{
                if tempBtn != nil {
                    tempBtn?.isSelected = false
                    tempBtn = btn
                    tempBtn?.isSelected = true
                }
            }
            
            self.delegate?.tabViewDidSelect(tabView: self, selectBtn: btn)
        }
        
        
//        YBPopupMenu.showRely(on: btn, titles: ["复制","转移","删除","关单"], icons: ["menuCopy","menuTrans","menuDelete","menuClose"], menuWidth: 100) { (menuView) in
//
//        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
