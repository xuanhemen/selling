//
//  ProjectSituationVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
enum situationType {
    case noCheck  //没有做过体检
    case check    //做过体检
}
class ProjectSituationVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    let vModel:ProjectSituationViewModel = ProjectSituationViewModel()
    var model:ProjectSituationModel?
    //打开合并
    var upArray = Array<Int>()
    let topView = ProjectSituationTopView.init(frame: CGRect(x: 0, y: 10, width: MAIN_SCREEN_WIDTH-20, height: 264+44))
    let footerView = ProjectSituationBottomView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH-20, height: 150))
    var selectContactArr = Array<Dictionary<String,Any>>()//选中其他联系人列表
    var type:situationType?
    var projectID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.configData()
    }
    
    
    func configData(){

        self.refreshWithModel(model: model!)
        
    }
    
    
    //同步权限
    func synchronizationAuth(){
        let tab:ProjectSituationTabVC = self.tabBarController as! ProjectSituationTabVC
        if self.model?.close_status != "0" {
//            tab.isEditAuth = false
            return
        }
//        tab.isEditAuth = self.vModel.isAuthority()
    }
    
    
    func refreshWithModel(model:ProjectSituationModel){
        self.vModel.configWithModel(model: model)
        var productArray = Array<Dictionary<String,String>>()
        var productStr = ""
        var i = 0
        for dic in model.project_product {
        //QF -- mark 修改产品名称
            
            DLog(dic.product_name);
            DLog("返回的产品-------------------------------------")
            
           let priceStr = String.init(format: "%.2f", dic.amount)
            productArray.append(["id":dic.product_id,"products":dic.product_name,"price": priceStr,"status":String.noNilStr(str: dic.status)])
            if i == 0 {
                let modelStr = dic.product_name+"（\(priceStr)）"
                productStr.append(modelStr)
            }else{
                let modelStr = dic.product_name+"（\(priceStr)）"
                productStr.append(",")
                productStr.append(modelStr)
            }
            i+=1
        }
       
        self.model = model
        self.topView.isAuth = (self.model?.save_auth == "1")
        self.topView.configWithModel(model: model)
        self.selectContactArr = model.other_contact_arr_new
        self.topView.editClick = {[weak self] in
            self?.umAnalyticsWithName(name: um_projectEdit)
            let newP = HYEditProjectVC()
            
            let fomatter = DateFormatter.init()
                fomatter.dateFormat = "yyyy-MM-dd"
            var date:Date?
            if Double(model.dealtime!)! == 0 {
                date = Date.init(timeIntervalSinceNow: 0)
            }else{
                date = Date.init(timeIntervalSince1970: TimeInterval.init(Double(model.dealtime!)!))
            }
            
            let dateStr = fomatter.string(from: date!)
            
            let qfmodel = HYProjectModel()
            qfmodel.client_name = model.client_name ?? ""
            qfmodel.trade_name = model.trade_name ?? ""
            qfmodel.name = model.name ?? ""
            qfmodel.productStr = productStr
            qfmodel.amount = String.init(format: "%.2f", model.amount)
            qfmodel.down_payment = String.init(format: "%.2f", model.down_payment)
            qfmodel.dateStr = dateStr
            qfmodel.deps_name = model.deps_name
            
            qfmodel.projectId = model.id
            qfmodel.alreadyProductArray = productArray
            qfmodel.alreadyProductString = productStr
            qfmodel.userId = model.userid!
            qfmodel.client_id = model.client_id//客户id
            
            qfmodel.trade_id = model.trade_id!
            qfmodel.trade_parent_id = model.trade_parent_id!
            qfmodel.timerIntStr = Int(model.dealtime!)!//日期
            
            self?.navigationController?.pushViewController(newP, animated: true)
            newP.configData(with: qfmodel)
            newP.needUpdate = { [weak self] in
                self?.umAnalyticsWithName(name: um_projectEditSave)
                
                guard self?.tabBarController != nil else {
                    return;
                }
                if (self?.tabBarController?.isKind(of: ProjectSituationTabVC.self))! {
                    let tab:ProjectSituationTabVC = self?.tabBarController as! ProjectSituationTabVC
                    tab.toRefresh()
                }
                
            }
            //todo点击编辑项目
        }
        
        footerView.isAuth = (self.model?.save_auth == "1")
        if model.pro_anaylse_logic_id != "0" {
            self.type = .check
            footerView.type = .other
        }else{
            footerView.type = .up
            self.upArray.append(0)
            self.type = .noCheck
        }
       
        table.reloadData()
        self.synchronizationAuth()
    }
    
    
    

    func configUI(){
        
//        self.title = "项目概况"
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        
        self.view.addSubview(self.table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(10)
            make.right.equalTo(-10)
//            make.height.equalTo(0)
            make.bottom.equalToSuperview().offset(-TAB_HEIGHT)
        }
        self.table.delegate = self
        self.table.dataSource = self
        self.table.backgroundColor = UIColor.groupTableViewBackground
        
        //header
        
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 296+44))
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(topView)
        self.table.tableHeaderView = view
        
        //footer
        
        self.table.tableFooterView = footerView
        footerView.type = .up
        footerView.click = {[weak footerView,weak self] (type) in
            if type == .up {
                footerView?.type = .down
                footerView?.image.image = UIImage.init(named: "pstDown")
                self?.upArray.removeAll()
                self?.table.reloadSections([0], with: .none)
            }else if type == .down {
                footerView?.type = .up
                footerView?.image.image = UIImage.init(named: "pstUp")
                self?.upArray.append(0)
                self?.table.reloadSections([0], with: .none)
            }else{
                
                if self?.model?.pro_anaylse_logic_id != "0" {
                    let tab:ProjectSituationTabVC = self?.tabBarController as! ProjectSituationTabVC
                    tab.selectWithTag(tag: 2)
//                    self?.tabBarController?.selectedIndex = 1
                   self?.tabBarController?.navigationItem.rightBarButtonItems = nil
                }else{
                    let analysisVC = ProjectAnalysisVC()
                    analysisVC.model = self?.model
                    analysisVC.isAuth = (self?.model?.save_auth == "1"); self?.navigationController?.pushViewController(analysisVC, animated: true)
                }
            }
        }
    }
    
    
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.type == .noCheck {
            return self.vModel.membersHeight[indexPath.row]
        }
        
        if indexPath.section == 3 {
            return self.vModel.membersHeight[indexPath.row]
        }
        else if indexPath.section == 0{
            return self.vModel.logicSituationHeightArray[indexPath.row]
        }
        else if indexPath.section == 1{
            return self.vModel.logicSituationHeightArray[indexPath.row]
        }
        else if indexPath.section == 2{
            return 50
        }
        return 120
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.type == .noCheck {
            return 1
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.type == .noCheck {
            return 0
        }
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.type == .noCheck {
            return nil
        }
        let header = ProjectSituationHeader.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH-20, height: 60))
        //QF -- mark :标题换位置
        var headerTitle = self.vModel.headerTitles[section]
        if section == 3 {
            headerTitle = self.vModel.headerTitles[0]
        }
        if section == 0 {
            headerTitle = self.vModel.headerTitles[1]
        }
        if section == 1 {
            headerTitle = self.vModel.headerTitles[2]
        }
        if section == 2 {
            if self.type == .noCheck {
                headerTitle = self.vModel.headerTitles[2]
            }else{
                headerTitle = "联系人/角色信息"
            }
        }
        header.nameLable.text = headerTitle
        
        if (self.upArray.contains(section)) {
            header.headImage.image = UIImage.init(named: "pstArrowGreenUp")
        }else{
            header.headImage.image = UIImage.init(named: "pstArrow")
        }
        if section <= 2 {
            
            
            if self.model?.close_status != "0" {
                header.editBtn.isHidden = true
            }else{
//                header.editBtn.isHidden = false
                
                if self.model?.save_auth == "1"{
                    header.editBtn.isHidden = false
                }else{
                    header.editBtn.isHidden = true
                }
            }
            
        }else{
            header.editBtn.isHidden = true
        }
        
        header.click = {[weak self] (type) in
            
            if type == 1 {
                //QF -- change : 2 -> 1
                if section == 2 {
                    self?.addRole()
                }else if section == 1{
                    self?.editFlowWithIndex(i: 1)
                }else{
                    self?.editFlowWithIndex(i: 0)
                }
                return
            }
            
            if (self?.upArray.contains(section))! {
                let index = self?.upArray.index(of: section)
                guard index != nil else{
                    return
                }
                if index! < (self?.upArray.count)! {
                    self?.upArray.remove(at:index!)
                }
                
            }else{
                self?.upArray.append(section)
                
                
            }
            self?.table.reloadSections(IndexSet.init(integer: section), with: .automatic)
        }
        return header
        
    }
    
    
    //编辑形势、流程
    
    func editFlowWithIndex(i:Int) {
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id!
        params["logic_id"] = self.model?.pro_anaylse_logic_id
        if i==0 {
            
            PublicMethod.showProgress()
            LoginRequest.getPost(methodName: "pp.project.show_pro_situation", params: params.addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismiss()
            }) { [weak self](dic) in
                PublicMethod.dismiss()
                if let array:Array<Dictionary<String,Any>> = dic["data"] as? Array<Dictionary<String, Any>>{
                    var result = Array<ProAnalysisModel>()
                    for subDic in array {
                        let model = ProAnalysisModel.deserialize(from: subDic)
                        result.append(model!)
                    }
                    self?.configFlowData(result: result,index: 0)
                }
            }
        }else{
            
            PublicMethod.showProgress()
            LoginRequest.getPost(methodName: "pp.project.show_pro_procedure", params: params.addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismiss()
            }) { [weak self](dic) in
                PublicMethod.dismiss()
                if let array:Array<Dictionary<String,Any>> = dic["data"] as? Array<Dictionary<String, Any>>{
                    var result = Array<ProAnalysisModel>()
                    for subDic in array {
                        let model = ProAnalysisModel.deserialize(from: subDic)
                        result.append(model!)
                    }
                    self?.configFlowData(result: result,index: 1)
                }
            }
        }
    }
    
    
    //还原形势流程历史选择
    func configFlowData(result:Array<ProAnalysisModel>,index:Int){
        
        let vc = ProEditFlowVC()
        vc.model = self.model
        if index == 0 {
            vc.title = "项目形势"
            if (self.model?.situation_logic.count)! > 0 {
                if (self.model?.situation_logic.count)! == result.count{
                    for i in 0 ..< (self.model?.situation_logic.count)! {
                        let lModel = self.model?.situation_logic[i]
                        let model = result[i]
                        let array = model.list.filter({[weak lModel] (subModel) -> Bool in
                            return subModel.index == lModel?.index
                        })
                        if array.count > 0{
                            model.select = array.first
                        }
                    }
                }
                vc.dataArray = result
            }
            else{
                vc.dataArray = result
            }
            
        }else{
            vc.title = "采购流程"
            if (self.model?.procedure_logic.count)! > 0 {
                if (self.model?.procedure_logic.count)! == result.count{
                    for i in 0 ..< (self.model?.procedure_logic.count)! {
                        let lModel = self.model?.procedure_logic[i]
                        let model = result[i]
                        let array = model.list.filter({[weak lModel] (subModel) -> Bool in
                            return subModel.index == lModel?.index
                        })
                        if array.count > 0{
                            model.select = array.first
                        }
                    }
                }
                vc.dataArray = result
            }
            else{
                vc.dataArray = result
            }
        }
        
        vc.click = { [weak self] in
            let tab:ProjectSituationTabVC = self?.tabBarController as! ProjectSituationTabVC
            tab.toRefresh()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    //添加角色
    func addRole(){
        let vc  = ProEditRoleInfoVC()
        vc.isAuth = (self.model?.save_auth == "1")
        vc.title = self.model?.name
        vc.model = self.model
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //未检测
        if self.type == .noCheck {
            if upArray.count > 0{
                return 3
            }else{
                return 0
            }
        }
        
        //已经检查过的
        if self.upArray.contains(section) {
            if section == 3 {
                return 2
            }else if section == 0{
                return (self.model?.situation_logic.count)!
            }else if section == 1{
                return (self.model?.procedure_logic.count)!
            }else if section == 2{
                return (self.model?.logic_people.count)!
            }else if section == 4{
                return 0
            }
            
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.type == .noCheck {
            return self.configNoCheckCell(indexPath: indexPath, tableView: tableView)
        }else{
            return self.configCheckCell(indexPath: indexPath, tableView: tableView)
        }
    }
    
    
    //没有做过检查
    func configNoCheckCell(indexPath: IndexPath,tableView: UITableView)->(UITableViewCell){
        let cellIde = "cell"
        var cell:ProSituationMemberCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProSituationMemberCell
        if cell == nil {
            cell = ProSituationMemberCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.clickPeople = {[weak self] (pid,type) in
            self?.contactDetail(pid: pid,type: type)
        }
        
        self.disposeMembersCell(cell: cell!, indexPath: indexPath)
        return cell!
    }
    
    
    func contactDetail(pid:String,type:memberStyle?){
        //点击头像进入联系人详情
        if type == .contacts {
//            sssssssssssssssssssss
            
                    PublicMethod.showProgress()
                    LoginRequest.getPost(methodName: CONTACT_DETAIL, params: ["contact_id":pid].addToken(), hadToast: true, fail: { (dic) in
                        PublicMethod.dismiss()
                    }) {[weak self] (dic) in
                         PublicMethod.dismiss()
                        DLog(dic)
                        let vc = ContactDetailVC()
                        vc.modelDic = dic
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
            
            
        }else{
            PublicPush().pushToUserInfo(imId:"",userId:pid,vc:self)
        }
        
        
        

        
        
        
    }
    
    
    
    
    //做过检查
    func configCheckCell(indexPath: IndexPath,tableView: UITableView)->(UITableViewCell){
        if indexPath.section == 3 {
            return self.configNoCheckCell(indexPath:indexPath, tableView:tableView)
        }
        else if indexPath.section == 0 {
            let cellIde = "ProLoginSituationCell"
            var cell:ProLoginSituationCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProLoginSituationCell
            if cell == nil {
                cell = ProLoginSituationCell.init(style: .default, reuseIdentifier: cellIde)
            }
            cell?.model = self.model?.situation_logic[indexPath.row]
            cell?.headImage.isHidden = true
            return cell!
        }
        else if indexPath.section == 1 {
            let cellIde = "ProLoginSituationCell"
            var cell:ProLoginSituationCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProLoginSituationCell
            if cell == nil {
                cell = ProLoginSituationCell.init(style: .default, reuseIdentifier: cellIde)
            }
            cell?.model = self.model?.procedure_logic[indexPath.row]
            cell?.headImage.isHidden = true
            return cell!
        }
        else if indexPath.section == 2 {
            let cellIde = "LogicPeopleCell"
            var cell:LogicPeopleCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? LogicPeopleCell
            if cell == nil {
                cell = LogicPeopleCell.init(style: .default, reuseIdentifier: cellIde)
            }
            cell?.accessoryType = .disclosureIndicator
            cell?.model = self.model?.logic_people[indexPath.row]
            cell?.btn.isHidden = true
            cell?.click = {[weak self] (model) in
                
                let alert = UIAlertController.init(title: "确定删除吗？", message: "", preferredStyle: .alert, btns: [kCancel:"取消","sure":"确定"], btnActions: { (ac, str) in
                    if str != kCancel {
                        self?.toDeleteLogicPeople(model: model, index: indexPath)
                    }
                })
                self?.present(alert, animated: true, completion: nil)
                
            }
            
            
            if cell?.model?.whether_input == "0" {
                cell?.red.isHidden = false
            }else{
               cell?.red.isHidden = true
            }
            
            
            return cell!
        }
        else{
        let cellIde = "cellll"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIde)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIde)
        }
       
            return cell!
        }
        
    }
    
    
    //处理参与者，观察员cell
    func disposeMembersCell(cell:ProSituationMemberCell,indexPath: IndexPath){
        cell.projectId = self.model?.id!
        if indexPath.row < 2 {
            cell.cellAuth = (self.model?.principal_auth)!
        }else{
            cell.cellAuth = (self.model?.save_auth)!
        }
        DLog(self.vModel.membersArray[indexPath.row])
        cell.type = memberStyle(rawValue: indexPath.row)
        cell.nameLable.text = self.vModel.membersTitles[indexPath.row]
        cell.isDelete = self.vModel.membersIsdelete[indexPath.row]
        cell.configAlReady(array:self.vModel.membersArray[indexPath.row])
        cell.click = {[weak self,weak cell] (str) in
            //todo cj
            
            if cell?.nameLable.text == "联系人"{
                
                if str == "+" {
                    let addC = HYSelectContactVC()
                    let clientModel = HYClientModel()
                    clientModel.id = String.noNilStr(str: self?.model?.client_id)
                    clientModel.name = String.noNilStr(str: self?.model?.client_name)
                    addC.clientModel = clientModel
                    if addC.clientModel.id == "" || addC.clientModel.id == "0"{
                        PublicMethod.toastWithText(toastText: "确定客户后才可以操作")
                        return;
                    }
                    
                    DLog(self?.vModel.membersArray[indexPath.row])
                    
                    addC.getResult = {[weak self] (list) in
                        let array:Array<Dictionary<String, Any>> = list as! [Dictionary<String, Any>]
                        self?.selectContactArr = array
                        var params = Dictionary<String,Any>()
                        params["project_id"] = self?.model?.id
                        params["contacts"] = SignTool.makeJsonStrWith(object: list)
                        
                        
                        LoginRequest.getPost(methodName: SAVE_CONTACTS, params: params.addToken(), hadToast: true, fail: { (dic) in
                            PublicMethod.dismiss()
                            PublicMethod.toastWithText(toastText: "添加失败")
                        }, success: {[weak self] (dic) in
                            PublicMethod.dismiss()
                            var result = Array<MemberModel>()
                            for dic in array{
                                
                                result.append(MemberModel.configWithDic(dic: ["id":dic["id"] ?? "","realname":dic["name"],"head":""]))
                                
                            }
                            if result.count > 0{
                                
                                let arr = result.map({ (model) -> String in
                                    return model.id!
                                })
                                
                                let idStr = (arr + cell!.resultIds()).joined(separator: ",") as String
                                
                                self?.toRefresh()
                                
                                
                                
                                //先走网络，添加完成在做本地UI更新
                                //                        self?.addMember(type: (cell?.type!)!, projectId: (self?.model?.id!)!, resultIdStr: idStr, result: {
                                self?.vModel.membersArray[indexPath.row] = result
                                cell?.configAlReady(array:result)
                                let height = cell?.refreshHeight()
                                DLog("height:"+String(describing: height))
                                if self?.vModel.membersHeight[indexPath.row] != height {
                                    self?.vModel.membersHeight[indexPath.row] = height!
                                    DLog("height:["+String(describing: indexPath.row)+"]"+String(describing: self?.vModel.membersHeight[indexPath.row]))
                                    self?.table.reloadData()
                                }
                            }
                        })
                    }
                    
                    addC.alreadyArray = (self?.selectContactArr)!
                    self?.navigationController?.pushViewController(addC, animated: true)
                    return
                    
                }
                if str == "-" {
                    let addC = HYDelContactVC()
                    addC.comeType = 1
                    addC.clientName = String.noNilStr(str: self?.model?.client_name)
                    addC.clientId = String.noNilStr(str: self?.model?.client_id)
                    if addC.clientId == "" || addC.clientId == "0"{
                        PublicMethod.toastWithText(toastText: "确定客户后才可以操作")
                        return;
                    }
                    
                    DLog(self?.vModel.membersArray[indexPath.row])
                    
                    addC.getResult = {[weak self] (list) in
                        let array:Array<Dictionary<String, Any>> = list as! [Dictionary<String, Any>]
                        self?.selectContactArr = array
                        var params = Dictionary<String,Any>()
                        params["project_id"] = self?.model?.id
                        params["contacts"] = SignTool.makeJsonStrWith(object: list)
                        
                        
                        LoginRequest.getPost(methodName: SAVE_CONTACTS, params: params.addToken(), hadToast: true, fail: { (dic) in
                            PublicMethod.dismiss()
                            PublicMethod.toastWithText(toastText: "删除失败")
                        }, success: {[weak self] (dic) in
                            PublicMethod.dismiss()
                            var result = Array<MemberModel>()
                            for dic in array{
                                
                                result.append(MemberModel.configWithDic(dic: ["id":dic["id"] ?? "","realname":dic["name"],"head":""]))
                                
                            }
                            if result.count >= 0{
                                
                                let arr = result.map({ (model) -> String in
                                    return model.id!
                                })
                                
                                let idStr = (arr + cell!.resultIds()).joined(separator: ",") as String
                                
                                self?.toRefresh()
                                
                                self?.vModel.membersArray[indexPath.row] = result
                                cell?.configAlReady(array:result)
                                let height = cell?.refreshHeight()
                                DLog("height:"+String(describing: height))
                                if self?.vModel.membersHeight[indexPath.row] != height {
                                    self?.vModel.membersHeight[indexPath.row] = height!
                                    DLog("height:["+String(describing: indexPath.row)+"]"+String(describing: self?.vModel.membersHeight[indexPath.row]))
                                    self?.table.reloadData()
                                }
                            }
                        })
                    }
                    
                    addC.alreadyArray = (self?.selectContactArr)!
                    self?.navigationController?.pushViewController(addC, animated: true)
                    return
                }
                
                
            }
            
            if str == "+" {
                self?.vModel.membersIsdelete[indexPath.row] = false
                cell?.collectionView.reloadData()
                let vc = TutoringMembersVC()
                let array = ["选择参与人","选择观察员","选择联系人"]
                vc.title = array[indexPath.row]
                if indexPath.row == 2 {
                    //联系人需要特殊处理
                    vc.style = .contact
                    vc.clientId = self?.model?.client_id
                }
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
                vc.userId = UserModel.getUserModel().id!
                vc.type = .multiple
                
                vc.configAlReadyArray(alReady: (cell?.currentMember())!)
                vc.resultArray = {[weak self,weak cell](result) in
                    
                    if result.count > 0{
                        
                        let arr = result.map({ (model) -> String in
                            return model.id!
                        })
                        
                        if indexPath.row != 2 {
                            //以前let idStr = (arr + cell!.resultIds()).joined(separator: ",") as String
                            //先走网络，添加完成在做本地UI更新
                            let idStr = arr.joined(separator: ",") as String
                            
                            self?.addMember(type: (cell?.type!)!, projectId: (self?.model?.id!)!, resultIdStr: idStr, result: {
                                self?.vModel.membersArray[indexPath.row] = result
                                cell?.configAlReady(array:result)
                                let height = cell?.refreshHeight()
                                if self?.vModel.membersHeight[indexPath.row] != height {
                                    self?.vModel.membersHeight[indexPath.row] = height!
                                    self?.table.reloadRows(at: [indexPath], with: .none)
                                }
                            })
                        }else{
                            //todo cj
                            
                            //联系人
                            let array = result + cell!.currentMember()
                            
                            self?.addContacts(array: array, result: {
                                self?.vModel.membersArray[indexPath.row] = result
                                cell?.configAlReady(array:result)
                                let height = cell?.refreshHeight()
                                if self?.vModel.membersHeight[indexPath.row] != height {
                                    self?.vModel.membersHeight[indexPath.row] = height!
                                    self?.table.reloadRows(at: [indexPath], with: .none)
                                }
                            })
                            
                        }
                        
                        
                    }
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }else if str == "-"{
                //TODO比较乱 临时改动   有时间做整理
                if self?.vModel.membersIsdelete[indexPath.row] == true{
//                    if (cell?.dataArray.count)! > 1 {
                        self?.addMember(type: (cell?.type!)!, projectId: (self?.model?.id!)!, resultIdStr: (cell?.resultIdStr())!, result: {
                            self?.vModel.membersIsdelete[indexPath.row] = !(self?.vModel.membersIsdelete[indexPath.row])!
                            cell?.isDelete = (self?.vModel.membersIsdelete[indexPath.row])!
                            cell?.collectionView.reloadData()
                        })
//                    }
//                else{
//                        DLog("DDDDDDDDDDDDDDDDD")
//                        self?.vModel.membersIsdelete[indexPath.row] = !(self?.vModel.membersIsdelete[indexPath.row])!
//                        cell?.isDelete = (self?.vModel.membersIsdelete[indexPath.row])!
//                        cell?.collectionView.reloadData()
//                    }
                
                    
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
                    self?.table.beginUpdates()
                    self?.table.endUpdates()
                }
                
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 {
            
            
            if self.model?.logic_people[indexPath.row].whether_input == "0" {
                self.fetchRoleData(id: (self.model?.logic_people[indexPath.row].id)!)
            }else{
                
                let vc = RoleInfoVC()
                vc.isAuth = (self.model?.save_auth == "1")
                vc.situationModel = self.model
                vc.id = self.model?.logic_people[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            
            
        }
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //删除角色信息
    func toDeleteLogicPeople(model:LogicPeopleModel,index:IndexPath){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DEL_PEOPLE, params: ["people_id":model.id!].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            self?.model?.logic_people.remove(at: index.row)
            self?.table.reloadSections([index.section], with: .none)
            PublicMethod.dismissWithSuccess(str: "删除成功")
            
        }
        
    }

    
    
    
    //添加成员    要求必需每次操作都需要调动网络
    func addMember(type:memberStyle,projectId:String,resultIdStr:String,result:@escaping ()->()){
        var url = ""
        var params = Dictionary<String,Any>()
        params["project_id"] = projectId
        if type == .patter{
            url = SAVE_PARTNERS
            params["partners"] = resultIdStr
        }else if type == .observer{
            url = SAVE_OBSERVER
            params["observer"] = resultIdStr
        }else{
            url = SAVE_CONTACTS
            params["contacts"] = resultIdStr
        }
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: url, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: "添加失败")
        }, success: {(dic) in
            PublicMethod.dismiss()
             result()
        })
    }
    
    func addContacts(array:Array<MemberModel>,result:@escaping ()->()){
        PublicMethod.showProgress()
        
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id
        var contacts = Array<Dictionary<String,Any>>()
        for model in array {
            let dic = model.toJSON()
            contacts.append(dic!)
        }
        params["contacts"] = LoginRequest.makeJsonStringWithObject(object: contacts)
        
        
        LoginRequest.getPost(methodName: SAVE_CONTACTS, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: "添加失败")
        }, success: {(dic) in
            PublicMethod.dismiss()
            result()
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //先获取到角色信息 再修改
    func fetchRoleData(id:String){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: LOGIC_PEOPLE_INFO, params: ["people_id":id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            if let mymodel = LogicPeopleInfoModel.deserialize(from: dic){
                if Int(mymodel.save_auth)!>=1  {
                    self?.gotoEditRole(projectId: (self?.model?.id)!,roleModel:mymodel)
                }else{
                    
                    //没有修改权限修改  可查看
                    let vc = RoleInfoVC()
                    vc.isAuth = (self?.model?.save_auth == "1")
                    vc.situationModel = self?.model
                    vc.id = id
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
        }
    }
    
    
    //修改
    func gotoEditRole(projectId:String,roleModel:LogicPeopleInfoModel) {
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName:PARAM_PEOPLE, params: ["project_id":projectId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }, success: {[weak self] (dic) in
            PublicMethod.dismiss()
            if  let newModel:ProParamsPeople = ProParamsPeople.deserialize(from: dic)!{
                let vc =  ProjectAddRoleAnalysisVC();
                vc.projectId = projectId
                vc.parentid = roleModel.parentid
                vc.situationModel = self?.model
                vc.model = newModel
                vc.peopleId = roleModel.id
                vc.contact_id = roleModel.contact_id
                vc.textArray = [ roleModel.name,roleModel.department,roleModel.level_str,roleModel.style_str,roleModel.sub_str,roleModel.impact_str,roleModel.engagement_str,roleModel.feedback_str,roleModel.support_str,roleModel.orgresult_str,roleModel.personalwin_str,roleModel.parent_str]
                if !(roleModel.coach_str.isEmpty) {
                    vc.textArray.insert(roleModel.coach_str, at: 11)
                }
                self?.navigationController?.pushViewController(vc, animated: true)
                vc.click = {[weak self](_,_) in
                    let tab:ProjectSituationTabVC = self?.tabBarController as! ProjectSituationTabVC
                    tab.toRefresh()
                }
            }
        })
    }
    
    
    
    func toRefresh(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                self?.model = model;
                self?.vModel.configWithModel(model: model)
                self?.table.reloadData()
            }
        }
    }
    
    
}



