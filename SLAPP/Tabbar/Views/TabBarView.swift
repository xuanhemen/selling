//
//  TabBarView.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import WZLBadge
class TabBarView: UIView {

    let backR = CGFloat(60)
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var tabBarDidSelectBtnFrom:(TabBarView,Int,Int)->() = {(tabBar,from,tp) in }
    var tabBarDidPlusBtn:(TabBarView,UIButton)->() = {(a,b) in }

    var tabBarButtons = Array<TabBarButton>()
    var selectedButton = TabBarButton()
    
    
    let backView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        let line = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 1))
        line.backgroundColor = UIColor.groupTableViewBackground
        line.layer.borderColor = UIColor.groupTableViewBackground.withAlphaComponent(1).cgColor
        self.addSubview(line)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTabBarButtonWithItem(item:UITabBarItem) {
        let btn = TabBarButton()
        tabBarButtons.append(btn)
        btn.item = item
        btn.addTarget(self, action: Selector("btnClick:"), for: .touchUpInside)
        if tabBarButtons.count == 1 {
            self.btnClick(btn: btn)
        }
    }
    
    func btnClick(btn:TabBarButton) {
        selectedButton.isSelected = false
        btn.isSelected = true
        selectedButton = btn
        tabBarDidSelectBtnFrom(self,selectedButton.tag,btn.tag)
    }
    
    func setBage(badge:String,index:NSInteger) {
        
        if index < tabBarButtons.count{
            let btn = tabBarButtons[index]
            btn.badgeCenterOffset = CGPoint(x: -(MAIN_SCREEN_WIDTH/5)*0.25, y: 15)
            if Int(badge) == 0{
                btn.clearBadge()
            }else{
                btn.showBadge(with: .redDot, value: Int(badge)!, animationType: .shake)
            }
        }
    }
    
    func selectedWithIndex(selectIndex:NSInteger) {
        selectedButton.isSelected = false
        let btn = tabBarButtons[selectIndex]
        btn.isSelected = true
        selectedButton = btn
        backView.image = UIImage.init(named: "tab_visit_back_nomal")
        tabBarDidSelectBtnFrom(self,self.selectedButton.tag,btn.tag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let btnH = self.frame.size.height
        let btnW = self.frame.size.width / CGFloat(self.tabBarButtons.count);
        let btnY:CGFloat = 0;
        var i = 0
        for btn in tabBarButtons {
            let btnX = CGFloat( i ) * btnW
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            btn.tag = i ;
            i = i+1
        }
    }
    
}
