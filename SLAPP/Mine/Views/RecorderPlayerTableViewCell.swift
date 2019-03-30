//
//  RecorderPlayerTableViewCell.swift
//  SLAPP
//
//  Created by 柴进 on 2018/2/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class RecorderPlayerTableViewCell: UITableViewCell {
    var phoneNum:IndexPath?
    var onPlayCall:(IndexPath?)->() = {a in}
    var onDelCall:(IndexPath?)->() = {a in}
    
    
    let rImage = UIImageView()
    let headerImage = UIButton()
    let lbContactName = UILabel()
    let lbPosition = UILabel()
    let lbCompany = UILabel()
    let btnCall = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        headerImage.layer.cornerRadius = 25
//        headerImage.layer.masksToBounds = true
        lbContactName.font = kFont_Big
        lbContactName.textColor = UIColor.black
        lbPosition.font = kFont_Big
        lbPosition.textColor = UIColor.gray
        lbCompany.font = kFont_Middle
        lbCompany.textColor = UIColor.gray
        
        let backView = UIView.init()
        
        self.contentView.addSubview(backView)
        self.contentView.addSubview(btnCall)
        self.contentView.addSubview(headerImage)
        self.contentView.addSubview(lbContactName)
        self.contentView.addSubview(lbPosition)
        self.contentView.addSubview(lbCompany)
        self.contentView.addSubview(rImage)
        
        backView.mas_makeConstraints { [unowned self](make) in
            make!.top.left().equalTo()(LEFT_PADDING/2)
            make!.right.bottom().equalTo()(-LEFT_PADDING/2)
        }
        backView.backgroundColor = .white
        self.backgroundColor = UIColor.groupTableViewBackground
        
        rImage.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(LEFT_PADDING/2)
            make!.size.equalTo()(CGSize.init(width: 60, height: 60))
        }
        rImage.image = UIImage.init(named: "mrGreen")
        
        headerImage.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.right.equalTo()(btnCall.mas_left)?.valueOffset()(-LEFT_PADDING as NSValue)
            make!.size.equalTo()(CGSize.init(width: 30, height: 30))
        }
        headerImage.setBackgroundImage(UIImage(named:"mrPlay"), for: .normal)
//        headerImage.setBackgroundImage(UIImage(named:"customer_call_selected"), for: .highlighted)
        headerImage.reactive.controlEvents(.touchUpInside).observe {[weak self] (event) in
            self?.onPlayCall(self?.phoneNum)
        }
        
        lbContactName.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.headerImage)?.valueOffset()(-8 as NSValue)
            make!.left.equalTo()(rImage.mas_right)?.offset()(LEFT_PADDING)
        }
        lbPosition.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.lbCompany)
            make!.left.equalTo()(self.lbCompany.mas_right)?.offset()(LEFT_PADDING)
        }
        lbCompany.mas_makeConstraints { [unowned self](make) in
            make!.bottom.equalTo()(self.headerImage)?.valueOffset()(8 as NSValue)
            make!.left.equalTo()(rImage.mas_right)?.offset()(LEFT_PADDING)
        }
        btnCall.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 30, height: 30))
        }
        btnCall.setBackgroundImage(UIImage(named:"mrDelete"), for: .normal)
//        btnCall.setBackgroundImage(UIImage(named:"customer_call_selected"), for: .highlighted)
        btnCall.reactive.controlEvents(.touchUpInside).observe {[weak self] (event) in
            self?.onDelCall(self?.phoneNum)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
