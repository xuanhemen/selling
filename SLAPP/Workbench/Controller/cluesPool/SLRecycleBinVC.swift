//
//  SLRecycleBinVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class SLRecycleBinVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    /**数据源*/
    var dataArr = [SLPublicModel]()
    /**搜索数据源*/
    var searchDataArr = [SLPublicModel]()
    /***/
    var dataDic = [String:SLPublicModel]()
    /**装选中的条目*/
    var paraDic = [String:String]()
    /**恢复通知，通知线索池刷新列表*/
    typealias Fresh = () -> Void
    var freshList: Fresh?
    /**是否为管理员*/
    var isRoot:String?
    
    var isSearch:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "线索回收站"
        let searchBarItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(searchClues))
        self.navigationItem.rightBarButtonItem = searchBarItem
        /**添加恢复按钮*/
        self.addRestoreView()
        /**请求垃圾站数据*/
        self.requestRecycleBin()
        
        // Do any additional setup after loading the view.
    }
    /**搜索*/
    @objc func searchClues(){
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
    func addRestoreView() {
        let restoreBtn = UIButton.init(type: UIButtonType.custom)
        restoreBtn.setTitle("恢 复", for: UIControlState.normal)
        restoreBtn.backgroundColor = .white
        restoreBtn.setTitleColor(SLGreenColor, for: UIControlState.normal)
        restoreBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        restoreBtn.addTarget(self, action: #selector(restoreClues), for: UIControlEvents.touchUpInside)
        self.view.addSubview(restoreBtn)
        restoreBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-SAFE_HEIGHT)
            //make.top.equalTo(self.view.snp.bottom)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 50))
            make.centerX.equalToSuperview()
        }
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.3)
        topLayer.backgroundColor = RGBA(R: 240, G: 240, B: 240, A: 1).cgColor
        restoreBtn.layer.addSublayer(topLayer)
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 49.7, width: SCREEN_WIDTH, height: 0.3)
        bottomLayer.backgroundColor = RGBA(R: 240, G: 240, B: 240, A: 1).cgColor
        restoreBtn.layer.addSublayer(bottomLayer)
        
    }
    //MARK: - 恢复线索
    @objc func restoreClues(button: UIButton) {
       
        //拿到线索id参数
        var cluesID = String()
        let cluesArr = self.paraDic.values
        if cluesArr.count == 0{
            self.toast(withText: "请选择要恢复的线索", andDruation: 1.5)
            return
        }
        for (index,clues) in cluesArr.enumerated(){
            if index==0{
                cluesID = cluesID.appendingFormat("%@", clues)
            }else{
                cluesID = cluesID.appendingFormat(",%@", clues)
            }
        }
        self.showProgress(withStr: "正在恢复中...")
        /**参数*/
        var parameters = [String:String]()
        parameters["id"] = cluesID
        
       LoginRequest.getPost(methodName: "pp.clue.clue_recover", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
           
            self.showDismiss()
            self.navigationItem.titleView = nil
            self.isSearch = false
           
            let status = dataDic["status"] as! Int
            if  status==1 {
                self.toast(withText: dataDic["msg"] as? String, andDruation: 1.5)
                let keys = self.paraDic.keys
               
//                for index in keys{
//                   // self.dataArr.remove(at: Int(index)!)
//                    self.dataDic.removeValue(forKey: index)
//                }
//                self.dataArr.removeAll()
//                let arr = self.dataDic.keys
//                for key in arr{
//                    let model = self.dataDic[key]
//                    self.dataArr.append(model!)
//                }
//                self.dataDic.removeAll()
//                for (index,value) in self.dataArr.enumerated(){
//                    self.dataDic["\(index)"] = value
//                }
                self.dataArr.removeAll()
                self.paraDic.removeAll()
               // self.tableView.reloadData()
                self.requestRecycleBin()
                self.freshList!()
            }else{
                self.toast(withText: "恢复失败", andDruation: 1.5)
            }
            //self.dataArr.removeAll()
//            self.requestCluesPool()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.backgroundColor = RGBA(R: 240, G: 240, B: 240, A: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.register(SLPublicCluesPoolCell.self, forCellReuseIdentifier: "public")
       self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50-SAFE_HEIGHT)
            make.width.equalTo(SCREEN_WIDTH)
        }
        return tableView
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearch == true {
            return self.searchDataArr.count
        }
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "public") as! SLPublicCluesPoolCell
        var model:SLPublicModel = SLPublicModel()
        if self.isSearch == true && self.searchDataArr.count != 0  {
           model = self.searchDataArr[indexPath.row]
        }else{
           model = self.dataArr[indexPath.row]
        }
        cell.setCellWithModel(model: model)
        cell.selectBtn.tag = indexPath.row
        cell.selectBtn.addTarget(self, action: #selector(selectedClick), for: UIControlEvents.touchUpInside)
        if model.selected==false {
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
            var model:SLPublicModel = SLPublicModel()
            if self.isSearch == true && self.searchDataArr.count != 0  {
                model = self.searchDataArr[indexPath.row]
            }else{
                model = self.dataArr[indexPath.row]
            }
            let vc = SLCluesDetailVC()
            vc.fordName = "回收站"
            vc.fresh = { isFreshList in
                self.isSearch = false
                self.dataArr.removeAll()
                self.requestRecycleBin()
            }
            vc.cluesID = model.id
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
        }else{
            model.selected = false
            self.paraDic.removeValue(forKey: key)
        }
        
    }
    /**请求回收站数据*/
    func requestRecycleBin() {
        /**参数*/
        self.showProgress(withStr: "正在加载中...")
        let parameters = [String:String]()
        LoginRequest.getPost(methodName: "pp.clue.del_pool_lists", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.showDismiss()
            if let json = JSON(dataDic).dictionary,let array = json["data"]?.arrayObject{
                self.dataArr = [SLPublicModel].deserialize(from: array) as! [SLPublicModel]
            }
            self.tableView.reloadData()
            
            for (index,value) in self.dataArr.enumerated(){
                self.dataDic["\(index)"] = value
            }
            
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
