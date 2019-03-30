//
//  ContactAddCompanyCell.swift
//  SLAPP
//
//  Created by rms on 2018/3/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ContactAddCompanyCell: ContactAddBaseCell {

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        bgView.mas_updateConstraints { (make) in
            make!.right.equalTo()(-LEFT_PADDING - 35)
        }
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        self.contentView.addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalTo(0)
            make.width.equalTo(35)
        }
        let companyBtn = UIButton()
        companyBtn.setImage(UIImage.init(named: "contact_company"), for: .normal)
        companyBtn.addTarget(self, action: #selector(companyBtnClick), for: .touchUpInside)
        self.contentView.addSubview(companyBtn)
        companyBtn.mas_updateConstraints { [unowned self](make) in
            make!.right.equalTo()(-LEFT_PADDING-5)
            make!.centerY.equalTo()(self.bgView)
            make!.size.equalTo()(CGSize.init(width: 30, height: 30))
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func companyBtnClick(button:UIButton) {
     
        if self.companyBtnClickBlock != nil{
            self.companyBtnClickBlock!()
        }
    }
}
