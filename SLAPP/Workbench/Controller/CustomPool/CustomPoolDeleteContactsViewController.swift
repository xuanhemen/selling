//
//  CustomPoolDeleteContactsViewController.swift
//  SLAPP
//
//  Created by fank on 2018/12/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomPoolDeleteContactsViewController: BaseVC {
    
    var customIdString : String?
    
    var selectedIdArray : [String] = []
    
    var searchArray : [CustomDetailModel] = []
    
    var dataArray : [CustomDetailModel] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        
        self.initData()
    }
    
    @IBAction func searchTextFieldEditingChanged(_ sender: UITextField) {
        
        if !sender.text!.isEmpty && sender.text!.trimSpace().count == 0 {
            sender.text = ""
            return
        }
        
        self.searchArray.removeAll()
        
        if sender.text! == "" {
            self.searchArray = self.dataArray
        } else {
            self.dataArray.forEach { [weak self] (model) in
                let topString = "\(String(describing: model.nameString)) | \(String(describing: model.titleString))"
                if topString.lowercased().contains(sender.text!) || (model.companyString ?? "").contains(sender.text!) {
                    self?.searchArray.append(model)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    @objc func delBtnClickFunc() {
        
        guard self.selectedIdArray.count > 0 else {
            PublicMethod.toastWithText(toastText: "请选择需要删除的联系人")
            return
        }
        
        let contactIdsString = self.selectedIdArray.joined(separator: ",")
        
        self.showProgress(withStr: "正在加载中...")
        
        LoginRequest.getPost(methodName: CUSTOM_POOL_CUSTOM_DETAIL_CONTACT_DELETE, params: ["token":UserModel.getUserModel().token ?? "", "client_id": self.customIdString!, "contact_ids":contactIdsString], hadToast: true, fail: { [weak self] (dict) in
            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
            self?.showDismiss()
            
            if let status = JSON(dict)["status"].int, status == 1 {
                
                self?.selectedIdArray.forEach({ (id) in
                    self?.searchArray.forEach({ (model) in
                        if id == model.idString {
                            self?.searchArray.remove(model)
                            self?.dataArray.remove(model)
                        }
                    })
                })
                
                self?.selectedIdArray.removeAll()
                
                self?.tableView.reloadData()
            }
        }
    }
    
    func addRightBarButtonItemsFunc() {
        
        let delBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        delBtn.setTitle("删除", for: .normal)
        delBtn.addTarget(self, action: #selector(delBtnClickFunc), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: delBtn)
    }
    
    func initData() {
        
        self.searchArray = self.dataArray
    }
    
    func initView() {
        
        self.title = "选择联系人"
        
        self.addRightBarButtonItemsFunc()
    }
}


extension CustomPoolDeleteContactsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDetailContactsCell") as! CustomDetailContactsCell
        
        cell.customDetailModel = self.searchArray[indexPath.row]
        
        cell.indexInt = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CustomDetailContactsCell
        cell.handleSelImageViewFunc(completion: { (index, isSelected) in
            self.searchArray[indexPath.row].isSelected = isSelected
        })
        
        let current = self.searchArray[indexPath.row].idString ?? ""
        
        if self.selectedIdArray.contains(current) {
            self.selectedIdArray.remove(current)
        } else {
            self.selectedIdArray.append(current)
        }
    }
}
