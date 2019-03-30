//
//  SLGroupVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class SLGroupVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    /**数据源*/
    lazy var dataArr:[SLCluesSectionModel] = []
    /**是否刷新*/
    var isFresh:Bool = false
    typealias FreshClues = () -> Void
    var fresh:FreshClues? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "分组管理"
        let leftItem = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelOperation))
        self.navigationItem.rightBarButtonItem = leftItem
        
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 1
        }
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0 {
            return CGFloat.leastNormalMagnitude
        }
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
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
        let cell:SLGroupCell = tableView.dequeueReusableCell(withIdentifier: "group") as! SLGroupCell
        let model:SLCluesSectionModel = self.dataArr[indexPath.row]
        cell.textField.text = model.name
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        if  model.is_custom == "1"{
            cell.textField.isEnabled = true
            cell.delBtn.isHidden = false
            cell.delBtn.tag = indexPath.row;
            cell.delBtn.addTarget(self, action: #selector(delGroup), for: UIControlEvents.touchUpInside)
        }else{
            cell.delBtn.isHidden = true
            
        }
        return cell
       
    }
    //MARK: - 添加分组
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
        }
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
                let numberID:String = dataDic["data"] as! String
                self.toast(withText: "添加成功", andDruation: 1.5)
                let model:SLCluesSectionModel = SLCluesSectionModel()
                model.name = name
                model.is_custom = "1"
                model.id = numberID
                self.dataArr.append(model)
                self.tableView.reloadData()
            }else{
                self.toast(withText: "添加失败", andDruation: 1.5)
            }
            self.tableView.reloadData()
        }
    }
    //MARK: - 删除分组
    @objc func delGroup(btn: UIButton){
        let model:SLCluesSectionModel = self.dataArr[btn.tag]
        let reminStr = "确定要删除“\(model.name!)”吗"
        let alertVC = UIAlertController.init(title: "", message: reminStr, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            return
        }
        let sureAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action) in
            self.deleteGroupWithId(id: model.id!,tag: btn.tag)
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    /**删除group*/
    func deleteGroupWithId(id: String,tag: Int) {
        /**参数*/
        var parameters = [String:String]()
        parameters["id"] = id
        LoginRequest.getPost(methodName: "pp.clue.del_custom_group", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            let state:Int = dataDic["status"] as! Int
            if state == 1{
                self.isFresh = true
                self.dataArr.remove(at: tag)
                self.toast(withText: "删除成功", andDruation: 1.5)
            }else{
                self.toast(withText: "删除失败", andDruation: 1.5)
            }
            self.tableView.reloadData()
        }
    }
    //MARK: - 取消操作
    @objc func cancelOperation(){
        if isFresh {
            self.fresh!()
        }
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let model = self.dataArr[textField.tag]
        if model.name == textField.text{
           return
        }else{
            self.changeThaGroupName(id: model.id!, name: textField.text!,tag: textField.tag)
        }
       
    }
    func changeThaGroupName(id: String,name: String,tag: Int) {
        /**参数*/
        var parameters = [String:String]()
        parameters["id"] = id
        parameters["new_name"] = name
        LoginRequest.getPost(methodName: "pp.clue.edit_custom_group", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)

        }) { (dataDic) in
            let status = dataDic["status"] as! Int
            if status==1{
                self.toast(withText: "修改成功", andDruation: 1.5)
                let model = self.dataArr[tag]
                model.name = name
            }else{
                self.toast(withText: "修改失败", andDruation: 1.5)
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
