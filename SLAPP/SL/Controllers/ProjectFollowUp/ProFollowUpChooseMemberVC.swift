//
//  ProFollowUpChooseMemberVC.swift
//  SLAPP
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

//类型type
enum VC_CHOOSE_TYPY {
    case client  //客户
    case project //项目
    case contact //联系人
    case clues //线索
}

class ProFollowUpChooseMemberVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var type:VC_CHOOSE_TYPY?
    //客户和联系 时 选择的项目id
    var proId:String?
    
    //项目  客户  联系 id
    var id:String = ""
    var result:(Array<MemberModel>)->() = {_ in
        
    }
    var dataArray = Array<MemberModel>()
    var selectArray = Array<MemberModel>()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0)
            make.bottom.equalTo(0)
        }
        table.register(ProFollowUpChooseMemberCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        self.configData()
        self.setRightBtnWithArray(items: ["确定"])
        
        table.addEmptyViewAndClickRefresh {[weak self] in
            self?.configData()
        }
    }
    
    
    override func rightBtnClick(button: UIButton) {
        result(selectArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func configData(){
        
        guard self.type != nil else {
            return
        }
        
        let url = FOLLOWUP_CONTACT_LIST
        

        
        DLog(self.type)
        DLog(CLIENT_FOLLOWUP_CONTACTS)
        
        PublicMethod.showProgress()
        var params = Dictionary<String,Any>()
        if self.id != nil {
            params["client_id"] = id
        }
        
        if self.proId != nil {
            params["pro_id"] = self.proId
        }
        
        
                switch self.type! {
                case .client:
                    self.title = "选择客户联系人"
                case .project:
                    self.title = "选择项目联系人"
                default: break

                }
        
        
        
        
        LoginRequest.getPost(methodName: url, params: params.addToken(), hadToast: true, fail: { (fail) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            self?.dataArray.removeAll()
            
            if dic["data"] is NSNull {
                return
            }
            
            for subDic in JSON(dic["data"]).arrayObject!{
                let model = MemberModel.deserialize(from: JSON(subDic).dictionaryObject)
                self?.dataArray.append(model!)
            }
            self?.configSelect()
            self?.table.reloadData()
        }
    }
    
    func configSelect(){
        
        if self.selectArray.count > 0 {
            let a = self.dataArray.filter { (m) -> Bool in
                if self.selectArray.filter({ (sub) -> Bool in
                    return m.id == sub.id
                }).count > 0 {
                    return true
                }
                else{
                    return false
                }
            }
            self.selectArray = a
        }
        
        
    }
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        let cell:ProFollowUpChooseMemberCell = tableView.dequeueReusableCell(withIdentifier: cellIde, for: indexPath) as! ProFollowUpChooseMemberCell
        cell.model = self.dataArray[indexPath.row]
        DLog(selectArray.count)
        DLog("aaaaaaa")
        if selectArray.contains(cell.model!) {
            cell.markImage.image = UIImage.init(named: "situationCellmarkSelect")
        }else{
            cell.markImage.image = UIImage.init(named: "situationCellmarkNomal")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.dataArray[indexPath.row]
        if selectArray.contains(model) {
            self.selectArray.remove(at: selectArray.index(of: model)!)
        }else{
            self.selectArray.append(model)
        }
        tableView.reloadData()
        
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
