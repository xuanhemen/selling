//
//  MineViewController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SDWebImage
class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var table = UITableView()
    
//    var theCell:UIImageView? = nil
    
    var modelDic:Dictionary<String,Any> = Dictionary()
    
    var dataArray:Array = Array<Dictionary<String,String>>()
    
    lazy var array:Array<Dictionary<String,String>> = {
        //["name":"消息中心","image":"ch_message_center_ico"],
        return [["name":"语音备忘录","image":"yuyin"],["name":"辅导付费记录","image":"coach"],["name":"关于","image":"ch_about_us_ico"]]
        }()
    
    
    
    let top = MineTopView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
        
        self.configUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMineInfo()
//        self.table.showBadge(with: .number, value: Int(RCIMClient.shared().getTotalUnreadCount()), animationType: .none)
        
    
//        if theCell != nil{
//            theCell?.contentView.badgeCenterOffset = CGPoint.init(x: 10, y: 22)
//            theCell?.contentView.showBadge(with: .number, value: Int(RCIMClient.shared().getTotalUnreadCount()), animationType: .none)
//        }
//        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
    

    func configUI(){
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.table.backgroundColor = UIColor.groupTableViewBackground
        top.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 240)
        top.backgroundColor = UIColor.black
        top.changeBtn.addTarget(self, action: #selector(changeBtnClick), for: .touchUpInside)
        self.view.addSubview(top)
        
        top.headClick = { [weak self](model) in
            
            PublicPush().centerPushToUserInfo(userId: UserModel.getUserModel().id!, vc: self!,model:model)
            
//            let personVC = PersonalInfoVC()
//            personVC.infoModel = model
//            self?.navigationController?.pushViewController(personVC, animated: true)
        }
        self.view.addSubview(self.table)
        self.table.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(top.snp.bottom).offset(-10)
            make.bottom.equalTo(self.view).offset(-NAV_HEIGHT)
        }
        self.table.delegate = self
        self.table.dataSource = self
        self.table.isScrollEnabled = true
        self.table.tableFooterView = UIView()
        let footView = UIView()
        footView.frame = CGRect(x: 0, y:MAIN_SCREEN_HEIGHT_PX-100-TAB_HEIGHT-NAV_HEIGHT, width: MAIN_SCREEN_WIDTH, height: 100)
        footView.backgroundColor = UIColor.groupTableViewBackground
        self.table.tableFooterView = footView;
        self.table.separatorStyle = UITableViewCellSeparatorStyle.none;
//        self.view.addSubview(footView)
        
        let exitBtn:UIButton = UIButton.init(type: .custom)
        footView.addSubview(exitBtn)
        exitBtn.backgroundColor = kGreenColor
        exitBtn.layer.cornerRadius = 6
        exitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalTo(50)
            make.height.equalTo(50)
        }
        exitBtn.setTitle("退出账号", for: .normal)
        exitBtn.addTarget(self, action: #selector(exitBtnClick), for: .touchUpInside)
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "changeGroupRedCount"), object: nil, queue: nil) { (notif) in
//            DispatchQueue.main.async(execute: { [weak self] in
//                if self?.theCell != nil {
//                    self?.theCell?.showBadge(with: .number, value: Int(RCIMClient.shared().getTotalUnreadCount()), animationType: .none)
//                }
//
//
//            })
//        }
        
    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
    
    
    
    
    func getMineInfo(){
        
        
        PublicMethod.showProgress()
        
        LoginRequest.getPost(methodName: LOGINER_MESSAGE, params: ["token":UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
             PublicMethod.dismiss()
        }) {[weak self] (dic) in
           PublicMethod.dismiss()
            DLog(dic)
            self?.refreshUI(model: dic )
        }
        
        
        
    }
    
    func refreshUI(model:Dictionary<String, Any>){
        self.modelDic = model
        
        self.top.reload(model: model)
        dataArray.removeAll()
        if model["is_root"] as! String == "1" {
            dataArray = dataArray + array
            dataArray.insert(["name":"企业管理","image":"ch_corp_administration_ico"], at: 0)
        }else{
            
        dataArray = dataArray + array
        }
        
        table.reloadData()
        
//        self.table.showBadge(with: .number, value: Int(RCIMClient.shared().getTotalUnreadCount()), animationType: .none)
    }
    
    
    
    //MARK: - ---------------------table代理------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIde)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIde)
            let label = UILabel();
            label.frame = CGRect(x: 0, y: 43.5, width: SCREEN_WIDTH, height: 0.5);
            label.backgroundColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1);
            cell?.contentView.addSubview(label);
            
        }
        cell?.contentMode = .scaleAspectFit
        cell?.accessoryType = .disclosureIndicator
        let dic = dataArray[indexPath.row]
        cell?.imageView?.image = UIImage.init(named: "clear")
        cell?.textLabel?.text = dic["name"]
