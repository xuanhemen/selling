//
//  SelectCustomerVC.swift
//  SLAPP
//
//  Created by rms on 2018/3/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import MJRefresh

class SelectCustomerVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate {
    
    let tableView:UITableView = UITableView.init()

     var searchView:UISearchBar = UISearchBar()
    @objc var clientListBase = Array<Dictionary<String,Any>>()
    @objc var clientList = Array<Dictionary<String,Any>>()
    @objc var selectCustomerId:(_ customerId:String,_ customerName:String) -> () = {_,_  in }
    var noDataView = UIImageView()
    var noDataLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择客户"
        self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.width, height: 0.1))
        
        self.tableView.addSubview(noDataView)
        self.tableView.addSubview(noDataLabel)
        
        
        searchView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 50)
        self.view.addSubview(searchView)
        searchView.delegate = self
        
        self.tableView.frame = CGRect(x: 0, y: 50, width: kScreenW, height:MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-50)
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        
        
        noDataView.mas_makeConstraints({ (make) in
            make!.size.equalTo()(CGSize(width: MAIN_SCREEN_WIDTH/3*2, height: MAIN_SCREEN_WIDTH/3*2/10*7))
            make!.center.equalTo()(self.view)
        })
        noDataView.image = UIImage.init(named: "noData")
        noDataLabel.mas_makeConstraints({ (make) in
            make!.top.equalTo()(noDataView.mas_bottom)
            make!.left.equalTo()(self.view)
            make!.size.equalTo()(CGSize(width: MAIN_SCREEN_WIDTH, height: 20))
        })
        noDataLabel.textAlignment = .center
        noDataLabel.font = kFont_Small
        noDataLabel.text = "您暂时无客户信息"
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CLIENT_LIST_SELECT, params: ["token":UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
            DLog(dic)
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            self?.clientListBase = dic["data"] as! [Dictionary<String, Any>]
            if self?.clientListBase.count != 0 {
                self?.noDataView.isHidden = true
                self?.noDataLabel.isHidden = true
            }
            
            self?.clientList = (self?.clientListBase)!
            self?.tableView.reloadData()
        }
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:#selector(clentRes))

        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.setImage(UIImage.init(imageLiteralResourceName: "nav_add_new"), for: .normal)
        btn.addTarget(self, action: #selector(rightClick(btn:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        
        
    }
    @objc func rightClick(btn:UIButton) {
        
        
        LoginRequest.getPost(methodName: "pp.user.loginer_message", params: ["token":UserModel.getUserModel().token as Any], hadToast: true, fail: {[weak self] (dic) in
            
        }) { [weak self](dic) in
            let userModel = UserModel.getUserModel()
            userModel.is_root = String.noNilStr(str: dic["is_root"])
            userModel.depId = String.noNilStr(str: dic["dep_id"])
            userModel.saveUserModel()
            
            let vc = AddCustomerVC()
            vc.isSelectCome = true
            vc.customerNew = { (id,name,tradeId,tradeName) in
                self?.selectCustomerId(id,name)
                self?.navigationController?.popViewController(animated: true)
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    @objc func clentRes() {
        LoginRequest.getPost(methodName: CLIENT_LIST, params: ["token":UserModel.getUserModel().token], hadToast: true, fail: {[weak self] (dic) in
            DLog(dic)
            self?.tableView.mj_header.endRefreshing()
        }) { [weak self](dic) in
            self?.tableView.mj_header.endRefreshing()
            self?.clientListBase = dic["data"] as! [Dictionary<String, Any>]
            if self?.clientListBase.count != 0 {
                self?.noDataView.isHidden = true
                self?.noDataLabel.isHidden = true
            }
            self?.clientList = (self?.clientListBase)!
            self?.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clientList.count
    }


     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "CustomerCell"
        var cell:CustomerCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? CustomerCell
        if cell==nil {
            cell = CustomerCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.lbCustomerName.text = String.noNilStr(str: clientList[indexPath.row]["name"])
        cell?.lbContacts.text = String.noNilStr(str: clientList[indexPath.row]["contact"]) != "" ? String.noNilStr(str: clientList[indexPath.row]["contact"]) : " "
        cell?.headerImage.image = UIImage(named:"head")
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectCustomerId(String.noNilStr(str: clientList[indexPath.row]["id"]!),String.noNilStr(str: clientList[indexPath.row]["name"]!))
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.clientList = self.clientListBase
          
            tableView.reloadData()
        }
    }
    
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text == nil || searchBar.text == "" {
            return
        }
        
        self.clientList.removeAll()
        
        self.clientList = self.clientListBase.filter({ (model) -> Bool in
            
            if String.noNilStr(str: model["name"]).contains(searchBar.text!){
                
                return true
            }
            else{
                return false
            }
            
        })
    
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    
}
