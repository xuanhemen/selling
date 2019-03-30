//
//  AddCustomerVC.swift
//  SLAPP
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class AddCustomerVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //客户信息
    @objc var modelDic:Dictionary<String, Any>?
    
    var firsttrade = ("","")
    @objc var isSelectCome = false
    var secondtrade:(String,String)? = nil
    var addCustomerView = AddCustomerView()
    let shareView = CustomerShareCell.init(style: .default, reuseIdentifier: "cell");
    let tableView = UITableView.init(frame: CGRect(x: 10, y: 75, width: SCREEN_WIDTH-20, height: SCREEN_HEIGHT-NAV_HEIGHT-80), style: .plain)
    var dataArray:Array<Dictionary<String, Any>> = Array()
    
    @objc var needUpdate = {
        
    }
    @objc var customerNew = {(id:String,name:String,tradeId:String,tradeName:String) in
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增客户"
        self.view.backgroundColor = UIColor.white
        if modelDic == nil {
            self.umAnalyticsWithName(name: um_clientAdd)
            addCustomerView = AddCustomerView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 360))
        }else{
            self.umAnalyticsWithName(name: um_clientEdit)
            addCustomerView = AddCustomerView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 180))
            addCustomerView.userBtn.isHidden = true
        }
        
        let clientClickBtn = UIButton.init(type: .custom)
        clientClickBtn.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH - 30, height: 50)
        addCustomerView.nameView.addSubview(clientClickBtn)
        clientClickBtn.addTarget(self, action: #selector(clientClick), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notific:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        
        
        // Do any additional setup after loading the view.
        //添加客户接口
        //        self.addCustom()
        //        self.tradeList(parent_id: 0)
        
        //QF -- 通讯录选择联系人 
        addCustomerView.userBtnClickBlock = ({ [weak self] in
            let vc = SortAddressVC()
            vc.addContact = true
            vc.addUserBlock = { [weak self] (params,model) in
                let name = String.noNilStr(str: params["realname"])
                let phone = String.noNilStr(str: params["username"])
                self?.addCustomerView.contactView.inputTf.text = name
                self?.addCustomerView.telView.inputTf.text = phone
                
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        
        self.view.addSubview(backScroll)
        backScroll.addSubview(addCustomerView)
        self.view.addSubview(bottomView)
        
        
        shareView.frame = CGRect(x: 0, y: addCustomerView.max_Y, width: SCREEN_WIDTH, height: 170)
        shareView.frameHeightChanged = {[weak shareView,weak backScroll](h) in
            shareView?.frame = CGRect(x: 0, y: (shareView?.frame.origin.y)!, width: SCREEN_WIDTH, height: h)
            backScroll?.contentSize = CGSize.init(width: 0, height: (shareView?.max_Y)!)
        }
        backScroll.addSubview(shareView)
        backScroll.contentSize = CGSize.init(width: 0, height: shareView.max_Y)
        
        //
        bottomView.cancleBtnClickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        bottomView.saveBtnClickBlock = {[weak self] in
            self?.addCustom()
        }
        
        
        if self.modelDic != nil {
            addCustomerView.configWithModel(model: self.modelDic!)
            self.title = "修改客户"
            if modelDic!["trade_first_name"] is NSNull{
                self.firsttrade = ("","")
            }else{
                self.firsttrade = ((modelDic!["trade_first_id"] is NSNumber ? String(describing: modelDic!["trade_first_id"] as! NSNumber) : modelDic!["trade_first_id"] as! String),modelDic!["trade_first_name"] as! String)
            }
            if modelDic!["trade_name"] is NSNull{
                self.secondtrade = nil
            }else{
                self.secondtrade = ((modelDic!["trade_id"] is NSNumber ? String(describing: modelDic!["trade_id"] as! NSNumber) : modelDic!["trade_id"] as! String),modelDic!["trade_name"] as! String)
            }
            
            
            
            self.disposeDepAndMembers()
            
        }
        
        
        
        
        addCustomerView.selectTradeBtnClickBlock = ({(btn) in
            if btn.tag == 10 {
                self.tradeList(parent_id: "0", btnActions: { (action, key) in
                    if action.style != UIAlertActionStyle.cancel{
                        
                        self.firsttrade = (key,action.title!)
                        self.secondtrade = nil
                        self.addCustomerView.tradeView.selectBtn1.setTitle(action.title!, for: .normal)
                        self.addCustomerView.tradeView.selectBtn2.setTitle("请选择", for: .normal)
                    }
                })
                return self.firsttrade.1 != "" ? self.firsttrade.1 : "请选择"
            }else{
                if self.firsttrade.0 == ""{
                    return "请选择"
                }else{
                    self.tradeList(parent_id: self.firsttrade.0, btnActions: { (action, key) in
                        //                        self.firsttrade = (key,action.title!)
                        if action.style != UIAlertActionStyle.cancel{
                            
                            self.secondtrade = (key,action.title!)
                            self.addCustomerView.tradeView.selectBtn2.setTitle(action.title!, for: .normal)
                        }
                    })
                }
                
                
                return self.secondtrade != nil ? self.secondtrade!.1 : "请选择"
            }
        })
        
        
        addCustomerView.showTable = { [weak self] (isShow) in
            self?.tableView.isHidden = !isShow
        }
        //网络有问题 需要后期优化
        addCustomerView.textChanged = { [weak self] (text) in
            if text.count > 1 {
//                self?.searchCompany(text: text)
                print("text -- ",text)
            }else{
                self?.dataArray.removeAll()
                self?.tableView.reloadData()
            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        self.tableView.isHidden = true
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        
        
    }
    
    
    func disposeDepAndMembers(){
        
        if JSON(modelDic!["authorization_member"]).stringValue == "1" {
            //我自己
            shareView.nameLable.configTag(tag: 0)
        }
            
        else if JSON(modelDic!["authorization_corp"]).stringValue == "1" {
            //全公司
            shareView.nameLable.configTag(tag: 1)
        }else {
            //            if (JSON(modelDic!["client_dep"]).array?.count)!>0{
            //选择了部门
            
            
            var dataArray = Array<Dictionary<String,Array<BaseModel>>>()
            
            var dArray = Array<DepModel>()
            var mArray = Array<DepMemberModel>()
            
            for dic in JSON(modelDic!["client_dep"]).array!{
                let model = DepModel()
                model.id = dic["id"].stringValue
                model.name = dic["name"].stringValue
                dArray.append(model)
            }
            
            
            for dic in JSON(modelDic!["client_member"]).array!{
                let model = DepMemberModel()
                model.id = dic["id"].stringValue
                model.realname = dic["realname"].stringValue
                model.head = dic["head"].stringValue
                mArray.append(model)
            }
            
            dataArray.append(["dep":dArray])
            dataArray.append(["mem":mArray])
            shareView.dataArray = dataArray
                   //         shareView.collectionView.reloadData()
            shareView.nameLable.configTag(tag: 2)
            
        }
        
    }
    
    //获取行业
    func tradeList(parent_id:String,btnActions:@escaping (UIAlertAction,String)->()){
        
        //parent_id 0 是一级   查对应一一级的子集  传对应一级的id
        let params:Dictionary = ["parent_id":parent_id,"token":UserModel.getUserModel().token]
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: TRADE_LIST, params: params, hadToast: true, fail: { (dic) in
            
        }) { (dic) in
            PublicMethod.dismiss()
            DLog(dic)
            if dic["data"] is Array<Dictionary<String,Any>>{
                var btnDic = Dictionary<String,String>()
                for oneDic in dic["data"] as! Array<Dictionary<String,Any>>{
                    btnDic[String.noNilStr(str: oneDic["index_id"]!)] = String.noNilStr(str: oneDic["name"])
                }
                btnDic[kCancel] = "取消"
                let alertCont = UIAlertController.init(title: "一级行业", message: nil, preferredStyle: UIAlertControllerStyle.alert, btns: btnDic, btnActions: btnActions)
                self.present(alertCont, animated: true, completion: nil)
            }
        }
        
    }
    
    
    //添加客户
    func addCustom(){
        if self.modelDic != nil{
            if addCustomerView.nameView.inputTf.text == "" || firsttrade.0 == "" {
                self.present(UIAlertController.init(title: "对不起", message: "请填全所有内容，内容缺失不能保存", preferredStyle: UIAlertControllerStyle.alert, okAndCancel: ("知道了",""), btnActions: { (action, str) in
                }), animated: true, completion: nil)
                return
            }
            PublicMethod.showProgress()
            self.umAnalyticsWithName(name: um_clientEditSave)
            let result = shareView.resultParams()
            let params:Dictionary = ["clientname":addCustomerView.nameView.inputTf.text as! String,"trade_name":secondtrade == nil ? firsttrade.1 : secondtrade?.1,"trade_id":secondtrade == nil ? firsttrade.0 : secondtrade?.0,"client_id":modelDic!["id"],"token":UserModel.getUserModel().token,"authorization_corp":result.0,"authorization_deps":result.1,"authorization_member":result.2]
            LoginRequest.getPost(methodName: CLIENT_SAVE, params: params, hadToast: true, fail: { (dic) in
                PublicMethod.dismissWithError()
            }) { (dic) in
                PublicMethod.dismissWithSuccess(str: "保存成功")
                self.needUpdate()
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            if addCustomerView.nameView.inputTf.text == "" || firsttrade.0 == ""  {
                self.present(UIAlertController.init(title: "对不起", message: "请填全所有内容，内容缺失不能保存", preferredStyle: UIAlertControllerStyle.alert, okAndCancel: ("知道了",""), btnActions: { (action, str) in
                }), animated: true, completion: nil)
                return
            }
            self.umAnalyticsWithName(name: um_clientAddSave)
            PublicMethod.showProgress()
            let result = shareView.resultParams()
            let params = ["clientname":addCustomerView.nameView.inputTf.text as! String,"trade_name":secondtrade == nil ? firsttrade.1 : secondtrade?.1 as Any,"trade_id":secondtrade == nil ? firsttrade.0 : secondtrade?.0,"contact_name":addCustomerView.contactView.inputTf.text as! String,"contact_position":addCustomerView.positionView.inputTf.text as! String,"contact_phone":addCustomerView.telView.inputTf.text as! String,"token":UserModel.getUserModel().token,"authorization_corp":result.0,"authorization_deps":result.1,"authorization_member":result.2] as [String : Any]
            LoginRequest.getPost(methodName: CLIENT_ADD, params: params, hadToast: true, fail: { (dic) in
                PublicMethod.dismissWithError()
            }) { (dic) in
                DLog("祁伟鹏")
                DLog(dic)
                PublicMethod.dismissWithSuccess(str: "保存成功")
                self.navigationController?.popViewController(animated: true)
                if self.isSelectCome {
                    self.customerNew(String.noNilStr(str: dic["id"]),String.noNilStr(str: dic["name"]),String.noNilStr(str: dic["trade_id"]),String.noNilStr(str: dic["trade_name"]))
                }else{
                    self.needUpdate()
                }
                
            }
        }
        
    }
    
    
    lazy var backScroll = { () -> UIScrollView in
        let back = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-40))
        return back
    }()
    
    lazy var bottomView = { () -> CustomerBottomView in
        let back = CustomerBottomView.init(frame: CGRect(x: 0, y: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-40, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT))
        return back
    }()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    /// 点击了客户
    @objc func clientClick(){
        let vc = HYSelectCompanyVC()
        vc.selectBlock = { [weak self](name)in
           
            
            self?.addCustomerView.nameView.inputTf.text = String.noNilStr(str: name)
            
        };
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //企业查询
    func searchCompany(text:String) {

        let params = ["token":UserModel.getUserModel().token as Any,"keyname":text] as [String : Any]
        LoginRequest.getPost(methodName: "pp.clientContact.getCompanyList", params: params, hadToast: true, fail: { (dic) in
        }) { [weak self](dic) in
            
            if dic["data"] != nil {
                let array = JSON(dic["data"] as Any).arrayObject
            
                if (array?.count)! > 0 {
                    let newArray:Array<Dictionary<String,Any>> = array as! Array<Dictionary<String, Any>>
                    self?.dataArray.removeAll()
                    for dict in newArray {
                        self?.dataArray.append(dict)
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func keyboardDidShow(notific:Notification)  {
        let dic:NSDictionary = notific.userInfo! as NSDictionary
        let a:AnyObject? = dic.object(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject?
        let endY = a?.cgRectValue.origin.y
        print(endY as Any,"endY")
        self.tableView.frame = CGRect(x: 10, y: 75, width: SCREEN_WIDTH-20, height: SCREEN_HEIGHT-(NAV_HEIGHT+75+endY!))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArray.count == 0 {
            self.tableView.isHidden = true
        }else{
            self.tableView.isHidden = false
        }
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = self.dataArray[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELLID")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "CELLID")
        }
        cell?.textLabel?.text = String.noNilStr(str: dict["name"])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = self.dataArray[indexPath.row]
        self.addCustomerView.nameView.inputTf.text = String.noNilStr(str: dict["name"])
        self.tableView.isHidden = true
        self.view.endEditing(true)
        
    }
}
