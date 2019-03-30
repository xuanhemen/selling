//
//  CustomPoolRecycleListViewController.swift
//  SLAPP
//
//  Created by fank on 2018/11/27.
//  Copyright © 2018年 柴进. All rights reserved.
//  客户公海池回收站

import UIKit
import SwiftyJSON

class CustomPoolRecycleListViewController: BaseVC {
    
    var dataArray : [CustomPoolModel] = []
    
    var selectArray : [CustomPoolModel] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initData()
    }
    
    @IBAction func resumeBtnClickFunc(_ sender: UIButton) {
        
        guard self.selectArray.count > 0 else {
            PublicMethod.toastWithText(toastText: "请选择客户")
            return
        }
        
        let idString = self.selectArray.map { $0.idString ?? "" }.joined(separator: ",")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_RECYCLE_RESUME, params: ["token":userModel.token ?? "", "client_id_str":idString], hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            
            self?.initData()
        }
    }
    
    @objc func searchBtnClickFunc() {
        if let vc = R.storyboard.customPool.customPoolSearchViewController() {
            vc.isPoolList = false
            vc.authTuple = (true, false)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addSearchBarButtonItemFunc() {
        
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchBtn.setImage(R.image.search(), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchBtnClickFunc), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
    }
    
    func initData() {
        
        self.showProgress(withStr: "正在加载中...")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_RECYCLE_LIST, params: ["token":userModel.token ?? ""], hadToast: true, fail: { [weak self] (dict) in
            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
            self?.dataArray.removeAll()
            
            self?.showDismiss()
            
            if let jsons = JSON(dict)["list"].array {
                
                self?.dataArray.removeAll()
                
                print("*** jsons = \(jsons)")
                
                jsons.forEach({ (json) in
                    self?.dataArray.append(CustomPoolModel.customPoolModel(json: json))
                })
                
                self?.tableView.reloadData()
            }
        }
    }
    
    func initView() {
        
        self.title = "公海客户回收站"
        
        self.addSearchBarButtonItemFunc()
    }

}

// MARK: - 代理相关
extension CustomPoolRecycleListViewController : CustomPoolCellDelegate {
    
    func customPoolCellBtnClickFunc(indexPath:IndexPath, isSelected: Bool) {
        
        if isSelected {
            self.selectArray.append(self.dataArray[indexPath.row])
        } else {
            self.selectArray.remove(self.dataArray[indexPath.row])
        }
    }
}

// MARK: - tableview相关
extension CustomPoolRecycleListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPoolCell") as! CustomPoolCell
        
        cell.customPoolModel = self.dataArray[indexPath.row]
        
        cell.indexPath = indexPath
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = R.storyboard.customPool.customDetailViewController() {
            vc.customIdString = self.dataArray[indexPath.row].idString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
