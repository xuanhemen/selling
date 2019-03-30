//
//  AddCustomerView.swift
//  SLAPP
//
//  Created by rms on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AddCustomerView: UIView {

    var nameView : AddCustomerCell!
    var tradeView : SelectTradeView!
    
    //QF -- 修改新增客户时 选择手机通讯录联系人
    var contactView : AddCustomerCell!
    let userBtn = UIButton()
    var userBtnClickBlock:(() -> ())?
    
    var positionView : AddCustomerCell!
    var telView : AddCustomerCell!
    var cancleBtn : UIButton!
    var saveBtn : UIButton!
    /// 选择行业按钮点击事件的回调
    var selectTradeBtnClickBlock : ((_ btn: UIButton) -> (String))?
    /// 取消按钮点击事件的回调
    var cancleBtnClickBlock : (()->())?
    /// 保存按钮点击事件的回调
    var saveBtnClickBlock : (()->())?
    
    var textChanged:(_ text:String) -> () = {_ in }
    var showTable:(_ isShow:Bool) -> () = {_ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        
        
        
        nameView = AddCustomerCell.init(modelArr: ["cName","客户名称:","请输入客户名称"], frame: CGRect.init(x: 15, y: 20, width: MAIN_SCREEN_WIDTH - 30, height: 50))
        
        
        
        
        nameView.textChanged = { [weak self] (text) in
            self?.textChanged(text)
        }
        nameView.showTable = { [weak self] (isShow) in
            self?.showTable(isShow)
        }
        
        tradeView = SelectTradeView.init(frame: CGRect.init(x: 15, y: 40 + 50, width: MAIN_SCREEN_WIDTH - 30, height: 50))
        
        tradeView.selectBtn1.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
        tradeView.selectBtn2.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)

        contactView = AddCustomerCell.init(modelArr: ["cPeople","联系人:","请输入联系人姓名"], frame: CGRect.init(x: 15, y: 60 + 50 * 2, width: MAIN_SCREEN_WIDTH - 70, height: 50))

        positionView = AddCustomerCell.init(modelArr: ["cPosition","职务:","请输入职务名称"], frame: CGRect.init(x: 15, y: 80 + 50 * 3, width: MAIN_SCREEN_WIDTH - 30, height: 50))

        telView = AddCustomerCell.init(modelArr: ["cPhone","联系电话:","请输入您的电话号码"], frame: CGRect.init(x: 15, y: 100 + 50 * 4, width: MAIN_SCREEN_WIDTH - 30, height: 50))

        cancleBtn = UIButton.init(frame: CGRect.init(x: 0, y: frame.size.height - NAV_HEIGHT - 40, width: frame.size.width * 0.5, height: 40))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.backgroundColor = UIColor.gray
        cancleBtn.addTarget(self, action:  #selector(cancleBtnClick), for: .touchUpInside)
        saveBtn = UIButton.init(frame: CGRect.init(x: frame.size.width * 0.5, y: frame.size.height - NAV_HEIGHT - 40, width: frame.size.width * 0.5, height: 40))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.backgroundColor = UIColor.init(hexString: "30b475")
        saveBtn.addTarget(self, action:  #selector(saveBtnClick), for: .touchUpInside)
        self.addSubview(nameView)
        self.addSubview(tradeView)
        self.addSubview(contactView)
        self.addSubview(positionView)
        self.addSubview(telView)
//        self.addSubview(cancleBtn)
//        self.addSubview(saveBtn)
        
        self.addSubview(userBtn)
        userBtn.setImage(#imageLiteral(resourceName: "qf_phoneC"), for: .normal)
        userBtn.addTarget(self, action: #selector(userBtnClick), for: .touchUpInside)
        userBtn.mas_updateConstraints { [unowned self](make) in
            make!.right.equalTo()(-15)
            make!.centerY.equalTo()(self.contactView)
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
    
    //根据客户信息  赋值
    func configWithModel(model:Dictionary<String,Any>){
        
//        let modelArr1 = [modelDic!["trade_first_name"] is NSNull ? "" : (modelDic!["trade_first_name"] as! String + (modelDic!["trade_name"] is NSNull ? "" : ("/" + (modelDic!["trade_name"]  as! String)))),
//                         "项目数:" + (modelDic!["pro_num"] is NSNumber ? String(describing: modelDic!["pro_num"] as! NSNumber) : modelDic!["pro_num"] as! String),
//                         "项目总金额:" + (modelDic!["pro_amount"] is NSNumber ? String(describing: modelDic!["pro_amount"] as! NSNumber) : modelDic!["pro_amount"] as! String) + "万",
//                         "创建者:  " + (modelDic!["realname"] is NSNull ? "" : modelDic!["realname"] as! String),
//                         "所属人: " + ((modelDic!["member"] == nil || modelDic!["member"] is NSNull) ? "" : modelDic!["member"] as! String),
//                         "创建时间: " + (modelDic!["addtime"] is NSNull ? "" : modelDic!["addtime"] as! String)
//        ]
        
        nameView.inputTf.text = model["name"] as! String
        telView.inputTf.text = "123123123"
        telView.inputTf.isEnabled = false
        telView.isHidden = true
        telView.inputTf.textColor = KColorRight
        positionView.inputTf.text = "职务"
        positionView.inputTf.isEnabled = false;
        positionView.isHidden = true
        positionView.inputTf.textColor = KColorRight
        contactView.inputTf.text = "123"
        contactView.inputTf.isEnabled = false
        contactView.isHidden = true
        contactView.inputTf.textColor = KColorRight
        tradeView.selectBtn1.setTitle(model["trade_first_name"] is NSNull ? "请选择" : model["trade_first_name"] as! String, for: .normal)
        tradeView.selectBtn2.setTitle(model["trade_name"] is NSNull ? "请选择" : model["trade_name"] as! String, for: .normal)
        
        
    }
    
    @objc func selectBtnClick(btn:UIButton)  {
        if self.selectTradeBtnClickBlock != nil {
            if btn.tag == 10{
                 tradeView.selectBtn1.setTitle(self.selectTradeBtnClickBlock!(btn), for: .normal)
            }
            if btn.tag == 11{
                tradeView.selectBtn2.setTitle(self.selectTradeBtnClickBlock!(btn), for: .normal)
            }
        }
    }
    @objc func saveBtnClick(btn:UIButton)  {
        if self.saveBtnClickBlock != nil {
            self.saveBtnClickBlock!()
        }
    }
    @objc func cancleBtnClick(btn:UIButton)  {
        if self.cancleBtnClickBlock != nil {
            self.cancleBtnClickBlock!()
        }
    }
    
    
    
    
}
