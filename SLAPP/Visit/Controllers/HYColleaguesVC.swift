//
//  HYColleaguesVC.swift
//  SLAPP
//
//  Created by apple on 2018/12/6.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class HYColleaguesVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate {
    
    var isSingle = false
    
    var singleSelectClosure : ((_ id: String) -> Swift.Void)?
    
   @objc var selectDataArray:Array<MemberModel> = Array()
    var dataArray:Array<MemberModel> = Array()
    var showDataArray:Array<MemberModel> = Array()
   @objc var selectWithMembers:(Array<MemberModel>)->() = { (m) in
    
    }
    
    @objc var willdis:()->() = { () in
        
    }
    
    let search:UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "选择同事";
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(table)
        table.register(HYColleaguesCell.self, forCellReuseIdentifier: "HYColleaguesCell")
        table.snp.makeConstraints { (make) in
            make.left.right.equalTo(0);
            make.top.equalTo(50)
            make.bottom.equalTo(-TAB_HEIGHT+49);
        }
        
        if !self.isSingle {
            self.setRightBtnWithArray(items: ["确定"])
        }
        
        table.delegate = self
        table.dataSource = self
        
        
        
        self.view.addSubview(search)
        search.placeholder = "搜索";
        search.backgroundImage = #imageLiteral(resourceName: "backGray")
        search.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        search.delegate = self;
        
        if self.dataArray.isEmpty {
            self.configData()
        } else {
            self.showDataArray = self.dataArray
            self.table.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.willdis()
    }
    
    override func rightBtnClick(button: UIButton) {
        
        self.selectWithMembers(self.selectDataArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIde = "HYColleaguesCell"
        let cell:HYColleaguesCell = tableView.dequeueReusableCell(withIdentifier: cellIde) as! HYColleaguesCell
        cell.model = self.showDataArray[indexPath.row]
        
        if !self.selectDataArray.filter({ [weak cell](model) -> Bool in
            return cell?.model?.id == model.id
        }) .isEmpty{
            cell.markImage.image = #imageLiteral(resourceName: "qf_select_statuschoose")
        }else{
            cell.markImage.image = #imageLiteral(resourceName: "qf_select_statusdefault")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.isSingle {
            if let closure = self.singleSelectClosure {
                closure(self.showDataArray[indexPath.row].id ?? "")
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let model = self.showDataArray[indexPath.row]
            if self.selectDataArray.filter({(sub) -> Bool in
                return model.id == sub.id
            }) .isEmpty{
                self.selectDataArray.append(model)
            }else{
                
                if let a = self.selectDataArray.index(where: { (m) -> Bool in
                    return model.id == m.id
                }){
                    self.selectDataArray.remove(at:a)
                }
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        
        return table
    }()
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    func configData(){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: SEARCH_MEMBER, params: ["":""].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            self?.dataArray.removeAll()
            
            self?.showDataArray.removeAll()
            if let array = JSON(dic)["data"].arrayObject {
                self?.dataArray = [MemberModel].deserialize(from: array)! as! Array<MemberModel>
                
            }
            self?.showDataArray = (self?.dataArray)!
            self?.table.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.showDataArray = (self.dataArray)
        }else{
            self.showDataArray = self.dataArray.filter({ (model) -> Bool in
                return (model.name?.contains(searchText))!
            })
        }
        self.table.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search.resignFirstResponder()
        if (searchBar.text?.isEmpty)! {
            self.showDataArray = (self.dataArray)
        }else{
            self.showDataArray = self.dataArray.filter({ (model) -> Bool in
                return (model.name?.contains(String.noNilStr(str: searchBar.text)))!
            })
        }
        self.table.reloadData()
    }

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        search.resignFirstResponder()
    }
}
