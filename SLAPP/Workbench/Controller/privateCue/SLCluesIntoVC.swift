//
//  SLCluesIntoVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/11.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
class SLCluesIntoVC: BaseVC,UITableViewDelegate,UITableViewDataSource,PassIndustry,AreaDelegate,Jump {
   
    /**地域数据源*/
    var areaArr = [SLProvinceModel]()
    /**参数*/
    var parameters = [String:String]()
    /**地址*/
    var address: String?
    /**公海池*/
    var pool: String = ""
    /**<#annotation#>*/
    var dataArr = ["客户","行业","区域","手机","所属"]
    /**行业*/
    var industryStr:String = ""
    /**行业id*/
    var industryID:String = ""
    /**线索id*/
    var cluesID:String = ""
    /**传过来的信息*/
    var basicDic:[String:Any]?
    /***/
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    var editInfoDic = [String:Any]()
    
    var repeatArr = [SLConverRepeatModel]()
    
    var count: Int = 0
    
    var markJump:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "线索转化"
        
        self.requestAreas()
        /**请求区域和行业*/
        self.requestIndustryAndAear()
        
        let sureItem = UIBarButtonItem.init(title: "确定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sure))
        self.navigationItem.rightBarButtonItem = sureItem
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.register(SLCluesInfoTableViewCell.self, forCellReuseIdentifier: "info")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "info") as! SLCluesInfoTableViewCell
        cell.title.text = dataArr[indexPath.row]
        if indexPath.row == 0 {
            cell.indentifier.isHidden = false
            cell.content.text = self.basicDic?["corp_name"] as? String
            cell.content.placeholder = "请输入客户"
            let logoImageView = UIImageView.init()
            logoImageView.image = UIImage.init(named: "qichacha")
            cell.addSubview(logoImageView)
            logoImageView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
                make.size.equalTo(CGSize(width:25,height:25))
            }
        }else if indexPath.row == 1{
            cell.indentifier.isHidden = false
            cell.content.text = self.industryStr
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.content.placeholder = "请输入行业"
        }else if indexPath.row == 2{
            cell.content.text = self.address
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.content.placeholder = "请输入地址"
        }else if indexPath.row == 3{
            cell.content.text = self.basicDic?["phone"] as? String
            cell.content.placeholder = "请输入电话号码"
            cell.content.isEnabled = true
        }else if indexPath.row == 4{
            
            cell.indentifier.isHidden = false
            cell.content.text = self.basicDic?["gonghai_category"] as? String
            self.pool = (self.basicDic?["gonghai_category"] as? String)!
            cell.content.placeholder = "请输入公海池"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = HYSelectCompanyVC()
            vc.selectBlock = { companyName in
                self.basicDic?["corp_name"] = companyName
                tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1 {
           let vc = SLIndustryVC()
           vc.delegate = self
           self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let bottomView = SLAreaBottomView.init(array: self.areaArr)
            bottomView.dismissNotice = {return}
            bottomView.delegate = self
            bottomView.show()
        }else{
           return
        }
    }
    //MARK: - 行业回调
    func passValue(name: String,id:String){
         self.industryID = id
         self.industryStr = name
         self.tableView.reloadData()
    }
    //MARK: - 确定
    @objc func sure() {
       
        let indus = NSString.init(string: self.basicDic?["corp_name"] as! String)
        if  indus == ""  {
             self.toast(withText: "请填写客户", andDruation: 1.5)
        
             return
        }else if self.industryStr == ""{
             self.toast(withText: "请填写行业", andDruation: 1.5)
             return
        }else if self.pool == "" {
            self.toast(withText: "请填写公海", andDruation: 1.5)
            return
        }
        self.showProgress(withStr: "正在加载中...")
        parameters["client_name"] = self.basicDic?["corp_name"] as? String
        parameters["clue_id"] = self.cluesID
        parameters["trade_id"] = self.industryID
        parameters["gonghai_cate"] = self.pool
        LoginRequest.getPost(methodName: "pp.clue.transform", params: parameters.addToken(), hadToast: true, fail: { (error) in
           
            if let json = JSON(error).dictionary,let state = json["status"]?.int{
                if state == 10060{
                    let arr = json["data"]?.arrayObject
                    self.repeatArr = [SLConverRepeatModel].deserialize(from: arr)! as! [SLConverRepeatModel]
                    let vc = SLCluesRepeatVC()
                    vc.dataArr = self.repeatArr
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    return
                }
                
            }
           
           
        }) { (dataDic) in
           
            self.showDismiss()
            var cluesIDs:String = ""
            if let json = JSON(dataDic).dictionaryObject{
                cluesIDs = json["id"] as! String
            }
           // self.toast(withText: "转化成功", andDruation: 1.5)
           // DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                let alertVC = UIAlertController.init(title: "线索已成功转化为客户", message: "您要继续添加项目吗？", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                    /**取消返回线索列表并刷新数据*/
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"isFresh"), object: nil)
                    
                    for vc in (self.navigationController?.childViewControllers)!{
                        if vc.isKind(of: SLMyCluesVC.self){
                             self.navigationController?.popToViewController(vc, animated: true)
                        }
                    }
                   
                    return
                }
                let sureAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive) { (action) in
                    
                    self.markJump = "jump"
                    /**确定添加项目*/
                    let vc = HYNewProjectVC()
                    vc.delegate = self
                    let model = HYClientModel()
                    model.name = self.basicDic?["corp_name"] as? String
                    model.id = cluesIDs
                    model.trade_name = self.industryStr
                    model.trade_id = self.industryID
                    vc.clientModel = model
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    return
                   
                }
                alertVC.addAction(cancelAction)
                alertVC.addAction(sureAction)
                self.present(alertVC, animated: true, completion: nil)
            //})
        }
    
   
    }
    func jumpCancelVC() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"isFresh"), object: nil)
        
        for vc in (self.navigationController?.childViewControllers)!{
            if vc.isKind(of: SLMyCluesVC.self){
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    //MARK: - 地区回调
    func passAreaInfo(name: String, provinceID: String, cityID: String, areaID: String) {
        self.address = name
        parameters["province"] = provinceID
        parameters["city"] = cityID
        parameters["area"] = areaID
        self.tableView.reloadData()
       
    }
    //MARK: - 请求区域
    func requestAreas() {
        self.showProgress(withStr: "正在加载中...")
        let para = [String:String]()
        LoginRequest.getPost(methodName: "pp.user.all_city_message", params: para.addToken(), hadToast: false, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            print("区域\(dataDic)")
            self.count += 1
            if self.count == 2{
                self.showDismiss()
            }
            if let json = JSON(dataDic).dictionary,let arr = json["list"]?.arrayObject{
                self.areaArr = [SLProvinceModel].deserialize(from: arr) as! [SLProvinceModel]
            }
        }
    }
    //MARK: - 请求行业和区域
    func requestIndustryAndAear() {
       
        var para = [String:String]()
        para["id"] = self.cluesID
        LoginRequest.getPost(methodName: "pp.clue.edit_clue_page", params: para.addToken(), hadToast: false, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.count += 1
            if self.count == 2{
                self.showDismiss()
            }
            
            if let json = JSON(dataDic).dictionaryObject{
                self.editInfoDic = json
                //地区
                self.parameters["province"] = self.editInfoDic["province"] as? String
                self.parameters["city"] = self.editInfoDic["city"] as? String
                self.parameters["area"] = self.editInfoDic["area"] as? String
                //行业
                self.industryID = self.editInfoDic["trade_id"] as? String ?? ""
                //公海
                self.pool = self.editInfoDic["gonghai_cate"] as? String ?? ""
                
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if markJump == "jump"{
            for vc in (self.navigationController?.childViewControllers)!{
                if vc.isKind(of: SLMyCluesVC.self){
                    self.navigationController?.popToViewController(vc, animated: true)
                }
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
