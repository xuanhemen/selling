//
//  AddCustomerCell.swift
//  SLAPP
//
//  Created by rms on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AddCustomerCell: UIView,UITextFieldDelegate {

    var headerImgV: UIImageView!
    var titleLb: UILabel!
    var inputTf: UITextField!
    
//    var text : String = ""
    
    var textChanged:(_ text:String) -> () = {_ in }
    var showTable:(_ isShow:Bool) -> () = {_ in }
    
    convenience init(modelArr : Array<String>, frame : CGRect) {
        self.init()
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.frame = frame
        
        headerImgV = UIImageView.init()
        headerImgV.image = UIImage.init(named: modelArr[0])
        titleLb = UILabel.init()
        titleLb.font = kFont_Big
        titleLb.textColor = UIColor.black
        titleLb.text = modelArr[1]
        titleLb.sizeToFit()
        inputTf = UITextField.init()
        inputTf.delegate = self
        inputTf.addTarget(self, action: #selector(senderValueChanged), for: .editingChanged)
        inputTf.placeholder = modelArr[2]
        inputTf.font = kFont_Big
        self.addSubview(headerImgV)
        self.addSubview(titleLb)
        self.addSubview(inputTf)
        
//        inputTf.reactive.continuousTextValues.observeValues { (text) in
//            self.text = text!
//        }
        
        
        headerImgV.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 20, height: 20))
        }
        
        titleLb.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(self.headerImgV.mas_right)?.offset()(5)
            make!.width.equalTo()(self.titleLb.frame.size.width)
        }
        inputTf.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(self.titleLb.mas_right)?.offset()(5)
            make!.right.equalTo()(-LEFT_PADDING)
        }
    }
    

    var model : Array<String>!{
        didSet{
           
        }
    }
    @objc func senderValueChanged(_ textField:UITextField) {
        if textField.placeholder == "请输入客户名称" {
            self.textChanged(textField.text!)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.placeholder == "请输入客户名称" {
            self.showTable(true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == "请输入客户名称" {
            self.showTable(false)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.placeholder == "请输入客户名称" {
            self.showTable(false)
        }

        textField.resignFirstResponder()

        return true
    }
    
    
}
