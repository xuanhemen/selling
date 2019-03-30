//
//  TutoringDetailVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
let headerViewHeight : CGFloat = 110
let viewMargin : CGFloat = 15
let btnHeight : CGFloat = 40
let timerViewHeight : CGFloat = 95
class TutoringDetailVC: BaseVC,UITableViewDelegate,UITableViewDataSource{

    var myHeadView:ConsultDetailHeaderView?
    
    var new_consult_id:String?
    var modelDic = Dictionary<String,Any>() //接口返回的所有数据
    var modelArr = Array<Any>() //tableView数据源
    var cancleBtn : UIButton!
    var editBtn : UIButton!
    var enterBtn : UIButton!
    var groupModel : GroupModel? //群组
    var subGroupModel : GroupModel? //主题
    var timer:Timer?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tutoringDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        CoachViewModel.clearCoachKey()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "辅导详情"
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        
//        通知   有辅导状态变化都会发送
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "coachrefresh"), object: nil, queue: nil) {[weak self] (notif) in
               let aJson = notif.object
            let idStr = JSON(aJson as Any).dictionaryValue["data"]?.dictionaryValue["id"]?.stringValue
            //判断当前推送来的辅导是否和当前辅导是同一个辅导
            if idStr == self?.new_consult_id! {
                self?.toRefresh()
            }
            
        }
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "changeGroupRedCount"), object: nil, queue: nil) {[weak self] (notif) in
            let aJson = notif.object
            let myMessage:RCMessage? = aJson as? RCMessage;
            
            if myMessage != nil {
                
               
                    if myMessage?.targetId == String.noNilStr(str: self?.modelDic["teacher_im_userid"]) {
                        self?.myHeadView?.messageBtn.showBadge(with: .number, value: Int(RCIMClient.shared().getUnreadCount(RCConversationType.ConversationType_PRIVATE, targetId: self?.modelDic["teacher_im_userid"] as! String)), animationType: .none)
                        
                    }
                
                
            }
            
            //判断当前推送来的辅导是否和当前辅导是同一个辅导
//            if idStr == self?.new_consult_id! {
//                self?.toRefresh()
//            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func toRefresh(){
        //收到通知后  做刷新   如果视图不在当前页就没有必要去刷新
        if PublicMethod.appCurrentViewController() is TutoringDetailVC {
        self.tutoringDetail()
       }
    }
    
    func configUI(){
        
        var scrollView_height : CGFloat = MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight - viewMargin
        if String(describing: modelDic["cate"]!) == "1" || String(describing: modelDic["cate"]!) == "3"{
            scrollView_height = MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight - viewMargin
        }
        if String(describing: modelDic["cate"]!) == "2"{
            if String(describing: modelDic["isReady"]!) == "1"{ //预约成功的有倒计时
                scrollView_height = MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight - timerViewHeight - viewMargin
            }else{
                scrollView_height = MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight - viewMargin
            }
        }
        let currentDate = Date()
        //和预约的开始时间做对比
        var totalTime = Double(String(describing: modelDic["begintime"] as! String))! - currentDate.timeIntervalSince1970

        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: scrollView_height))
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
        let headerView = ConsultDetailHeaderView.init(modelArr: [modelDic["teacher_heads"] as! String,modelDic["teacher_realname"] as! String,modelDic["teacher_position"] as! String,String(describing: modelDic["teacher_fen"]!)], frame: CGRect.init(x: 15, y: viewMargin, width: MAIN_SCREEN_WIDTH - 30, height: headerViewHeight))
        self.myHeadView = headerView
        headerView.phoneNum = modelDic["teacher_phone"] as? String
        headerView.layer.cornerRadius = 2
        headerView.layer.masksToBounds = true

        headerView.gotoTeacherDetail = {
            let detailVC = QFTeacherDetailVC()
            detailVC.fen = String(describing: self.modelDic["teacher_fen"]!)
            detailVC.teacherID = JSON(self.modelDic["teacher_sso_id"] as Any).stringValue
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        headerView.startMessage = {
//            DLog("teacher__")
//            DLog(self.modelDic)
            
            let userModel = RCUserInfo.init()
            userModel.userId = String.noNilStr(str: self.modelDic["teacher_im_userid"])
            userModel.name = String.noNilStr(str: self.modelDic["teacher_realname"])
            if String.noNilStr(str: self.modelDic["teacher_heads"]).isEmpty{
                
            }else{
                userModel.portraitUri = String.noNilStr(str: self.modelDic["teacher_heads"]).appending(imageSuffix)
            }
            
            RCIM.shared().refreshUserInfoCache(userModel, withUserId: userModel.userId)
            
            
            
            let userModel1 = RCUserInfo.init()
            userModel1.userId = UserModel.getUserModel().im_userid
            userModel1.name = UserModel.getUserModel().realname
            if UserModel.getUserModel().avater == nil {
                userModel1.portraitUri = tcp_host+"static/images/userpic.jpg"
            }else{
                userModel1.portraitUri = UserModel.getUserModel().avater?.appending(imageSuffix)
            }
            RCIM.shared().refreshUserInfoCache(userModel1, withUserId: userModel1.userId)
            
            
            
            let talk = SingleChatVC(conversationType: .ConversationType_PRIVATE, targetId:self.modelDic["teacher_im_userid"] as! String )
            talk?.title = (self.modelDic["teacher_realname"] as! String)
            talk?.fen = String(describing: self.modelDic["teacher_fen"]!)
            talk?.teacherId = JSON(self.modelDic["teacher_sso_id"] as Any).stringValue
            self.navigationController?.pushViewController(talk!, animated: true)
            
            
//            imageSuffix
//            teacher_heads
            
        }

        var trueGroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(self.groupModel?.groupid)!)).firstObject() as? GroupModel


        if trueGroupModel != nil {
            DLog("trueGroupModel?.owner_id:"+(self.modelDic["create_sso_id"] as! String)+"    "+UserModel.getUserModel().id!)
            if((self.modelDic["create_sso_id"] as! String) != UserModel.getUserModel().id!){
                headerView.phoneBtn.isHidden = true
                headerView.messageBtn.isHidden = true
            }else{
                headerView.messageBtn.badgeCenterOffset = CGPoint.init(x: 70, y: 0)
                headerView.messageBtn.showBadge(with: .number, value: Int(RCIMClient.shared().getUnreadCount(RCConversationType.ConversationType_PRIVATE, targetId: self.modelDic["teacher_im_userid"] as! String)), animationType: .none)
            }
        }else{
            PublicDataSingle.initData(fail: { (dic) in

            }, success: { (dic) in
                trueGroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(self.groupModel?.groupid)!)).firstObject() as? GroupModel
                if trueGroupModel == nil {
                    self.view.makeToast("获取辅导失败，不能进入")
                    return
                }
                if((self.modelDic["create_sso_id"] as! String) != UserModel.getUserModel().id!){
                    headerView.phoneBtn.isHidden = true
                    headerView.messageBtn.isHidden = true
                }else{
                    headerView.messageBtn.badgeCenterOffset = CGPoint.init(x: 70, y: 0)
                    headerView.messageBtn.showBadge(with: .number, value: Int(RCIMClient.shared().getUnreadCount(RCConversationType.ConversationType_PRIVATE, targetId: self.modelDic["teacher_im_userid"] as! String)), animationType: .none)
                }
            })
        }

        scrollView.addSubview(headerView)
        var tempArr = Array<Dictionary<String,Any>>()
