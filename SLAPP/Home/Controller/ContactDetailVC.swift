//
//  ContactDetailVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ContactDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let topViewHeight : CGFloat = 230
    let topBottomMargin : CGFloat = 20
    var index:Int = 0
    var proList:Array<Dictionary<String,Any>> = Array()

    @objc var modelDic = Dictionary<String,Any>(){
        didSet{
            
            proList = modelDic["pro"] as! Array<Dictionary<String, Any>>
            self.table.reloadData()
        }
    }
    
    var contactDetailView : ContactDetailView!
    
    lazy var table:UITableView = {
        let tb = UITableView.init(frame: CGRect.init(x: 15, y: 0, width: MAIN_SCREEN_WIDTH - 30, height: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT), style: .plain)
        tb.backgroundColor = UIColor.groupTableViewBackground
        tb.separatorStyle = .none
        
        tb.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH - 30, height: 0.1))
        return tb
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "联系人详情"
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        if JSON(self.modelDic["save_auth"] as Any).stringValue == "1" {
            self.setRightBtnWithArray(items: [UIImage.init(named: "customer_edit")])
        }
        
        self.view.addSubview(table)
      
        //联系人信息详情页面
        self.addHeader()
        
//        self.view.addSubview(contactDetailView)
        
        contactDetailView.switchBtnClickBlock = ({(btn) in
            switch btn.tag {
            case 10:
                DLog(btn.titleLabel?.text)
                self.index = 0
                self.table.reloadData()
            case 11:
                DLog(btn.titleLabel?.text)
                self.index = 1
                self.table.reloadData()
            default:
                break
            }
        })
        table.delegate = self
        table.dataSource = self

        self.getMsgNum()
    }

    func getRedNum(){
        //显示红点
        LoginRequest.getPost(methodName: QF_contact_red_point, params: ["id":String.noNilStr(str: self.modelDic["id"])].addToken(), hadToast: false, fail: { (dic) in
            
        }) {[weak self] (dic) in
            DLog(dic);
            
            if JSON(dic["is_have"] as Any).intValue > 0 {
               
                self?.contactDetailView.redView.isHidden = false
                self?.contactDetailView.redBackView.isHidden = true
            }else{
                self?.contactDetailView.redView.isHidden = true
                self?.contactDetailView.redBackView.isHidden = true
            }
        }
        
    }
    //    获取消息个数
    func getMsgNum(){
        
        guard modelDic != nil else {
            return
        }
        
        //显示个数
        LoginRequest.getPost(methodName: QF_contact_newMessage_num, params: ["id":String.noNilStr(str: self.modelDic["id"])].addToken(), hadToast: false, fail: { (dic) in
            
        }) { [weak self](dic) in
            if JSON(dic["new_message_num"] as Any).intValue == 0 {
                self?.contactDetailView.redView.isHidden = true
                self?.contactDetailView.redBackView.isHidden = true
                self?.getRedNum()
            }
            else{
                let num = JSON(dic["new_message_num"] as Any).intValue
                self?.contactDetailView.redView.isHidden = true
                self?.contactDetailView.redBackView.isHidden = false
                if num > 99 {
                    self?.contactDetailView.redNumLabel.text = "99+"
                }else{
                    self?.contactDetailView.redNumLabel.text = String.init(format: "%d", num)
                }
                
            }
        }
    }
    
    func addHeader(){
        if (contactDetailView != nil) {
            contactDetailView.removeFromSuperview()
        }
        self.table.tableHeaderView = nil
        let array = self.configShare()
        var str = ""
        if array.count>1 {
            str = array.joined(separator: "\n")
        }else{
            if array.count > 0 {
                str = array.first!
            }
            
        }
        let height = UILabel.getHeightWith(str: str, font: 15, width: MAIN_SCREEN_WIDTH-30)
        
        contactDetailView = ContactDetailView.init(modelArr: ["login_avatar",String.noNilStr(str: modelDic["name"]),String.noNilStr(str: modelDic["position_name"]),String.noNilStr(str: modelDic["client_name"]),String.noNilStr(str: modelDic["phone"]),String.noNilStr(str: modelDic["email"]),str], frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: topViewHeight+height+40+60))
        contactDetailView.gotoContactTimeLine = { [weak self] in
            self?.contactDetailView.redView.isHidden = true
            let qfvc = QFTimeLineVC()
            qfvc.contactId = String.noNilStr(str: self?.modelDic["id"])
            qfvc.contactName = String.noNilStr(str: self?.modelDic["name"])
            qfvc.clientId = String.noNilStr(str: self?.modelDic["client_id"])
            self?.navigationController?.pushViewController(qfvc, animated: true)
            return
        }
        table.tableHeaderView = contactDetailView
        
    }
    
    
    
    
    override func rightBtnClick(button: UIButton) {
        
        self.updateInfo { [weak self] in
            self?.toEdit()
        }
        
        
        
    }
    
    func toEdit(){
        let addVC = HYAddContactVC()
        addVC.contactInfo = modelDic
        addVC.action = {[weak self]  in
            self?.getContactDetail(contactId: self?.modelDic["id"] as! String)
        }
        
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    //获取联系人详情
    func getContactDetail(contactId:String) {
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CONTACT_DETAIL, params: [kToken:UserModel.getUserModel().token as Any,"contact_id":contactId], hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            
            PublicMethod.dismiss()
            self?.modelDic = dic
            self?.addHeader()
//            self?.contactDetailView.update(modelArr:["login_avatar",String.noNilStr(str: self?.modelDic["name"]),String.noNilStr(str: self?.modelDic["position_name"]),String.noNilStr(str: self?.modelDic["client_name"]),String.noNilStr(str: self?.modelDic["phone"]),String.noNilStr(str: self?.modelDic["email"])])
        }
    }
    
    
    
    func configShare()->([String]){
        if JSON(modelDic["authorization_corp"]).stringValue == "1" {
            return ["所属人: 本公司"]
        }else{
            
            var array = Array<String>()
            
        
            if (JSON(modelDic["contact_member"]).array?.count)! > 0 {
                let sub = JSON(modelDic["contact_member"]).arrayObject?.map({ (a) -> String in
                    return JSON(a)["realname"].stringValue
                })
                array.append("所属人: " + (sub?.joined(separator: ","))!)
            }
            
            if (JSON(modelDic["contact_dep"]).array?.count)! > 0 {
                
                let sub = JSON(modelDic["contact_dep"]).arrayObject?.map({ (a) -> String in
                    return JSON(a)["name"].stringValue
                })
                array.append("所属部门: " + (sub?.joined(separator: ","))!)
                
            }
            
            return array
            
            
            
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 0 {
            return proList.count
        }else{
           return 7
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIde)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.accessoryType = .disclosureIndicator
        if index == 0 {
            let dic = proList[indexPath.row]
            cell?.textLabel?.text = dic["name"] as! String
        }
        else{
            cell?.accessoryType = .none
            switch indexPath.row{
            case 0:
                cell?.textLabel?.text = "QQ: " + String.changeToString(inValue: modelDic["qq"])
                break
            case 1:
                cell?.textLabel?.text = "微信: " + String.changeToString(inValue: modelDic["wechat"])
                break
            case 2:
                cell?.textLabel?.text = "地址: " + String.changeToString(inValue: modelDic["addr"])
                break
            case 3:
                cell?.textLabel?.text = "邮编: " + String.changeToString(inValue: modelDic["postcode"])
                break
            case 4:
                cell?.textLabel?.text = "传真: " + String.changeToString(inValue: modelDic["fax"])
                break
            case 5:
                cell?.textLabel?.text = "性别: " + String.changeToString(inValue: modelDic["sex"])
                break
            case 6:
                cell?.textLabel?.text = "备注: " + String.changeToString(inValue: modelDic["more"])
                cell?.textLabel?.numberOfLines = 0;
                cell?.textLabel?.sizeToFit();
                break
            default :
                break
            }
//            cell?.textLabel?.text = "目前不知道其他改显示啥"
        }
        return cell!
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if index == 0 {
            let dic = proList[indexPath.row]
            //TODO
//            ((sharePublicDataSingle.publicTabbar?.childViewControllers[1] as! BaseNavigationController).childViewControllers.first as! SLViewController).webView.loadRequest(URLRequest(url: URL(string: h5_host + "main.html#/projectSurvey/id/" + (dic["id"] as! String) + "/app")!))
//            sharePublicDataSingle.publicTabbar?.selectedWithIndex(index: 1)
            self.selectProject(projectId: dic["id"] as! String)
        }
    }
    
    func selectProject(projectId: String) {
        print(projectId)
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":projectId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                let tab = ProjectSituationTabVC()
                tab.model = model; self?.navigationController?.pushViewController(tab, animated: true)
            }
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
