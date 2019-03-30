//
//  PersonalCenterVC.swift
//  SLAPP
//
//  Created by apple on 2018/6/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class PersonalCenterVC: BaseVC,UITableViewDelegate,UITableViewDataSource,QFFunnelViewDelegate{

    var tcpUserid = ""
    var userId = ""
    
    var proNum:Double = 0
    var amount:Double = 0
    var dmount:Double = 0
     let header = PersonalHeaderView.init(frame: CGRect(x: 10, y: 0, width: kScreenW-20, height: 50))
    var model:PersonalModel = PersonalModel()
    var dataArray:Array<Dictionary<String,Any>> = Array()
    var infoModel:Dictionary<String,Any>?
    var is_Address = 0 //1 通讯录入口 0 默认  2个人中心进入
    //阶段信息
    
    var rightHeader:QFFunnelView = QFFunnelView.init(frame: CGRect(x: 15, y:0, width: MAIN_SCREEN_WIDTH-30, height:(MAIN_SCREEN_WIDTH-60-30-15)/1000*867+30+30))
    var funnel:Array<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"
        if is_Address != 0 {
         self.title = "个人资料"
        }
         self.configUI()
         self.congfigData()
    }
    
    
    
    func congfigData(){
        
        var params = Dictionary<String,Any>()
        if userId != "" {
            params["personal_userid"] = userId
        }
        if tcpUserid != "" {
            params["tcp_userid"] = tcpUserid
        }
        print("*** params = \(params)")
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PERSONAL_INDEX, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            DLog(dic)
            
            if let adic = dic["pro_funnel_list"] as? Array<Any> {
                self?.funnel = adic
            }
            
            if let model = PersonalModel.deserialize(from: dic){
                self?.model = model
                self?.refreshUI()
            }
        }
        
        
        if is_Address == 2 {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            btn.sizeToFit()
            btn.setTitle("修改", for: .normal)
            btn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
            let barButtonItem = UIBarButtonItem.init(customView: btn)
            self.navigationItem.rightBarButtonItem = barButtonItem

        }
    }
    @objc func editBtnClick() {
        let personVC = PersonalInfoVC()
        personVC.infoModel = infoModel
        self.navigationController?.pushViewController(personVC, animated: true)
        
    }
    
    func refreshUI(){
        
        //个人信息
        top.configWithData(model: model.member, pModel: model.performance_completion_rate, auth: model.auth)
        
        
       
        
            let chartData = self.model.getMapArray()
            let max = chartData.1.max()
            self.topChart.titleLabel.text = "完成率"
            self.topChart.bottomLabel.text = "月"
            if chartData.0.count > 0 {
                //折线图
                DLog(max)
                DLog("kkkkkkkkkkkkkkk")
                self.topChart.dataArrOfY = self.configMarkY(max:Int(max!))
                self.topChart.dataArrOfX = chartData.0
                self.topChart.dataArrOfPoint = chartData.1
            }
        
        
        if self.model.auth == "0" {
            backScroll.frame = CGRect(x: 0, y: 230, width: SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-310)
        }
        
        
        
        
        self.tableLeft.reloadData()
        
        
        
        if self.model.auth == "0" || self.model.pro_funnel_list.count == 0 {
            //没有权限查看
            return
        }
      
        
//        self.funnelView = [[QFFunnelView alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth-30, (kScreenWidth-60-30-15)/1000*867+30+30)];
//        self.funnelView.delegate = self;
        
//        let rightHeader = QFFunnelView.init(frame: CGRect(x: 15, y:0, width: MAIN_SCREEN_WIDTH-30, height:(MAIN_SCREEN_WIDTH-60-30-15)/1000*867+30+30))
        rightHeader.delegate = self;

        
        rightHeader.funnelDataArray(self.funnel)
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: (MAIN_SCREEN_WIDTH-60-30-15)/1000*867+30+30))
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(rightHeader)
        
        self.tableRight.tableHeaderView = view
        
        
        
