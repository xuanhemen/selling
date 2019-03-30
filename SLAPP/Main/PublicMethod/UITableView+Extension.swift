//
//  UITableView+Extension.swift
//  SLAPP
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 柴进. All rights reserved.
//

import Foundation

extension UITableView {
    
    
    
    /// 添加空数据提醒 并且带有刷新按钮
    ///
    /// - Parameter refresh: 刷新按钮点击后的闭包
    func addEmptyViewAndClickRefresh(_ refresh: @escaping ()->()){
        let emptyView = LYEmptyView.emptyActionView(withImageStr: "noDataRemind", titleStr: "暂无数据", detailStr: nil, btnTitleStr: "刷新试试") {
            refresh()
        }
        emptyView?.subViewMargin = 36;
        emptyView?.titleLabFont = UIFont.systemFont(ofSize: 15)
        emptyView?.titleLabTextColor = kGreenColor;
        emptyView?.actionBtnFont = UIFont.systemFont(ofSize: 15)
        emptyView?.actionBtnTitleColor = UIColor.white
        emptyView?.actionBtnHeight = 40;
        emptyView?.actionBtnHorizontalMargin = 74;
        emptyView?.actionBtnCornerRadius = 20;
        emptyView?.actionBtnBackGroundColor = kGreenColor;
        self.ly_emptyView = emptyView;
    }
    
    
    
    /// 添加空数据提醒   不带刷新按钮
    func addEmptyViewWithNoAction(){
        let emptyView = LYEmptyView.empty(withImageStr: "noDataRemind", titleStr: "暂无数据", detailStr: nil)
        emptyView?.subViewMargin = 36;
        emptyView?.titleLabFont = UIFont.systemFont(ofSize: 15)
        emptyView?.titleLabTextColor = kGreenColor;
        self.ly_emptyView = emptyView;
        
    }
    
    
    /// 添加空数据提醒   不带刷新按钮
    func addEmptyViewWithTitle(titleStr:String){
        
        let emptyView = LYEmptyView.empty(withImageStr: "noDataRemind", titleStr: titleStr, detailStr: nil)
        emptyView?.subViewMargin = 36;
        emptyView?.titleLabFont = UIFont.systemFont(ofSize: 15)
        emptyView?.titleLabTextColor = kGreenColor;
        self.ly_emptyView = emptyView;
        
    }
    
}








