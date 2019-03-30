//
//  VipDetailView.swift
//  SLAPP
//
//  Created by rms on 2018/2/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class VipDetailView: UIView {

    var detailLb : UILabel!
    /// 续费按钮点击事件的回调
    var continueBtnClickBlock : (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        detailLb = UILabel.init()
        detailLb.textColor = UIColor.darkGray
        detailLb.font = kFont_Middle
        detailLb.text = "会员期: 2017.07.08 ~ 2018.07.08"
    
        self.addSubview(detailLb)
        
        let continueBtn = UIButton.init(frame: CGRect.init(x: frame.size.width - 80, y: 5, width: 50, height: 40))
        continueBtn.addTarget(self, action: #selector(continueBtnClick), for: .touchUpInside)
        continueBtn.backgroundColor = kOrangeColor
        continueBtn.layer.cornerRadius = 5
        continueBtn.layer.masksToBounds = true
        continueBtn.setTitle("续费", for: .normal)
        continueBtn.setTitleColor(UIColor.white, for: .normal)
        continueBtn.titleLabel?.font = kFont_Middle
        
        self.addSubview(continueBtn)
        
        detailLb.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(LEFT_PADDING)
        }
        continueBtn.mas_makeConstraints { [unowned self](make) in
            make!.right.equalTo()(-LEFT_PADDING)
            make!.centerY.equalTo()(self.detailLb)
            make!.size.equalTo()(CGSize.init(width: 60, height: 35))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func continueBtnClick(btn: UIButton){
        
        if self.continueBtnClickBlock != nil{
            
            self.continueBtnClickBlock!()
        }
    }

}
