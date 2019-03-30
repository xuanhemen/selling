//
//  QFTeacherExperienceVC.swift
//  SLAPP
//
//  Created by qwp on 2018/4/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class QFTeacherExperienceVC: UIViewController {

    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configUI() {
        self.title = "背景经历"
        scrollView.backgroundColor = HexColor("#f2f2f2")
        self.view.backgroundColor = HexColor("#f2f2f2")
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
        
    }

    func configSubUI(gongzuoArray:Array<QFExperienceModel>,jiaoyuArray:Array<QFExperienceModel>) {
        
        let backView = UIView()
        self.scrollView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT-64)
        }
        var lastHeight:CGFloat = 0
        var lastView:QFTeacherExperienceView?
        for model in gongzuoArray {
            let view = QFTeacherExperienceView()
            scrollView.addSubview(view)
            
            var height:CGFloat = 0
            if lastView == nil {
                height = view.setData(isShow: true, haveValue: true, isShowArrow: false, model: model)
            }else{
                height = view.setData(isShow: false, haveValue: true, isShowArrow: false, model: model)
            }
            view.snp.makeConstraints { (make) in
                if lastView == nil {
                    make.top.equalTo(15)
                }else{
                    make.top.equalTo((lastView?.snp.bottom)!).offset(1)
                }
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(height)
                make.width.equalTo(SCREEN_WIDTH-20)
            }
            if lastView == nil {
                lastHeight = lastHeight+height+15
            }else{
                lastHeight = lastHeight+height+1
            }
            
            lastView = view
        }
        
        
        for i in 0..<jiaoyuArray.count {
            let model = jiaoyuArray[i]
            
            let view = QFTeacherExperienceView()
            scrollView.addSubview(view)
            
            var height:CGFloat = 0
            if lastView == nil {
                height = view.setData(isShow: true, haveValue: true, isShowArrow: false, model: model)
            }else{
                if i == 0 {
                    height = view.setData(isShow: true, haveValue: true, isShowArrow: false, model: model)
                }else{
                    height = view.setData(isShow: false, haveValue: true, isShowArrow: false, model: model)
                }
            }
            view.snp.makeConstraints { (make) in
                if lastView == nil {
                    make.top.equalTo(15)
                }else{
                    if i==0 {
                        make.top.equalTo((lastView?.snp.bottom)!).offset(15)
                    }else{
                        make.top.equalTo((lastView?.snp.bottom)!).offset(1)
                    }
                }
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(height)
                make.width.equalTo(SCREEN_WIDTH-20)
            }
            
            if lastView == nil {
                lastHeight = lastHeight+height+15
            }else{
                if i==0 {
                    lastHeight = lastHeight+height+15
                }else{
                    lastHeight = lastHeight+height+1
                }
            }
            
            lastView = view
        }
        backView.snp.remakeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(lastHeight+15)
        }
        
        
    }
    
}