//        cell?.imageView?.image = UIImage.init(named: dic["image"]!)
//        if dic["name"] == "辅导付费记录" {
        
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: dic["image"]!)
        cell?.imageView?.addSubview(imageView)
        imageView.snp.updateConstraints({ (make) in
            make.center.equalToSuperview()
        })
//        if dataArray[indexPath.row]["name"] == "消息中心" {
//            DispatchQueue.main.async(execute: {[weak self] in
//                if self?.theCell != nil {
//                    self?.theCell?.removeFromSuperview()
//                    self?.theCell = nil
//                }
//                self?.theCell = imageView
//                imageView.badgeCenterOffset = CGPoint.init(x: MAIN_SCREEN_WIDTH-80, y: imageView.centerY)
//                imageView.showBadge(with: .number, value: Int(RCIMClient.shared().getTotalUnreadCount()), animationType: .none)
//            })
//
//
//
//        }
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
         let dic = dataArray[indexPath.row]
        if dic["name"] == "企业管理" {
            self.navigationController?.pushViewController(EnterpriseManagementVC(), animated: true)
        }
        else if dic["name"] == "语音备忘录"{
            let recordV = RecorderPlayerListViewController()
            self.navigationController?.pushViewController(recordV, animated: true)
            
        }else if dic["name"] == "消息中心"{
//            let groupListVc = GroupListViewController()
            let groupListVc = PrivateListViewController()
            self.navigationController?.pushViewController(groupListVc, animated: true)
        }else if (dic["name"] == "关于"){
            
            self.navigationController?.pushViewController(AboutUsVC(), animated: true)
        }else if (dic["name"] == "辅导付费记录"){
            self.navigationController?.pushViewController(CoachHistoryVC(), animated: true)
        }
        else{
            PublicMethod.toastWithText(toastText: (dic["name"] as! String) + "暂未开放")
        }
            
        
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
    
    
    
    //MARK: - ---------------------选择企业------------------
    @objc func changeBtnClick(){
    
        if modelDic.count == 0 {
            return
        }
        
        let companyArray:Array<Dictionary<String,Any>> = modelDic["other_company"] as! Array
        guard companyArray.count>0 else {
            PublicMethod.toastWithText(toastText: "没有可切换的企业")
            return
        }
        
        var alertDic = Dictionary<String,String>()
        alertDic.updateValue("取消", forKey: kCancel)
        for dic in companyArray {
//            DLog(dic["name"])
            alertDic.updateValue(dic["name"] as! String, forKey: dic["id"] as! String)
        }
        
        let alert = UIAlertController.init(title: "选择企业", message: "", preferredStyle: .alert, btns: alertDic) {[weak self] (action, str) in
//            DLog(str)
            if str == kCancel {
                
                return
            }
            self?.chooseWith(idStr: str)
            
        }
        
//        let alert = UIAlertController.init(title: "选择", message: "选择", preferredStyle: .alert, okAndCancel: ("123", "123")) { (action, str) in
//
//        }
        self.present(alert, animated: true, completion: nil)
    
    }
    
    
    /// 选择企业
    ///
    /// - Parameter idStr: <#idStr description#>
    func chooseWith(idStr:String){
        
       
        let userModel = UserModel.getUserModel()
        PublicMethod.showProgressWithStr(statusStr: "正在切换企业中...")
        LoginRequest.login2(params: ["userid":userModel.id,"corpid":idStr], hadToast: true, fail: { (dic) in
            DLog(dic)
            PublicMethod.dismiss()
        }, success: {[weak self] (dic) in
           
            self?.getRYInfo(loginDic: dic)
//            userModel.guide = dic["guide"] as? String
//            userModel.is_pass = dic["is_pass"] as? String
//            userModel.token = dic["token"] as? String
//            userModel.is_root = dic["is_root"] as? String
//            userModel.saveUserModel()
//            PublicMethod.dismiss()
//            RCIM.shared().disconnect()
//            let tab = TabBarController.init(nibName: nil, bundle: nil)
//            APPDelegate.window?.rootViewController = tab
//            tab.selectedWithIndex(index: tab.childViewControllers.count-1)
        })
    }
    
    
    //切换企业后需要把单例相关的信息都清楚掉
    func refreshPublicDataSingle(){
        
       
        
        sharePublicDataSingle.token = UserModel.getUserModel().token! as NSString;
        sharePublicDataSingle.publicData.userid = UserModel.getUserModel().tcp_userid!
        sharePublicDataSingle.publicData.avater = UserModel.getUserModel().avater!
        sharePublicDataSingle.publicData.corpid = UserModel.getUserModel().corpid!
        sharePublicDataSingle.publicData.realname = UserModel.getUserModel().realname!
        sharePublicDataSingle.publicData.im_token = UserModel.getUserModel().im_token!
        sharePublicDataSingle.publicData.im_userid = UserModel.getUserModel().im_userid!
    }
    
    func getRYInfo(loginDic:Dictionary<String,Any>){
        
        LoginRequest.getPost(methodName: IM_GetToken, params: ["app_token":loginDic["token"]], hadToast: true, fail: { (dic) in
        
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            
            let userModel = UserModel.getUserModel()
           
            userModel.guide = loginDic["guide"] is String ? loginDic["guide"] as! String : String(describing: loginDic["guide"] as! NSNumber)
            userModel.is_pass = loginDic["is_pass"] is String ? loginDic["is_pass"] as! String : String(describing: loginDic["is_pass"] as! NSNumber)
            userModel.token = loginDic["token"] as? String
            userModel.is_root = loginDic["is_root"] is String ? loginDic["is_root"] as! String : String(describing: loginDic["is_root"] as! NSNumber)
            userModel.ismanager = loginDic["ismanager"] is String ? loginDic["ismanager"] as! String : String(describing: loginDic["ismanager"] as! NSNumber)
             userModel.corpid = String.noNilStr(str: dic["corpid"])
            userModel.avater = dic["avater"] as? String
            userModel.realname = dic["realname"] as? String
            userModel.im_token = dic["im_token"] as? String
            userModel.im_userid = dic["im_userid"] as? String
            userModel.depId = self?.modelDic["dep_id"] as? String
            userModel.saveUserModel()
            
            self?.refreshPublicDataSingle()
            
            PublicMethod.dismiss()
            RCIM.shared().logout()
            if userModel.is_pass == "0" || userModel.guide == "0"{
                APPDelegate.window?.rootViewController = BaseNavigationController.init(rootViewController: WelcomeViewController())
            }else{
                let tab = TabBarController.init(nibName: nil, bundle: nil)
                APPDelegate.window?.rootViewController = tab
                tab.selectedWithIndex(index: tab.childViewControllers.count-1)
            }
            
//            let tab = TabBarController.init(nibName: nil, bundle: nil)
//            APPDelegate.window?.rootViewController = tab
//            tab.selectedWithIndex(index: tab.childViewControllers.count-1)
            
            
            
        }
        
    }
    
    
    
    
    @objc func exitBtnClick(){
        
        self.Logout()
        
    }
    
    
    /// 退出
    func Logout(){
        //退出融云
        RCIM.shared().logout()
        
        let keyStr = "userModel" + UserModel.getUserModel().id!
        UserDefaults.standard.removeObject(forKey: keyStr)
        APPDelegate.window?.rootViewController = BaseNavigationController.init(rootViewController: LoginViewController())
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
