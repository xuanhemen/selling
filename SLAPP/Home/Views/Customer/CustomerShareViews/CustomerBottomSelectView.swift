//
//  CustomerBottomSelectView.swift
//  SLAPP
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CustomerBottomSelectView: UIView {

    var myTag: Int = 0
        
    
    var subArray = Array<CustomerBottomSubView>()
    var titleArray = ["我自己","全公司","指定部门及人员"]
    var selectChange:(_ isSelect:Bool)->() = {_ in
        
    }
    
    var editClick:()->() = {
        
    }
    
    func configTag(tag:Int){
        myTag = tag
        self.isSelect()
        self.selectChange(false)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if UserModel.getUserModel().ismanager != "1" {
            titleArray[2] = "本部门"
        }
        
        self.configUI()
        
    }
    
    func configUI(){
        
        let iconImage = UIImageView.init(frame: CGRect(x: 15, y: 10, width: 17, height: 19))
        iconImage.image = #imageLiteral(resourceName: "shareIcon")
        self.addSubview(iconImage)
        
        nameLable.frame = CGRect(x: 50, y: 10, width: 100, height: 20)
        nameLable.text = "参与人:"
        self.addSubview(nameLable)
        
        
        for i in 0...2 {
            let select = CustomerBottomSubView.init(frame: CGRect(x: 0, y:40*CGFloat(i)+40, width: frame.size.width, height: 40))
            self.addSubview(select)
            select.tag = i
            select.nameLable.text = titleArray[i]
            select.clickWithTag = { [weak self](tag)in
                self?.myTag = tag
                self?.isSelect()
                
                if UserModel.getUserModel().ismanager != "1" {
                    self?.selectChange(false)
                    select.editBtn.isHidden = true
                }else{
                    self?.selectChange(true)
                    select.editBtn.isHidden =  self?.myTag != 2
                }
                
               
            }
            select.editClick = { [weak self] in
                self?.editClick()
            }
            
            if i == 0 {
                select.isSelect = true
            }
            
            subArray.append(select)
        }
    }
    
    func isSelect(){
        for sub in subArray {
            sub.isSelect =  sub.tag == myTag
            if self.myTag == 2 && sub.tag == 2{
                if UserModel.getUserModel().ismanager != "1" {
                    sub.editBtn.isHidden = true
                }else{
                    sub.editBtn.isHidden =  self.myTag != 2
                }
                
            }else{
                sub.editBtn.isHidden = true
            }
        }
        
    }
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 17)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CustomerBottomSubView: UIView {
//    situationCellmarkNomal
    var isSelect:Bool = false {
        didSet{
           if isSelect == false{
                headImage.image = #imageLiteral(resourceName: "situationCellmarkNomal")
            }else{
                headImage.image = #imageLiteral(resourceName: "situationCellmarkSelect")
            }
        }
    }
    
    var clickWithTag:(_ tag:Int)->() = { _ in
        
    }
    
    var editClick:()->() = {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(headImage)
        self.addSubview(nameLable)
        self.addSubview(btn)
        self.addSubview(editBtn)
        
        headImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.height.width.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.top.equalTo(0)
            make.left.equalTo((headImage?.snp.right)!).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(0)
        }
        
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        editBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-40)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        editBtn.isHidden = true
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        editBtn.setTitle("编辑", for: .normal)
//        editBtn.isEnabled = false
        editBtn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        editBtn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
    }
    
    @objc func btnClick(){
        clickWithTag(self.tag)
    }
    
    @objc func editBtnClick(){
        editClick()
    }
    
    lazy var btn = { () -> UIButton in
        let b = UIButton.init(type: .custom)
        return b
    }()
    
    
    lazy var editBtn = { () -> UIButton in
        let b = UIButton.init(type: .custom)
        return b
    }()
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "situationCellmarkNomal")
        return image
    }()
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
