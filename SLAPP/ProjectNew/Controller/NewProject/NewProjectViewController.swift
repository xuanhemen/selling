//
//  NewProjectViewController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/3/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class NewProjectViewController: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    
    @objc var clientModel:HYClientModel?
    @objc var canEditClient = true
    var userid:String = UserModel.getUserModel().id!
    var tableView : UITableView!//列表
    var cancleBtn : UIButton!//取消按钮
    var saveBtn : UIButton!//保存按钮
    var sectionNum : Int!//行数，用于判断展示更多信息
    var footImgV : UIImageView!//说明展开情况的界面
    var footTextLabel : UILabel!//说明展开文字
    var projectId : String?//历史
    var datasourceEditArr : Array<Array<Dictionary<String,String>>>! //修改
    var datasourceArr = Array<Array<Dictionary<String,String>>>() //新增
    var selectedCustomerId : String? = ""//联系人id
    var selectedContactId : String? = ""//客户id
    var selectedCustomerName : String? = ""//联系人姓名
    var selectedContactName : String? = ""//客户名称
    var tradeId = ""//行业id
    var tradeParentId = ""//行业id
    var vModel = ProjectSituationViewModel()//选人数据
    
    var allProduct_lineModel = Array<Product_lineModel>()//所有产品列表
    let chooseVc = ChooseProductVC()//选产品界面
    var productArray = Array<Dictionary<String,String>>()//选中产品列表
    var selectContactArr = Array<Dictionary<String,Any>>()//选中其他联系人列表
    var productStr = ""//选中产品文字
    
    var timerIntStr = 0//日期
    var isNeedUpdate:Bool = false //是否需要更新
    
    var needUpdate = {
        
    }
    //保存产品信息
    var upProductInfo:(_ array:Array<Dictionary<String,String>>)->() = {_ in
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if projectId != nil {
            self.title = "修改项目"
            self.sectionNum = 1;
            self.umAnalyticsWithName(name: um_projectEdit)
        }else{
            self.title = "新增项目"
            self.sectionNum = 1;
            self.umAnalyticsWithName(name: um_projectAdd)
        }
        self.configData()
        self.configUI()
        self.configBackItem()
    }
    
    override func backBtnClick() {
        if self.isNeedUpdate {
            needUpdate()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func getAllProduct(success:(()->())?) {
        LoginRequest.getPost(methodName: PRODUCTS_LIST, params: [kToken:UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
            DLog(dic)
            PublicMethod.dismissWithError()
        }) { (dic) in
            DLog(dic)
            PublicMethod.dismiss()
            let array:Array<Dictionary<String,Any>> = dic["data"] as! Array<Dictionary<String, Any>>
            var data = Array<Product_lineModel>()
            for oneP in array{
               
                let model = Product_lineModel.deserialize(from: oneP)
                data.append(model!)
            }
            self.allProduct_lineModel = data
            if success != nil{
                success!()
            }
        }
    }
    func willShowProductView() {
        if allProduct_lineModel.count == 0 {
            getAllProduct {
                self.showRemindDelAndChangeProductLine()
            }
        }else{
            self.showRemindDelAndChangeProductLine()
        }
    }
    
    func showRemindDelAndChangeProductLine(){
        
        var lineStr = ""
        var delStr = ""
        var currentArray = Array<Dictionary<String,String>>();
        for dic in self.productArray {
            
            
            if String.noNilStr(str: dic["status"]) == "file"  {
                if lineStr != "" {
                    lineStr.append("，")
                }else{
                    lineStr.append(dic["products"]!)
                }
                continue;
            }
            if String.noNilStr(str: dic["status"]) == "del" {
                if delStr != "" {
                    delStr.append("，")
                }else{
                    delStr.append(dic["products"]!)
                }
                
                continue;
            }
            currentArray.append(dic)
        }
        var remindStr = ""
        
        if lineStr != "" {
            remindStr.append(lineStr)
            remindStr.append("产品设置已被系统管理员修改。")
        }
        if delStr != "" {
            remindStr.append(delStr)
            remindStr.append("产品已被系统管理员删除。")
        }
        
        if remindStr != "" {
            self.showAlert(titleStr: remindStr, finish: { [weak self] in
                self?.productArray = currentArray;
                self?.showProductView()
            })
        }else{
            
            self.showProductView()
            
        }
    }

    func showProductView(){
        
        
        if self.productArray.count != 0 {
            self.chooseVc.alreadyArray = self.productArray
        }
        DLog(self.productArray);
        DLog("产品入口数据---------")
        
        self.chooseVc.alldata = allProduct_lineModel
        self.chooseVc.resultArray = {[weak self] (array) in
            self?.productCallBackWithArray(array: array)
        }
        self.navigationController?.pushViewController(self.chooseVc, animated: true)
    }
    
    func configData(){
        if projectId != nil { //修改页面
            
            self.datasourceArr = datasourceEditArr
        }else{
            if self.clientModel != nil && self.canEditClient == false {
                self.selectedContactId = self.clientModel?.id
                self.selectedContactName = self.clientModel?.name
                self.tradeId = (self.clientModel?.trade_id)!
                self.datasourceArr = [[["客户名称:":(self.clientModel?.name)!],["所属行业:":self.clientModel?.trade_name],["项目名称:":""],["产品/服务:":""],["合同额:":""],["预计实现业绩（万）:":""],["预计成交时间:":""]],[["参与人":""],["观察员":""],["联系人":""]]] as! [Array<Dictionary<String, String>>]
            }else{
                self.datasourceArr = [[["客户名称:":""],["所属行业:":""],["项目名称:":""],["产品/服务:":""],["合同额:":""],["预计实现业绩（万）:":""],["预计成交时间:":""]],[["参与人":""],["观察员":""],["联系人":""]]]
            }
        }
        getAllProduct(success: nil)
        
    }
    func configUI() {
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - 40), style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        cancleBtn = UIButton.init(frame: CGRect.init(x: 0, y: tableView.height, width: self.view.frame.size.width * 0.5, height: 40))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.backgroundColor = UIColor.gray
        cancleBtn.addTarget(self, action:  #selector(cancleBtnClick), for: .touchUpInside)
        saveBtn = UIButton.init(frame: CGRect.init(x: self.view.frame.size.width * 0.5, y: tableView.height, width: self.view.frame.size.width * 0.5, height: 40))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.backgroundColor = UIColor.init(hexString: "30b475")
        saveBtn.addTarget(self, action:  #selector(saveBtnClick), for: .touchUpInside)
        
        self.view.addSubview(cancleBtn)
        self.view.addSubview(saveBtn)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNum
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasourceArr[section].count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return nil
        }else{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 15, width: tableView.width, height: 25))
            headerView.backgroundColor = HexColor("#F2F2F2")
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return self.vModel.membersHeight[indexPath.row]
        }
        return  60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ContactAddBaseCell?
        if indexPath.section == 0{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "ContactAddCompanyCell") as? ContactAddCompanyCell
                if cell == nil{
                    cell = ContactAddCompanyCell.init(style: .default, reuseIdentifier: "ContactAddCompanyCell")
                }
                cell?.detailTf.isEnabled = false
                cell?.companyBtnClickBlock = ({ [weak self] in
                    
                    if self?.canEditClient == false {
                        return;
                    }
                    let vc = SelectCustomerVC()
                    vc.selectCustomerId = { [weak self](customerId,customerName) in
                        self?.selectedContactId = customerId
                        self?.selectedContactName = customerName
                        self?.datasourceArr[indexPath.section][indexPath.row].updateValue(customerName, forKey: (self?.datasourceArr[indexPath.section][indexPath.row].keys.first)!)
                        self?.selectedCustomerId = ""
                        self?.selectedCustomerName = ""
                        
                        self?.vModel.membersArray[2] = []
                        
//                        self?.datasourceArr[0][7].updateValue("", forKey: (self?.datasourceArr[0][7].keys.first)!)
                        
                        LoginRequest.getPost(methodName: CLIENT_DETAIL, params: [kToken:UserModel.getUserModel().token ?? "","id":customerId], hadToast: true, fail: { (dic) in
                            self?.datasourceArr[indexPath.section][indexPath.row+3].updateValue("", forKey: (self?.datasourceArr[indexPath.section][indexPath.row+3].keys.first)!)
                        }) { (dic) in
                            DLog(dic)
                            if !(dic["trade_id"] is NSNull){
                                self?.tradeId = dic["trade_id"]  as! String
                                self?.datasourceArr[0][1].updateValue(dic["trade_name"]  as! String, forKey: (self?.datasourceArr[0][1].keys.first)!)
                            }
                            self?.tableView.reloadData()
                        }
                        self?.tableView.reloadData()
                    }
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                })
                
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "ContactAddBaseCell") as? ContactAddBaseCell
                if cell == nil{
                    cell = ContactAddBaseCell.init(style: .default, reuseIdentifier: "ContactAddBaseCell")
                    
                }
                if indexPath.row == 1 {
                    cell?.detailTf.isEnabled = false
                }
            }
        }else{
            return self.configNoCheckCell(indexPath: indexPath, tableView: tableView)
        }
        
        cell?.textChangeBlock = ({ [weak self]text in
            if indexPath.section == 0 && indexPath.row == 2{
                if text != self?.selectedCustomerName{
                    self?.selectedCustomerId = ""
                }
            }
            self?.datasourceArr[indexPath.section][indexPath.row].updateValue(text, forKey: (self?.datasourceArr[indexPath.section][indexPath.row].keys.first)!)
        })
        cell?.titleLb.text = self.datasourceArr[indexPath.section][indexPath.row].keys.first
        cell?.detailTf.text = self.datasourceArr[indexPath.section][indexPath.row].values.first
        cell?.detailTf.isUserInteractionEnabled = false
        cell?.bgView.backgroundColor = UIColor.white
        cell?.backgroundColor = UIColor.white
        switch (cell?.titleLb.text)! {
        case "预计实现业绩（万）:":
            cell?.detailTf.placeholder = "请填写预计实现的业绩"
            cell?.detailTf.keyboardType = .numberPad
            cell?.detailTf.isUserInteractionEnabled = true
            if (cell?.detailTf.text?.count)!>0{
                cell?.detailTf.text = String.init(format: "%@", (cell?.detailTf.text)!)
            }
        case "预计成交时间:":
            cell?.detailTf.placeholder = "请选择预计成交的时间"
        case "项目名称:":
            cell?.detailTf.placeholder = "请输入项目名称"
            cell?.detailTf.isUserInteractionEnabled = true
        case "手机号:":
            cell?.detailTf.placeholder = "请输入手机号"
            cell?.detailTf.keyboardType = .numberPad
            cell?.detailTf.isUserInteractionEnabled = true
        case "客户名称:":
            cell?.detailTf.placeholder = "请选择客户公司名称"
            cell?.detailTf.isUserInteractionEnabled = true
            cell?.detailTf.reactive.continuousTextValues.observeValues({[weak self] (text) in
                if text != self?.selectedContactName {
                    self?.selectedContactId = ""
                    self?.selectedContactName = text
                    
                }
            })
        case "所属行业:":
            cell?.bgView.backgroundColor = UIColor.groupTableViewBackground
            cell?.backgroundColor = UIColor.groupTableViewBackground
            cell?.detailTf.placeholder = "所属行业"
        case "产品/服务:":
            cell?.detailTf.placeholder = "请选择为客户提供的产品/服务"
        case "合同额:":
            cell?.detailTf.placeholder = "请填写合同额"
            if (cell?.detailTf.text?.count)!>0{
                cell?.detailTf.text = String.init(format: "%@(万)", (cell?.detailTf.text)!)
            }
        default:
            cell?.detailTf.placeholder = ""
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DLog(indexPath)
        tableView.deselectRow(at: indexPath, animated: true);
        switch (self.datasourceArr[indexPath.section][indexPath.row].keys.first)! {
            
        case "客户名称:":
            if self.canEditClient == false {
                return;
            }
            let vc = SelectCustomerVC()
            vc.selectCustomerId = { [weak self](customerId,customerName) in
                self?.selectedContactId = customerId
                self?.selectedContactName = customerName
                self?.datasourceArr[indexPath.section][indexPath.row].updateValue(customerName, forKey: (self?.datasourceArr[indexPath.section][indexPath.row].keys.first)!)
                
                
                self?.selectedCustomerId = ""
                self?.selectedCustomerName = ""
                
                self?.vModel.membersArray[2] = []
                
                LoginRequest.getPost(methodName: CLIENT_DETAIL, params: [kToken:UserModel.getUserModel().token ?? "","id":customerId], hadToast: true, fail: { (dic) in
                    self?.datasourceArr[indexPath.section][indexPath.row+3].updateValue("", forKey: (self?.datasourceArr[indexPath.section][indexPath.row+3].keys.first)!)
                }) { (dic) in
                    DLog(dic)
                    if !(dic["trade_id"] is NSNull){
                        self?.tradeId = String.noNilStr(str: dic["trade_id"])
                        self?.datasourceArr[0][1].updateValue(String.noNilStr(str: dic["trade_name"]), forKey: (self?.datasourceArr[0][1].keys.first)!)
                    }
                    self?.tableView.reloadData()
                }
                self?.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
            break;
            
        case "预计实现业绩(万):": break
        case "预计成交时间:":
            let picker = Bundle.main.loadNibNamed("DatePicker", owner: self, options: nil)?.last as? DatePicker
            picker?.showInVC(view: view)
            
            if self.timerIntStr == 0 {
                picker?.datePicker.date = Date.init(timeIntervalSinceNow: 0)
            }else{
                if self.timerIntStr == 0 {
                    picker?.datePicker.date = Date.init(timeIntervalSinceNow: 0)
                }else{
                    picker?.datePicker.date = Date.init(timeIntervalSince1970: TimeInterval(self.timerIntStr))
                }
                
            }
            
            picker?.resultTimeStr = {timerStr,timerInt in
                DLog(timerStr)
                self.datasourceArr[indexPath.section][indexPath.row].updateValue(timerStr!, forKey: (self.datasourceArr[indexPath.section][indexPath.row].keys.first)!)
                self.timerIntStr = timerInt
                self.tableView.reloadData()
            }
            break
        case "项目名称:": break
        case "手机号:": break
        case "客户名称:":
            //            self.addClient()
            break
        case "所属行业:":
            break
        case "产品/服务:":
            willShowProductView()
            break
        case "合同额:":
            willShowProductView()
            break
        default:
            break
        }
    }
    
    @objc func saveBtnClick(btn:UIButton)  {
        
        self.saveBtn.isEnabled = false
        if self.datasourceArr[0][2].values.first == ""{
            self.view.makeToast("项目名不能为空", duration: 1.0, position: self.view.center)
            saveBtn.isEnabled = true
            return
        }
        
        if self.datasourceArr[0][0].values.first == ""{
            self.view.makeToast("客户名不能为空", duration: 1.0, position: self.view.center)
            saveBtn.isEnabled = true
            return
        }
        var product_lineJson = Array<Dictionary<String,String>>()
        for dic in productArray {
            var priceString = "0"
            if dic["amount"] != nil {
                priceString = dic["amount"]!
            }else if dic["price"] != nil {
                priceString = dic["price"]!
            }
            
            product_lineJson.append(["id":dic["id"]!,"products":dic["products"]!,"price":priceString])
        }
    
        let arr0 = self.vModel.membersArray[0].map({ (model) -> String in
            return model.id!
        })
        var menStr0 = ""
        for oneStr in arr0{
            if oneStr == arr0.first{
                menStr0.append(oneStr)
            }else{
                menStr0.append(",")
                menStr0.append(oneStr)
            }
        }
        
        let arr1 = self.vModel.membersArray[1].map({ (model) -> String in
            return model.id!
        })
        var menStr1 = ""
        for oneStr in arr1{
            if oneStr == arr1.first{
                menStr1.append(oneStr)
            }else{
                menStr1.append(",")
                menStr1.append(oneStr)
            }
        }
        let arr2 = self.vModel.membersArray[2].map({ (model) -> String in
            return model.id!
        })
        var menStr2 = SignTool.makeJsonStrWith(object: selectContactArr)
        
        
        var params:Dictionary = [
            "name":self.datasourceArr[0][2].values.first!,
            "client_id":self.selectedContactId,
            "client_name":self.datasourceArr[0][0].values.first!,
            "trade_id":tradeId,
            "trade_name":self.datasourceArr[0][1].values.first!,
            "product_line":SignTool.makeJsonStrWith(object: product_lineJson),
            "amount":self.datasourceArr[0][4].values.first!,
            "down_payment":self.datasourceArr[0][5].values.first!,
            "dealtime":timerIntStr,
            "partners":menStr0,
            "observer":menStr1,
            "contacts":menStr2,
            "token":UserModel.getUserModel().token!] as [String : Any]
        
        var methodName = PROJECT_ADD_PROJECT
        if projectId != nil {
            params["project_id"] = projectId
            methodName = PROJECT_SAVE_PROJECT
        }
        
        if methodName == PROJECT_ADD_PROJECT {
            self.umAnalyticsWithName(name: um_projectAddSave)
        }else{
            self.umAnalyticsWithName(name: um_projectEditSave)
        }
        
        LoginRequest.getPost(methodName: methodName, params: params, hadToast: true, fail: {[weak self] (dic) in
            PublicMethod.dismissWithError()
            self?.saveBtn.isEnabled = true
        }) { [weak self](dic) in
            PublicMethod.dismissWithSuccess(str: "保存成功")
            self?.saveBtn.isEnabled = true
            //QF -- mark -- 保存产品信息
            self?.upProductInfo(product_lineJson)
            self?.needUpdate()
            
            if methodName == PROJECT_ADD_PROJECT{
                DLog(dic)
                self?.toProjectSituation(id:JSON(dic["data"]).stringValue)
            }else{
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //跳转到项目概况
    func toProjectSituation(id:String){
        self.isNeedUpdate = true
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                let tab = ProjectSituationTabVC()
                tab.model = model; self?.navigationController?.pushViewController(tab, animated: true)
            }
        }
    }
    @objc func cancleBtnClick(btn:UIButton)  {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK - 选人cell
    //没有做过检查
    func configNoCheckCell(indexPath: IndexPath,tableView: UITableView)->(UITableViewCell){
        let cellIde = "cell"
        var cell:ProSituationMemberCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProSituationMemberCell
        
        if cell == nil {
            cell = ProSituationMemberCell.init(style: .default, reuseIdentifier: cellIde)
        }
        self.disposeMembersCell(cell: cell!, indexPath: indexPath)
        return cell!
    }
    //处理参与者，观察员cell
    func disposeMembersCell(cell:ProSituationMemberCell,indexPath: IndexPath){
        cell.projectId = ""
        cell.type = memberStyle(rawValue: indexPath.row)
        cell.nameLable.text = self.vModel.membersTitles[indexPath.row]
        cell.isDelete = self.vModel.membersIsdelete[indexPath.row]
        cell.configAlReady(array:self.vModel.membersArray[indexPath.row])
        cell.click = {[weak self,weak cell] (str) in
            
            if cell?.nameLable.text == "联系人"{
                
                if str == "+" {
                    let addC = HYSelectContactVC()
                    let model = HYClientModel()
                    model.id = (self?.selectedContactId)!
                    model.name = self?.selectedContactName
                    addC.clientModel = model
                    if addC.clientModel.id == "" || addC.clientModel.id == "0"{
                        PublicMethod.toastWithText(toastText: "确定客户后才可以操作")
                        return;
                    }
                    
                    
                    addC.getResult = {[weak self] (list) in
                        let array:Array<Dictionary<String, Any>> = list as! [Dictionary<String, Any>]
                        self?.selectContactArr = array
                        var result = Array<MemberModel>()
                        for dic in array{
                            result.append(MemberModel.configWithDic(dic: ["id":dic["id"] as Any,"realname":dic["name"] as Any,"head":""]))
                        }
                        if result.count > 0{
                            
                            let arr = result.map({ (model) -> String in
                                return model.id!
                            })
                            let idStr = (arr + cell!.resultIds()).joined(separator: ",") as String
                            //先走网络，添加完成在做本地UI更新
                            //                        self?.addMember(type: (cell?.type!)!, projectId: (self?.model?.id!)!, resultIdStr: idStr, result: {
                            self?.vModel.membersArray[indexPath.row] = result
                            cell?.configAlReady(array:result)
                            let height = cell?.refreshHeight()
                            DLog("height:"+String(describing: height))
                            if self?.vModel.membersHeight[indexPath.row] != height {
                                self?.vModel.membersHeight[indexPath.row] = height!
                                DLog("height:["+String(describing: indexPath.row)+"]"+String(describing: self?.vModel.membersHeight[indexPath.row]))
                                self?.tableView.reloadData()
                            }
                        }
                    }
                    addC.alreadyArray = (self?.selectContactArr)!
                    self?.navigationController?.pushViewController(addC, animated: true)
                    return
                }
                
                if str == "-" {
                    let delVC = HYDelContactVC()
                    delVC.comeType = 1;
                    delVC.alreadyArray = (self?.selectContactArr)!
                    delVC.clientId = (self?.selectedContactId)!
                    if delVC.clientId == "" || delVC.clientId == "0"{
                        PublicMethod.toastWithText(toastText: "确定客户后才可以操作")
                        return;
                    }
                    
                    delVC.getResult = {[weak self] (list) in
                        let array:Array<Dictionary<String, Any>> = list as! [Dictionary<String, Any>]
                        self?.selectContactArr = array
                        var result = Array<MemberModel>()
                        for dic in array{
                            result.append(MemberModel.configWithDic(dic: ["id":dic["id"] as Any,"realname":dic["name"] as Any,"head":""]))
                        }
                        if result.count > 0{
                            
                            let arr = result.map({ (model) -> String in
                                return model.id!
                            })
                            let idStr = (arr + cell!.resultIds()).joined(separator: ",") as String
                            //先走网络，添加完成在做本地UI更新
                            //                        self?.addMember(type: (cell?.type!)!, projectId: (self?.model?.id!)!, resultIdStr: idStr, result: {
                            self?.vModel.membersArray[indexPath.row] = result
                            cell?.configAlReady(array:result)
                            let height = cell?.refreshHeight()
                            DLog("height:"+String(describing: height))
                            if self?.vModel.membersHeight[indexPath.row] != height {
                                self?.vModel.membersHeight[indexPath.row] = height!
                                DLog("height:["+String(describing: indexPath.row)+"]"+String(describing: self?.vModel.membersHeight[indexPath.row]))
                                self?.tableView.reloadData()
                            }
                        }
                    }
                    self?.navigationController?.pushViewController(delVC, animated: true)
                    return
                }
        
            }
            
            if str == "+" {
                let vcTitleArray = ["选择参与人","选择观察员","选择联系人"]
                self?.vModel.membersIsdelete[indexPath.row] = false
                cell?.collectionView.reloadData()
                let vc = TutoringMembersVC()
                vc.title = vcTitleArray[indexPath.row]
                if indexPath.row == 0{
                    vc.qf_otherArray.removeAll()
                    for qf_model in (self?.vModel.membersArray[1])!{
                        vc.qf_otherArray.append(qf_model)
                    }
                }else if indexPath.row == 1{
                    vc.qf_otherArray.removeAll()
                    for qf_model in (self?.vModel.membersArray[0])!{
                        vc.qf_otherArray.append(qf_model)
                    }
                }
                vc.userId = (self?.userid)!
                vc.type = .multiple
                vc.configAlReadyArray(alReady: (cell?.currentMember())!)
                vc.resultArray = {[weak self,weak cell](result) in
                    DLog(result)
                    if result.count > 0{
                        
                        let arr = result.map({ (model) -> String in
                            return model.id!
                        })
                        let idStr = (arr + cell!.resultIds()).joined(separator: ",") as String
                        //先走网络，添加完成在做本地UI更新
                        //                        self?.addMember(type: (cell?.type!)!, projectId: (self?.model?.id!)!, resultIdStr: idStr, result: {
                        self?.vModel.membersArray[indexPath.row] = result
                        cell?.configAlReady(array:result)
                        let height = cell?.refreshHeight()
                        DLog("height:"+String(describing: height))
                        if self?.vModel.membersHeight[indexPath.row] != height {
                            self?.vModel.membersHeight[indexPath.row] = height!
                            DLog("height:["+String(describing: indexPath.row)+"]"+String(describing: self?.vModel.membersHeight[indexPath.row]))
                            self?.tableView.reloadData()
                        }
                    }
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }else if str == "-"{
                
                //TODO比较乱 临时改动   有时间做整理
                if self?.vModel.membersIsdelete[indexPath.row] == true{
                    if (cell?.dataArray.count)! > 1 {
                        //                        self?.addMember(type: (cell?.type!)!, projectId: (self?.model?.id!)!, resultIdStr: (cell?.resultIdStr())!, result: {
                        self?.vModel.membersIsdelete[indexPath.row] = !(self?.vModel.membersIsdelete[indexPath.row])!
                        cell?.isDelete = (self?.vModel.membersIsdelete[indexPath.row])!
                        cell?.collectionView.reloadData()
                        //                        })
                    }else{
                        self?.vModel.membersIsdelete[indexPath.row] = !(self?.vModel.membersIsdelete[indexPath.row])!
                        cell?.isDelete = (self?.vModel.membersIsdelete[indexPath.row])!
                        cell?.collectionView.reloadData()
                    }
                    
                    
                }else{
                    self?.vModel.membersIsdelete[indexPath.row] = !(self?.vModel.membersIsdelete[indexPath.row])!
                    cell?.isDelete = (self?.vModel.membersIsdelete[indexPath.row])!
                    cell?.collectionView.reloadData()
                }
                
                
                
            }else{
                self?.vModel.membersArray[indexPath.row] = (cell?.currentMember())!
                let height = cell?.refreshHeight()
                if self?.vModel.membersHeight[indexPath.row] != height {
                    self?.vModel.membersHeight[indexPath.row] = height!
                    //                    self?.table.beginUpdates()
                    //                    self?.table.endUpdates()
                }
                
            }
        }
    }
    
    /**
     *  产品回调处理
     *
     *  @param array
     */
    func productCallBackWithArray(array:Array<Product_lineModel>) {
        var resultStr = String()
        var resultIDArray = Array<Dictionary<String,String>>()
        var sum = 0.0
        var i = 0
        for model in array{
            if model.amount == nil || model.amount == ""{
                model.amount = "0.00"
            }
            var dic = Dictionary<String,String>()
            dic["id"] = String.noNilStr(str: model.id)
            dic["amount"] = String.noNilStr(str: model.amount)
            dic["products"] = String.noNilStr(str: model.name)
            DLog(dic);
            DLog("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv")
            if array.count == 1{
                sum = sum + NSString.init(string: String.noNilStr(str: model.amount)).doubleValue
                let modelStr = String.noNilStr(str: model.name)+"("+String.noNilStr(str: model.amount)+")"
                resultStr.append(modelStr)
            }else{
                sum = sum + NSString.init(string: String.noNilStr(str: model.amount)).doubleValue
                
                //有数据  name 是nil
                let modelStr = String.noNilStr(str: model.name)+"("+String.noNilStr(str: model.amount)+")"
                resultStr.append(modelStr)
                if i<array.count-1{resultStr.append(",")}
            }
            resultIDArray.append(dic)
            i = i+1
        }
        productArray.removeAll()
        productArray = resultIDArray
        productStr = resultStr
        
        DLog(resultIDArray);
        DLog("返回的数据");
        self.datasourceArr[0][4].updateValue(String(sum), forKey: (self.datasourceArr[0][4].keys.first)!)
        self.datasourceArr[0][3].updateValue(String(resultStr), forKey: (self.datasourceArr[0][3].keys.first)!)
        tableView.reloadData()
    }
}
