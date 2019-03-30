//
//  TutoringVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
class TutoringVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    let consultBtn = UIButton.init(type: .custom)
    var isChange:Bool = false
    var scrollView : UIScrollView!
    var consultingList = Array<Dictionary<String,Any>>()//预约中
    var consultedList = Array<Dictionary<String,Any>>()//已预约
    var finishedList = Array<Dictionary<String,Any>>()//已完成
    let cardView = CardView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 50))
    
    lazy var noDataVIew:UIView = {
        let tableView = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT - TAB_HEIGHT - NAV_HEIGHT))
        tableView.backgroundColor = UIColor.groupTableViewBackground
        let nodataImage = UIImageView.init(image: UIImage(named: "noChatImg"))
        nodataImage.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH - 100, height: nodataImage.frame.height)
//        90  897 × 796
        nodataImage.center = CGPoint(x: tableView.center.x - ((MAIN_SCREEN_WIDTH - 100) / 897 * 40), y: tableView.center.y - 100)
        nodataImage.contentMode = UIViewContentMode.scaleAspectFit
        tableView.addSubview(nodataImage)
        
//        let consultBtn = UIButton.init(frame: CGRect.init(x: 15, y: MAIN_SCREEN_HEIGHT - TAB_HEIGHT - NAV_HEIGHT - 60, width: MAIN_SCREEN_WIDTH - 30, height: 40))
//        consultBtn.backgroundColor = kGreenColor
//        consultBtn.layer.cornerRadius = 5
//        consultBtn.layer.masksToBounds = true
//        consultBtn.setTitleColor(UIColor.white, for: .normal)
//        consultBtn.titleLabel?.font = kFont_Big
//        consultBtn.setTitle("预约新辅导", for: .normal)
//        tableView.addSubview(consultBtn)
//        consultBtn.addTarget(self, action: #selector(consultBtnClicked), for: .touchUpInside)
//
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.noDataVIew.superview != nil) {
            self.noDataVIew.removeFromSuperview()
            self.configData()
        }
        
//        if isChange {
//            self.headerRefresh()
//        }
        
        self.cardView.selectAction(withTag: self.cardView.currentTag())
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "辅导"
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.configUI()
        CoachViewModel.clearCoachKey()
        PublicMethod.showProgressWithStr(statusStr: "获取数据中")
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "coachrefresh"), object: nil, queue: nil) {[weak self] (notif) in
            self?.refresh()
        }
        self.configData()
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchBtn.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchButtonClick(sender:)), for:.touchUpInside)
        let searchItem = UIBarButtonItem.init(customView: searchBtn)
        self.navigationItem.rightBarButtonItem = searchItem
    }
    
    @objc func searchButtonClick(sender:UIButton) {
        let vc = SearchViewController()
        vc.from = 2
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func refresh(){
        CoachViewModel.clearCoachKey()
        if PublicMethod.appCurrentViewController() is TutoringVC {
            self.headerRefresh()
        }
        else{
             isChange = true
        }
        
    }
    
    func configData(){
//        let count = 0
        
        self.getDataWith(type: "2") { [weak self](isSuccess) in
            if self?.consultedList.count != 0 {
                PublicMethod.dismiss()
                
                if (isSuccess){
                    CoachViewModel.saveLastTimeWith(tag: "2")
                }
                self?.cardView.configSelect(with: 11)
                return
            }
            
            self?.getDataWith(type: "1", finishDo: {[weak self] (isSuccess) in
                if self?.consultingList.count != 0 {
                    PublicMethod.dismiss()
                    
                    if (isSuccess){
                        CoachViewModel.saveLastTimeWith(tag: "1")
                    }
//                    DispatchQueue.main.async(execute: {
                        self?.cardView.configSelect(with: 10)
//                    }) 
//                    self?.cardView.configSelect(with: 10)
                    return
                }
                
                self?.getDataWith(type: "3", finishDo: { [weak self](isSuccess) in
                    PublicMethod.dismiss()
                    if (isSuccess){
                        CoachViewModel.saveLastTimeWith(tag: "3")
                    }
                    if self?.finishedList.count != 0 {
                        self?.cardView.configSelect(with: 12)
                        return
                    }
                    else{
                        self?.cardView.configSelect(with: 11)
                        self?.view.addSubview((self?.noDataVIew)!)
                        self?.view.bringSubview(toFront:(self?.consultBtn)!)
                        return
                    }
                })
            })
            
            
        }
    }
    
    
    func configUI(){
        cardView.backgroundColor = kGrayColor_Slapp
        cardView.titleNormalColor = HexColor("85899c")
        cardView.titleSelectColor = UIColor.white
        cardView.bottomLineNormalColor = kGreenColor
        cardView.creatBtns(withTitles: ["预约中","已预约","已完成"])
        
        cardView.btnClickBlock = ({ [weak self](btnTag) in
            switch btnTag {
            case 10:
                self?.tableConsulting.reloadData()
                self?.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            case 11:
                self?.tableConsulted.reloadData()
                self?.scrollView.setContentOffset(CGPoint.init(x: (self?.scrollView.frame.size.width)!, y: 0), animated: true)

            case 12:
                self?.tableFinished.reloadData()
                self?.scrollView.setContentOffset(CGPoint.init(x: (self?.scrollView.frame.size.width)! * 2, y: 0), animated: true)

            default:
                break
            }
            
            if CoachViewModel.isCanGetData(tag: "\(btnTag-9)") {
                
                self?.headerRefresh()
            }
            
            return false
        })
        self.view.addSubview(cardView)
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: cardView.frame.size.height, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT - NAV_HEIGHT - cardView.frame.size.height))
        scrollView.backgroundColor = UIColor.clear

        self.view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.addSubview(self.tableConsulting)
        scrollView.addSubview(self.tableConsulted)
        scrollView.addSubview(self.tableFinished)

        self.tableConsulting.delegate = self
        self.tableConsulting.dataSource = self
        
        self.tableConsulted.delegate = self
        self.tableConsulted.dataSource = self
        
        self.tableFinished.delegate = self
        self.tableFinished.dataSource = self
        
