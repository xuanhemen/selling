//
//  SelectTradeView.swift
//  SLAPP
//
//  Created by rms on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SelectTradeView: UIView {

    var selectBtn1 : UIButton!
    var selectBtn2 : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
     
        let bgView1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: (frame.size.width - 15)/3*2, height: frame.size.height))
        bgView1.backgroundColor = UIColor.white
        self.addSubview(bgView1)
        let headerImgV = UIImageView.init(frame: CGRect.init(x: 15, y: 15, width: 20, height: 20))
        headerImgV.image = UIImage.init(named: "cTrade")
        let titleLb = UILabel.init()
        titleLb.font = kFont_Big
        titleLb.textColor = UIColor.black
        titleLb.text = "所属行业:"
        titleLb.sizeToFit()
        titleLb.frame = CGRect.init(x: 40, y: 5, width: titleLb.frame.size.width, height: 40)
        
        selectBtn1 = UIButton.init(frame: CGRect.init(x: 45 + titleLb.frame.size.width, y: 5, width: (frame.size.width - 15)/3*2 - titleLb.frame.size.width - 45, height: 40))
        selectBtn1.tag = 10
        selectBtn1.setTitle("请选择", for: .normal)
        selectBtn1.titleLabel?.font = kFont_Big
        selectBtn1.setTitleColor(UIColor.lightGray, for: .normal)
        
        selectBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
        selectBtn1.contentHorizontalAlignment = .left
        
        let imgV1 = UIImageView.init(frame: CGRect.init(x: selectBtn1.frame.size.width - 20, y: 15, width: 10, height: 10))
        imgV1.image = UIImage.init(named: "cSanjiao")
        selectBtn1.addSubview(imgV1)
        bgView1.addSubview(headerImgV)
        bgView1.addSubview(titleLb)
        bgView1.addSubview(selectBtn1)
        
        let bgView2 = UIView.init(frame: CGRect.init(x: bgView1.frame.size.width + 15, y: 0, width: (frame.size.width - 15)/3*1, height: frame.size.height))
        bgView2.backgroundColor = UIColor.white
        selectBtn2 = UIButton.init(frame: CGRect.init(x: 0, y: 5, width: bgView2.frame.size.width, height: 40))
        selectBtn2.tag = 11
        selectBtn2.setTitle("请选择", for: .normal)
        selectBtn2.titleLabel?.font = kFont_Big
        selectBtn2.setTitleColor(UIColor.lightGray, for: .normal)
        selectBtn2.imageView?.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        selectBtn2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
        selectBtn2.contentHorizontalAlignment = .left
        let imgV2 = UIImageView.init(frame: CGRect.init(x: selectBtn2.frame.size.width - 20, y: 15, width: 10, height: 10))
        imgV2.image = UIImage.init(named: "cSanjiao")
        selectBtn2.addSubview(imgV2)
        bgView2.addSubview(selectBtn2)
        self.addSubview(bgView2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
