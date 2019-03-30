//
//  ProjectSituationTabVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
import YBPopupMenu
class ProjectSituationTabVC: UITabBarController,YBPopupMenuDelegate,UITabBarControllerDelegate,ProjectSituationDelegate {
    
   @objc var tab = ProjectSituationTabView.init(frame: CGRect.zero)
    
    //是否有编辑权限
//    var isEditAuth:Bool = false
    
    
    var isChart = false
    var model:ProjectSituationModel?{
        didSet{
            self.title = model?.name!
            self.creatTabController()
            self.isShowMore()
        }
    }
    
    
  
    
    
    //第一次分析完做切换
    func toSwitcher(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                self?.model = model;
                self?.selectedIndex = 2
                self?.tab.selectWithTag(tag: 2)
                let nav:UINavigationController = self?.viewControllers![2] as! UINavigationController
                let vc:ProjectAnalyzeVC = nav.viewControllers.first as! ProjectAnalyzeVC;
                
                
                let alertVC = QFAlertVC()
                alertVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                alertVC.project_id = (self?.model?.id)!
                alertVC.view.backgroundColor = .clear
                vc.navigationController?.present(alertVC, animated: false, completion: {
                    
                })
            }
        }
        
    }
    
    /// 右上角是否显示很多
    func isShowMore(){
        
        if self.moreTitles().0.count > 0 {
            self.setRightBtnWithArray(items: [UIImage.init(named: "promore")])
        }
        
        
    }
    
    
    func toRefresh(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                self?.model = model;
            }
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.isHidden = true
        self.hiddenTabNav()
        if self.selectedIndex == 2 {
            let vc = self.selectedViewController
            if (vc?.isKind(of: ProjectAnalyzeVC.self))!{
                if isChart == true {
                    (vc as! ProjectAnalyzeVC).qfSegment?.selectIndex(index: 1)
                    self.isChart = false
                }
            }
            
        }
        
        self.getMsgNum()
    }
    
    
    
    /// 隐藏Tab的nav
    func hiddenTabNav(){
        if self.selectedIndex == 1 || self.selectedIndex == 2 || self.selectedIndex == 3{
            self.navigationController?.isNavigationBarHidden = true
        }else{
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
//        self.navigationController?.isNavigationBarHidden = true
       
        
        self.umAnalyticsWithName(name: um_projectDetailBase)
//        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:kGreenColor, forKey:NSAttributedStringKey.foregroundColor as NSCopying) as? [NSAttributedStringKey : Any], for: .selected)
        
    
        NotificationCenter.default.addObserver(self, selector: #selector(notiToSwitcher), name: NSNotification.Name(rawValue: "toSwitcher"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiTorefresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
       self.addBtn()
    }
    
    
    
    func addBtn(){
        
        self.tabBar.isHidden = true
        self.view.addSubview(tab)
        tab.delegate = self
        tab.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(49)
            make.bottom.equalTo(49-TAB_HEIGHT)
        }
    }
    
    @objc  func notiToSwitcher(){
        DLog("通知通知通知-----------------")
        self.toSwitcher()
    }
    
    @objc  func notiTorefresh(){
        DLog("通知通知通知-----------------")
        self.toRefresh()
    }
    
    
    override func rightBtnClick(button: UIButton) {
        let array = self.moreTitles().0
        guard array.count > 0  else {
            return
        }
        
        YBPopupMenu.showRely(on: button, titles: array, icons: self.moreTitles().1, menuWidth: 100) { [weak self] (menuView) in
            menuView?.delegate = self
        }
        
    }

    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        
        let str = self.moreTitles().0[index]
        if str == "复制" {
            self.umAnalyticsWithName(name: um_projectCopy)
            let alert = UIAlertController.init(title: "请输入新项目名称", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (text) in
                text.placeholder = "请再此输入名称"
            })
            
            alert.addAction(UIAlertAction.init(title: "取消", style: .default, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: {[weak alert,weak self] (action) in
                
                if alert!.textFields!.count > 0{
                    let str = alert!.textFields!.first?.text
                    if str!.isEmpty{
                        PublicMethod.toastWithText(toastText: "请输入新名称")
                    }else{
                        self?.toCopyWithName(name: str!)
                    }
                }
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if str == "转移"{
            self.umAnalyticsWithName(name: um_projectTransfer)
            let vc = TutoringMembersVC()
            vc.isTransfer = true
            vc.title = "选择转移对象"
            vc.style = .ourcompany
            vc.type = .single
            
            vc.resultArray = {[weak self,weak vc](result) in
                
                vc?.navigationController?.popViewController(animated: true)
                self?.transfer(memberId: (result.first?.id)!)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if str == "删除"{
            self.umAnalyticsWithName(name: um_projectDelete)
            self.delete()
            
        }else if str == "关单"  {
            self.umAnalyticsWithName(name: um_projectEnd)
            let checkView = CheckView.configWithTitles(titles:self.projectStatus())
            checkView.isCloseStatus = true
            checkView.click = {[weak self] (name,index) in
                self?.toClose(status: "\(index.row+1)")
            }
        }else if str == "打开"{
           
//            let alert = UIAlertController.init(title: "是否确认重新打开", message: "", preferredStyle: .alert, okAndCancel: ("否","是") { (a, key) in
//                self.toClose(status: "")
//            }
            let alert = UIAlertController.init(title: "是否确认重新打开", message: "", preferredStyle: .alert, btns: [kCancel:"否","yes":"是"]) {[weak self] (a, key) in
                if key == "yes"{
                    self?.toClose(status: "")
                }
            }
            self.present(alert, animated: true, completion: nil)
            
        }else if (str == "结转"){
            self.toCarryDown()
        }
    }
    
    func creatTabController(){
        
        let situationVC = ProjectSituationVC()
        situationVC.model = model
//        let situationItem: UITabBarItem = UITabBarItem(title: "概况", image: UIImage.init(named: "projectS-Nomal0"), selectedImage: UIImage.init(named: "projectS-Select0")!.withRenderingMode(.alwaysOriginal))
//        situationVC.tabBarItem = situationItem
        
        
        let followUpVC = SDTimeLineTableViewController()
        followUpVC.model = self.model;
        followUpVC.title = self.model?.name
        
//        let situationItem1: UITabBarItem = UITabBarItem(title: "跟进", image: UIImage.init(named: "projectS-Nomal0"), selectedImage: UIImage.init(named: "projectS-Select0")!.withRenderingMode(.alwaysOriginal))
//        followUpVC.tabBarItem = situationItem1
        followUpVC.proID = model?.id
       
       let nav = BaseNavigationController.init(rootViewController: followUpVC)
        var myAnalysisVC:UIViewController
        // == 0表示没有   大于0有
        if self.model?.pro_anaylse_logic_id != "0" {
            //已经做过体检  qwp
            let vc = ProjectAnalyzeVC()
            vc.model = model
            myAnalysisVC = vc
            myAnalysisVC = BaseNavigationController.init(rootViewController: vc)
            
        }else{
            //没有做过体检
            let analysisVC = ProjectEmptyAnalysisVC()
            analysisVC.model = model
            myAnalysisVC = BaseNavigationController.init(rootViewController: analysisVC)
        }
        
        let analysisItem: UITabBarItem = UITabBarItem(title: "分析", image: UIImage.init(named: "projectS-Nomal1"), selectedImage: UIImage.init(named: "projectS-Select1")!.withRenderingMode(.alwaysOriginal))
//        myAnalysisVC.tabBarItem = analysisItem
        
       
        let planVC = QFProjectPlanVC()
//        let planVC = HYVisitHomeVC()
//        let planItem: UITabBarItem = UITabBarItem(title: "计划", image: UIImage.init(named: "projectS-Nomal2"), selectedImage: UIImage.init(named: "projectS-Select2")!.withRenderingMode(.alwaysOriginal))
//        planVC.tabBarItem = planItem
        planVC.model  =  self.model
        let planNav =  BaseNavigationController.init(rootViewController: planVC)
        
        let tutorVC = ProjectTutoringVC()
        tutorVC.model = self.model
        let tutorItem: UITabBarItem = UITabBarItem(title: "辅导", image: UIImage.init(named: "projectS-Nomal3"), selectedImage: UIImage.init(named: "projectS-Select3")!.withRenderingMode(.alwaysOriginal))
//        tutorVC.tabBarItem = tutorItem
        
        
        let discussVC = UIViewController.init()
        let discussItem: UITabBarItem = UITabBarItem(title: "讨论", image: UIImage.init(named: "projectS-Nomal4"), selectedImage: UIImage.init(named: "projectS-Select4")!.withRenderingMode(.alwaysOriginal))
//        let tutorVC1 = SmallTalkVC.init(conversationType: .ConversationType_GROUP, targetId: "")
//        let tutorItem1: UITabBarItem = UITabBarItem(title: "辅导", image: UIImage.init(named: "projectS-Nomal3"), selectedImage: UIImage.init(named: "projectS-Select3")!.withRenderingMode(.alwaysOriginal))
//        discussVC.tabBarItem = discussItem
        self.viewControllers = [situationVC,nav,myAnalysisVC,planNav,tutorVC]
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    
    //复制
    func toCopyWithName(name:String){
        
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id!
        params["new_name"] = name
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: COPY_PROJECT, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: "复制成功")
            let alert = UIAlertController.init(title: "现在是否查看复制的项目", message: nil, preferredStyle: UIAlertControllerStyle.alert, btns: ["sure":"确定",kCancel:"取消"], btnActions: { (action, key) in
                if key == "sure"{
                     self?.toShowCopy(proId: JSON(dic["data"] as Any).stringValue)
                }
            })
            self?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func toShowCopy(proId:String){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":proId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in

            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                self?.model = model;
            }
        }
        
    }
    
    
    //关单-开单
    func toClose(status:String){
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id!
        if self.model?.close_status == "0" {
            params["act"] = "close"
             params["close_status"] = status
        }else{
            params["act"] = "restart"
        }
       
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_OPEN_CLOSE, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            self?.toRefresh()
        }
        
    }
    
    
    //转移项目
    func transfer(memberId:String){
        
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id!
        params["transfer_userid"] = memberId
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_TRANSFER, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: "转移成功")
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //项目删除
    func delete(){
        let alert = UIAlertController.init(title: "提示", message: "确定要删除当前项目吗？", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (sender) in
            PublicMethod.showProgress()
            LoginRequest.getPost(methodName: PROJECT_DELETE, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismiss()
            }) {[weak self] (dic) in
                PublicMethod.dismiss()
                PublicMethod.toastWithText(toastText: "删除成功")
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (sender) in
            
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        let vc = self.selectedViewController
        vc?.present(alert, animated: true, completion: {
            
        })
        
    }
    
    
    
    
    func isAnalysisVC(index:Int){
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id
        //        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: EXISTS_PROJECTANALYSE, params: params.addToken(), hadToast: true, fail: { (dic) in
            //            PublicMethod.dismiss()
        }) { [weak self](dic) in
            //            PublicMethod.dismiss()
            let code = JSON(dic["code"] as Any).stringValue
            if code == "2" {
                self?.toAlert(index:index)
            }else{
                self?.selectedIndex = index
                self?.tab.selectWithTag(tag: index)
            }
        }
        
    }
    func toAlert(index:Int){
        var title = "您已修改过项目信息，更新下分析报告，列计划更准确哦。"
        var sureButton = "更新"
        var notSureButton = "不更新"
        if index == 2 {
            sureButton = "更新报告"
            notSureButton = "看原来的"
            title = "您已修改过项目信息，是否更新分析报告？"
        }
        let alert = UIAlertController.init(title: "提示", message: title, preferredStyle: .alert, btns: [kCancel:notSureButton,"sure":sureButton], btnActions: {[weak self] (ac, str) in
            if str != kCancel {
                PublicMethod.showProgress()
                LoginRequest.getPost(methodName:PROJECT_OPEN_CLOSE, params: ["project_id":self?.model?.id,"close_status":"0"].addToken(), hadToast: true, fail: { (dic) in
                    PublicMethod.dismiss()
                }, success: {[weak self] (dic) in
                    PublicMethod.dismiss()
                    PublicMethod.toastWithText(toastText: JSON(dic["msg"] as Any).stringValue)
                    if index == 2{
                        self?.toSwitcher()
                    }else{
                        self?.selectedIndex = 3
                        self?.tab.selectWithTag(tag: 3)
                    }
                })
            }else{
                self?.selectedIndex = index
                self?.tab.selectWithTag(tag: index)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if viewController.isKind(of: ProjectSituationVC.self) {
            self.setRightBtnWithArray(items: [UIImage.init(named: "promore")])
        }else{
             self.navigationItem.rightBarButtonItems = nil
        }

        if viewController.isKind(of: ProjectAnalyzeVC.self) {
            self.title = self.model?.name//"项目分析"
            self.umAnalyticsWithName(name: um_projectAnalyze)
            self.isAnalysisVC(index: 2)
            return false
        }
        if viewController.isKind(of: QFProjectPlanVC.self) {

            self.title = self.model?.name//"项目计划"
            self.umAnalyticsWithName(name: um_projectPlan)
            if self.model?.pro_anaylse_logic_id != "0" {
                self.isAnalysisVC(index:3)
            }else{
                let alert = UIAlertController.init(title: "提示", message: "做一下项目体检，再列行动计划，会更有的放矢哦。", preferredStyle: UIAlertControllerStyle.alert)
                let sureAction = UIAlertAction.init(title: "体检", style: UIAlertActionStyle.default) { (alert) in

                    let analysisVC = ProjectAnalysisVC()
                    analysisVC.model = self.model
                    self.navigationController?.pushViewController(analysisVC, animated: true)

                }
                let notSureAction = UIAlertAction.init(title: "不体检", style: UIAlertActionStyle.default) {[weak self] (alert) in
//                    self?.selectedIndex = 3
                    self?.selectWithTag(tag: 3)
                    self?.navigationItem.rightBarButtonItems = nil
                }

                alert.addAction(sureAction)
                alert.addAction(notSureAction)
                self.present(alert, animated: true) {

                }
            }
            return false
        }
        return true
    }
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
       
        if self.selectedIndex == 0 {
            self.umAnalyticsWithName(name: um_projectDetailBase)
            self.title = self.model?.name//"项目概况"
            self.setRightBtnWithArray(items: [UIImage.init(named: "promore")])
        }else if self.selectedIndex == 1{
            
            self.title = self.model?.name//"项目跟进"
//            self.umAnalyticsWithName(name: um_projectAnalyze)
            self.navigationItem.rightBarButtonItems = nil
        }
        else if self.selectedIndex == 2{
            self.title = self.model?.name//"项目分析"
             self.umAnalyticsWithName(name: um_projectAnalyze)
            self.navigationItem.rightBarButtonItems = nil
        }else if self.selectedIndex == 3{
            self.title = self.model?.name//"项目计划"
            self.umAnalyticsWithName(name: um_projectPlan)
            self.navigationItem.rightBarButtonItems = nil
        }else if self.selectedIndex == 4{
            self.title = self.model?.name//"相关辅导"
            self.umAnalyticsWithName(name: um_projectCoach)
            self.navigationItem.rightBarButtonItems = nil
        }else if self.selectedIndex == 5{
            self.title = self.model?.name//"讨论"
            self.umAnalyticsWithName(name: um_projectChat)
            self.navigationItem.rightBarButtonItems = nil
        }
        
        
        
        if self.selectedIndex == 4 {
            self.getChatInfo()
        }
        
    }
    
    
    //获取项目的聊天
    func getChatInfo(){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_GROUP, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { [weak self] (pdic)  in
//            DLog(pdic)
            PublicMethod.dismiss()
            
            if (JSON(pdic["groupid"] as Any).stringValue.isEmpty){
                PublicMethod.toastWithText(toastText: "获取的讨论组信息有误", druation: 4);
                return;
            }
            
            
            PublicDataSingle.initData(fail: { (dic) in
                
            }, success: { (dic) in
                let gModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",JSON(pdic["groupid"] as Any).stringValue)).firstObject() as? GroupModel
                
                if gModel != nil {
                    
                    let model : RCConversationModel = RCConversationModel.init()
                    model.targetId = gModel?.groupid
                    model.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
                    model.conversationTitle = gModel?.group_name
                    model.extend = gModel?.icon_url
                    model.topCellBackgroundColor = UIColor.hexString(hexString: "DCDCDC")
                    model.cellBackgroundColor = UIColor.white
                    model.conversationType = RCConversationType.ConversationType_GROUP
                    let tabBarVc : TMTabbarController = TMTabbarController()
                    tabBarVc.groupModel = model
                    tabBarVc.projectId = ""
                    self?.navigationController?.pushViewController(tabBarVc, animated: true)
                    return
                }else{
                    //如果本地查不到  把时间戳清空  下次请求全数据
                    let time = "0"
                    let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                    UserDefaults.standard.set(time, forKey: username)
                    
                }
            })
        }
    }
    
    
    func toChat(){
        
    }
    
    
    func moreTitles()->(Array<String>,imageArray:Array<String>){
        
        var array = Array<String>()
        var imageArray = Array<String>()
        //        ["menuCopy","menuTrans","menuDelete","menuClose"],
        if self.model?.save_auth == "1" {
            array.append("复制")
            imageArray.append("menuCopy")
        }
        if self.model?.save_pro_userid == "1"{
            array.append("转移")
            imageArray.append("menuTrans")
        }
        
        if self.model?.save_auth == "1" {
            array.append("删除")
            imageArray.append("menuDelete")
        }
        
        if self.model?.carry_down == "1" {
            array.append("结转")
            imageArray.append("carryDown")
        }
        
        
        if self.model?.close_open_auth == "1" {
            
            if self.model?.close_status == "0"{
                array.append("关单")
                imageArray.append("menuClose")
            }else{
                array.append("打开")
                imageArray.append("menuClose")
            }
        }
        
        
        
        return (array,imageArray)
    }
    
    
    //项目状态
    func projectStatus()->([String]){
        return ["赢单","丢单","延缓","暂停","其他"]
    }
    
    
    func selectWithTag(tag:Int){
       self.selectedIndex = tag
        self.tab.selectWithTag(tag: tag)
    }
    
    
    
    
    // MARK: - ***********ProjectSituationDelegate  **************
    /// 点击了某个按钮 返回true 表示执行点击 或做相应视图切换  false 截断点击
    ///
    /// - Parameters:
    ///   - tabView: ProjectSituationTabView
    ///   - selectBtn: 具体点击的按钮
    /// - Returns: 是否确认通过点击事件
    func tabViewClick(tabView: ProjectSituationTabView, selectBtn: ProjectTabBtn) -> (Bool) {
        
        if selectBtn.titleLabel?.text == "概况" {
            self.setRightBtnWithArray(items: [UIImage.init(named: "promore")])
        }else{
            self.navigationItem.rightBarButtonItems = nil
        }
        
        if selectBtn.titleLabel?.text == "分析" {
            self.umAnalyticsWithName(name: um_projectAnalyze)
            self.isAnalysisVC(index: 2)
            return false
        }
        
        
        if selectBtn.titleLabel?.text == "计划" {
            
            self.umAnalyticsWithName(name: um_projectPlan)
            if self.model?.pro_anaylse_logic_id != "0" {
                self.isAnalysisVC(index:3)
            }else{
                let alert = UIAlertController.init(title: "提示", message: "做一下项目体检，再列行动计划，会更有的放矢哦。", preferredStyle: UIAlertControllerStyle.alert)
                let sureAction = UIAlertAction.init(title: "体检", style: UIAlertActionStyle.default) { (alert) in
                    
                    let analysisVC = ProjectAnalysisVC()
                    analysisVC.model = self.model
                    self.navigationController?.pushViewController(analysisVC, animated: true)
                    
                }
                let notSureAction = UIAlertAction.init(title: "不体检", style: UIAlertActionStyle.default) {[weak self] (alert) in
                    self?.selectedIndex = 3
                    self?.tab.selectWithTag(tag: 3)
                    self?.navigationItem.rightBarButtonItems = nil
                }
                
                alert.addAction(sureAction)
                alert.addAction(notSureAction)
                self.present(alert, animated: true) {
                    
                }
            }
            return false
        }
        
        
        
        return true
    }
    
    
    
    
    
    /// 某个按钮已经点击了
    ///
    /// - Parameters:
    ///   - tabView: ProjectSituationTabView
    ///   - selectBtn: 具体点击的按钮
    func tabViewDidSelect(tabView: ProjectSituationTabView, selectBtn: ProjectTabBtn) {
       
        self.moreNavigationController.isNavigationBarHidden = true
        
        if selectBtn.tag-1000 == 4 {
            self.getChatInfo()
        }
        else if selectBtn.tag-1000 == 5 {
            selectedIndex = 4
        }else{
            selectedIndex =  selectBtn.tag-1000
        }
        
        
        if selectedIndex == 0 {
            self.umAnalyticsWithName(name: um_projectDetailBase)
            self.title = self.model?.name//"项目概况"
            self.setRightBtnWithArray(items: [UIImage.init(named: "promore")])
        }else if selectedIndex == 1 {
            self.title = self.model?.name//"项目跟进"
        }else if selectedIndex == 2 {
            self.title = self.model?.name//"项目分析"
            self.umAnalyticsWithName(name: um_projectAnalyze)
            //self.navigationItem.rightBarButtonItems = nil
        }else if selectedIndex == 3 {
            self.title = self.model?.name//"项目计划"
            self.umAnalyticsWithName(name: um_projectPlan)
            self.navigationItem.rightBarButtonItems = nil
        }else if selectedIndex == 5 {
            self.title = self.model?.name//"相关辅导"
            self.umAnalyticsWithName(name: um_projectCoach)
            self.navigationItem.rightBarButtonItems = nil
        }else if selectedIndex == 4 {
            self.title = self.model?.name//"讨论"
            self.umAnalyticsWithName(name: um_projectChat)
            self.navigationItem.rightBarButtonItems = nil
        }
        
        self.hiddenTabNav()
        
    }
    
    
//    获取消息个数
    func getMsgNum(){
        
        guard model != nil else {
            return
        }
        
        //显示个数
        LoginRequest.getPost(methodName: FOLLOWUP_NEW_MESSAGE_NUM, params: ["id":model?.id as Any].addToken(), hadToast: false, fail: { (dic) in
            
        }) { [weak self](dic) in
            if JSON(dic["new_message_num"]).intValue == 0 {
                self?.getRedNum()
            }
            else{
                self?.tab.showPoint(num: JSON(dic["new_message_num"] as Any).intValue, tag: 1,isRed: false)
            }
        }
        
        
        
       
        
    }
    
    func getRedNum(){
        //显示红点
        LoginRequest.getPost(methodName: FOLLOWUP_RED_POINT, params: ["id":model?.id as Any].addToken(), hadToast: false, fail: { (dic) in
            
        }) {[weak self] (dic) in
            DLog(dic);
            
            if JSON(dic["is_have"] as Any).intValue > 0 {
                self?.tab.showPoint(num: JSON(dic["is_have"] as Any).intValue, tag: 1,isRed: true)
            }
            
            
            
            
        }
        
    }
    
    
    
    
    
    /// 结转
    func toCarryDown(){
        
        PublicMethod.showProgress()
        var params : Dictionary<String,Any> = Dictionary()
        params["ids"] = self.model?.id
        LoginRequest.getPost(methodName: PROJECY_PROJECT_SETTING_SAVE, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: "结转成功", druation: 2)
            self?.toRefresh()
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    
    
    
}
