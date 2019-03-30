//
//  PersonalHeaderView.swift
//  SLAPP
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class PersonalHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        self.addSubview(leftLable)
        self.addSubview(rightLable)
        self.addSubview(centerLable)
        

        
        leftLable.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(centerLable.snp.left)
            make.width.equalTo(centerLable)
        }
        
        centerLable.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(rightLable.snp.left)
            make.left.equalTo(leftLable.snp.right)
            make.width.equalTo(rightLable)
        }
        
        
        rightLable.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalToSuperview().offset(0)
            make.left.equalTo(centerLable.snp.right)
            make.width.equalTo(leftLable)
        }
        
    }
    
    
    
    lazy var leftLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    
    lazy var centerLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.textAlignment = .left
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    
    lazy var rightLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.textAlignment = .right
        lable.textColor = UIColor.lightGray
        return lable
    }()
}
