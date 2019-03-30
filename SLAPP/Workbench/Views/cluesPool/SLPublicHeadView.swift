//
//  SLPublicHeadView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLPublicHeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let recycleBin = UIButton.init(type: UIButtonType.custom)
    let info = UILabel()
    let opetation = UIButton.init(type: UIButtonType.custom)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        recycleBin.setTitle("回收站", for: UIControlState.normal)
        recycleBin.backgroundColor = RGBA(R: 253, G: 144, B: 55, A: 1)
        recycleBin.setTitleColor(.white, for: UIControlState.normal)
        recycleBin.layer.masksToBounds = true
        recycleBin.layer.cornerRadius = 6
        recycleBin.titleLabel?.font = FONT_14
        self.addSubview(recycleBin)
        recycleBin.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        
//        info.text = "已领取线索数：0 / 0"
//        info.textColor = RGBA(R: 50, G: 50, B: 50, A: 1)
//        self.addSubview(info)
//        info.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
        
        opetation.setTitle("操作", for: UIControlState.normal)
        opetation.setTitleColor(SLGreenColor, for: UIControlState.normal)
        opetation.backgroundColor = UIColor.white
        opetation.titleLabel?.font = FONT_16
        self.addSubview(opetation)
        opetation.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
