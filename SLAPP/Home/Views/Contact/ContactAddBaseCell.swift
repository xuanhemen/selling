//
//  ContactAddBaseCell.swift
//  SLAPP
//
//  Created by rms on 2018/3/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ContactAddBaseCell: UITableViewCell,UITextFieldDelegate {

    @objc var bgView : UIView!
    @objc var titleLb : UILabel!
    @objc var detailTf : UITextField!
    var selectSexBtn : UIButton!
    var tradeView : SelectTradeView!
    var maleBtn : UIButton!
    var femaleBtn : UIButton!
    var textChangeBlock:((_ text:String) -> ())?
    @objc var companyBtnClickBlock:(() -> ())?
    @objc var userBtnClickBlock:(() -> ())?
    @objc var sexChangeBlock:((_ text:String) -> ())?
    /// 选择行业按钮点击事件的回调
    @objc var selectTradeBtnClickBlock : ((_ btn: UIButton) -> (String))?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bgView)
        
        titleLb = UILabel()
        titleLb.textColor = UIColor.black
        titleLb.font = kFont_Middle
        bgView.addSubview(titleLb)
        
        detailTf = UITextField()
        detailTf.delegate = self
        detailTf.font = kFont_Middle
        bgView.addSubview(detailTf)
        
        bgView.mas_makeConstraints { (make) in
            make!.top.equalTo()(0)
            make!.left.equalTo()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.bottom.equalTo()(self)
        }
        titleLb.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.bgView)
            make!.left.equalTo()(LEFT_PADDING)
            make!.width.equalTo()(140)
        }
        detailTf.snp.makeConstraints { [weak self](make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo((self?.titleLb.snp.right)!).offset(5)
            make.right.equalTo(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.textChangeBlock != nil{
            self.textChangeBlock!(textField.text!)
        }
    }
}
