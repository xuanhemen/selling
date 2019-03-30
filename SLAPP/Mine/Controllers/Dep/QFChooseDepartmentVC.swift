//
//  QFChooseDepartmentVC.swift
//  SLAPP
//
//  Created by qwp on 2018/6/8.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit
import MJRefresh
class QFChooseDepartmentVC: BaseVC ,UITableViewDelegate,UITableViewDataSource {

    var parentId = ""
    var parentName = ""
    var otherUserId = ""
    var isHaveProject = false
    var userArray:Array = Array<Dictionary<String,Any>>()
    lazy var table:UITableView = {
        let tb = UITableView()
        tb.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT)
        tb.backgroundColor = UIColor.groupTableViewBackground
        return tb
    }()
    var depArray:Array = Array<QFDepModel>()
    var depHistoryArray:Array = Array<Array<QFDepModel>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.parentName == "" {
            self.title = "部门及人员"
        }else{
            self.title = self.parentName
        }
        self.table.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT)
        
        self.configUI()
        self.configData()
        self.configBackItem()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backBtnClick() {
        if self.depHistoryArray.count>1 {
            self.depHistoryArray.removeLast()
            self.depArray = self.depHistoryArray.last!
            self.table.reloadData()
        }else{
            self.navigationController?.popViewController(animated: true)
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
            self?.depArray.removeAll()
            self?.parentId = dic["dep_id"] as! String
            self?.parentName = dic["dep_name"] as! String
            
            let array = dic["dep"] as! Array<[String : Any]>
            for subDict in array {
                let model = QFDepModel.deserialize(from: subDict)
                self?.depArray.append(model!)
            }
            self?.depHistoryArray.append((self?.depArray)!)
            self?.table.reloadData()
        }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var i = 0
        if self.depHistoryArray.count == 1 {
            i = 1
        }
        return depArray.count + i
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model = QFDepModel()

        if self.depHistoryArray.count == 1 {
            if indexPath.row == 0 {
                model.whether_dep = "1"
                model.name = "顶级部门"
            }else{
                model = self.depArray[indexPath.row-1]
            }
        }else{
           model = self.depArray[indexPath.row]
        }
        
        
        let cellIde = "QFChooseDepCell"
        var cell:QFChooseDepCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? QFChooseDepCell
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("QFChooseDepCell", owner: nil, options: nil)?.last as! QFChooseDepCell)
        }
        
        
        if model.whether_dep == "1" {
            cell?.nextImage.isHidden = true
        }else{
            cell?.nextImage.isHidden = false
        }
        
        cell?.nextButtonSelect = {[weak self] in
            if model.whether_dep == "1" {
                return
            }
            self?.parentId = model.id
            self?.parentName = model.name
            self?.configData()
        }
        cell?.cellTitleLabel.text = model.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var model = QFDepModel()
        
        if self.depHistoryArray.count == 1 {
            if indexPath.row == 0 {
                model.whether_dep = "1"
                model.name = "顶级部门"
                model.id = ""
            }else{
                model = self.depArray[indexPath.row-1]
            }
        }else{
            model = self.depArray[indexPath.row]
        }
        
        let string = String.init(format: "确定转移人员到%@吗?", model.name)
        let alert = UIAlertController.init(title: "提醒", message: string, preferredStyle: .alert, btns: [kCancel:"取消","sure":"确定"], btnActions: {[weak self] (ac, str) in
            if str != kCancel {
                PublicMethod.showProgress()
                
                var useridArray = Array<String>()
                for dict in (self?.userArray)! {
                    let userid:String = dict["userid"] as! String
                    useridArray.append(userid)
                }
                let string = useridArray.joined(separator: ",")
                LoginRequest.getPost(methodName: QFbatch_transfer_dep, params: ["take_project":self?.isHaveProject as Any,"userids":string,"recipient":self?.otherUserId as Any,"new_depid":model.id,"token":UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
                    PublicMethod.dismiss()
                }) {[weak self] (dic) in
                    DLog(dic)
                    PublicMethod.dismiss()
                    if self?.otherUserId != "" {
                        let vc = self?.navigationController?.viewControllers[(self?.navigationController?.viewControllers.count)!-3]
                        self?.navigationController?.popToViewController(vc!, animated: true)
                    }else{
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        })
        self.present(alert, animated: true, completion: nil)
        
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
}
