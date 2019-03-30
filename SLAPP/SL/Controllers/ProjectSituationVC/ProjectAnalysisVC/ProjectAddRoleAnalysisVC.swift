//
//  ProjectAddRoleAnalysisVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import SwiftyJSON

let cStr1 = "117"
let cStr2 = "118"

class ProjectAddRoleAnalysisVC: BaseVC,UITableViewDataSource,UITableViewDelegate {
    var click:(_ name:String,_ id:String)->() = {_,_ in
        
    }
    
    //和peopleId 不一样   新增和修改都需要上传
    var contact_id:String?
    
    //项目概况   这里直接上级会用到角色信息
    var situationModel:ProjectSituationModel?
    var model:ProParamsPeople?
    var projectId:String?
    var peopleId:String?
    var parentid:String = "0"
    var titleArray = ["姓名:","部门:","职级:","风格:","细分角色:","影响力:","参与度:","反馈态度:","支持度:","组织结果:","个人赢:","直接上级:"]
    
//    var titleArray = ["姓名:","部门:","职位:","风格:","角色:","细分角色:","影响力:","参与度:","反馈态度:","支持度:","组织结果:","个人赢:","Coach指导级别:","直接上级:"]
    var placeArray = ["姓名","部门","职级","此人的处事风格是怎样的?","此人的细分角色是?","此人的影响力是","此人对项目的参与程度","对此事的态度","此人对你的支持度","对他们公司的价值","对他个人带来的利弊",""]
    var textArray = ["","","","","","","","","","","","无"]
    var isEditArray = ["","","","","","","","","","","","无"]
    var selectModel:ProAddContactModel?
    
    //上级数据源
    var chooseArray:Array<Dictionary<String,Any>> = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.peopleId == nil {
            self.title =  "添加角色信息"
        }else{
            self.title =  "修改角色信息"
        }
        
        self.configUI()
        
        isEditArray = textArray
        