//        let userModel = UserModel.getUserModel()
//        tempArr.append(["id":userModel.id,"imgurl":userModel.avater,"name":userModel.realname])


        if modelDic["user_lists"] is Array<Dictionary<String,Any>>{
            for i  in 0..<(modelDic["user_lists"] as! Array<Dictionary<String,Any>>).count {
                tempArr.append(["id":(modelDic["user_lists"] as! Array<Dictionary<String,Any>>)[i]["sso_id"] as Any,"imgurl":(modelDic["user_lists"] as! Array<Dictionary<String,Any>>)[i]["heads"] as Any,"name":(modelDic["user_lists"] as! Array<Dictionary<String,Any>>)[i]["sso_realname"] as Any])
            }
        }
        self.modelArr = ["时间: " +
            Date.timeIntervalToDateDetailStr(timeInterval: Double(String(describing: modelDic["begintime"]!))!) ,"时长: " + String(describing: modelDic["consult_time_text"]!),"辅导内容: " + String(describing: modelDic["project_name"]!),String(describing: modelDic["consult_status_name"]!),tempArr]
        let tableView = UITableView.init(frame: CGRect.init(x: 15, y: viewMargin + headerView.frame.size.height + viewMargin, width: MAIN_SCREEN_WIDTH - 30, height: scrollView.frame.size.height - (viewMargin + headerView.frame.size.height + viewMargin)))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 0.1))
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.white
        tableView.layer.cornerRadius = 2
        tableView.layer.masksToBounds = true
        scrollView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutIfNeeded()
        tableView.frame = CGRect.init(x: 15, y: viewMargin + headerView.frame.size.height + viewMargin, width: MAIN_SCREEN_WIDTH - 30, height: tableView.contentSize.height)
        scrollView.contentSize = CGSize(width: MAIN_SCREEN_WIDTH, height: tableView.frame.origin.y + tableView.contentSize.height)

        if String(describing: modelDic["cate"]!) != "3" { // 已完成的不能取消和修改
            if String(describing: modelDic["canCancel"]!) == "1" && ((self.modelDic["create_sso_id"] as! String) == UserModel.getUserModel().id!){
                cancleBtn = UIButton.init(frame: CGRect.init(x: 0, y: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight, width: MAIN_SCREEN_WIDTH, height: btnHeight))
                cancleBtn.setTitle("取消", for: .normal)
                cancleBtn.backgroundColor = UIColor.gray
                cancleBtn.addTarget(self, action:  #selector(cancleBtnClick), for: .touchUpInside)
                self.view.addSubview(cancleBtn)
            }
            if String(describing: modelDic["canEdit"]!) == "1"  && ((self.modelDic["create_sso_id"] as! String) == UserModel.getUserModel().id!){
                editBtn = UIButton()
                if cancleBtn != nil {
                    cancleBtn.width = MAIN_SCREEN_WIDTH * 0.5
                    editBtn.frame = CGRect.init(x: MAIN_SCREEN_WIDTH * 0.5, y: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight, width: MAIN_SCREEN_WIDTH * 0.5, height: btnHeight)
                }else{
                    editBtn.frame = CGRect.init(x: 0, y: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight, width: MAIN_SCREEN_WIDTH, height: btnHeight)
                }
                editBtn.setTitle("修改", for: .normal)
                editBtn.backgroundColor = kGreenColor
                editBtn.addTarget(self, action:  #selector(editBtnClick), for: .touchUpInside)
                self.view.addSubview(editBtn)
            }
        }

        if String(describing: modelDic["cate"]!) == "2" || String(describing: modelDic["cate"]!) == "3"{ // 已预约/已完成
            if String(describing: modelDic["isReady"]!) == "1" || String(describing: modelDic["isFinish"]!) == "1"{//预约成功/已完成
                enterBtn = UIButton.init(frame: CGRect.init(x: 0, y: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight, width: MAIN_SCREEN_WIDTH, height: btnHeight))
                enterBtn.setTitle("进入辅导", for: .normal)
                enterBtn.backgroundColor = kGreenColor
                enterBtn.addTarget(self, action:  #selector(enterBtnClick), for: .touchUpInside)
                self.view.addSubview(enterBtn)

            }
            if String(describing: modelDic["cate"]!) == "2"{
                if String(describing: modelDic["isReady"]!) == "1" {//预约成功的有倒计时
                    let timerView = UIView.init(frame: CGRect.init(x: 15, y: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight - timerViewHeight, width: MAIN_SCREEN_WIDTH - 30, height: timerViewHeight + 10))
                    timerView.backgroundColor = UIColor.white
                    timerView.layer.cornerRadius = 2
                    timerView.layer.masksToBounds = true
                    self.view.addSubview(timerView)

                    timerView.snp.makeConstraints { (make) in

                        make.left.equalTo(15)
                        make.right.equalTo(-15)
                        make.height.equalTo(timerViewHeight + 10)
                        make.bottom.equalToSuperview().offset(-btnHeight-10-(TAB_HEIGHT-49))
                    }

                    let titleLb = UILabel.init(frame: CGRect.init(x: 0, y: 5, width: timerView.frame.size.width, height: 25))
                    titleLb.textColor = UIColor.black
                    titleLb.font = kFont_Big
                    titleLb.textAlignment = .center
                    timerView.addSubview(titleLb)

                    let timeLb = UILabel.init(frame: CGRect.init(x: 0, y: 30, width: timerView.frame.size.width, height: timerViewHeight - 5 - 25 * 2))
                    timeLb.textColor = kOrangeColor
                    timeLb.font = UIFont.systemFont(ofSize: 20)
                    timeLb.textAlignment = .center
                    timerView.addSubview(timeLb)

                    let bottomLb = UILabel.init(frame: CGRect.init(x: 0, y: timerViewHeight - 25, width: timerView.frame.size.width, height: 25))
                    bottomLb.textColor = UIColor.gray
                    bottomLb.font = kFont_Middle
                    bottomLb.textAlignment = .center
                    bottomLb.text = "开始前五分钟可进入"
                    timerView.addSubview(bottomLb)

                    if totalTime > 0{
                        titleLb.text = "距离辅导开始还有"
                        if totalTime <= 300 {
                            enterBtn.isHidden = false
                        }else{
                            enterBtn.isHidden = true
                        }
                    }else{
                        titleLb.text = "辅导已开始"
                        bottomLb.isHidden = true
                    }
                    //todo   改bug时候发现timer有问题  时间紧急 暂时简单粗暴解决
                    if timer != nil {

                        timer?.invalidate()
                        timer = nil
                    }
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self](timer) in

                        if String.noNilStr(str: self?.modelDic["real_begintime"]!) == "0"{
                            //导师未进入
                            totalTime -= 1
                            if totalTime > 0{
                                titleLb.text = "距离辅导开始还有"
                                if totalTime <= 300 {
                                    self?.enterBtn.isHidden = false
                                }else{
                                    self?.enterBtn.isHidden = true
                                }

                                let totalTimeTemp = fabs(totalTime)
                                timeLb.text = "\((Int)(totalTimeTemp/(3600 * 24)))天" + "\((Int)(totalTimeTemp.truncatingRemainder(dividingBy: (3600 * 24))/3600))时" + "\((Int)(totalTimeTemp.truncatingRemainder(dividingBy: 3600)/60))分" + "\((Int)(totalTimeTemp.truncatingRemainder(dividingBy: 60)))秒"


                            }else{
                                //QF -- 修改 只针对当前代码块
                                titleLb.text = ""
                                timeLb.text = "导师尚未开始辅导"
                                
                                let beginTime = JSON(self?.modelDic["begintime"] as Any).doubleValue
                                let currentTime = Double(Date().timeIntervalSince1970)
                                bottomLb.text = "十分钟后，可免费取消本次辅导"
                                bottomLb.isHidden = false
                                
                                if currentTime-beginTime > 600{
                                    bottomLb.isHidden = false
                                    if self?.cancleBtn == nil {
                                        self?.cancleBtn = UIButton()
                                        self?.cancleBtn.setTitle("取消", for: .normal)
                                        self?.cancleBtn.backgroundColor = UIColor.gray
                                        self?.cancleBtn.addTarget(self, action:  #selector(self?.cancleBtnClick), for: .touchUpInside)
                                        self?.view.addSubview((self?.cancleBtn)!)
                                    }
                                    self?.view.bringSubview(toFront: (self?.cancleBtn)!)
                                    self?.cancleBtn.frame = CGRect.init(x: MAIN_SCREEN_WIDTH/2, y: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight, width: MAIN_SCREEN_WIDTH/2, height: btnHeight)
                                    self?.enterBtn.frame = CGRect.init(x: 0, y: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - btnHeight, width: MAIN_SCREEN_WIDTH/2, height: btnHeight)
                                    
                                }else{
                                    bottomLb.isHidden = false
                                }
                                
                            }



                        }else{
                           //导师已经进入
                            titleLb.text = "辅导已开始"
                            bottomLb.isHidden = true
                            //导师开始
                            let totalTimeBegin = Double(String(describing: self?.modelDic["real_begintime"] as! String))!-Date().timeIntervalSince1970

                            let totalTimeTempBegin = fabs(totalTimeBegin)


                            timeLb.text = "\((Int)(totalTimeTempBegin/(3600 * 24)))天" + "\((Int)(totalTimeTempBegin.truncatingRemainder(dividingBy: (3600 * 24))/3600))时" + "\((Int)(totalTimeTempBegin.truncatingRemainder(dividingBy: 3600)/60))分" + "\((Int)(totalTimeTempBegin.truncatingRemainder(dividingBy: 60)))秒"

                        }




//                        totalTime -= 1
//                        if totalTime > 0{
//                            titleLb.text = "距离辅导开始还有"
//                            if totalTime <= 300 {
//                                self?.enterBtn.isHidden = false
//                            }else{
//                                self?.enterBtn.isHidden = true
//                            }
//                        }else{
//                            titleLb.text = "辅导已开始"
//                            bottomLb.isHidden = true
//                        }
//                        let totalTimeTemp = fabs(totalTime)
//
//                        if totalTime < 0 {
//                            //返回0 表示导师还没有进入，开始时长是按导师进入的时间为起点
//                            if String.noNilStr(str: self?.modelDic["real_begintime"]!) == "0" {
//                              titleLb.text = ""
//                              timeLb.text = "导师尚未开始辅导"
//                            }else{
//
//                                //导师开始
//                                var totalTimeBegin = Double(String(describing: self?.modelDic["real_begintime"] as! String))!-Date().timeIntervalSince1970
//
//                                 let totalTimeTempBegin = fabs(totalTimeBegin)
//
//
//                                    timeLb.text = "\((Int)(totalTimeTempBegin/(3600 * 24)))天" + "\((Int)(totalTimeTempBegin.truncatingRemainder(dividingBy: (3600 * 24))/3600))时" + "\((Int)(totalTimeTempBegin.truncatingRemainder(dividingBy: 3600)/60))分" + "\((Int)(totalTimeTempBegin.truncatingRemainder(dividingBy: 60)))秒"
//
//
//                            }
//                        }else{
//
//                           timeLb.text = "\((Int)(totalTimeTemp/(3600 * 24)))天" + "\((Int)(totalTimeTemp.truncatingRemainder(dividingBy: (3600 * 24))/3600))时" + "\((Int)(totalTimeTemp.truncatingRemainder(dividingBy: 3600)/60))分" + "\((Int)(totalTimeTemp.truncatingRemainder(dividingBy: 60)))秒"
//                        }
//

                    }
                    RunLoop.current.add(timer!, forMode: .commonModes)
                    timer?.fire()
                }
            }

        }
        if cancleBtn != nil{
            self.view.bringSubview(toFront: cancleBtn)
        }
        if editBtn != nil{
            self.view.bringSubview(toFront: editBtn)
        }
        if enterBtn != nil{
            self.view.bringSubview(toFront: enterBtn)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.modelArr.count - 1{
           
            return ((self.modelArr[indexPath.row] as! Array<Dictionary<String,Any>>).count == 0 ? 0 : CGFloat(((self.modelArr[indexPath.row] as! Array<Dictionary<String,Any>>).count - 1)/5 + 1) * (tableView.frame.size.width/CGFloat(5) + 30)) + 40
        }else{
            return 45
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.modelArr.count - 1{

            let cell = ConsultParticipantCell.init(style: .default, reuseIdentifier: "ConsultParticipantCell")
            cell.model = (self.modelArr[indexPath.row] as! Array<Dictionary<String,Any>>)
            cell.participantClickBlock = ({ [weak self] contactId in
                self?.getContactDetail(contactId: contactId!)
            })
            return cell
        }else{
            let cell = ConsultDetailCell.init(style: .default, reuseIdentifier: "ConsultDetailCell")
            if indexPath.row == self.modelArr.count - 2{
                cell.detailLb.textColor = kOrangeColor
            }else{
                cell.detailLb.textColor = UIColor.black
            }
            cell.model = self.modelArr[indexPath.row] as! String
            return cell

        }
        
    }
    //取消
    @objc func cancleBtnClick(btn:UIButton)  {
        let alert = UIAlertController.init(title: "请注意", message: "您确定要取消此预约么？", preferredStyle: UIAlertControllerStyle.alert, okAndCancel: ("不取消","")) {(action, key) in
        }
        alert.addTextField { (tf1) in
            tf1.placeholder = "取消原因"
        }

        let cancelAction = UIAlertAction(title: "取消预约", style: UIAlertActionStyle.cancel, handler: { (action) in
            PublicMethod.showProgressWithStr(statusStr: "正在取消")
            LoginRequest.getPost(methodName: CONSULT_DEL, params: ["consult_id":self.modelDic["id"]!,"memo":alert.textFields?.first?.text as Any,kToken:UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
                DLog(dic)
                PublicMethod.dismissWithError()
            }, success: {[weak self] (dic) in
                PublicMethod.dismissWithSuccess(str: "取消成功")
                self?.navigationController?.popViewController(animated: true)
            })
        })
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    //修改
    @objc func editBtnClick(btn:UIButton)  {
        let bookVC = BookingTutoringVC()
        bookVC.configAlreadyInfo(model: self.modelDic, mArray: nil)
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    //进入辅导
    fileprivate func gotoThemeChatVC() {
        let tabBarVc : TMTabbarController = TMTabbarController()
        _ = RCIMClient.shared().getConversation(RCConversationType.ConversationType_GROUP, targetId: self.groupModel?.groupid)
//        let model = RCConversationModel.init(conversation: rcc, extend: nil)
////        model.targetId = self.groupModel?.groupid
        
        let model : RCConversationModel = RCConversationModel.init()
        model.targetId = self.groupModel?.groupid
        model.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
        model.conversationTitle = groupModel?.group_name
        model.extend = groupModel?.icon_url
//        model.sentTime = Int64((groupModel?.inputtime)!)!
        model.topCellBackgroundColor = UIColor.hexString(hexString: "DCDCDC")
        model.cellBackgroundColor = UIColor.white
        model.conversationType = RCConversationType.ConversationType_GROUP
        
        tabBarVc.groupModel = model
        tabBarVc.projectId = String.noNilStr(str: (self.groupModel?.project_id)!)
        
        if self.subGroupModel != nil{
//            self.navigationController?.pushViewController(tabBarVc, animated: false)
//
//            tabBarVc.btnClick(tabBarVc.bgImageView.viewWithTag(1001) as! TMTabbarButton)
            let talk = ThemeChatVC(conversationType: .ConversationType_GROUP, targetId: self.subGroupModel?.groupid)
            talk?.projectId = (self.groupModel?.project_id)!
            self.navigationController?.pushViewController(talk!, animated: true)
        }else{
            self.navigationController?.pushViewController(tabBarVc, animated: true)
            
        }
    }
    
    @objc func enterBtnClick(btn:UIButton)  {
        //没有话题的，进入组群
        if self.subGroupModel == nil{
            var trueGroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(self.groupModel?.groupid)!)).firstObject() as? GroupModel
            
            if trueGroupModel != nil {
                gotoThemeChatVC()
            }else{
                PublicDataSingle.initData(fail: { (dic) in
                    
                }, success: { (dic) in
                    trueGroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(self.groupModel?.groupid)!)).firstObject() as? GroupModel
                    if trueGroupModel == nil {
                        self.view.makeToast("获取辅导失败，不能进入")
                       
                        return
                    }
                    self.gotoThemeChatVC()
                })
            }
        }else if self.groupModel != nil{
            var trueGroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(self.groupModel?.groupid)!)).firstObject() as? GroupModel
            var trueGroupModel2 = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(self.subGroupModel?.groupid)!)).firstObject() as? GroupModel
            
            if trueGroupModel != nil && trueGroupModel2 != nil{
                gotoThemeChatVC()
            }else{
                PublicDataSingle.initData(fail: { (dic) in
                
                }, success: { (dic) in
                    trueGroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(self.groupModel?.groupid)!)).firstObject() as? GroupModel
                    trueGroupModel2 = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(self.subGroupModel?.groupid)!)).firstObject() as? GroupModel
                    if trueGroupModel == nil || trueGroupModel2 == nil {
                        self.view.makeToast("获取辅导失败，不能进入")
                        return
                    }
                    self.gotoThemeChatVC()
                })
            }
        }
    }
    
    func clearSubViews(){
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
    }
    
    
    /// 辅导详情
    func tutoringDetail(){
        
        
        var params = Dictionary<String, Any>()
        params["new_consult_id"] = self.new_consult_id!
        params = params.addToken()
        PublicMethod.showProgress()

        LoginRequest.getPost(methodName: "pp.consult.consult_se", params: params, hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()

        }) { [weak self](dic) in
            
            DLog(dic)
            
            PublicMethod.dismiss()
            self?.clearSubViews()
            if dic.keys.contains("data"){
                self?.modelDic = dic["data"] as! Dictionary<String,Any>
            }else{
                self?.modelDic = dic as! Dictionary<String,Any>
            }
            if self?.modelDic["group_info"] is Dictionary<String,Any>{
                let groupModel = GroupModel()
                groupModel.groupid = (self?.modelDic["group_info"] as? Dictionary<String,Any>)!["groupid"] as! String
                groupModel.group_name = (self?.modelDic["group_info"] as? Dictionary<String,Any>)!["group_name"] as! String
                groupModel.is_delete = (self?.modelDic["group_info"] as? Dictionary<String,Any>)!["is_delete"] as! String
                self?.groupModel = groupModel
//                DispatchQueue.main.async {
//                    DataBaseOperation.addData(rlmObject: groupModel)
//                }
            }
//            if self?.modelDic["modelDic"] != nil{
                if self?.modelDic["sub_group_info"] is Dictionary<String,Any>{
                    let groupModel = GroupModel()
                    groupModel.groupid = (self?.modelDic["sub_group_info"] as? Dictionary<String,Any>)!["groupid"] as! String
                    groupModel.group_name = (self?.modelDic["sub_group_info"] as? Dictionary<String,Any>)!["group_name"] as! String
                    groupModel.is_delete = (self?.modelDic["sub_group_info"] as? Dictionary<String,Any>)!["is_delete"] as! String
                    if self?.modelDic["group_info"] is Dictionary<String,Any>{
                        groupModel.parentid = (self?.modelDic["group_info"] as? Dictionary<String,Any>)!["groupid"] as! String
                    }
                    self?.subGroupModel = groupModel
                    
                    //                DispatchQueue.main.async {
                    //                    DataBaseOperation.addData(rlmObject: groupModel)
                    //                }
                }
//            }else{
//                let groupModel = GroupModel()
//                groupModel.groupid = ""
//                groupModel.group_name = ""
//                groupModel.is_delete = ""
//                groupModel.parentid = ""
//                self?.subGroupModel = groupModel
//            }
            DispatchQueue.main.async {
                self?.configUI()
            }
        }
    }

    /// 辅导修改
    func tutoringChange(){
        
        var params = Dictionary<String, Any>()
        params["consult_id"] = ""
        params["teacher_id"] = ""
        params["begintimes"] = ""
        params["consult_minute"] = ""
        params["memo"] = ""
        params["nameLists"] = ""
        
        LoginRequest.getPost(methodName: "sl.project.save_consult", params: params, hadToast: true, fail: { (dic) in
            
        }) { (dic) in
            
        }
    }
    //获取联系人详情
    func getContactDetail(contactId:String) {
        PublicPush().pushToUserInfo(imId: "", userId: contactId, vc: self)
//        PublicMethod.showProgressWithStr(statusStr: "获取联系人信息中...")
//        LoginRequest.getPost(methodName: CONTACT_DETAIL, params: [kToken:UserModel.getUserModel().token as Any,"contact_id":contactId], hadToast: true, fail: { (dic) in
//            PublicMethod.dismissWithError()
//        }) { [weak self](dic) in
//            DLog(dic)
//            PublicMethod.dismiss()
//            let detailVC = ContactDetailVC()
//            detailVC.modelDic = dic
//            self?.navigationController?.pushViewController(detailVC, animated: true)
//        }
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
