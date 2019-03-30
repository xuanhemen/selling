//
//  SLCluesGroupVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class SLCluesGroupVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    /**数据源*/
    lazy var dataArr:[Any] = [Any]()
    /**线索id*/
    var cluesID:String?
    /**中间变量模型*/
    var seletedModel:SLGroupModel?
    /**参数-系统*/
    var systemPara:String = ""
    /**参数-自定义*/
    var customPara:NSString = NSString.init()
    
    var isFirst:Bool = true
    /**是否刷新线索列表*/
    var isFresh:Bool = false
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "线索分组"
        let rightItem = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(commitInfo))
        self.navigationItem.rightBarButtonItem = rightItem
        let leftItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelOperation))
        self.navigationItem.leftBarButtonItem = leftItem
        self.tableView.reloadData()
        /**请求分组列表*/
        self.requestGroup()
        // Do any additional setup after loading the view.
    }
    /**取消*/
    @objc func cancelOperation() {
        if isFresh==true{
           NotificationCenter.default.post(name: NSNotification.Name("isFresh"), object: nil, userInfo: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    /**完成提交给服务器*/
    @objc func commitInfo() {
        self.commitInfoToServer()
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        //tableView.tableHeaderView = headView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0
        tableView.register(SLGroupCell.self, forCellReuseIdentifier: "group")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        return tableView
    }()
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count+1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 1
        }
        let array = self.dataArr[section-1] as! [SLGroupModel]
        return array.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0 {
            return CGFloat.leastNormalMagnitude
        }
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        let lable = UILabel()
        if section==1 {
            lable.text = "系统分组"
        }else{
            lable.text = "自定义分组"
        }
        lable.textColor = RGBA(R: 100, G: 100, B: 100, A: 1)
        lable.font = FONT_15
        headView.addSubview(lable)
        lable.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        return headView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "添加分组"
            cell.textLabel?.textColor = RGBA(R: 50, G: 50, B: 50, A: 1)
            cell.textLabel?.font = FONT_18
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }
        let array = self.dataArr[indexPath.section-1] as! [SLGroupModel]
        let model = array[indexPath.row]
        let cell = SLCluesGroupCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = model.name
        cell.textLabel?.textColor = RGBA(R: 50, G: 50, B: 50, A: 1)
        cell.textLabel?.font = FONT_18
        
        if model.is_on==1{
            if indexPath.section==1{
               seletedModel = model
            }
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            cell.tintColor = RGBA(R: 88, G: 195, B: 88, A: 1)
            cell.isSelect = true
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.tintColor = UIColor.clear
            cell.isSelect = false
        }
        return cell
    }
    //MARK: - 添加分组和自定义分组
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /**中间变量*/
        var field = UITextField()
        if indexPath.section==0{
            let alertVC = UIAlertController.init(title: "添加分组", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                return
            }
            let sureAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive) { (action) in
                /**确定分组*/
                self.addGroup(name: field.text!)
            }
            alertVC.addTextField { (textFileld) in
                field = textFileld
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(sureAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        let array = self.dataArr[indexPath.section-1] as! [SLGroupModel]
        let model = array[indexPath.row]
        if indexPath.section==1 {
            if model != seletedModel {
                model.is_on = 1
                seletedModel?.is_on = 0
                seletedModel = model
            }else{
                model.is_on = 0
                seletedModel = nil
            }
        }else if (indexPath.section==2){
            let cell = tableView.cellForRow(at: indexPath) as! SLCluesGroupCell
            cell.isSelect = !(cell.isSelect)
           
            if cell.isSelect == true{
                 model.is_on = 1
            }else{
                 model.is_on = 0
            }
            
        }
           self.tableView.reloadData()
           return
    }
    func addGroup(name: String) {
        /**参数*/
        var parameters = [String:String]()
        parameters["name"] = name
        LoginRequest.getPost(methodName: "pp.clue.add_custom_group", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            print("结果\(dataDic)")
            let state:Int = dataDic["status"] as! Int
            if state == 1{
                /**是否刷新*/
                self.isFresh = true
                self.toast(withText: "添加成功", andDruation: 1.5)
                self.dataArr.removeAll()
                self.requestGroup()
            }else{
                self.toast(withText: "添加失败", andDruation: 1.5)
            }
            self.tableView.reloadData()
        }
    }
    func requestGroup() {
        /**参数*/
        var parameters = [String:String]()
        parameters["clue_id"] = self.cluesID
        print("参数\(parameters)")
        LoginRequest.getPost(methodName: "pp.clue.all_group", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            
            print("结果\(dataDic)")
            

            if let dic = JSON(dataDic).dictionary{
               if let arr = dic["sys_group"]?.arrayObject{
                let sysModels = [SLGroupModel].deserialize(from: arr) as! [SLGroupModel]
                self.dataArr.append(sysModels)
               }
               if let array = dic["custom_group"]?.arrayObject{
                let cusModels = [SLGroupModel].deserialize(from: array) as! [SLGroupModel]
                self.dataArr.append(cusModels)
               }
            }
            self.tableView.reloadData()
        }
    }
    //MARK: - 提交线索转移
    func commitInfoToServer() {
        /**参数*/
        var parameters = [String:String]()
        parameters["clue_id"] = self.cluesID
        for item in self.dataArr[0] as! [SLGroupModel] {
            if item.is_on==1 {
                systemPara = item.id!
            }
        }
        let array = self.dataArr[1] as! [SLGroupModel]
        for item in array {
            if item.is_on==1 && isFirst==true{
                isFirst = false
                customPara = customPara.appendingFormat("%@", item.id!)
            }else if item.is_on==1 {
                customPara = customPara.appendingFormat(",%@", item.id!)
            }
        }
        parameters["sys_group"] = systemPara
        parameters["custom_group_id"] = customPara as String
        LoginRequest.getPost(methodName: "pp.clue.transfer", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            let status:Int = dataDic["status"] as! Int
            if status==1{
                self.toast(withText: "分组成功", andDruation: 1.5)
                NotificationCenter.default.post(name: NSNotification.Name("isFresh"), object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
            }else{
                self.toast(withText: "提交失败", andDruation: 1.5)
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