        self.isCoach(str: (self.model?.subId(str:textArray[4]).joined(separator: ","))!)
        
    }

    override func rightBtnClick(button: UIButton) {
        self.saveClick()
    }
    
    override func backBtnClick() {

        var isEdit = false
        for i in 0..<textArray.count{
            let str1 = textArray[i]
            let str2 = isEditArray[i]
            if str1 != str2 {
                isEdit = true
                break
            }
        }
        
        if isEdit == false {
            self.navigationController?.popViewController(animated: true)
            return
        }

        let alert = UIAlertController.init(title: "提醒", message: "该界面有没有保存的信息，是否保存", preferredStyle: .alert, btns: [kCancel:"不保存","sure":"保存"], btnActions: {[weak self] (ac, str) in
            if str != kCancel {
                self?.saveClick()
            }else{
                self?.navigationController?.popViewController(animated: true)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func configUI(){
        self.view.backgroundColor = UIColor.groupTableViewBackground
        table.backgroundColor = UIColor.groupTableViewBackground
        table.separatorStyle = .none
        self.view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        table.delegate = self
        table.dataSource = self
        
        self.setRightBtnWithArray(items: ["保存"])
        self.configBackItem()
//        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 100))
//        let btn = UIButton.init(type: .custom)
//        btn.setTitle("保存", for: .normal)
//        footView.addSubview(btn)
//        btn.backgroundColor = kGreenColor
//        btn.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.height.equalTo(49)
//            make.centerY.equalToSuperview()
//        }
//        table.tableFooterView = footView
//        btn.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
    }
    
//    保存点击
    @objc func saveClick(){
        
        PublicMethod.showProgress()
        var params = Dictionary<String,Any>()
        params["project_id"] = self.situationModel?.id
        params["logic_id"] = ""
        
        var dic = Dictionary<String,Any>()
        dic["name"] = textArray[0]
        dic["department"] = textArray[1]
        //级别
        dic["level"] =  self.model?.levelId(str: textArray[2]).first?.index;
        //分格
//        dic["style"] = textArray[3]
//        //角色
        dic["style"] =  self.model?.styleId(str: textArray[3]).first?.index
        //细分角色
        dic["sub"] = self.model?.subId(str:textArray[4]).joined(separator: ",")
        //影响
        dic["impact"] =  self.model?.impactId(str: textArray[5]).first?.index
        //参与
        dic["engagement"] =  self.model?.engagementId(str: textArray[6]).first?.index
        //反馈
        dic["feedback"] = self.model?.feedbackId(str: textArray[7]).first?.index
        //支持度
        dic["support"] = self.model?.supportId(str: textArray[8]).first?.index
        //组织结果
        dic["orgresult"] =  self.model?.orgresultId(str: textArray[9]).first?.index
        //个人赢
        dic["personalwin"] = self.model?.personalwinId(str: textArray[10]).first?.index
//        //coach 指导级别
//        dic["coach"] = textArray[12]
        if textArray.count == 13 {
            dic["coach"] = self.model?.coachId(str: textArray[11]).first?.index;
        }
        
        
        dic["parentid"] = self.parentid
        
        
        if selectModel != nil {
            dic["contact_id"] = selectModel?.id
        }else{
            if (self.contact_id != nil){
                dic["contact_id"] = self.contact_id
            }
            
        }
        params["more"] = LoginRequest.makeJsonStringWithObject(object: dic)
        
        if self.peopleId != nil {
            params["people_id"] = self.peopleId
            
            LoginRequest.getPost(methodName: PROJECT_SAVE_PEOPLE, params: params.addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismiss()
            }) {[weak self] (dic) in
                PublicMethod.dismiss()
                self?.click("",String.noNilStr(str: dic["data"]))
                self?.navigationController?.popViewController(animated: true)
            }
        }else{
            
            LoginRequest.getPost(methodName: PROJECT_ADD_PEOPLE, params: params.addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismiss()
            }) {[weak self] (dic) in
                
                PublicMethod.dismiss()
                self?.click((self?.textArray.first!)!,JSON(dic["data"]).stringValue)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    
    
    
    
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cellIde = "celltop"
            var cell:AddRoleAnalysisTopCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? AddRoleAnalysisTopCell
            if cell == nil {
                cell = AddRoleAnalysisTopCell.init(style: .default, reuseIdentifier: cellIde)
            }
            cell?.nameLable.text = titleArray[indexPath.row]
            cell?.textField.text = textArray[indexPath.row]
            cell?.textField.placeholder = placeArray[indexPath.row]
            if selectModel != nil {
               cell?.textField.text = selectModel?.name
              self.textArray[indexPath.row] = (selectModel?.name)!
            }
            cell?.textField.reactive.continuousTextValues.observe { [weak self](text) in
                if indexPath.row == 0 {
                    if text.value != nil {
                        let str = String.noNilStr(str: text.value!! as Any)
                        self?.textArray[indexPath.row] = str
                    }
                }
            }
//            cell?.textField.isEnabled = false
            cell?.btnClick = { [weak self] in
            let vc = ProChooseContactVC()
                vc.projectID = (self?.projectId)!
                vc.situationModel = self?.situationModel
                vc.result = {[weak self] (model) in
                    self?.selectModel = model
                    self?.table.reloadData()
                }
            self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell!
        }else if indexPath.row == self.titleArray.count-1 {
            let cellIde = "celltop1"
            var cell:AddRoleAnalysisTopCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? AddRoleAnalysisTopCell
            if cell == nil {
                cell = AddRoleAnalysisTopCell.init(style: .default, reuseIdentifier: cellIde)
            }
            cell?.nameLable.text = titleArray[indexPath.row]
            cell?.textField.text = textArray[indexPath.row]
            cell?.textField.placeholder = placeArray[indexPath.row]
            cell?.textField.isEnabled = false
            cell?.btn.setImage(UIImage.init(named: "addCoach"), for: .normal)
            cell?.btnClick = { [weak self] in
                let vc =  ProjectAddRoleAnalysisVC();
                vc.projectId = self?.projectId
                vc.situationModel = self?.situationModel
                vc.click = { (name,id) in
                    self?.textArray[(self?.textArray.count)!-1] = name
                    self?.parentid = id
                    self?.table.reloadData()
                }
                vc.model = self?.model;
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }
            return cell!
        }
        else{
        let cellIde = "cell"
        var cell:AddRoleAnalysisCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? AddRoleAnalysisCell
        if cell == nil {
            cell = AddRoleAnalysisCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.nameLable.text = titleArray[indexPath.row]
        cell?.textField.placeholder = placeArray[indexPath.row]
        cell?.textField.reactive.continuousTextValues.observe { [weak self](text) in
            if indexPath.row == 1 {
                if text.value != nil {
                    
                    let str = String.noNilStr(str: text.value!! as Any)
                    self?.textArray[indexPath.row] = str
                }
            }
        }
        
        if indexPath.row <= 1 {
            cell?.textField.isEnabled = true
        }else{
            cell?.textField.isEnabled = false
        }
        
        cell?.textField.text = self.textArray[indexPath.row]
            if cell?.nameLable.text == "细分角色:" {
                let baseString = cell?.textField.text
                var newString = ""
                if (baseString?.components(separatedBy: "：").count)! > 1 {
                  let baseArr = baseString?.components(separatedBy: ",")
                    for subS in baseArr! {
                        newString.append((subS.components(separatedBy: "：").first)!)
                        newString.append(",")
                    }
                    newString.removeLast()
                    cell?.textField.text = newString
                }
            }
        return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            return
        }
        var titles = Array<String>()
        switch indexPath.row {
        case 0:   return
         
        case 1: break
        case 2:
            titles = (self.model?.levelTitles())!
            break
        case 3:
            titles = (self.model?.styleTitles())!
            break
        case 4:
            titles = (self.model?.subTitles())!
            break
        case 5:
            titles = (self.model?.impactTitles())!
            break
        case 6:
            titles = (self.model?.engagementTitles())!
            break
        case 7:
            titles = (self.model?.feedbackTitles())!
        case 8:
            titles = (self.model?.supportTitles())!
        case 9:
            titles = (self.model?.orgresultTitles())!
        case 10:
            titles = (self.model?.personalwinTitles())!
        default:
            break
        }
        
        if titleArray[indexPath.row] == "指导级别:" {
            titles = (self.model?.coachTitles())!
        }
        
        if titleArray[indexPath.row] == "直接上级:" {
            
            self.canChooseParent { [weak self] () in
                var array = self?.chooseTitles()
                array?.insert("无", at: 0)
                let check = CheckView.configWithTitles(titles: array!)
                check.click = {[weak self] (str,index)  in
                    self?.parentid = (self?.chooseId(str: str))!
                self?.textArray[indexPath.row] = str
                self?.table.reloadRows(at: [indexPath], with: .none)
                }
                if !(self?.textArray[(self?.textArray.count)!-1].isEmpty)! {
                    check.selecArray = [self?.textArray[(self?.textArray.count)!-1]] as! [String]
                check.refresh()
                }
            }
        }
        else{
            let check = CheckView.configWithTitles(titles: titles)
            let str = textArray[indexPath.row]
            if indexPath.row == 4 {
                check.style = .multiple
                if str.contains(","){
                    check.selecArray = str.components(separatedBy: ",")
                }else{
                    if !str.isEmpty {
                        check.selecArray = [textArray[indexPath.row]]
                    }
                }
            }else{
                if !str.isEmpty {
                    check.selecArray = [textArray[indexPath.row]]
                }
            }
            check.nameLable.text = "请选择"+titleArray[indexPath.row]
            if check.nameLable.text == "请选择风格:" {
                check.nameLable.text = "此人的处事风格是怎样的："
            }
            if check.nameLable.text == "请选择细分角色:" {
                check.nameLable.text = "此人的细分角色是："
            }
            if check.nameLable.text == "请选择影响力:" {
                check.nameLable.text = "此人的影响力是："
            }
            if check.nameLable.text == "请选择参与度:" {
                check.nameLable.text = "此人对项目的参与程度："
            }
            if check.nameLable.text == "请选择反馈态度:" {
                check.nameLable.text = "对此事的态度："
            }
            if check.nameLable.text == "请选择支持度:" {
                check.nameLable.text = "此人对你的支持度："
            }
            if check.nameLable.text == "请选择组织结果:" {
                check.nameLable.text = "对他们公司的价值："
            }
            if check.nameLable.text == "请选择个人赢:" {
                check.nameLable.text = "对他个人带来的利弊："
            }
            
            
            check.click = {[weak self] (str,index)  in
                self?.textArray[indexPath.row] = str
                if (indexPath.row == 4){
                    self?.isCoach(str: (self?.model?.subId(str:(self?.textArray[4])!).joined(separator: ","))!)
                    }
                self?.table.reloadData()
            }
            check.refresh()
        }
    }
    
    func isCoach(str:String){
        if str.contains(cStr1) || str.contains(cStr2) {
            if self.titleArray.count == 12 {
                self.titleArray.insert("指导级别:", at: 11)
                self.placeArray.insert("指导级别", at: 11)
                if self.textArray.count == 12 {
                    self.textArray.insert("", at: 11)
                }
            }
        }else{
            
            if self.titleArray.count != 12 {
                self.titleArray.remove(at: 11)
                self.placeArray.remove(at: 11)
                self.textArray.remove(at: 11)
            }
        }
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func canChooseParent(end:@escaping ()->()){
        PublicMethod.showProgress()
        var params = Dictionary<String,Any>()
        
        if self.peopleId != nil {
            params["people_id"] = self.peopleId
        }
        
        if selectModel != nil {
           params["people_id"] = selectModel?.contact_id
        }
        
        params["project_id"] = self.situationModel?.id
        
        LoginRequest.getPost(methodName: PEOPLE_PARENT, params: params.addToken(), hadToast: true, fail: { (dic) in
             PublicMethod.dismiss()
        }) {[weak self] (dic) in
            self?.chooseArray = JSON(dic["data"] as Any).arrayObject as! Array<Dictionary<String, Any>>
            PublicMethod.dismiss()
            end()
        }
        
    }
    
    
    //获取可选择的上级的名称
    func chooseTitles()->([String]){
      return self.chooseArray.map { (dic) -> String in
        return JSON(dic["name"] as Any).stringValue
        }
    }
    
    //获取对应选择的上级的id
    func chooseId(str:String)->(String){
        
        let array = self.chooseArray.filter { (model) -> Bool in
            return JSON(model["name"] as Any).stringValue == str
        }
        
        if array.count > 0{
            return JSON(array.first!["id"] as Any).stringValue
        }else{
            return "0"
        }
        
        
    }
    
}
