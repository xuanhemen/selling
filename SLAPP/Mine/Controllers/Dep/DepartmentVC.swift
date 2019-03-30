//
//  DepartmentVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import MJRefresh
import YBPopupMenu
class DepartmentVC: BaseVC ,UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate {
    
    var isInitConfig = false
    var parentId = ""
    var parentName = ""
    @objc var is_root = true
    @objc var is_Address = false
    lazy var table:UITableView = {
        let tb = UITableView()
        tb.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT)
        tb.backgroundColor = UIColor.groupTableViewBackground
        return tb
    }()
    
    var dataArray:Array = Array<Dictionary<String,Any>>()
    var depArray:Array = Array<QFDepModel>()
    var qfsection = 1
    var chosseArray:Array = Array<Dictionary<String,Any>>()
    
    
    //批量修改部门人员
    var isEdit = false
    let editView = UIView()
    
    func addSaveButton()  {
        let loginBtn = UIButton(type: UIButtonType.custom)
        loginBtn.setTitle("保存", for: .normal)
        loginBtn.backgroundColor = kNavBarBGColor
        self.view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints{ (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(49)
        }
        loginBtn.addTarget(self, action: #selector(self.finishClick), for: .touchUpInside)
    }
    @objc func finishClick() {
        let vc = ProductInformationVC()
        vc.parentid = "0"
        vc.isInit = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configData()
        isEdit = false
        chosseArray.removeAll()
        self.table.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-49)
        self.editView.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.parentName == "" {
            self.title = "部门及人员"
        }else{
            self.title = self.parentName
        }
        
        
        self.configUI()
        
        
        let addBtn = UIButton.init(type: .custom)
        addBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addBtn.setImage(UIImage.init(named: "nav_add_new"), for: .normal)
        addBtn.addTarget(self, action: #selector(rightClick(btn:)), for:.touchUpInside)
        let rightBarBtn = UIBarButtonItem.init(customView: addBtn)
        
        
        if isInitConfig == true {
            self.addSaveButton()
            self.table.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-49)
            self.navigationItem.rightBarButtonItem = rightBarBtn
        }else{
            self.table.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT)
            
            let batchButton = UIButton.init(type: .custom)
            batchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            batchButton.setImage(#imageLiteral(resourceName: "batchDep"), for: .normal)
            batchButton.addTarget(self, action: #selector(batchButtonClick(btn:)), for:.touchUpInside)
            let batchBarBtn = UIBarButtonItem.init(customView: batchButton)
            
            if self.is_root {
                self.navigationItem.rightBarButtonItems = [rightBarBtn,batchBarBtn]
            }
            self.configBottomView()
        }
    }
    
    func configBottomView(){
        self.editView.backgroundColor = .white
        self.editView.isHidden = true
        self.view.addSubview(self.editView)
        self.editView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(49)
        }
    
        let messageBtn = UIButton.init(type: .custom)
        messageBtn.setImage(#imageLiteral(resourceName: "QFBatchMessage"), for: .normal)
        messageBtn.addTarget(self, action: #selector(messageBtnClick(btn:)), for:.touchUpInside)
        self.editView.addSubview(messageBtn)
        messageBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH/2)
        }
        
        let moveBtn = UIButton.init(type: .custom)
        moveBtn.setImage(#imageLiteral(resourceName: "QFBatchMove"), for: .normal)
        moveBtn.addTarget(self, action: #selector(moveBtnClick(btn:)), for:.touchUpInside)
        self.editView.addSubview(moveBtn)
        moveBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH/2)
        }
    }
    @objc func messageBtnClick(btn: UIButton) {
        
        if self.chosseArray.count == 0 {
            self.batchButtonClick(btn: nil)
            return
        }else{
            PublicMethod.showProgress()
            var useridArray = Array<String>()
            for dict in self.chosseArray {
                let userid:String = dict["userid"] as! String
                useridArray.append(userid)
            }
            let string = useridArray.joined(separator: ",")
            LoginRequest.getPost(methodName: QFbatch_send_message, params: ["userids":string,"token":UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
                PublicMethod.dismiss()
            }) {[weak self] (dic) in
                DLog(dic)
                self?.chosseArray.removeAll()
                self?.batchButtonClick(btn: nil)
                PublicMethod.dismiss()
            }
        }
        
    }
    @objc func moveBtnClick(btn: UIButton) {
        if self.chosseArray.count == 0 {
            self.batchButtonClick(btn: nil)
            
            return
        }
        
        var alertString  = "转移时是否携带项目？"
        var cancelString = "不带项目"
        var sureString = "带项目"
        var isNoUser = false
        if (self.dataArray.count-self.chosseArray.count)>0 {
            
        }else{
            alertString = "部门没有可接收项目人员，转移时会携带您的项目"
            cancelString = "取消"
            sureString = "确定"
            isNoUser = true
        }
        let alert = UIAlertController.init(title: "提醒", message: alertString, preferredStyle: .alert, btns: [kCancel:cancelString,"sure":sureString], btnActions: {[weak self] (ac, str) in
            
            if str != kCancel {
                let qfChooseVC = QFChooseDepartmentVC()
                qfChooseVC.isHaveProject = true
                qfChooseVC.userArray = (self?.chosseArray)!
                self?.navigationController?.pushViewController(qfChooseVC, animated: true)
            }
            if str != "sure" {
                if isNoUser == false {
                    let vc = QFMoveProjectVC()
                    vc.userArray = (self?.dataArray)!
                    vc.chooseArray = (self?.chosseArray)!
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    @objc func batchButtonClick(btn: UIButton?) {
        if isEdit == false{
            self.table.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-49)
            self.editView.isHidden = false
        }else{
            self.table.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT)
            self.editView.isHidden = true
        }
        self.table.reloadData()
        isEdit = !isEdit
    }
    
    @objc func rightClick(btn: UIButton) {
        
    
        YBPopupMenu.showRely(on: btn, titles: ["邀请同事","添加部门"], icons: [], menuWidth: 100) { [weak self] (menuView) in
            menuView?.delegate = self
    }
    }
    
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        let  array = ["邀请同事","添加部门"]
        let str = array[index]
        if str == "邀请同事" {
            self.addBtnClick()
        }else if str == "添加部门" {
            let addDepVC = QFAddDepVC()
            addDepVC.title = "添加部门"
            addDepVC.parent_id = self.parentId
            addDepVC.parent_name = self.parentName
            self.navigationController?.pushViewController(addDepVC, animated: true)
        }
    }
    
    
    
    
    
    func configData(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: QF_USERDEP_LIST, params: ["parent_id":parentId,"token":UserModel.getUserModel().token as Any], hadToast: true, fail: {[weak self] (dic) in
            PublicMethod.dismiss()
            self?.table.mj_header.endRefreshing()
        }) {[weak self] (dic) in
         
            DLog(dic)
            PublicMethod.dismiss()
            self?.table.mj_header.endRefreshing()
            self?.dataArray.removeAll()
            self?.dataArray = dic["member"] as! Array<[String : Any]>
            self?.depArray.removeAll()
            //self?.depArray = dic["dep"] as! Array<[String : Any]>
            
            self?.parentId = dic["dep_id"] as! String
            self?.parentName = dic["dep_name"] as! String
            
            let array = dic["dep"] as! Array<[String : Any]>
            for subDict in array {
                let model = QFDepModel.deserialize(from: subDict)
                self?.depArray.append(model!)
            }
            if (self?.depArray.count)!>0{
                self?.qfsection = 2
            }else{
                self?.qfsection = 1
            }
            self?.refresh()
            
        }
        
    }
    
    
    func refresh(){
        self.table.reloadData()
    }
   
    func configUI(){
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(table)
        self.table.register(UINib.init(nibName: "DepartmentCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.tableFooterView = UIView()
        self.table.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in
            self?.configData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - ---------------------table代理------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if qfsection == 2 {
            if section == 0{
                return depArray.count
            }else{
                return dataArray.count
            }
        }else{
            return dataArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return qfsection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if qfsection == 2{
            if indexPath.section == 0{
                let cellIde = "QFDepCell"
                var cell:QFDepCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? QFDepCell
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("QFDepCell", owner: nil, options: nil)?.last as! QFDepCell)
                }
                let model = self.depArray[indexPath.row]
                
                if model.whether_del == "0" {
                    cell?.deleteBtn.isHidden = true
                }else{
                    cell?.deleteBtn.isHidden = false
                    cell?.delete = {
                        let alert = UIAlertController.init(title: "提醒", message: "是否删除该部门吗？", preferredStyle: .alert, btns: [kCancel:"取消","sure":"删除"], btnActions: {[weak self] (ac, str) in
                            if str != kCancel {
                                self?.deleteDep(id: model.id)
                            }
                        })
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                
                cell?.editButtonSelect = {
                    let addDepVC = QFAddDepVC()
                    addDepVC.title = "修改部门"
                    addDepVC.parent_id = self.parentId
                    addDepVC.parent_name = self.parentName
                    addDepVC.model = model
                    self.navigationController?.pushViewController(addDepVC, animated: true)
                }
                cell?.cellNameLabel.text = model.name
                
                if !self.is_root {
                    cell?.deleteBtn.isHidden = true
                    cell?.editButton.isHidden = true
                }
                
                return cell!
            }
        }
        let cellIde = "cell"
        let cell:DepartmentCell = tableView.dequeueReusableCell(withIdentifier: cellIde) as! DepartmentCell
        let dic = dataArray[indexPath.row]
        cell.top.text = (dic["realname"] as! String)
        cell.bottom.text = (dic["position_name"] as! String ) + "   " + (dic["phone"] as! String)
        cell.headImage.sd_setImage(with: URL.init(string: dic["head"] as! String + imageSuffix), placeholderImage: UIImage.init(named: "mine_avatar"))
        
        print(dic)
        
        cell.clickBlock = { [weak self](isResend)  in
            if isResend {
                self?.reSend(index: indexPath.row)
            }else{
            self?.delete(index: indexPath.row)
            }
            
        }
        let str = "\(dic["userid"]!)"
        if str == UserModel.getUserModel().id {
           cell.deleteBtn.isHidden = true
        }else{
            cell.deleteBtn.isHidden = false
        }
        let status:String = dic["status"] as! String
        
        
        if status == "jobon" {
            cell.deleteBtn.setImage(UIImage.init(named: "ch_contact_dimission"), for: .normal)
        }else{
            cell.deleteBtn.setImage(UIImage.init(named: "ch_contact_return"), for: .normal)
        }
        
       //新邀请的  1系统中没有
        if String.noNilStr(str: dic["not_come"])  == "1" || String.noNilStr(str: dic["is_login"])  == "1" {
            cell.reSendBtn.isHidden = false
        }else{
            cell.reSendBtn.isHidden = true
        }
        
        if status == "joboff" || String.noNilStr(str: dic["is_login"])  == "1" || String.noNilStr(str: dic["not_come"])  == "1" {
            
            cell.grayType(isGray: true)
        }else{
            cell.grayType(isGray: false)
            
        }
        
        
        
        if isEdit == true{
            cell.headerX.constant = 45
            cell.checkButton.isHidden = false
        }else{
            cell.headerX.constant = 15
            cell.checkButton.isHidden = true
            cell.checkButton.isSelected = false
        }
        cell.checkBlock = { [weak self](isCheck)  in
            if isCheck {
                self?.chosseArray.append(dic)
            }else{
                for i in 0..<(self?.chosseArray)!.count {
                    let dict = self?.chosseArray[i]
                    let userid:String = dict!["userid"] as! String
                    let baseUserId:String = dic["userid"] as! String
                    if  userid == baseUserId {
                        self?.chosseArray.remove(at: i)
                        break
                    }
                }
            }
            DLog(self?.chosseArray)
        }
        if !self.is_root {
            cell.deleteBtn.isHidden = true
            cell.reSendBtn.isHidden = true
        }
        return cell
        
    }
    
    
    //重新发送登录验证码
    func reSend(index:Int){
        
        let alert = UIAlertController.init(title: "温馨提示", message: "要给该用户重新发送邀请短信吗?", preferredStyle: .alert, okAndCancel: ("确定", "取消"), btnActions: {[weak self] (action, str) in
            if str != "Cancel"{
                self?.netResend(index: index)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func netResend(index:Int){
        guard dataArray.count > index else {
            self.table.reloadData()
            return
        }
        
        var model = dataArray[index]
        let params = ["dep_id":self.parentId,"domains":"CC","username":String.noNilStr(str: model["phone"]),"realname":String.noNilStr(str: model["realname"])] as [String : Any];
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: USER_REGISTER, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            PublicMethod.dismissWithSuccess(str: "发送成功")
            self?.table.reloadData()
        }
        
    }
    
    
    
    func delete(index:Int){
        
        var alertStr = ""
        var model = dataArray[index]
        
        if (model["status"] as! String) == "jobon" {
            alertStr = "确定要把此用户设为离职?离职后将不占用授权数"
        }else{
            alertStr = "确定要重新启用此用户?启用后将占用授权数"
        }
        
        let alert = UIAlertController.init(title: "温馨提示", message: alertStr, preferredStyle: .alert, okAndCancel: ("确定", "取消"), btnActions: {[weak self] (action, str) in
            if str != "Cancel"{
                self?.netDelete(index: index)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    //删除部门
    func deleteDep(id:String){
        PublicMethod.showProgress()
        
        
        LoginRequest.getPost(methodName: QF_DELETE_DEP, params:["dep_id":id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
            PublicMethod.dismiss()
            self.configData()
        }
        
    }
    
    func netDelete(index:Int){
        
        guard dataArray.count > index else {
            self.table.reloadData()
            return
        }
        PublicMethod.showProgress()
        var model = dataArray[index]
        LoginRequest.getPost(methodName: MEMBER_IS_DIMISSION, params: ["userid":model["userid"] as Any,"token":UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
            
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            if (model["status"] as! String) == "jobon" {
                model["status"] = "joboff"
            }else{
                model["status"] = "jobon"
            }
            self?.dataArray.replaceSubrange(Range(index..<index+1), with: [model])
            self?.table.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
                self?.refresh()
            })
            

        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if qfsection == 2 {
            if indexPath.section == 0{
                let model = self.depArray[indexPath.row]
                let vc = DepartmentVC()
                vc.parentId = model.id
                vc.parentName = model.name
                vc.is_root = self.is_root
                vc.is_Address = self.is_Address
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let dict = self.dataArray[indexPath.row]
                let userid:String = dict["userid"] as! String
                
                if is_Address {
                    PublicPush().addressPushToUserInfo(userId: userid, vc: self)
                }else{
                    
                    
                    let personnelVC = QFPersonnelVC()
                    personnelVC.userId = userid
                    personnelVC.userDict = dict
                    personnelVC.is_root = self.is_root
                    personnelVC.allUserArray = self.dataArray
                    self.navigationController?.pushViewController(personnelVC, animated: true)
                }
                
            }
        }else{
            let dict = self.dataArray[indexPath.row]
            let userid:String = dict["userid"] as! String
            
            if is_Address {
                PublicPush().addressPushToUserInfo(userId: userid, vc: self)
            
            }else{
                
                let personnelVC = QFPersonnelVC()
                personnelVC.userDict = dict
                personnelVC.is_root = self.is_root
                personnelVC.allUserArray = self.dataArray
                personnelVC.userId = userid
                self.navigationController?.pushViewController(personnelVC, animated: true)
            }
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
    
    
    @objc func addBtnClick(){
        let sortVC = SortAddressVC()
        sortVC.dep_id = self.parentId
        self.navigationController?.pushViewController(sortVC, animated: true)
        
    }
    
}
