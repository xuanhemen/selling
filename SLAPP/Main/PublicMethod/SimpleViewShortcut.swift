//
//  SimpleViewShortcut.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SimpleViewShortcut: NSObject {

    class func makeSimpleViewController(title:String,lableTitle:String,countTitle:String,tvNumberOfRowsInSection:@escaping (_ tableView: UITableView, _ section: Int) -> Int,tvCellForRowAt:@escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell,tvDidSelectRowAt:@escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> UIViewController {
        let svc = UIViewController.init()
        svc.title = title
        let tableView = BaseTableView.init()
        
        //背景图片
        let backView = UIView.init(frame: CGRect(x: 0.0, y: MAIN_SCREEN_HEIGHT - NAV_HEIGHT - 41, width: svc.view.frame.size.width, height: 41.0))
        backView.backgroundColor = .black
        backView.alpha = 0.5
        
        let lbSum = UILabel.init(frame: CGRect(x: 15.0, y: MAIN_SCREEN_HEIGHT - NAV_HEIGHT - 41, width: svc.view.frame.size.width, height: 41.0))
        lbSum.textColor = .white
        lbSum.font = kFont_Big
        lbSum.backgroundColor = .clear
        if lableTitle == "" {
            lbSum.isHidden = true
            backView.isHidden = true
        }else{
            lbSum.text = lableTitle
        }
        
        let lbCount = UILabel.init(frame: CGRect(x: svc.view.frame.size.width/2, y: MAIN_SCREEN_HEIGHT - NAV_HEIGHT - 41, width: svc.view.frame.size.width/2-15, height: 41.0))
        lbCount.textColor = .white
        lbCount.font = kFont_Big
        lbCount.backgroundColor = .clear
        lbCount.textAlignment = .right
        if countTitle == ""{
            lbCount.isHidden = true
        }else{
            lbCount.text = countTitle
        }
        
        svc.reactive.signal(for: #selector(UIViewController.viewWillAppear(_:))).observe { (event) in
            svc.view.backgroundColor = .white
            svc.view.addSubview(tableView)
            tableView.reloadData()
            svc.view.addSubview(backView)
            svc.view.addSubview(lbSum)
            svc.view.addSubview(lbCount)
        }
        
        tableView.tvNumberOfRowsInSection = tvNumberOfRowsInSection
        tableView.tvCellForRowAt = tvCellForRowAt
        tableView.tvDidSelectRowAt = tvDidSelectRowAt
        return svc
    }
}
