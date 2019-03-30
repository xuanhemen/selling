//
//  ContactAddNameCell.swift
//  SLAPP
//
//  Created by rms on 2018/3/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ContactAddNameCell: ContactAddBaseCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        bgView.mas_updateConstraints { (make) in
            make!.right.equalTo()(-LEFT_PADDING - 35)
        }
        
        detailTf.mas_updateConstraints { (make) in
            make!.right.equalTo()(-LEFT_PADDING - 10)
        }
        let imgV = UIImageView()
        imgV.image = UIImage.init(named: "*")
        self.bgView.addSubview(imgV)
        imgV.mas_makeConstraints { [unowned self](make) in
            make!.right.equalTo()(-10)
            make!.centerY.equalTo()(self.bgView)
            make!.size.equalTo()(CGSize.init(width: 10, height: 10))
        }
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        self.contentView.addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalTo(0)
            make.width.equalTo(35)
        }
        
        let userBtn = UIButton()
        userBtn.setImage(#imageLiteral(resourceName: "qf_phoneC"), for: .normal)
        userBtn.addTarget(self, action: #selector(userBtnClick), for: .touchUpInside)
        self.contentView.addSubview(userBtn)
        userBtn.mas_updateConstraints { [unowned self](make) in
            make!.right.equalTo()(-LEFT_PADDING-5)
            make!.centerY.equalTo()(self.bgView)
            make!.size.equalTo()(CGSize.init(width: 30, height: 30))
        }
        
        
    }
    @objc func userBtnClick(button:UIButton) {
        
        if self.userBtnClickBlock != nil{
            self.userBtnClickBlock!()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
