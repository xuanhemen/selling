//
//  ContactAddBaseNoImgCell.swift
//  SLAPP
//
//  Created by 柴进 on 2018/4/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ContactAddBaseNoImgCell: ContactAddBaseCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bgView)
        
        titleLb = UILabel()
        titleLb.textColor = UIColor.black
        titleLb.font = kFont_Big
        bgView.addSubview(titleLb)
        
        detailTf = UITextField()
        detailTf.delegate = self
        bgView.addSubview(detailTf)
        
        bgView.mas_makeConstraints { (make) in
            make!.left.top().equalTo()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.bottom.equalTo()(self)
        }
        titleLb.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.bgView)
            make!.left.equalTo()(LEFT_PADDING)
            make!.width.equalTo()(80)
        }
        detailTf.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.bgView)
            make!.left.equalTo()(self.titleLb.mas_right)?.offset()(5)
            make!.right.equalTo()(-LEFT_PADDING)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
