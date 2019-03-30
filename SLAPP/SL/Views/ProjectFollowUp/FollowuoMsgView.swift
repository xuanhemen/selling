//
//  FollowuoMsgView.swift
//  SLAPP
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class FollowuoMsgView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kGrayColor_Slapp2
        self.configUI()
        self.layer.cornerRadius = 6
    }
    
    
   @objc var click:()->() = {
        
    }
    
  @objc  func setHeadStr(head:String){
         headImage.setImageWith(url: head, imageName: "mine_avatar")
    }
    
    
    func configUI(){
        self.addSubview(headImage)
        self.addSubview(nameLable)
        self.addSubview(markImage)
        
        
        
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.height.equalTo(30)
        }
        
        nameLable.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(headImage.snp.right).offset(10)
            make.right.equalTo(markImage.snp.left).offset(-10)
            make.height.equalTo(20)
        }
        
        markImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(15)
        }
        
        
        let btn = UIButton.init(type: .custom)
        self.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        btn.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
    }
    
    
    @objc func btnclick(){
        click()
       self.removeFromSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
  @objc  lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textAlignment = .center
        lable.textColor = UIColor.white
        return lable
    }()
    
    lazy var markImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "arrowWhite")
        return image
    }()
    
}
