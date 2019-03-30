//
//  ProductInformationVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import MJRefresh
class ProductInformationVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    var parentid : String?
    var pDic = Dictionary<String,Any>()
    var isInit = false
    @objc var is_root = true
    
    lazy var table:UITableView = {
        let tb = UITableView()
        tb.backgroundColor = UIColor.groupTableViewBackground
        if isInit == true {
            tb.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-49)
        }else{
            tb.frame = CGRect(x: 0, y: 0, width:MAIN_SCREEN_WIDTH , height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT)
        }
        return tb
    }()
    
    var dataArray:Array = Array<Dictionary<String,Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "产品信息"
        if parentid == nil {
            parentid = "0"
        }
        if pDic.count != 0 {
            self.title = pDic["name"] as! String
        }
        
        
        
        self.configUI()
       
        
        
    }
//   PRODUCTS_LIST
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.configData()
        
    }
    
    func configData(){
        
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: MANAGE_PRODUCTS, params: ["parentid":parentid!,"token":UserModel.getUserModel().token], hadToast: true, fail: { [weak self](dic) in
            PublicMethod.dismiss()
            self?.table.mj_header.endRefreshing()
            
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            self?.table.mj_header.endRefreshing()
            let array = dic["data"]
            self?.dataArray.removeAll()
            self?.dataArray = array! as! Array<[String : Any]>
            self?.table.reloadData()
        }
        
    }
    
    func configUI(){
        self.view.addSubview(self.table)
        self.table.register(UINib.init(nibName: "ProduceCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.table.delegate = self
        self.table.dataSource = self
//        self.table.isScrollEnabled = false
        self.table.tableFooterView = UIView()
        self.table.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in
            self?.configData()
        })
        
//        let footView = UIView()
//        if isInit == true {
//            footView.frame = CGRect(x: 0, y:MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-165, width: MAIN_SCREEN_WIDTH, height: 165)
//        }else{
//            footView.frame = CGRect(x: 0, y:MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-100, width: MAIN_SCREEN_WIDTH, height: 100)
//        }
//
//        footView.backgroundColor = UIColor.groupTableViewBackground
//        //        self.table.tableFooterView = footView
//        self.view.addSubview(footView)
//
//        let addBtn:UIButton = UIButton.init(type: .custom)
//        footView.addSubview(addBtn)
//        addBtn.backgroundColor = kGreenColor
//        addBtn.layer.cornerRadius = 6
//        addBtn.snp.makeConstraints { (make) in
//            make.left.equalTo(20)
//            make.right.equalTo(-20)
//            make.centerY.equalTo(50)
//            make.height.equalTo(50)
//        }
//        addBtn.setTitle("增加", for: .normal)
//        addBtn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        
        if isInit == true {
            let stepBtn:UIButton = UIButton.init(type: .custom)
            self.view.addSubview(stepBtn)
            stepBtn.backgroundColor = kGreenColor
            stepBtn.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.width.equalTo(SCREEN_WIDTH/2-0.5)
                make.bottom.equalTo(0)
                make.height.equalTo(49)
            }
            stepBtn.setTitle("上一步", for: .normal)
            stepBtn.addTarget(self, action: #selector(stepBtnClick), for: .touchUpInside)
            
            let finishBtn:UIButton = UIButton.init(type: .custom)
            self.view.addSubview(finishBtn)
            finishBtn.backgroundColor = kGreenColor
            finishBtn.snp.makeConstraints { (make) in
                make.right.equalTo(0)
                make.width.equalTo(SCREEN_WIDTH/2-0.5)
                make.bottom.equalTo(0)
                make.height.equalTo(49)
            }
            finishBtn.setTitle("完成", for: .normal)
            finishBtn.addTarget(self, action: #selector(finishBtnClick), for: .touchUpInside)
        }
        
        
        let rightButton = UIButton.init(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.setImage(UIImage.init(named: "nav_add_new"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightClick(btn:)), for:.touchUpInside)
        let rightBarBtn = UIBarButtonItem.init(customView: rightButton)
        
        if self.is_root {
            self.navigationItem.rightBarButtonItem = rightBarBtn
        }
        
    }
    @objc func rightClick(btn: UIButton) {
        self.addBtnClick()
    }
    
    
    @objc func stepBtnClick(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func finishBtnClick(){
        self.navigationController?.pushViewController(WelcomeEndViewController(), animated: true)
    }
    @objc func addBtnClick(){
        
        let addVC = AddProductVC()
        addVC.parentid = self.parentid!
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    
    //MARK: - ---------------------table代理------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.parentid != "0" {
//            if section == 0 {
//                return 1
//            }else{
                return dataArray.count
//            }
            
        }else{
            return dataArray.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.parentid != "0" {
            return 1
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        let cell:ProduceCell = (tableView.dequeueReusableCell(withIdentifier: cellIde) as! ProduceCell)
        
//        if tableView.numberOfSections == 2 && indexPath.section == 0{
//            cell.desLb.text = (pDic["name"] as! String)
//            cell.deleteBtn.isHidden = true
//            cell.editBtn.isHidden = true
//            return cell
//        }
        
        guard dataArray.count > indexPath.row else {
            return cell
        }
        
        let model = dataArray[indexPath.row]
        cell.desLb.text = (model["name"] as! String)
        cell.deleteBtn.isHidden = false
        cell.editBtn.isHidden = false
        
        if !self.is_root {
            cell.deleteBtn.isHidden = true
            cell.editBtn.isHidden = true
        }
        if model["child"] as! String  != "0"
        {
            
            cell.deleteBtn.setImage(UIImage.init(named: "ch_div_right_new"), for: .normal)
            cell.deleteBtn.isEnabled = false
            
        }else{
            cell.deleteBtn.setImage(UIImage.init(named: "ch_delete_ico"), for: .normal)
            cell.deleteBtn.isEnabled = true
        }
        
        cell.clickBlock = { [weak self](type:productBtnClick) in
            self?.cellBtnClick(type: type, index: indexPath.row)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.numberOfSections == 2 && indexPath.section == 0 {
            return
        }
        let model = dataArray[indexPath.row]
        let vc = ProductInformationVC()
        vc.is_root = self.is_root
        vc.parentid = (model["id"] as! String)
        vc.pDic = model
    self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.numberOfSections == 2 && section == 0 {
            return 5
        }
        
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
    
    
    
    
    /// 产品cell上的按钮点击处理
    ///
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - index: <#index description#>
    func cellBtnClick(type:productBtnClick,index:Int){
        
        guard dataArray.count > index else {
            self.table.reloadData()
            return
        }
        
        let model = dataArray[index]
        switch type {
            
        case .edit:
            
            let addVC = AddProductVC()
            addVC.parentid = self.parentid!
            addVC.model = model
        self.navigationController?.pushViewController(addVC, animated: true)
            break
        case .delete:
            
            let alert = UIAlertController.init(title: "温馨提示", message: "确定删除该产品", preferredStyle: .alert, okAndCancel: ("确定", "取消"), btnActions: {[weak self] (action, str) in
                if str != "Cancel"{
                    self?.delete(model: model, index: index)
                }
            })
            self.present(alert, animated: true, completion: nil)
            
            
            
            
            break
        }
    }
    
    
    
    /// 删除产品
    ///
    /// - Parameters:
    ///   - model: <#model description#>
    ///   - index: <#index description#>
    func delete(model:Dictionary<String,Any>,index:Int){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PRODUCTS_DELETE, params: ["id":model["id"],"token":UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
            
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            self?.deleteRefresh(index: index)
        }
        
    }
    
   
    
    
    /// 删除操作成功后 处理本地界面
    ///
    /// - Parameter index: <#index description#>
    func deleteRefresh(index:Int){
        dataArray.remove(at: index)
      var section = 0
        if self.parentid != "0" {
            section = 1
        }
      let indexpath = IndexPath.init(row: index, section: 0)

        table.deleteRows(at: [indexpath], with: .automatic)
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
