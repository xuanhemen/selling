//
//  AVPlayerView.swift
//  SLAPP
//
//  Created by 柴进 on 2018/2/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AVPlayerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var phoneNum:IndexPath?
    var onPlayCall:(IndexPath?)->() = {a in}
    var onDelCall:(IndexPath?)->() = {a in}
    
    let headerImage = UIButton()
    let lbContactName = UILabel()
    let lbPosition = UILabel()
    let lbCompany = UILabel()
    let btnCall = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        
        headerImage.layer.cornerRadius = 25
        headerImage.layer.masksToBounds = true
        lbContactName.font = kFont_Big
        lbContactName.textColor = UIColor.black
        lbPosition.font = kFont_Big
        lbPosition.textColor = UIColor.gray
        lbCompany.font = kFont_Middle
        lbCompany.textColor = UIColor.gray
        self.addSubview(btnCall)
        
        self.addSubview(headerImage)
        self.addSubview(lbContactName)
        self.addSubview(lbPosition)
        self.addSubview(lbCompany)
        
        headerImage.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.right.equalTo()(btnCall.mas_left)?.valueOffset()(-LEFT_PADDING as NSValue)
            make!.size.equalTo()(CGSize.init(width: 50, height: 50))
        }
        headerImage.setBackgroundImage(UIImage(named:"rStop"), for: .normal)
//        headerImage.setBackgroundImage(UIImage(named:"customer_call_selected"), for: .highlighted)
        headerImage.reactive.controlEvents(.touchUpInside).observe {[weak self] (event) in
            self?.onPlayCall(self?.phoneNum)
        }
        
        lbContactName.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.headerImage)
            make!.left.equalTo()(LEFT_PADDING)
        }
        lbPosition.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.lbCompany)
            make!.left.equalTo()(self.lbCompany.mas_right)?.offset()(LEFT_PADDING)
        }
        lbCompany.mas_makeConstraints { [unowned self](make) in
            make!.bottom.equalTo()(self.headerImage)
            make!.left.equalTo()(LEFT_PADDING)
        }
        btnCall.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 50, height: 50))
        }
        btnCall.setBackgroundImage(UIImage(named:"rEnd"), for: .normal)
//        btnCall.setBackgroundImage(UIImage(named:"customer_call_selected"), for: .highlighted)
        btnCall.reactive.controlEvents(.touchUpInside).observe {[weak self] (event) in
            self?.onDelCall(self?.phoneNum)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
