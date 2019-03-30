//
//  ProChooseContactVC.swift
//  SLAPP
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProChooseContactVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var result:(_ selectModel:ProAddContactModel)->() = { _ in
        
    }
    var situationModel:ProjectSituationModel?
    var selectModel:ProAddContactModel?
    var dataArray = Dictionary<String,Array<ProAddContactModel>>()
    var currentDataArray = Dictionary<String,Array<ProAddContactModel>>()
    var sectionCurrentArray = Array<String>()
    var sectionArray = Array<String>()
    var projectID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "选择联系人"
        self.configUI()
        self.configDataMember()
        
    }
    
    lazy var searchView = { () -> UISearchBar in
        let search = UISearchBar()
        search.placeholder = "输入搜索"
        search.setBackgroundImage(UIImage.init(named: "backGray")!, for: .any, barMetrics: .default)
        return search
    }()
    
    
    override func rightBtnClick(button: UIButton) {
        if selectModel == nil {
            PublicMethod.toastWithText(toastText: "还没有选择联系人")
            return
        }
        result(selectModel!)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func configUI(){
        self.setRightBtnWithArray(items: ["确定"])
        
        self.view.addSubview(searchView)
        searchView.delegate = self
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(table)
        table.snp.makeConstraints {[weak searchView] (make) in
            make.top.equalTo((searchView?.snp.bottom)!)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        
        table.addEmptyViewAndClickRefresh {[weak self] in
            self?.configDataMember()
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionCurrentArray[section]
    }
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionCurrentArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let str = sectionCurrentArray[section]
        let array = self.currentDataArray[str]
        return (array?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell:ProChooseContactCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProChooseContactCell
        if cell == nil {
            cell = ProChooseContactCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.model = self.currentDataArray[sectionCurrentArray[indexPath.section]]?[indexPath.row]
        if selectModel == cell?.model {
            cell?.headImage.image = UIImage.init(named: "situationCellmarkSelect")
        }else{
            cell?.headImage.image = UIImage.init(named: "situationCellmarkNomal")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell:ProChooseContactCell = tableView.cellForRow(at: indexPath) as! ProChooseContactCell
        if selectModel != cell.model {
            selectModel = cell.model
            tableView.reloadData()
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
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty)! else {
            return
        }
        self.currentDataArray.removeAll()
        self.sectionCurrentArray.removeAll()
        for key in sectionArray {
            let array = self.dataArray[key]?.filter({ (model) -> Bool in
                if model.name.contains(searchBar.text!){
                    
                    return true
                }
                else{
                    return false
                }
            })
            if !(array?.isEmpty)! {
                self.currentDataArray[key] = array
                sectionCurrentArray.append(key)
            }
        }
        table.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.currentDataArray = self.dataArray
            self.sectionCurrentArray = sectionArray
            table.reloadData()
        }
    }
    
    

    func configDataMember(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: "pp.clientContact.customer_pro_contact", params: ["project_id":self.projectID,"client_id":self.situationModel?.client_id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            
            
            PublicMethod.dismiss()
            if JSON(dic["list"] as Any).arrayValue.count > 0{
                for sub:Dictionary<String,Any> in dic["list"] as! Array {
                    if let model = ProAddContactModel.deserialize(from: sub){
                        if self?.dataArray[model.key] != nil {
                            self?.dataArray[model.key]?.append(model)
                        }else{
                            self?.dataArray[model.key] = Array<ProAddContactModel>()
                            self?.dataArray[model.key]?.append(model)
                            self?.sectionArray.append(model.key)
                        }
                    }
                }
                
            }
            self?.sectionArray.sort(by: {
               return $0<$1
            })
            self?.currentDataArray = (self?.dataArray)!
            self?.sectionCurrentArray = (self?.sectionArray)!
            self?.table.reloadData()
        }
        
    }


}