//        let consultBtn = UIButton.init(frame: CGRect.init(x: 15, y: MAIN_SCREEN_HEIGHT - TAB_HEIGHT - NAV_HEIGHT - 60, width: MAIN_SCREEN_WIDTH - 30, height: 40))
        consultBtn.backgroundColor = kGreenColor
        consultBtn.layer.cornerRadius = 5
        consultBtn.layer.masksToBounds = true
        consultBtn.setTitleColor(UIColor.white, for: .normal)
        consultBtn.titleLabel?.font = kFont_Big
        consultBtn.setTitle("预约新辅导", for: .normal)
        self.view.addSubview(consultBtn)
        consultBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-TAB_HEIGHT + 49 - 10)
        }
        consultBtn.addTarget(self, action: #selector(consultBtnClicked), for: .touchUpInside)
    }
    @objc func headerRefresh() {
        switch self.cardView.currentTag() {
        case 10:
            self.getDataWith(type: "1", finishDo: {(isSuccess) in
                if (isSuccess){
                    CoachViewModel.saveLastTimeWith(tag: "1")
                }
                self.tableConsulting.mj_header.endRefreshing()
            })
            
        case 11:
            self.getDataWith(type: "2", finishDo: {(isSuccess) in
                if (isSuccess){
                    CoachViewModel.saveLastTimeWith(tag: "2")
                }
                self.tableConsulted.mj_header.endRefreshing()
            })
        case 12:
            self.getDataWith(type: "3", finishDo: {(isSuccess) in
                if (isSuccess){
                    CoachViewModel.saveLastTimeWith(tag: "3")
                }
                self.tableFinished.mj_header.endRefreshing()
            })
        default:
            break
        }
        
    }
    
    
    
    
    
    func getDataWith(type:String!,finishDo:((Bool)->())?){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CONSULT_LIST, params: ["type":type].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            finishDo?(false)
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            switch type{
            case "1":
                self?.consultingList = dic["list"] as! [Dictionary<String, Any>]
                self?.tableConsulting.reloadData()
            case "2":
                self?.consultedList = dic["list"] as! [Dictionary<String, Any>]
                self?.tableConsulted.reloadData()
            case "3":
                self?.finishedList = dic["list"] as! [Dictionary<String, Any>]
                self?.tableFinished.reloadData()
            default:
                break
            }
            finishDo?(true)
        }
        
    }
    
    
    
    func isHasTime(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: COACHPAY_LIST, params: [:].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            DLog(dic)
            
          let a =  JSON(dic["left_hour_str"]).floatValue
            if a <= 0 {
                PublicMethod.toastWithText(toastText: "您好，您的可预约时长用完了")
                return
            }else{
                
                var per = "0.0"
                let all = JSON(dic["license_minute"] as Any).floatValue
                let left = JSON(dic["left_minute"] as Any).floatValue
                per = JSON(dic["per"]).stringValue
                if all != 0{
                    per = "\(left/all)"
                    
                }
                self?.toMakeAppointment(per:per,left:"\(left)")
            }
        }
        
    }
    
    func toMakeAppointment(per:String,left:String){
        
        
        
        
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CONSULT_PRO_LIST, params: [kToken:UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
            
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
           
            if dic["data"] is Array<Any>{
                var btnDic = Dictionary<String,String>()
                for oneDic in dic["data"] as! Array<Dictionary<String,Any>>{
                    btnDic[oneDic["project_id"]! as! String] = (oneDic["pro_name"] as! String)
                }
                btnDic[kCancel] = "取消"
                let alertCont = UIAlertController.init(title: "选择项目", message: nil, preferredStyle: UIAlertControllerStyle.alert, btns: btnDic, btnActions: {action,key in
                    DLog(key)
                    if key != kCancel{

                        
                        if (self?.noDataVIew.superview != nil) {
                            self?.noDataVIew.removeFromSuperview()
                        }
                        let vc = BookingTutoringVC()
                       
                        
                        let array = JSON(dic["data"]).arrayObject?.filter({ (subdic) -> Bool in
                            return JSON(subdic).dictionaryObject!["project_id"] as! String == key
                        })
                        var mArray = Array<MemberModel>()
                       
                        if (array?.count)! > 0 {
                            let subMarray = JSON(array?.first)["member"].arrayObject
                            if subMarray != nil {
                                for subdic in subMarray! {
                                    let m = MemberModel()
                                    m.head = JSON(subdic)["head"].stringValue
                                    m.id = JSON(subdic)["userid"].stringValue
                                    m.name = JSON(subdic)["realname"].stringValue
                                    mArray.append(m)
                                }
                            }
                            
                        }
                        
                        let model = ["projectId":key,"project_name":btnDic[key],"percentage":per,"left_minute":left]
                        vc.configAlreadyInfo(model: model, mArray: mArray)
                        self?.navigationController?.pushViewController(vc, animated: true)
                       
                        
//                        DLog(1)
//                        let viewC2 = SLViewController.init()
//                        viewC2.setCookie()
//                        viewC2.webView.loadRequest(URLRequest.init(url:url!))
//
//                        viewC2.func_cancelModify = {
//                            self.navigationController?.isNavigationBarHidden = false
//                            self.navigationController?.popToRootViewController(animated: false)
//                        }
//                        viewC2.func_createSuccess = {[weak self] consultId in
//                            //            PublicMethod.dismissWithSuccess(str: "修改已提交")
//                            //详情
//                            self?.isChange = true
//
//                            let vc = TutoringDetailVC()
//                            vc.new_consult_id = consultId
//                            (sharePublicDataSingle.publicTabbar?.childViewControllers[2] as! BaseNavigationController).pushViewController(vc, animated: false)
//                        }
//                        viewC2.tabBarController?.tabBar.isHidden = true
//                        self.navigationController?.pushViewController(viewC2, animated: true)
                    }
                    
                })
                self?.present(alertCont, animated: true, completion: nil)
            }
        }
    
    }
    //预约新辅导
    @objc func consultBtnClicked(btn:UIButton){
        self.isHasTime()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == tableConsulting{
            return self.consultingList.count
            
        }else if tableView == tableConsulted{
            return self.consultedList.count
        }else{
            return self.finishedList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIde = "ConsultListCell"
        var cell:ConsultListCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ConsultListCell
        if cell==nil {
            cell = ConsultListCell.init(style: .default, reuseIdentifier: cellIde)
        }
        if tableView == tableConsulting{
            cell?.model = self.consultingList[indexPath.row]
            
        }else if tableView == tableConsulted{
            cell?.model = self.consultedList[indexPath.row]
            
        }else{
            cell?.model = self.finishedList[indexPath.row]
            
        }
       
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let clearView = UIView()
        clearView.backgroundColor = .clear
        return clearView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TutoringDetailVC()
        if tableView == tableConsulting{
            tableConsulting.deselectRow(at: indexPath, animated: true)
           let dic = self.consultingList[indexPath.row]
            vc.new_consult_id = dic["id"] as! String
            
        }else if tableView == tableConsulted{
            tableConsulted.deselectRow(at: indexPath, animated: true)
            let dic =  self.consultedList[indexPath.row]
            vc.new_consult_id = dic["id"] as! String
        }else{
            tableFinished.deselectRow(at: indexPath, animated: true)
            let dic =  self.finishedList[indexPath.row]
            vc.new_consult_id = dic["id"] as! String
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var tableConsulting:UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:#selector(headerRefresh))
        return tableView
    }()
    
    lazy var tableConsulted:UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:#selector(headerRefresh))
        return tableView
    }()
    
    lazy var tableFinished:UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: scrollView.frame.size.width * 2, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:#selector(headerRefresh))
        return tableView
    }()
    
    
    
    /// 预约状态的优先级显示
    func configTag(){
        //1-0-2
        if consultedList.count > 0 {
            //已预约
            self.cardView.selectAction(withTag: 10)
        }else if consultingList.count > 0{
            //预约中
            self.cardView.selectAction(withTag: 11)
        }else if finishedList.count > 0{
            //已完成
            self.cardView.selectAction(withTag: 12)
        }else{
            //预约中
            self.cardView.selectAction(withTag: 10)
        }
        

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
