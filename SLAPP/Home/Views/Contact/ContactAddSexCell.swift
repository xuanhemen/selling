//
//  ContactAddSexCell.swift
//  SLAPP
//
//  Created by rms on 2018/3/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ContactAddSexCell: ContactAddBaseCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bgView.backgroundColor = UIColor.clear
        detailTf.isHidden = true
        
        maleBtn = UIButton()
        maleBtn.addTarget(self, action: #selector(sexBtnClick), for: .touchUpInside)
        maleBtn.setImage(UIImage.init(named: "circle_normal"), for: .normal)
        maleBtn.setImage(UIImage.init(named: "circle_select"), for: .selected)
        maleBtn.setTitle("男", for: .normal)
        maleBtn.setTitleColor(UIColor.black, for: .normal)
        self.contentView.addSubview(maleBtn)
        self.selectSexBtn = maleBtn
        self.selectSexBtn.isSelected = true
        
        femaleBtn = UIButton()
        femaleBtn.addTarget(self, action: #selector(sexBtnClick), for: .touchUpInside)
        femaleBtn.setImage(UIImage.init(named: "circle_normal"), for: .normal)
        femaleBtn.setImage(UIImage.init(named: "circle_select"), for: .selected)
        femaleBtn.setTitle("女", for: .normal)
        femaleBtn.setTitleColor(UIColor.black, for: .normal)
        self.contentView.addSubview(femaleBtn)
        
        maleBtn.mas_updateConstraints { [unowned self](make) in
            make!.left.equalTo()(self.titleLb.mas_right)?.offset()(5)
            make!.centerY.equalTo()(self.bgView)
            make!.size.equalTo()(CGSize.init(width: 50, height: 30))
        }
        femaleBtn.mas_updateConstraints { [unowned self](make) in
            make!.left.equalTo()(maleBtn.mas_right)?.offset()(10)
            make!.centerY.equalTo()(self.bgView)
            make!.size.equalTo()(CGSize.init(width: 50, height: 30))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func sexBtnClick(button:UIButton) {
        if button.isSelected == true{
            return
        }else{
            button.isSelected = true
            if self.selectSexBtn != nil{
                self.selectSexBtn.isSelected = false
            }
            self.selectSexBtn = button
        }  
        if self.sexChangeBlock != nil{
            self.sexChangeBlock!((self.selectSexBtn.titleLabel?.text)!)
        }
    }
}
