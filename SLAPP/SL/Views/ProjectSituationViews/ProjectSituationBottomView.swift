//
//  ProjectSituationBottomView.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

enum bottomType {
    case up
    case down
    case other
}

class ProjectSituationBottomView: UIView {

     var isAuth:Bool = false
    //点击
    var click:(_ type:bottomType)->() = {_ in 
        
    }
    let image = UIImageView()
    let lab = UILabel()
    var type:bottomType?{
        didSet{
            DLog(self.isAuth)
            DLog(type)
            DLog("查看权限-------------------")
            if type == .up {
               
               btn.setTitle("花5分钟时间，给项目做一次体检?", for:.normal)
              btn.backgroundColor = UIColor.red
              lab.text = "只显示基本信息"
                btn.isHidden = !self.isAuth
                
            }else if type == .down{
                
               btn.setTitle("花5分钟时间，给项目做一次体检?", for:.normal)
                btn.backgroundColor = UIColor.red
                lab.text = "填写更多信息"
                btn.isHidden = !self.isAuth
            }else{
               btn.setTitle("更新项目概况", for:.normal)
               btn.isHidden = true  
               btn.backgroundColor = kGreenColor
                self.topView.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
                lab.text = ""
                image.image = nil
                self.topView.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
                self.btn.snp.updateConstraints({[weak topView] (make) in
                     make.top.equalTo((topView?.snp.bottom)!).offset(50)
                })
            }
           
            
            
            
        }
        
    }
    
    
    let topView = UIView()
    let btn = UIButton.init(type: .custom)
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(70)
        }
        
       
        topView.addSubview(image)
        image.image = UIImage.init(named: "pstUp")
        image.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(25)
        }
        
        
        topView.addSubview(lab)
//        lab.text = "填写更多信息"
        lab.textAlignment = .center
        lab.snp.makeConstraints {[weak image] (make) in
            make.top.equalTo((image?.snp.bottom)!)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(20)
        }
        
        
        let upBtn = UIButton.init(type: .custom)
        topView.addSubview(upBtn)
        upBtn.snp.makeConstraints {(make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
         upBtn.addTarget(self, action: #selector(upclick), for: .touchUpInside)
        
        self.addSubview(btn)
        btn.snp.makeConstraints { [weak topView](make) in
            make.top.equalTo((topView?.snp.bottom)!)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(49)
        }
        btn.addTarget(self, action: #selector(otherclick), for: .touchUpInside)
    }
    
    
    @objc func otherclick(){
        self.click(.other)
    }
    
    @objc func upclick(){
        self.click(self.type!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