//        rightHeader.click = {[weak self](selectArray) in
//
//            self?.dataArray.removeAll()
//
//           let sortSelect = selectArray.sorted(by: < )
//            self?.proNum = 0
//            self?.amount = 0
//            self?.dmount = 0
//            for s in sortSelect {
//                let m = self?.model.pro_funnel_list[s]
//                self?.dataArray += m!.list
//                self?.proNum += (m?.pro_num)!
//                self?.amount += (m?.amount)!
//                self?.dmount += (m?.down_payment)!
//            }
//            self?.refreshHeader()
//            self?.tableRight.reloadData()
//        }
//
    }
    
    

    func configUI(){
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(top)
        self.view.addSubview(backScroll)
        backScroll.backgroundColor = UIColor.groupTableViewBackground
        backScroll.addSubview(tableLeft)
        backScroll.addSubview(tableRight)
        
        tableLeft.register(PersonalResultsCell.self, forCellReuseIdentifier: "leftCell")
        tableLeft.estimatedRowHeight = 75
        tableLeft.rowHeight = UITableViewAutomaticDimension
        
        
        tableLeft.delegate = self
        tableLeft.dataSource = self
        tableRight.delegate = self
        tableRight.dataSource = self
        
        
        tableLeft.tableHeaderView = self.topChart
    
        top.btnClickBlock = {[weak self](tag) in
//            tag 0 业绩   1项目
            self?.backScrolltoScroll(tag: tag)
        }
        
        top.clickChat = {[weak self] in
            
            
            let userModel = RCUserInfo.init()
            userModel.userId = self?.model.member.im_userid
            userModel.name = self?.model.member.realname
            if !(self?.model.member.head.isEmpty)!{
                userModel.portraitUri = self?.model.member.head.appending(imageSuffix)
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
            
            
            
            
            let talk = SingleChatVC(conversationType: .ConversationType_PRIVATE, targetId:self?.model.member.im_userid )
            talk?.title = self?.model.member.realname
            self?.navigationController?.pushViewController(talk!, animated: true)
        }
    
    }
    
    
    
    

    /// 滑动到scroll到指定位置
    ///
    /// - Parameter tag: tag 0 业绩   1项目
    func backScrolltoScroll(tag:Int){
        backScroll.setContentOffset(CGPoint.init(x: SCREEN_WIDTH*CGFloat(tag), y: 0), animated: true)
    }
    
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableRight {
            return 100
        }
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableRight {
            return 1
        }
        return 2
    }
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView == tableLeft {
//            return nil
//        }
//
//        if self.model.auth == "0" || self.model.pro_funnel_list.count == 0 {
//            //没有权限查看
//            return nil
//        }
//
//        self.refreshHeader()
//        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 50))
//        view.addSubview(header)
//        return view
//    }
    
//    func refreshHeader(){
//
//        header.leftLable.text = String.init(format: "项目数：%.0f", self.proNum)
//        header.centerLable.text = String.init(format: "合同额：%.1f万", self.amount)
//        header.rightLable.text = String.init(format: "回款额：%.1f万", self.dmount)
//    }
    
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if tableView == tableLeft {
//            return 0
//        }
//
//        if self.model.auth == "0" || self.model.pro_funnel_list.count == 0 {
//            //没有权限查看
//            return 0
//        }
//
//        return 50
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableRight {
            return self.dataArray.count
        }
        
        if self.model.auth == "0" {
            return 0
        }
        
        return  self.model.results_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableRight {
            var cell = tableView.dequeueReusableCell(withIdentifier: "HYProjectCell")
            if cell == nil {
                cell = Bundle.main.loadNibNamed("HYProjectCell", owner: self, options: [:])?.last as! HYProjectCell
            }
            (cell as! HYProjectCell).setViewModelWithDictWithDict(self.dataArray[indexPath.row])
            return cell!
        }
        else{
            let cellIde = "leftCell"
            let cell:PersonalResultsCell = tableView.dequeueReusableCell(withIdentifier: cellIde, for: indexPath) as! PersonalResultsCell
            cell.topLine.isHidden = indexPath.row == 0
            cell.model = self.model.results_list[indexPath.row]
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == tableRight {
            
            let pModel = self.dataArray[indexPath.row]
            
            PublicMethod.showProgress()
            LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":pModel["id"]].addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismissWithError()
            }) { [weak self](dic) in
                
                PublicMethod.dismiss()
                if let model = ProjectSituationModel.deserialize(from: dic){
                    let tab = ProjectSituationTabVC()
                    tab.model = model; self?.navigationController?.pushViewController(tab, animated: true)
                }
            }
        }
        
    }
    
    lazy var tableLeft = { () -> UITableView in
        let table  = UITableView()
        table.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-280)
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        return table
    }()
    
    lazy var tableRight = { () -> UITableView in
        let table  = UITableView()
        table.tableFooterView = UIView()
        table.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-280)
        table.backgroundColor = UIColor.groupTableViewBackground
        return table
    }()
    
    
    
    
    

    /// 纵坐标标量
    ///
    /// - Parameter max: <#max description#>
    /// - Returns: <#return value description#>
    func configMarkY(max:Int)->( [String]){
        let yMax =  (max/10)*10 + 10
        var array = Array<String>()
        let ySpace = yMax/5
        for i in 0...5 {
            array.append("\(0+(5-i)*ySpace)")
        }
        return array
    }
    
    func qf_funnelViewDataChange() {
        
        
        self.dataArray.removeAll()
        self.dataArray = self.rightHeader.selectArray as! Array<Dictionary<String, Any>>;
        self.tableRight.reloadData()

        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//   个人信息
    lazy var top = { () -> PersonalCenterTopView in
        let s = PersonalCenterTopView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 280))
        return s
    }()
    
    
    lazy var backScroll = { () -> UIScrollView in
        let s = UIScrollView.init(frame: CGRect(x: 0, y: 280, width: SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-280))
        s.isScrollEnabled = false
        s.contentSize = CGSize.init(width: SCREEN_WIDTH*2, height: 0)
        return s
    }()
    
    lazy var topChart = { () -> HomeLineChartView in
        let s = HomeLineChartView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-20, height: 230))
        return s
    }()
    

}
