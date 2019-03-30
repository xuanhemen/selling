//
//  CustomPoolSearchViewController.swift
//  SLAPP
//
//  Created by fank on 2018/11/27.
//  Copyright © 2018年 柴进. All rights reserved.
//  客户公海池搜索

import UIKit
import SwiftyJSON

class CustomPoolSearchViewController: BaseVC {
    
    var isPoolList = true
    
    var searchView : UISearchBar!
    
    var dataArray : [CustomPoolModel] = []
    
    var selectArray : [CustomPoolModel] = []
    
    var alreadySelectDepAndMembersArray : [[String:[BaseModel]]] = []
    
    var authTuple : (isRoot: Bool, isManager: Bool) = (false, false)
    
    @IBOutlet weak var operateButton: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.searchView.resignFirstResponder()
    }
    
    @IBAction func operateBtnClickFunc(_ sender: UIButton) {
        
        var buttonTitles : [String] = [OperateCustomTypeEnum.description(.get)()]
        
        if self.authTuple.isManager {
            buttonTitles.append(OperateCustomTypeEnum.description(.alloc)())
        }
        
        if self.authTuple.isRoot {
            buttonTitles.append(OperateCustomTypeEnum.description(.delete)())
        }
        
        let actionSheet = LCActionSheet(title: "操作选项", buttonTitles: buttonTitles, redButtonIndex: -1, delegate: self)
        actionSheet?.show()
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
            
            self?.dataArray.removeAll()
            self?.tableView.reloadData()
            
            self?.selectArray.removeAll()
            
            PublicMethod.toastWithText(toastText: "恢复成功")
        }
    }
    
    func initSearchViewFunc() {
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW - 50, height: 30))
        titleView.layer.masksToBounds = true
        titleView.layer.cornerRadius = 8
        
        self.searchView = UISearchBar(frame: CGRect(x: 5, y: 0, width: titleView.width - 10, height: titleView.height))
        self.searchView.placeholder = "请输入搜索关键字..."
        self.searchView.tintColor = UIColor.blue
        self.searchView.delegate = self
        
        titleView.addSubview(self.searchView)
        
        self.navigationItem.titleView = titleView
    }
    
    func initData(text: String) {
        
        self.showProgress(withStr: "正在加载中...")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: isPoolList ? CUSTOM_POOL_LIST : CUSTOM_POOL_RECYCLE_LIST, params: ["token":userModel.token ?? "", "get_client_name":text], hadToast: true, fail: { [weak self] (dict) in
            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
            self?.dataArray.removeAll()
            
            self?.showDismiss()
            
            if let jsons = JSON(dict)["list"].array {
                
                jsons.forEach({ (json) in
                    self?.dataArray.append(CustomPoolModel.customPoolModel(json: json))
                })
                
                self?.tableView.reloadData()
            }
        }
    }
    
    func initView() {
        
        self.initSearchViewFunc()
        
        if self.isPoolList {
            self.operateButton.isHidden = false
        } else {
            self.resumeButton.isHidden = false
        }
    }

}

// MARK: - 代理相关
extension CustomPoolSearchViewController : UISearchBarDelegate, CustomPoolCellDelegate, LCActionSheetDelegate {
    
    func deleteFunc() {
        
        let idString = self.selectArray.map { $0.idString ?? "" }.joined(separator: ",")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_LIST_DELETE, params: ["token":userModel.token ?? "", "client_id_str":idString], hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            
            self?.dataArray.removeAll()
            self?.tableView.reloadData()
            
            self?.selectArray.removeAll()
            
            PublicMethod.toastWithText(toastText: "操作成功")
        }
    }
    
    func getAndAllocFunc(isGet:Bool = true) {
        
        var memberId = ""
        
        let status = isGet ? "0" : "1"
        
        let idString = self.selectArray.map { $0.idString ?? "" }.joined(separator: ",")
        
        if !self.alreadySelectDepAndMembersArray.isEmpty, let last = self.alreadySelectDepAndMembersArray.last, let mem = last["mem"] {
            memberId = (mem.last as! DepMemberModel).id // 选部门页面是多选，目前是取最后一个作为目标人
        }
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_LIST_ALLOC_GET, params: ["token":userModel.token ?? "", "status":status, "client_id_str":idString, "member_id":memberId], hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            
            self?.dataArray.removeAll()
            self?.tableView.reloadData()
            
            self?.selectArray.removeAll()
            
            PublicMethod.toastWithText(toastText: "操作成功")
        }
    }
    
    func pushToSelectDepAndMemberVCFunc() {
        
        let vc = DistributionDepAndMemberVC()
        
        if !self.alreadySelectDepAndMembersArray.isEmpty {
            vc.aReadyArray = self.alreadySelectDepAndMembersArray
        }
        
        vc.resultArray = { [weak self] (dep, mem) in
            
            self?.alreadySelectDepAndMembersArray.removeAll()
            
            if dep.count > 0 {
                self?.alreadySelectDepAndMembersArray.append(["dep":dep])
            }
            
            if mem.count > 0 {
                self?.alreadySelectDepAndMembersArray.append(["mem":mem])
                self?.getAndAllocFunc(isGet: false)
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func actionSheet(_ actionSheet: LCActionSheet!, didClickedButtonAt buttonIndex: Int) {
        
        guard self.selectArray.count > 0 else {
            PublicMethod.toastWithText(toastText: "请选择客户")
            return
        }
        
        if self.authTuple.isManager {
            switch OperateCustomTypeEnum(type: buttonIndex) {
            case .get:
                self.getAndAllocFunc()
            case .alloc:
                self.pushToSelectDepAndMemberVCFunc()
            case .delete:
                self.deleteFunc()
            default:
                break
            }
        } else {
            switch OperateCustomTypeEnum(type: buttonIndex) {
            case .get:
                self.getAndAllocFunc()
            case .delete:
                self.deleteFunc()
            default:
                break
            }
        }
    }
    
    func customPoolCellBtnClickFunc(indexPath:IndexPath, isSelected: Bool) {
        
        if isSelected {
            self.selectArray.append(self.dataArray[indexPath.row])
        } else {
            self.selectArray.remove(self.dataArray[indexPath.row])
        }
        
        print("*** self.selectArray.count = \(self.selectArray.count)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchView.resignFirstResponder()
        
        self.initData(text: self.searchView.text ?? "")
    }
}

// MARK: - tableview相关
extension CustomPoolSearchViewController : UITableViewDataSource, UITableViewDelegate {
    
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
        if self.authTuple.isRoot, let vc = R.storyboard.customPool.customDetailViewController() {
            vc.customIdString = self.dataArray[indexPath.row].idString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
