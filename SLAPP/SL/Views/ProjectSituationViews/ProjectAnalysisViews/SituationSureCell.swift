//
//  SituationSureCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SituationSureCell: SituationAndFlowCell {
    
    var click:()->() = {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        table.removeFromSuperview()
        nameLable.text = "点击确定提交"
        
        let btn = UIButton.init(type: .custom)
        self.contentView.addSubview(btn)
        btn.backgroundColor = kGreenColor
        btn.setTitle("确定", for: .normal)
        btn.layer.cornerRadius = 6
        btn.clipsToBounds = true
        btn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func btnClick(){
        click()
    }
    
}
