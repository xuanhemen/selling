//
//  ToViewOtherPerformanceVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ToViewOtherPerformanceVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var topConstrait: NSLayoutConstraint!
    var dataArray:Array = Array<Dictionary<String,Any>>()
    let top = RankingTopView()
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "业绩排行榜"
        self.table.separatorStyle = .none
        self.table.register(UINib.init(nibName: "RankingListCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        
        self.configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configData()
    }
    
    func configUI(){
        self.view.backgroundColor = UIColor.groupTableViewBackground
        table.backgroundColor = UIColor.groupTableViewBackground
        top.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 120)
        self.view.addSubview(top)
        self.topConstrait.constant = 120
        top.editBtn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        top.headerClick = { [weak self] in
            let array = self?.dataArray.filter { (dic) -> Bool in
                return  String.noNilStr(str: dic["userid"]) == UserModel.getUserModel().id
            }
            guard (array?.count)! > 0 else {
                return
            }
            PublicPush().pushToUserInfo(imId: "", userId: UserModel.getUserModel().id!, vc: self!)
        }
//        self.table.tableHeaderView = top
        
    }
    
    func configData(){
        
        var url = ""
//        if UserModel.getUserModel().is_root == "1" {
////            oldStr = "低于本行业\(str)的企业"
//           url = COMPLETION_RATE_MORE
//        }
//        else if UserModel.getUserModel().ismanager == "1" {
////            oldStr = "低于本公司\(str)的部门"
//            url = TARGET_DEP_FIND
//        }else{
//            url = TARGET_ONESELF_FIND
////            oldStr = "低于本公司\(str)的小伙伴"
//        }
//        
        
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: COMPLETION_RATE_MORE, params: [:].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            
            if let array = dic["member"] as? Array<[String : Any]>{
                self?.dataArray = array
                self?.configTopData(topDic: dic["top"] as! Dictionary<String, Any>)
            }
            self?.table.reloadData()
        }
        
        
    }
    
    func configTopData(topDic:Dictionary<String,Any>){
        guard self.dataArray.count > 0 else {
            return
        }
        
        
        let array = self.dataArray.filter { (dic) -> Bool in
          return  String.noNilStr(str: dic["userid"]) == UserModel.getUserModel().id
        }
        if array.count > 0 {
            let dic:Dictionary<String,Any> = array.first!
            DLog(topDic)
            
            top.head.sd_setImage(with: NSURL.init(string: String.noNilStr(str: dic["head"]).appending(imageSuffix)) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
            
//            let topStr = String.noNilStr(str: topDic["planamount"]).appending("万")
            let topStr = String.init(format: "%.0f",JSON(topDic["planamount"]).floatValue).appending("万")
            top.top.attributedText = String.configAttributedStr(oldStr: "业绩目标:  ".appending(topStr), subStr: topStr, oldColor: UIColor.darkGray,color: UIColor.hexString(hexString: "E94E2C"))
            
            let middleStr = String.init(format: "%.1f", JSON(dic["completion_rates"] as Any).floatValue).appending("%")
            top.middle.attributedText = String.configAttributedStr(oldStr: "完成情况:  ".appending(middleStr), subStr: middleStr, oldColor: UIColor.darkGray, color: UIColor.hexString(hexString: "E94E2C"))
            
            
            let bottomStr = String.init(format: "%.0f",JSON(topDic["difference"]).floatValue).appending("万")
            top.bottom.attributedText = String.configAttributedStr(oldStr: "业绩差距:  ".appending(bottomStr), subStr: bottomStr, oldColor: UIColor.darkGray, color: UIColor.hexString(hexString: "E94E2C"))

//            let index = self.dataArray.index { (subdic) -> Bool in
//                return String.noNilStr(str: subdic["userid"]) == UserModel.getUserModel().id
//            }
            top.configWithRanking(ranking: JSON(topDic["ranking"]).intValue)
            top.num.text = JSON(topDic["ranking"]).stringValue
        }
        
    }
    
    //MARK: - ---------------------table代理------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        let cell:RankingListCell = tableView.dequeueReusableCell(withIdentifier: cellIde) as! RankingListCell
        
        if indexPath.row == 0 {
            cell.progress.color = UIColor.hexString(hexString: "2c9A35")
            
        }else if indexPath.row == 1 {
            cell.progress.color = UIColor.hexString(hexString: "77B92C")
        }else if indexPath.row == 2 {
            cell.progress.color = UIColor.hexString(hexString: "F5A912")
        }else{
            cell.progress.color = UIColor.hexString(hexString: "E94E2C")
            cell.number.text = "\((indexPath.row+1))"
            
        }
        if indexPath.row < 3 {
            cell.medals.isHidden = false
            cell.number.isHidden = true
            cell.medals.image = UIImage.init(named: "medals".appending("\(indexPath.row+1)"))
        }else{
             cell.number.isHidden = false
            cell.medals.isHidden = true
        }

        cell.percent.textColor = cell.progress.color
        let dic =   dataArray[indexPath.row]
        cell.progress.animate = 0
        cell.progress.progress = CGFloat(JSON(dic["completion_rates"]).floatValue/100.0)
        cell.progress.animate = 1
        cell.percent.text = String.init(format: "%.1f", JSON(dic["completion_rates"]).floatValue).appending("%")
        cell.name.text = String.noNilStr(str: dic["realname"])
        cell.head.sd_setImage(with: NSURL.init(string: String.noNilStr(str: dic["head"]).appending(imageSuffix)) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
        cell.userid = String.noNilStr(str: dic["userid"])
        
        cell.editClick = {[weak self] (str) in
            self?.toPush(str: str,userDic: dic)
        }
        cell.headerClick = {[weak self] (str) in
            PublicPush().pushToUserInfo(imId: "", userId: str, vc: self!)
        }
        if UserModel.getUserModel().is_root == "1" ||  UserModel.getUserModel().ismanager == "1"{
            
            if (String.noNilStr(str: dic["isthis_dep"]) == "1"){
                cell.edit.isHidden = true
            }else{
                cell.edit.isHidden = false
            }
            
        }else{
             cell.edit.isHidden = true
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
//        self.navigationController?.pushViewController(ToSetPermanceVC(), animated: true)
//        let dic = dataArray[indexPath.row]
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func editClick(){
        let array = self.dataArray.filter { (dic) -> Bool in
            return  String.noNilStr(str: dic["userid"]) == UserModel.getUserModel().id
        }
        guard array.count > 0 else {
            return
        }
        self.toPush(str: UserModel.getUserModel().id!,userDic: array.first!)
    }
    
    
    func toPush(str:String,userDic:Dictionary<String,Any>){
        
        PublicMethod.showProgress()
        
        if String.noNilStr(str: userDic["ismanager"]) == "1" {
            LoginRequest.getPost(methodName: DEP_FIND, params: ["dep_id":String.noNilStr(str: userDic["departmentid"])].addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismissWithSuccess(str: "获取失败，请再次点击设置")
            }) { [weak self](dic) in
                
                
                
                PublicMethod.dismiss()
                let vc = ToSetPermanceVC()
                vc.isManager = true
                vc.userid = String.noNilStr(str: userDic["departmentid"])
                
                vc.lookatModel = dic
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else{
            LoginRequest.getPost(methodName: ONESELF_FIND, params: ["userid":str].addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismissWithSuccess(str: "获取失败，请再次点击设置")
            }) { [weak self](dic) in
                
                
                
                PublicMethod.dismiss()
                let vc = ToSetPermanceVC()
                vc.userid = str
                vc.lookatModel = dic
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
        
        
    }
    
    
    func getPermanceInfo(userid:String){
        
        
        
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
