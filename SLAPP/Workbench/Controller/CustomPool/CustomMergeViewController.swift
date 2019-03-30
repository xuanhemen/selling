//
//  CustomMergeViewController.swift
//  SLAPP
//
//  Created by fank on 2018/12/6.
//  Copyright © 2018年 柴进. All rights reserved.
//  客户池 - 合并客户

import UIKit
import SwiftyJSON

class CustomMergeViewController: BaseVC {
    
    var dataArray : [MyCustomListModel] = []
    
    var selectArray : [MyCustomListModel] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        self.initData()
    }
    
    @objc func mergeBtnClickFunc() {
        
        if self.selectArray.isEmpty {
            PublicMethod.toastWithText(toastText: "请选择需要合并的客户")
            return
        } else if self.selectArray.count == 1 {
            PublicMethod.toastWithText(toastText: "请选择2个客户进行合并")
            return
        } else {
            self.getMergeDataFunc()
        }
    }
    
    func getMergeDataFunc() {
        
        guard let firstId = self.selectArray.first?.idString, let secondId = self.selectArray.last?.idString else {
            print("id is nil")
            return
        }
        
        self.showProgress(withStr: "正在加载中...")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_MERGE_GET_INFO, params: ["token":userModel.token ?? "", "main_client_id":firstId, "vice_client_id":secondId], hadToast: true, fail: { [weak self] (dict) in
            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
            self?.showDismiss()
            
            print("*** = \(dict)")
            
            if let jsons = JSON(dict)["data"].array {
                
                var tempArray : [MyCustomListModel] = []
                
                jsons.forEach({ (json) in
                    tempArray.append(MyCustomListModel.myCustomListModel(json: json))
                })
                
                if let mergeView = CustomMergeView.customMergeView() {
                    mergeView.dataArray = tempArray
                    mergeView.frame = UIApplication.shared.keyWindow!.bounds
                    UIApplication.shared.keyWindow!.addSubview(mergeView)
                    
                    mergeView.endClosure = { () in
                        self?.initData()
                    }
                }
            }
        }
    }
    
    func addRightBarButtonItemsFunc() {
        
        let mergeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        mergeBtn.setTitle("合并", for: .normal)
        mergeBtn.addTarget(self, action: #selector(mergeBtnClickFunc), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: mergeBtn)]
    }
    
    func initData() {
        
        self.dataArray.removeAll()
        self.selectArray.removeAll()
        
        self.showProgress(withStr: "正在加载中...")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_MERGE_LIST, params: ["token":userModel.token ?? ""], hadToast: true, fail: { [weak self] (dict) in
            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
            self?.showDismiss()
            
            print("*** = \(dict)")
            
            if let jsons = JSON(dict)["list"].array {
                
                self?.dataArray.removeAll()
                
                jsons.forEach({ (json) in
                    self?.dataArray.append(MyCustomListModel.myCustomListModel(json: json))
                })
                
                self?.tableView.reloadData()
            }
        }
    }
    
    func initView() {
        
        self.title = "合并客户"
        
        self.addRightBarButtonItemsFunc()
    }

}

// MARK: - tableview相关
extension CustomMergeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomListCell") as! MyCustomListCell
        
        cell.indexInt = indexPath.row
        
        cell.myCustomListModel = self.dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MyCustomListCell
        cell.handleSelImageViewFunc(completion: { (index, isSelected) in
            self.dataArray[indexPath.row].isSelected = isSelected
        })
        
        let current = self.dataArray[indexPath.row]
        
        if self.selectArray.contains(current) {
            self.selectArray.remove(current)
        } else {
            self.selectArray.append(current)
        }
        
        if self.selectArray.count > 2 && self.selectArray.first != nil {
            if let first = self.selectArray.first {
                let firstIndex = IndexPath(row: self.dataArray.index(of: first)!, section: 0)
                let cell = tableView.cellForRow(at: firstIndex) as! MyCustomListCell
                cell.handleSelImageViewFunc(completion: { (index, isSelected) in
                    self.dataArray[firstIndex.row].isSelected = isSelected
                    self.dataArray[indexPath.row].isSelected = !isSelected
                })
                self.selectArray.remove(first)
            }
        }
    }
}
