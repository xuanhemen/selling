//
//  AuthorizationInformationVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AuthorizationInformationVC: BaseVC,UITableViewDelegate,UITableViewDataSource  {
    
    lazy var table:UITableView = {
        let tb = UITableView()
        tb.backgroundColor = UIColor.groupTableViewBackground
        tb.frame = CGRect(x: 10, y: 0+20, width: MAIN_SCREEN_WIDTH-20, height: 230)
        tb.layer.borderColor = UIColor.lightGray.cgColor
        tb.layer.borderWidth = 1
        tb.layer.cornerRadius = 4
        tb.isScrollEnabled = false
        tb.tableFooterView = UIView()
        return tb
    }()
    
    var dataArray:Array = Array<String>()
    var mydic = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "授权信息"
        dataArray = ["云端服务包","·授权数量:**","·授权时间:**","·已使用授权数:**","·未授权使用数:**"]
        self.view.addSubview(table)
        self.table.delegate  = self
        self.table.dataSource = self
        self.view.backgroundColor = UIColor.white
        self.configData()
        
    }
    
    func configData(){
        
        LoginRequest.getPost(methodName: COMPANY_MESSAGE, params: ["domains":"CC","token":UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
            
        }) {[weak self] (dic) in
            
            let myDic:Dictionary<String,Any> = (dic["data"] as? Array)!.first!
            self?.changeDataWithDic(myDic: myDic)
           
            
        }
    }
    
    
    
    func changeDataWithDic(myDic:Dictionary<String,Any>){
        DLog(myDic)
        
        dataArray[1] = "·授权数量:  \(myDic["authnum"]!)"
        let beginStr = "\(myDic["begintime"]!)"
        let endStr = "\(myDic["endtime"]!)"
        dataArray[2] = "·授权时间:  " + Date.timeIntervalToDateStr(timeInterval: Double(beginStr)!) + "-" + Date.timeIntervalToDateStr(timeInterval: Double(endStr)!)
        dataArray[3] = "·已使用授权数:  \(myDic["use"]!)"
        dataArray[4] = "·未授权使用数:  \(myDic["remain"]!)"
        
        
        self.table.reloadData()
    }
    
    
    
    //MARK: - ---------------------table代理------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
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
//        cell?.accessoryType = .disclosureIndicator
        let dic = dataArray[indexPath.row]
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.textLabel?.text = dic
        if indexPath.row == 0 {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
            cell?.textLabel?.textAlignment = .center
        }else{
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        cell?.selectionStyle = .none
        
        
        return cell!
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let dic = dataArray[indexPath.row]
//        if dic["name"] == "企业管理" {
//            self.navigationController?.pushViewController(EnterpriseManagementVC(), animated: true)
//        }
//        else{
//
//            PublicMethod.toastWithText(toastText: (dic["name"] as! String) + "暂未开放")
//
//
//        }
//    }
    
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 47
        }
        return 46
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
