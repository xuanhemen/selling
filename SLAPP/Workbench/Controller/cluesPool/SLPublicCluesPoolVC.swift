//
//  SLPublicCluesPoolVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class SLPublicCluesPoolVC: BaseVC,UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,UISearchBarDelegate{
   
    
   
    /**数据源*/
    var dataArr = [SLPublicModel]()
    /**装选中的条目*/
    var paraDic = [String:String]()
    
    var topView:SLPublicHeadView!
    /**领取客户个数*/
    var selectedCount:Int = 0
    /**总线索数*/
    var totalCount:Int = 0
    /**权限数据*/
    var authArray = [String]()
    /**映射之后权限数据*/
    var titlesArray = [String]()
    /**权限*/
    var isRoot:String?
    /**数据源*/
    var searchDataArr = [SLPublicModel]()
    var isSearch:Bool = false
    
    /**公海分配id*/
    var allotsID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGBA(R: 240, G: 240, B: 240, A: 1)
        self.title = "线索公海"

        self.addLeftAndRightItem()
        /**添加操作bar*/
        topView = self.createTableHeadView() as? SLPublicHeadView
        self.view.addSubview(topView)
        /**请求线索公海*/
        self.requestCluesPool()
        // Do any additional setup after loading the view.
    }
    /**添加左右导航按钮*/
    func addLeftAndRightItem() -> Void {
        let addBtn = UIButton.init(type: UIButtonType.custom)
        addBtn.setImage(image("nav_add_new"), for: UIControlState.normal)
        addBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addBtn.addTarget(self, action: #selector(addClues), for: UIControlEvents.touchUpInside)
        let addBarItem = UIBarButtonItem.init(customView: addBtn)
        let searchBtn = UIButton.init(type: UIButtonType.custom)
        searchBtn.setImage(image("search"), for: UIControlState.normal)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchBtn.addTarget(self, action: #selector(searchClues), for: UIControlEvents.touchUpInside)
        let searchBarItem = UIBarButtonItem.init(customView: searchBtn)
        self.navigationItem.rightBarButtonItems = [addBarItem,searchBarItem]
    }
    //MARK: - 添加线索
    @objc func addClues() {
        let cvc = SLCreateCluesVC()
        cvc.pool = WhichPool.publicPool
        cvc.fresh = { isFresh in
            self.dataArr.removeAll()
            self.requestCluesPool()
        }
        self.navigationController?.pushViewController(cvc, animated: true)
    }
    //MARK: - 搜索
    @objc func searchClues() {
        self.isSearch = true
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.showsCancelButton = true
        searchBar.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44)
        let cancelBtn = searchBar.value(forKeyPath: "cancelButton") as! UIButton
        cancelBtn.isEnabled = true
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        self.navigationItem.titleView = searchBar
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchDataArr.removeAll()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchBar.resignFirstResponder()
        self.navigationItem.titleView = nil
         self.isSearch = false
         self.tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let cancel = searchBar.value(forKeyPath: "cancelButton") as! UIButton
        cancel.isEnabled = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchDataArr = self.dataArr.filter({ (model) -> Bool in
            let isContain = model.name?.contains(searchBar.text ?? "")
            return isContain!
        })
        self.tableView.reloadData()
    }
    
    func createTableHeadView() -> UIView {
        let headView = SLPublicHeadView()
        headView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60)
        headView.recycleBin.addTarget(self, action: #selector(travelToRecycleBin), for: UIControlEvents.touchUpInside)
        headView.opetation.addTarget(self, action: #selector(operation), for: UIControlEvents.touchUpInside)
        return headView
    }
    //MARK: - 回收站
    @objc func travelToRecycleBin() {
        if isRoot=="0" {
            self.toast(withText: "您无权限查看回收站", andDruation: 2)
        }else{
            let rvc = SLRecycleBinVC()
            rvc.freshList = {
                self.dataArr.removeAll()
                self.requestCluesPool()
            }
            rvc.isRoot = isRoot
            self.navigationController?.pushViewController(rvc, animated: true)
        }
       
    }
   
    @objc func operation() {
        let cluesArr = self.paraDic.values
        if cluesArr.isEmpty {
            self.toast(withText: "请先选择线索", andDruation: 1.5)
            return
        }
        self.titlesArray = self.authArray.map { (string) -> String in
            if string == "get"{
                 return "领取"
            }else if string == "allot"{
                 return "分配"
            }else if string == "del"{
                 return "删除"
            }else{
                 return ""
            }
           
        }
        let sheetView = LCActionSheet.init(title: "操作选项", buttonTitles: self.titlesArray, redButtonIndex: -1, delegate: self)
        sheetView?.show()
    }
    //MARK: - 操作
    func actionSheet(_ actionSheet: LCActionSheet!, didClickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        if buttonIndex == self.titlesArray.count{return}
        //拿到线索id参数
        var cluesID = String()
        let cluesArr = self.paraDic.values
        for (index,clues) in cluesArr.enumerated(){
            if index==0{
                cluesID = cluesID.appendingFormat("%@", clues)
            }else{
                cluesID = cluesID.appendingFormat(",%@", clues)
            }
        }
        let string = self.titlesArray[buttonIndex]
        if string=="领取" {
            self.operationClues(methodName: "pp.clue.allot_clue", clueID: cluesID, mark: "1")
        }else if (string=="分配") {
            let vc = HYColleaguesVC()
            vc.isSingle = true
            vc.singleSelectClosure = { id in
                self.allotsID = id
                self.operationClues(methodName: "pp.clue.allot_clue", clueID: cluesID, mark: "2")
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (string=="删除") {
             self.operationClues(methodName: "pp.clue.del", clueID: cluesID, mark: "4")
        }
    }
    func operationClues(methodName: String,clueID: String,mark: String) {
        /**参数*/
        self.showProgress(withStr: "正在加载中...")
        let userModel = UserModel.getUserModel()
        var parameters = [String:String]()
        var remindString = ""
        if mark=="4" {
            parameters["id"] = clueID
            remindString = "删除成功"
        }else if mark=="2"{
            parameters["userid"] = self.allotsID
            parameters["mark"] = mark
            parameters["clue_id"] = clueID
            remindString = "分配成功"
        }else{
            parameters["userid"] = userModel.id
            parameters["mark"] = mark
            parameters["clue_id"] = clueID
            remindString = "操作成功"
        }
        LoginRequest.getPost(methodName: methodName, params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            
            self.showDismiss()
            self.navigationItem.titleView = nil
            self.isSearch = false
            let status = dataDic["status"] as! Int
            if status==1{
                self.selectedCount = 0
                self.toast(withText: remindString , andDruation: 1.5)
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    self.dataArr.removeAll()
                    self.requestCluesPool()
                })
                
            }else{
                 self.toast(withText: "操作失败", andDruation: 2)
            }
           
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.register(SLPublicCluesPoolCell.self, forCellReuseIdentifier: "public")
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.dataArr.removeAll()
            self.requestCluesPool()
        })
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(70)
            make.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        return tableView
    }()
    //MARK: - tableview代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch==false{
            return self.dataArr.count
        }else{
            return self.searchDataArr.count
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "public") as! SLPublicCluesPoolCell
        var model:SLPublicModel?
        
        if isSearch==false || self.searchDataArr.count == 0{
            model = self.dataArr[indexPath.row]
        }else{
           
            model = self.searchDataArr[indexPath.row]
        }
        cell.setCellWithModel(model: model!)
        cell.selectBtn.tag = indexPath.row
        cell.selectBtn.addTarget(self, action: #selector(selectedClick), for: UIControlEvents.touchUpInside)
        if model?.selected==false {
            cell.selectBtn.isSelected=false
        }else{
            cell.selectBtn.isSelected=true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isRoot=="0" {
             let cell = tableView.cellForRow(at: indexPath) as! SLPublicCluesPoolCell
             self.selectedClick(button: cell.selectBtn)
        }else{
            var model:SLPublicModel?
            
            if isSearch==false || self.searchDataArr.count == 0{
                model = self.dataArr[indexPath.row]
            }else{
                
                model = self.searchDataArr[indexPath.row]
            }
            
            let vc = SLCluesDetailVC()
            vc.fresh = { isFreshList in

                self.isSearch=false
                tableView.mj_header.beginRefreshing()
                
            }
            vc.cluesID = model?.id
            vc.pool = WhichPool.publicPool
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //MARK: - 添加或移除条目
    @objc func selectedClick(button: UIButton){
        button.isSelected = !button.isSelected
        var model: SLPublicModel = SLPublicModel()
        if self.isSearch == true{
              model = self.searchDataArr[button.tag]
        }else{
              model = self.dataArr[button.tag]
        }
       
        let key = "\(button.tag)"
        if button.isSelected==true {
             model.selected = true
             self.paraDic[key] = model.id
            selectedCount += 1
        }else{
             model.selected = false
             self.paraDic.removeValue(forKey: key)
             selectedCount -= 1
        }
        /**选中或取消的时候更改选择指示器的个数*/
        self.selectionIndicators(selectedCount: selectedCount,totalCount: totalCount)
    }
    func selectionIndicators(selectedCount: Int,totalCount: Int){
        let remindStr = "已领取客户数：\(selectedCount) / \(totalCount)"
        let attrsting = NSMutableAttributedString.init(string: remindStr)
        let lengthStr = "\(selectedCount)"
        attrsting.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: NSRange(location: 7, length: lengthStr.count))
        self.topView.info.attributedText = attrsting
    }
    //MARK: - 请求线索池
    func requestCluesPool() {
        /**参数*/
        self.showProgress(withStr: "正在加载中...")
        var parameters = [String:String]()
        parameters["keyword"] = ""
        LoginRequest.getPost(methodName: "pp.clue.gonghai_lists", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            self.tableView.mj_header.endRefreshing()
        }) { (dataDic) in
            self.showDismiss()
            self.tableView.mj_header.endRefreshing()
            if let json = JSON(dataDic).dictionary,let array = json["list"]?.arrayObject{
                self.dataArr = [SLPublicModel].deserialize(from: array) as! [SLPublicModel]
//                if let count = json["my_list_count"]?.intValue {
//                    self.totalCount = count
//                    self.selectionIndicators(selectedCount: 0, totalCount: self.totalCount)
//                }
                if let authArr = json["jurisdiction"]?.arrayObject{
                    self.authArray = authArr as! [String]
                }
                if let isRoot = json["is_root"]?.stringValue{
                   self.isRoot = isRoot
                }
            }
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
