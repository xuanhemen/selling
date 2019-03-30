//
//  ProjectSituationHeader.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProjectSituationHeader: UIView {

    //1编辑  0就是普通点击
    var click:(_ type:Int)->() = {_ in
        
    }
   let editBtn = UIButton.init(type: .custom)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        self.backgroundColor = UIColor.groupTableViewBackground
        let back = UIView()
        self.addSubview(back)
        back.backgroundColor = UIColor.white
        back.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(40)
        }
        headImage.image = UIImage.init(named: "pstArrow")
        back.addSubview(nameLable)
        back.addSubview(headImage)
        
        
//        nameLable.text = "12123"
        
        nameLable.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(15)
            make.width.equalTo(200)
            make.bottom.equalTo(0)
        }
        
        headImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(10)
            make.width.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        let btn = UIButton.init(type: .custom)
        back.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        
        editBtn.setImage(UIImage.init(named: "projectS-Nomal0"), for: .normal)
        back.addSubview(editBtn)
        editBtn.snp.makeConstraints {[weak headImage] (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo((headImage?.snp.left)!).offset(-20)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
//        editBtn.isHidden = true
        editBtn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
    }
    
    //编辑按钮
    @objc func editBtnClick(){
         self.click(1)
    }
    
    @objc func btnClick(){
        self.click(0)
    }
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
}
