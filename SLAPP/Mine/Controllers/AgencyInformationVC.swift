//
//  AgencyInformationVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AgencyInformationVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    lazy var table:UITableView = {
        let tb = UITableView()
        tb.backgroundColor = UIColor.groupTableViewBackground
        tb.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height:MAIN_SCREEN_HEIGHT_PX-50)
        tb.tableFooterView = UIView()
        tb.isScrollEnabled = false
        tb.separatorStyle = .none
        return tb
    }()

    var myDic:Dictionary<String,Any> = Dictionary()
    
    let nameArray = ["公司名称:","简称:","所属行业:","联系人姓名:","手机号:","email:","所在地区:","公司地址:"]
    
     let keyArray = ["name","shortname","所属行业:","contacts","phone","email","所在地区:","address"]
    
    
    var dataArray:Array = Array<Dictionary<String,String>>()
    
    var tradeFirst:String? //行业一级
    var tradeSecond:String? //行业二级
    var province:String?
    var city:String?
    
    
    var provinceArray = Array<Any>()
    var tradeFirstArray = Array<Any>()
    var tradeSecondArray = Array<Any>()
    var cityArray = Array<Any>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.getAgencyInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func configUI(){
        self.title = "机构信息"
        self.view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        
        
        table.register(UINib.init(nibName: "AgencyInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "AgencyInfoCell")
        table.register(UINib.init(nibName: "AgencyTradeCell", bundle: Bundle.main), forCellReuseIdentifier: "AgencyTradeCell")
        
        
        let footView = UIView()
        footView.frame = CGRect(x: 0, y:MAIN_SCREEN_HEIGHT_PX-100-NAV_HEIGHT, width: MAIN_SCREEN_WIDTH, height: 100)
        footView.backgroundColor = UIColor.groupTableViewBackground
        //        self.table.tableFooterView = footView
        self.view.addSubview(footView)
        
        let saveBtn:UIButton = UIButton.init(type: .custom)
        footView.addSubview(saveBtn)
        saveBtn.backgroundColor = kGreenColor
        saveBtn.layer.cornerRadius = 6
        saveBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(50)
            make.height.equalTo(50)
        }
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        
    }
    
    
    
    func getAgencyInfo(){
        
        LoginRequest.getPost(methodName: COMPANY_INFO, params: ["token":UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
            
        }) {[weak self] (dic) in
            
//            DLog(dic)
            
            if dic["data"] != nil {
                
                self?.myDic = dic["data"] as! Dictionary<String, Any>
            }else{
                
                self?.myDic = dic
            }
            
//            DLog(dic)
            
           self?.tradeFirst = String.noNilStr(str: self?.myDic["trade_id"])

            self?.tradeSecond = String.noNilStr(str: self?.myDic["trade_id"])
            
            self?.province = String.noNilStr(str: self?.myDic["province"])
            
            self?.city = String.noNilStr(str: self?.myDic["city"])
            
            self?.table.reloadData()
            
            
        }
        
    }
    
    
    
    @objc func saveBtnClick(){
        self.infoSave()
        
    }
    
    
    //MARK: - ---------------------table代理------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 2 || indexPath.row == 6 {
            let cellIde = "AgencyTradeCell"
            let cell:AgencyTradeCell = tableView.dequeueReusableCell(withIdentifier: cellIde) as! AgencyTradeCell
            cell.selectionStyle = .none
            cell.name.text = nameArray[indexPath.row]
            cell.index = indexPath.row
            guard myDic.count > 0 else{
                return cell
            }
            cell.click = {[weak self] (index,btnInt) in
                self?.click(cell: cell, index: index, btnInt: btnInt)
            }
            
            if(indexPath.row == 2){
               
//                cell.btnA.titleLabel?.text = myDic["trade_first_name"] as! String
                
                cell.btnA.setTitle(String.noNilStr(str: myDic["trade_first_name"]), for: .normal)
                cell.btnB.setTitle(String.noNilStr(str: myDic["trade_name"]), for: .normal)
                
                
            }else{
               
               cell.btnA.setTitle(String.noNilStr(str: myDic["province_name"]), for: .normal)
                cell.btnB.setTitle(String.noNilStr(str: myDic["city_name"]), for: .normal)
            }
            
            return cell
        }else{
            
            let cellIde = "AgencyInfoCell"
            let cell:AgencyInfoCell = tableView.dequeueReusableCell(withIdentifier: cellIde) as! AgencyInfoCell
            
            if indexPath.row == 0 {
                cell.nameValue.isEnabled = false
            }
            cell.name.text = nameArray[indexPath.row]
            
            if  myDic.count > 0 {
                cell.nameValue.text = String.noNilStr(str: myDic[keyArray[indexPath.row]])
            }
            cell.selectionStyle = .none
            return cell
        }
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    
    

    
    
    
    func click(cell:AgencyTradeCell,index:Int,btnInt:Int){
        
        if index == 2 {
            //行业
            if btnInt == 1{
                  //行业一级
                if tradeFirstArray.count == 0{
                    self.getTrade(idStr: "0", finish: {[weak self]  in
                        self?.configTradeCell(cell: cell, index: btnInt)
                    })
                    
                }else{
                    
                    self.configTradeCell(cell: cell, index: btnInt)
                }
              
                
                
                
            }else{
                self.getTrade(idStr: tradeFirst!, finish: {[weak self]  in
                    self?.configTradeCell(cell: cell, index: btnInt)
                })
            }
        }else{
            
            if btnInt == 1{
                
                if provinceArray.count == 0{
                    self.getProvince(idStr: "0", finish: {[weak self]  in
                        self?.configAdressCell(cell: cell, index: btnInt)
                    })
                    
                }else{
                    
                    self.configAdressCell(cell: cell, index: btnInt)
                }
                
                //省
            }else{
                //市
                self.getCity(idStr: province!, finish: {[weak self]  in
                    self?.configAdressCell(cell: cell, index: btnInt)
                })
            }
        }
        
    }
    
    func configAdressCell(cell:AgencyTradeCell,index:Int){
        let dic = self.configDic(type: 6,btnInt: index)
        if index == 1 {
            self.showAlert(alertDic: dic, finish: {[weak cell,weak self] (str) in
                
                self?.getCity(idStr: str, finish: {
                    cell?.btnA.setTitle(dic[str], for: .normal)
                    self?.province = str
                    self?.city = nil
                    cell?.btnB.setTitle("", for: .normal)
                    
                    if (self?.cityArray.count)! > 0 {
                        let dic:Dictionary<String,Any> = self?.cityArray.first as! Dictionary<String, Any>
                        cell?.btnB.setTitle((dic["city"] as! String), for: .normal)
                        self?.city = (dic["cityid"] as! String)
                        
                    }
                })
                
                
            })
        }
        else{
            
            let dic = self.configDic(type: 6,btnInt: index)
            self.showAlert(alertDic: dic, finish: {[weak cell,weak self] (str) in
                guard str != kCancel else{
                    return
                }
                cell?.btnB.setTitle((dic[str] as! String), for: .normal)
                self?.city = str
                
                
                
            })
            
        }
    
        
    }
    
    

    func configTradeCell(cell:AgencyTradeCell,index:Int){
        
        let dic = self.configDic(type: 2,btnInt: index)
        if index == 1 {
            self.showAlert(alertDic: dic, finish: {[weak cell,weak self] (str) in
                
                self?.getTrade(idStr: str, finish: {
                    cell?.btnA.setTitle(dic[str], for: .normal)
                    self?.tradeFirst = str
                    self?.tradeSecond = nil
                    cell?.btnB.setTitle("", for: .normal)
                    if (self?.tradeSecondArray.count)! > 0 {
            let dic:Dictionary<String,Any> = self?.tradeSecondArray.first as! Dictionary<String, Any>
                        cell?.btnB.setTitle((dic["name"] as! String), for: .normal)
                        self?.tradeSecond = (dic["index_id"] as! String)
                        
                    }
                })
                
                
            })
        }
        else{
            
            let dic = self.configDic(type: 2,btnInt: index)
            self.showAlert(alertDic: dic, finish: {[weak cell,weak self] (str) in
                
                guard str != kCancel else{
                    return
                }
                cell?.btnB.setTitle(dic[str] , for: .normal)
                self?.tradeSecond = dic[str]
                
                
            })
            
        }
        
    }
    
    
    
    func configDic(type:Int,btnInt:Int)->(Dictionary<String,String>){
        var alertDic = Dictionary<String,String>()
        alertDic.updateValue("取消", forKey: kCancel)
        if type == 2 && btnInt == 1 {
            for i in 0..<tradeFirstArray.count{
                let dic:Dictionary<String,Any> = tradeFirstArray[i] as! Dictionary<String, Any>
                alertDic.updateValue(dic["name"] as! String, forKey: dic["index_id"] as! String)
                
            }
        }
        
        if type == 2 && btnInt == 2 {
            for i in 0..<tradeSecondArray.count{
                let dic:Dictionary<String,Any> = tradeSecondArray[i] as! Dictionary<String, Any>
                alertDic.updateValue(dic["name"] as! String, forKey: dic["index_id"] as! String)
                
            }
        }
        
        
        if type==6 && btnInt == 1 {
            
            
            for i in 0..<provinceArray.count{
                let dic:Dictionary<String,Any> = provinceArray[i] as! Dictionary<String, Any>
                alertDic.updateValue(dic["province"] as! String, forKey: dic["provinceid"] as! String)
                
            }
        }

        
        if type==6 && btnInt == 2 {
            
            
            for i in 0..<cityArray.count{
                let dic:Dictionary<String,Any> = cityArray[i] as! Dictionary<String, Any>
                alertDic.updateValue(dic["city"] as! String, forKey: dic["cityid"] as! String)
                
            }
        }
        
        
        return alertDic
    }
    
    
    
    func showAlert(alertDic:Dictionary<String,String>,finish:@escaping (_ str:String)->()){
        
        let alert = UIAlertController.init(title: "请选择", message: "", preferredStyle: .alert, btns: alertDic) {[weak self] (action, str) in
            if str == kCancel {
                return
            }
            finish(str)
            
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func infoSave(){
        
//        let keyArray = ["name","shortname","所属行业:","contacts","phone","email","所在地区:","address"]
         var params:Dictionary<String,Any> = Dictionary()
        let array = table.visibleCells
        for i in 0..<array.count {
            if i == 2 || i == 6 {
                continue
            }
            let cell:AgencyInfoCell = array[i] as! AgencyInfoCell
            switch i {
            case 0:
//                if cell.nameValue.text == nil{
//                    PublicMethod.toastWithText(toastText: "公司名称不能为空")
//                    return
//                }
//                params["shortname"] =
                
                break
            case 1:
                if (cell.nameValue.text?.isEmpty)!{
                    PublicMethod.toastWithText(toastText: "简称不能为空")
                    return
                }
                params["shortname"] = cell.nameValue.text
                break
            case 3:
                if (cell.nameValue.text?.isEmpty)!{
                    PublicMethod.toastWithText(toastText: "联系人不能为空")
                    return
                }
                params["contacts"] = cell.nameValue.text
                break
            case 4:
                if (cell.nameValue.text?.isEmpty)!{
                    PublicMethod.toastWithText(toastText: "手机号不能为空")
                    return
                }
                params["phone"] = cell.nameValue.text
                break
            case 5:
                if (cell.nameValue.text?.isEmpty)!{
                    PublicMethod.toastWithText(toastText: "email不能为空")
                    return
                }
                params["email"] = cell.nameValue.text
                break
            case 7:
                if (cell.nameValue.text?.isEmpty)!{
                    PublicMethod.toastWithText(toastText: "公司地址不能为空")
                    return
                }
                params["address"] = cell.nameValue.text
                break
            default:
                continue
            }
        }
        
        
        
        
        if myDic.count == 0 {
            PublicMethod.toastWithText(toastText: "请返回上一级界面重新进入")
        }
        
        params["id"] = myDic["id"]
        
    
        if !(self.tradeSecond?.isEmpty)! {
            params["trade_id"] = self.tradeSecond
        }
        else{
            PublicMethod.toastWithText(toastText: "行业不能为空")
            
        }
        
        if !(self.province?.isEmpty)! {
            params["province"] = self.province
        }
        else{
            PublicMethod.toastWithText(toastText: "省不能为空")
            
        }
      
        if !(self.city?.isEmpty)! {
            params["city"] = self.city
        }
        
        
      
            
            
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: COMPANYINFO_SAVE, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
            PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: "修改成功")
        }
        
        
    }
    
    
    
    /// 获取行业
    func getTrade(idStr:String,finish:@escaping ()->()){
        let parent_id = idStr
        if idStr != "0" {
            self.tradeSecondArray.removeAll()
        }
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: TRADE_LIST, params: ["parent_id":parent_id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            finish()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            if idStr == "0"{
                let array = dic["data"] as! Array<Any>
              self?.tradeFirstArray = (self?.tradeFirstArray)! + array
               
            }
            else{
                let array = dic["data"] as! Array<Any>
                
              self?.tradeSecondArray =  (self?.tradeSecondArray)! + array
                
            }
            finish()
        }
        
    }
    
    
    /// 获取省
    func getProvince(idStr:String,finish:@escaping ()->()){
//        let parent_id = idStr
        if idStr != "0" {
            self.cityArray.removeAll()
        }
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROVINCE, params: [:].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            finish()
        }) { (dic) in
            PublicMethod.dismiss()
            self.provinceArray = dic["data"] as! [Any]
            finish()
        }
        
    }
    
    
    ///
    func getCity(idStr:String,finish:@escaping ()->()){
        let parent_id = idStr
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CITIES, params: ["provinceid":parent_id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            finish()
        }) { (dic) in
            PublicMethod.dismiss()
           
            self.cityArray = dic["data"] as! [Any]
            finish()
        }
        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
