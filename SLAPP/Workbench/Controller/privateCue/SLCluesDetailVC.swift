//
//  SLCluesDetailVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/4.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

enum WhichPool {
    case privatePool
    case publicPool
}

var SLHeadViewHeight:CGFloat = 0

class SLCluesDetailVC: BaseVC,UITableViewDelegate,UITableViewDataSource,BtnClick,UIScrollViewDelegate,LCActionSheetDelegate,UITextViewDelegate {
    
    var imageScView:UIScrollView!
    
    var cluesModel: SLCluesModel?
    
    var pool: WhichPool?
    /**线索id*/
    var cluesID:String?
    /**客户id*/
    var clientID:String?
    
    var frm:CGRect?
    
    var json: [String : JSON]?
    
    let scrollView = UIScrollView()
    
    var headModel:SLCDHeadModel?
    var basicDic:[String:Any]?
    var sysDic:[String:Any]?
    /**跟踪记录数据源*/
    var followArr = [SLFollowUpModel]()
    /**相关信息数据源*/
    var releArr = [SLReleInfoModel]()
    /**标识-公海还是私海*/
    var markStr:String?
    /**回调-权限操作之后返回公海池刷新列表*/
    typealias FreshList = (Bool) -> Void
    var fresh: FreshList?
    
    let textView = UITextView()
    
    var section:Int?
    var row:Int?
    var style:String?
    
    let headNewView = SLCluesDetailsHeadView()
    
    var isFromEdit:Bool?
    /**标识从回收站进来*/
    var fordName:String?
    /**公海分配id*/
    var allotsID:String?
    /**该线索是否是自己负责 0不是  1是*/
    var saveAuth:Int = 0
    var backWindow:UIWindow?
    
    var infoDic = [String:String]()
    
    var isFromSearch:String?
    
    lazy var displayLabel = UILabel()
    
    var disCount:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "线索详情"
        self.view.backgroundColor = UIColor.white
        
        let cancelBtn = UIButton.init(type: UIButtonType.custom)
        cancelBtn.setImage(image("icon-arrow-left"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(popVC), for: UIControlEvents.touchUpInside)
        let cancelItem = UIBarButtonItem.init(customView: cancelBtn)
        self.navigationItem.leftBarButtonItem = cancelItem
        /**请求线索详情*/
        self.requestData()
        /**跟进记录*/
        self.requestRecords()
        /**请求相关信息*/
        self.requestRelevantInfo()
        
        
        weak var weakSelf = self
        /**监听跟进记录修改*/
        NotificationCenter.default.addObserver(weakSelf as Any, selector: #selector(editFollowUp), name: NSNotification.Name("edit"), object: nil)
        NotificationCenter.default.addObserver(weakSelf as Any, selector: #selector(lookBigImage), name: NSNotification.Name("imgCliked"), object: nil)
        
        /**监听键盘弹出收回*/
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text=="" || textView.text==nil {
            return
        }
        if style == "comments" {
            self.insertCommentText(textView.text,section!)
        }else if style == "reply" {
            self.replyInfo(section: section!, row: row!, content: textView.text)
        }
    }
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let value = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect = value.cgRectValue
        self.textView.frame = CGRect(x: 0, y: SCREEN_HEIGHT-keyboardRect.size.height, width: SCREEN_WIDTH, height: 50)
        
    }
    @objc func keyboardWillHide(notification: Notification) {
        self.textView.removeFromSuperview()
    }
    //MARK: - 返回
    @objc func popVC() {
        
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
        if isFromSearch == "search"{
            for vc in (self.navigationController?.childViewControllers)!{
                if vc.isKind(of: SLMyCluesVC.self){
                    self.navigationController?.popToViewController(vc, animated: true)
                    
                }
            }
            
            
        }else{
            self.navigationController?.popViewController(animated: true)
            
        }
        if self.isFromEdit == true{
            self.fresh!(true)
        }
        
        
    }
    //MARK: - 跳转到编辑跟踪记录界面
    @objc func editFollowUp(notice: Notification) {
        
        let dic = notice.userInfo as! [String:Int]
        let section = dic["section"]
        let modelt = self.followArr[section!]
        
        let evc = AddCustomerFollowUpVC()
        evc.needRefresh = {
            self.followArr.removeAll()
            self.requestRecords()
        }
        evc.type = .clues
        evc.cluesID = self.cluesID!
        evc.fo_id = modelt.id
        let model = SDTimeLineCellModel()
        
        model.msgContent = String.base64Decode(str: modelt.encode_note ?? "")
        model.contactnames = ""
        model.contactids = ""
        var markString = ""
        for (index,objc) in (modelt.class_list ?? []).enumerated(){
            evc.tagList.append(objc.id!)
            if index==0{
                markString = markString+"\(objc.name ?? "")"
            }else{
                markString = markString+"、\(objc.name ?? "")"
            }
            
        }
        
        evc.category.tagsString = markString
        var arr = [Dictionary<String, Any>]()
        for objc in modelt.filesArr {
            var dict = [String:String]()
            dict["preview_url_small"] = objc.preview_url_small
            dict["preview_url"] = objc.preview_url
            arr.append(dict)
        }
        model.picNamesArray = arr as [Any]
        evc.model = model
        
        self.navigationController?.pushViewController(evc, animated: true)
        
    }
    //MARK: - 查看大图
    @objc func lookBigImage(notice: Notification) {
        let dicInfo = notice.userInfo as! [String:Int]
        let sec = dicInfo["sec"]
        let whichOne = dicInfo["whichOne"]
        let model = self.followArr[sec!]
        let imgArr = model.filesArr
        /**显示指示器用*/
        disCount = imgArr.count
        
        imageScView = UIScrollView.init()
        imageScView.delegate = self
        imageScView.tag = 777
        imageScView.backgroundColor = .clear
        imageScView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        imageScView.contentSize = CGSize(width: SCREEN_WIDTH*CGFloat(imgArr.count), height: SCREEN_HEIGHT)
        imageScView.isPagingEnabled = true
        imageScView.contentOffset = CGPoint(x: SCREEN_WIDTH*CGFloat(whichOne!), y: 0)
        let tap = UITapGestureRecognizer.init()
        tap.addTarget(self, action: #selector(exitMode))
        imageScView.addGestureRecognizer(tap)
        
        for (index,objc) in imgArr.enumerated() {
            let imageView = UIImageView.init()
            imageView.frame = CGRect(x: SCREEN_WIDTH*CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            imageView.tag = index
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            // imageView.isUserInteractionEnabled = true
            let url = URL.init(string: objc.preview_url ?? "")
            imageView.sd_setImage(with: url, completed: nil)
            imageScView.addSubview(imageView)
            imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.setAnimationDuration(0.3)
            imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.commitAnimations()
        }
        //        let bgView = UIView()
        //        bgView.backgroundColor = .clear
        //        bgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        //
        //        self.backWindow.addSubview(bgView)
        backWindow = UIWindow.init(frame: UIScreen.main.bounds)
        backWindow?.backgroundColor = RGBA(R: 0, G: 0, B: 0, A: 1)
        backWindow?.isHidden = false
        backWindow?.windowLevel = UIWindowLevelAlert
        backWindow?.addSubview(imageScView)
        
        
        let disStr = NSString.init(format:  "%d  /  %d", (whichOne!+1),disCount)
        displayLabel.text = disStr as String
        displayLabel.textColor = .white
        displayLabel.font = UIFont.boldSystemFont(ofSize: 20)
        backWindow?.addSubview(displayLabel)
        displayLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
        }
    }
    
    //    lazy var backWindow: UIWindow = {
    //        let backWindow = UIWindow.init(frame: UIScreen.main.bounds)
    //        backWindow.backgroundColor = RGBA(R: 0, G: 0, B: 0, A: 0.5)
    //        backWindow.isHidden = false
    //        backWindow.windowLevel = UIWindowLevelAlert
    //        return backWindow
    //    }()
    //MARK: - 退出浏览
    @objc func exitMode(ges: UITapGestureRecognizer) {
        
        backWindow?.isHidden = true
        backWindow?.removeFromSuperview()
        
    }
    //MARK: - scrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 777{
            let count = Int(scrollView.contentOffset.x/SCREEN_WIDTH)
            let disStr = NSString.init(format:  "%d  /  %d", (count+1),disCount)
            self.displayLabel.text = disStr as String
        }
        
    }
    //MARK: - 头部文件
    func headView() -> SLCluesDetailsHeadView {
        
        
        headNewView.name.text = headModel?.name
        headNewView.company.text = "公司："+(headModel?.corp_name ?? "")!
        headNewView.state.text = "状态："+(headModel?.status ?? "")!
        headNewView.belong.text = "所属："+(headModel?.gonghai_category ?? "")!
        headNewView.businessCard.image = UIImage()
        var style = WhichPool.privatePool
        style = pool!
        switch style {
        case .privatePool:
            
            headNewView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 210)
            headNewView.timeLimit.text = "时限："
            headNewView.responsible.text = "负责：\(self.sysDic!["realname"] ?? "")"
            headNewView.fromSource.text = "来源：\(self.basicDic!["source_name"] ?? "")"
            SLHeadViewHeight = 210
        case .publicPool:
            headNewView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 140)
            SLHeadViewHeight = 140
        }
        self.frm = headNewView.frame
        return headNewView
    }
    /**懒加载tableview*/
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
        tableView.tableHeaderView = self.headView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0
        tableView.tag = 111
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, SAFE_HEIGHT+50, 0))
        })
        return tableView
    }()
    //MARK: - 底部选项卡
    func addTabView() {
        var titles = [String]()
        var style = WhichPool.privatePool
        style = pool!
        switch style {
        case .privatePool:
            if  saveAuth == 1 {
                titles = ["添加跟进","状态","分组","更多"]
            }else{
                titles = ["添加跟进","更多"]
            }
            
        case .publicPool:
            if fordName == "回收站"{
                titles = ["恢复"]
            }else{
                titles = ["更多"]
            }
            
        }
        
        let tabView = SLCluesBottomView.init(frame: CGRect.zero, titleArray: titles)
        tabView.delegate = self
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-SAFE_HEIGHT)
            make.height.equalTo(50)
        }
    }
    
    /**头部个数*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /**头部高度*/
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    /**头部视图*/
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = SLCluesDetailSegView()
        /**点击选项卡切换界面*/
        headView.moveTableView = {(tag: Int) in
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: SCREEN_WIDTH*CGFloat(tag), y: 0)
            })
            switch tag {
            case 1:
                if self.followArr.count == 0 {
                    self.toast(withText: "暂无跟进记录", andDruation: 1.5)
                }
            case 2:
                if self.releTableView.dataArr.count == 0 {
                    self.toast(withText: "暂无相关信息", andDruation: 1.5)
                }
            default: break
                
            }
            
        }
        return headView
    }
    /**每个头部下的行数*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    /**行高*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return SCREEN_HEIGHT-NAV_HEIGHT-SAFE_HEIGHT-50-50
    }
    /**返回cell*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NAV_HEIGHT-SAFE_HEIGHT-50)
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH*3, height: 0)
        cell.contentView.addSubview(scrollView)
        scrollView.addSubview(self.cluesTableView)
        scrollView.addSubview(self.frTableView)
        scrollView.addSubview(self.releTableView)
        return cell
        
    }
    //MARK: - 线索详情
    lazy var cluesTableView: SLCDCluesTableView = {
        let cluesTableView = SLCDCluesTableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NAV_HEIGHT-SAFE_HEIGHT-50-50), style: UITableViewStyle.grouped)
        cluesTableView.bounces = false
        cluesTableView.pool = self.pool
        cluesTableView.ofSet = {(ofSetY) in
            if ofSetY>=0 {
                self.tableView.contentOffset.y = ofSetY
            }else{
                self.headView().frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SLHeadViewHeight)
            }
        }
        return cluesTableView
    }()
    
    //MARK: - 跟踪记录
    lazy var frTableView: SLGZTableView = {
        let frTableView = SLGZTableView.init(frame: CGRect(x:  SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NAV_HEIGHT-SAFE_HEIGHT-50-50), style: UITableViewStyle.grouped)
        frTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.followArr.removeAll()
            self.requestRecords()
        })
        frTableView.popTextView = { (section,row,style) in
            self.section = section
            self.row = row
            self.style = style
            self.textView.becomeFirstResponder()
            self.textView.delegate = self
            self.textView.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
            self.textView.font = FONT_16
            self.textView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 50)
            self.view.addSubview(self.textView)
        }
        frTableView.bounces = true
        frTableView.ofSet = {(ofSetY) in
            if ofSetY>=0 {
                self.tableView.contentOffset.y = ofSetY
            }else{
                self.headView().frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SLHeadViewHeight)
            }
        }
        return frTableView
    }()
    /**相关消息*/
    lazy var releTableView: SLReleInfoTableView = {
        let releTableView = SLReleInfoTableView.init(frame: CGRect(x: SCREEN_WIDTH*2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NAV_HEIGHT-SAFE_HEIGHT-50-50), style: UITableViewStyle.plain)
        return releTableView
    }()
    
    //MARK: - 编辑
    @objc func edit(){
        let cvc = SLCreateCluesVC()
        let dic = self.cluesTableView.getEditPara()
        cvc.infoDic = dic
        //cvc.infoDic["性别"] = self.basicDic?["sex"] as? String
        cvc.cluesID = self.cluesID
        cvc.operation = .edit
        cvc.fresh = { isFresh in
            self.isFromEdit = isFresh
            self.requestData()
        }
        self.navigationController?.pushViewController(cvc, animated: true)
    }
    //MARK: - 回复信息
    func replyInfo(section: Int,row: Int,content: String) {
        let model = self.frTableView.dataArr[section]
        let commentsModel = model.comments![row]
        /**参数*/
        self.showProgress(withStr: "正在加载中...")
        var parameters = [String:String]()
        parameters["fo_id"] = model.id
        parameters["to_userid"] = commentsModel.create_userid
        parameters["comment_id"] = commentsModel.id
        parameters["content"] = content
        //        let ecContent = SLStringFunc.stringUTF8(withStr: content)
        //        parameters["encode_content"] = ecContent
        print("参数\(parameters)")
        LoginRequest.getPost(methodName: "pp.followup.reply_add", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.showDismiss()
            print("护肤\(dataDic)")
            if let json = JSON(dataDic).dictionaryObject {
                
                let code = json["status"] as! Int
                if code == 1 {
                    let userModel = UserModel.getUserModel()
                    let addModel = SLCommentsModel.init()
                    addModel.is_me = 1
                    addModel.id = json["data"] as? String
                    addModel.create_realname = userModel.realname
                    addModel.create_userid = userModel.id
                    addModel.content = content
                    addModel.to_realname = commentsModel.create_realname
                    addModel.to_userid = commentsModel.create_userid
                    model.comments?.append(addModel)
                    self.frTableView.reloadSections(IndexSet.init(integer: section), with: UITableViewRowAnimation.fade)
                }
                
            }
            
            
        }
    }
    //MARK: - 请求基本信息
    func requestData() {
        /**参数*/
        self.showProgress(withStr: "正在加载中...")
        var parameters = [String:String]()
        parameters["clue_id"] = self.cluesID
        LoginRequest.getPost(methodName: "pp.clue.detail", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.showDismiss()
            
            if let json = JSON(dataDic).dictionary{
                if let head = json["head"]?.dictionary{
                    self.headModel = SLCDHeadModel.deserialize(from: head)
                }
                if let basic = json["detail"]!["basic"].dictionaryObject{
                    self.basicDic = basic
                    self.cluesTableView.basicDic = self.basicDic!
                    
                }
                if let sys = json["detail"]!["system"].dictionaryObject{
                    self.sysDic = sys
                    self.cluesTableView.sysDic = self.sysDic!
                }
                if let auth = json["jurisdiction"]!["save_clue"].int{
                    self.saveAuth = auth
                }
                
            }
            
            /**添加tableview*/
            self.tableView.reloadData()
            if self.isFromEdit == true {
                self.tableView.tableHeaderView = self.headView()
                self.cluesTableView.reloadData()
            }
            if self.fordName != "回收站" && self.saveAuth == 1{
                /**右导航按钮-编辑*/
                let barBtn = UIBarButtonItem.init(title: "编辑", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.edit))
                self.navigationItem.rightBarButtonItem = barBtn
            }else{
                self.navigationItem.rightBarButtonItem = nil
            }
            /**添加底部选项卡*/
            self.addTabView()
            
            
        }
    }
    //MARK: - 跟进记录
    func requestRecords(){
        self.showProgress(withStr: "正在加载中...")
        var parameters = [String:String]()
        parameters["id"] = self.cluesID
        LoginRequest.getPost(methodName: "pp.clue.get_followup", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.showDismiss()
            self.frTableView.mj_header.endRefreshing()
            if let json = JSON(dataDic).dictionary,let array = json["list"]?.arrayObject{
                self.followArr = [SLFollowUpModel].deserialize(from: array) as! [SLFollowUpModel]
                for objc in self.followArr{
                    let jsonStr = objc.files
                    if jsonStr != ""{
                        let fileArray = LoginRequest.makeJsonWithString(jsonStr: jsonStr!) as! [Any]
                        objc.filesArr = [SLFlollowUpFileModel].deserialize(from: fileArray) as! [SLFlollowUpFileModel]
                    }
                }
            }
            self.frTableView.dataArr = self.followArr
            self.frTableView.reloadData()
            
        }
    }
    //MARK: - 请求相关信息
    func requestRelevantInfo(){
        self.showProgress(withStr: "正在加载中...")
        var parameters = [String:String]()
        parameters["clue_id"] = self.cluesID
        LoginRequest.getPost(methodName: "pp.clue.relation_info", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.showDismiss()
            print("信息\(dataDic)")
            if let json = JSON(dataDic).dictionary,let arr = json["logs"]?.arrayObject {
                self.releArr = [SLReleInfoModel].deserialize(from: arr) as! [SLReleInfoModel]
            }
            self.releTableView.dataArr = self.releArr
            self.releTableView.reloadData()
            
        }
    }
    //MARK: - 点击选项卡
    @objc func btnClicked(tag: Int) {
        var style = WhichPool.privatePool
        style = pool!
        switch style {
        case .privatePool:
            if self.saveAuth==1{
                if tag==0 {
                    let avc = AddCustomerFollowUpVC()
                    avc.cluesID = self.cluesID ?? ""
                    avc.configType(t: 3)
                    avc.needRefresh = {
                        self.followArr.removeAll()
                        self.requestRecords()
                    }
                    self.navigationController?.pushViewController(avc, animated: true)
                }else if(tag==1){
                    let sheetView = LCActionSheet.init(title: "操作选项", buttonTitles: ["未跟进","已联系","无效信息"], redButtonIndex: -1, delegate: self)
                    sheetView?.tag = 666
                    sheetView?.show()
                }else if(tag==2){
                    let cvc = SLCluesGroupVC()
                    cvc.cluesID = self.cluesID
                    let nvc = UINavigationController.init(rootViewController: cvc)
                    self.present(nvc, animated: true, completion: nil)
                }else if(tag==3){
                    let sheetView = LCActionSheet.init(title: "操作选项", buttonTitles: ["线索转化","更换负责人","退回公海"], redButtonIndex: -1, delegate: self)
                    sheetView?.tag = 999
                    sheetView?.show()
                }
            }else{
                if tag==0 {
                    let avc = AddCustomerFollowUpVC()
                    avc.cluesID = self.cluesID ?? ""
                    avc.configType(t: 3)
                    avc.needRefresh = {
                        self.followArr.removeAll()
                        self.requestRecords()
                    }
                    self.navigationController?.pushViewController(avc, animated: true)
                }else if(tag==1){
                    let sheetView = LCActionSheet.init(title: "操作选项", buttonTitles: ["更换负责人"], redButtonIndex: -1, delegate: self)
                    sheetView?.tag = 333
                    sheetView?.show()
                }
            }
            
            
            break
            
        case .publicPool:
            
            if fordName == "回收站"{
                self.showProgress(withStr: "正在恢复中...")
                /**参数*/
                var parameters = [String:String]()
                parameters["id"] = self.cluesID
                
                LoginRequest.getPost(methodName: "pp.clue.clue_recover", params: parameters.addToken(), hadToast: true, fail: { (error) in
                    print(error)
                    
                }) { (dataDic) in
                    print("结果\(dataDic)")
                    self.showDismiss()
                    let status = dataDic["status"] as! Int
                    if  status==1 {
                        self.toast(withText: dataDic["msg"] as? String, andDruation: 1.5)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                            self.fresh!(true)
                            self.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self.toast(withText: "恢复失败", andDruation: 1.5)
                    }
                    
                    
                }
            }else{
                let sheetView = LCActionSheet.init(title: "操作选项", buttonTitles: ["领取","分配","删除"], redButtonIndex: -1, delegate: self)
                sheetView?.tag = 222
                sheetView?.show()
            }
            
            
            break
            
        }
        
    }
    //MARK: - 操作
    func actionSheet(_ actionSheet: LCActionSheet!, didClickedButtonAt buttonIndex: Int) {
        if actionSheet.tag == 666 {
            if buttonIndex == 3 {return}
            self.showProgress(withStr: "正在加载中...")
            var parameters = [String:String]()
            parameters["id"] = self.cluesID
            let arr = ["0","1","3"]
            parameters["status"] = "\(arr[buttonIndex])"
            LoginRequest.getPost(methodName: "pp.clue.change_status", params: parameters.addToken(), hadToast: true, fail: { (error) in
                print(error)
                
            }) { (dataDic) in
                self.showDismiss()
                let array = ["0","1","3"]
                self.cluesModel?.status = "\(array[buttonIndex])"
                let state = ["未跟进","已联系","无效信息"]
                self.headView().state.text = "状态：\(state[buttonIndex])"
                self.cluesTableView.basicDic["status"] = "\(state[buttonIndex])"
                self.cluesTableView.reloadData()
                self.toast(withText: "变更成功", andDruation: 1.5)
                //参数是指需不需要重新请求
                self.fresh!(false)
            }
            return
            
        }else if actionSheet.tag == 999 {
            if buttonIndex == 3 {return}
            if buttonIndex == 0 {
                let vc = SLCluesIntoVC()
                vc.basicDic = self.basicDic
                vc.industryStr = self.basicDic?["trade"] as? String ?? ""
                vc.cluesID = self.cluesID ?? ""
                vc.address = self.basicDic?["pro_city_area"] as? String
                self.navigationController?.pushViewController(vc, animated: true)
            }else if buttonIndex == 1 {
                let vc = HYColleaguesVC()
                vc.isSingle = true
                vc.singleSelectClosure = { id in
                    self.showProgress(withStr: "正在加载中...")
                    var parameters = [String:String]()
                    parameters["userid"] = id
                    parameters["clue_id"] = self.cluesID
                    parameters["mark"] = "3"
                    LoginRequest.getPost(methodName: "pp.clue.allot_clue", params: parameters.addToken(), hadToast: true, fail: { (error) in
                        print(error)
                        
                    }) { (dataDic) in
                        self.showDismiss()
                        
                        self.isFromEdit = true
                        self.requestData()
                        self.cluesTableView.reloadData()
                        self.toast(withText: "变更成功", andDruation: 1.5)
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if buttonIndex == 2 {
                /**中间变量*/
                var field = UITextField()
                let alertVC = UIAlertController.init(title: "原因", message: "", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                    return
                }
                let sureAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive) { (action) in
                    /**确定分组*/
                    // self.addGroup(name: field.text!)
                    self.showProgress(withStr: "正在加载中...")
                    var parameters = [String:String]()
                    parameters["id"] = self.cluesID
                    parameters["reason"] = field.text
                    LoginRequest.getPost(methodName: "pp.clue.return_gonghai", params: parameters.addToken(), hadToast: true, fail: { (error) in
                        print(error)
                        
                    }) { (dataDic) in
                        self.showDismiss()
                        self.toast(withText: "退回成功", andDruation: 1.5)
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                            self.fresh!(true)
                            self.navigationController?.popViewController(animated: true)
                            
                        })
                    }
                }
                alertVC.addTextField { (textFileld) in
                    field = textFileld
                }
                alertVC.addAction(cancelAction)
                alertVC.addAction(sureAction)
                self.present(alertVC, animated: true, completion: nil)
                
            }
            return
        }else if actionSheet.tag == 222 {
            
            if buttonIndex == 3 {return}
            if buttonIndex == 0 {//领取
                self.operationClues(methodName: "pp.clue.allot_clue", clueID: self.cluesID!, mark: "1")
            }else if buttonIndex == 1 {//分配
                let vc = HYColleaguesVC()
                vc.isSingle = true
                vc.singleSelectClosure = { id in
                    self.allotsID = id
                    self.operationClues(methodName: "pp.clue.allot_clue", clueID: self.cluesID!, mark: "2")
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }else if buttonIndex == 2 {//删除
                self.operationClues(methodName: "pp.clue.del", clueID: self.cluesID!, mark: "4")
            }
            return
        }else if actionSheet.tag == 333 {
            if buttonIndex == 1 {return}
            let vc = HYColleaguesVC()
            vc.isSingle = true
            vc.singleSelectClosure = { id in
                self.showProgress(withStr: "正在加载中...")
                var parameters = [String:String]()
                parameters["userid"] = id
                parameters["clue_id"] = self.cluesID
                parameters["mark"] = "3"
                LoginRequest.getPost(methodName: "pp.clue.allot_clue", params: parameters.addToken(), hadToast: true, fail: { (error) in
                    print(error)
                    
                }) { (dataDic) in
                    self.showDismiss()
                    
                    self.isFromEdit = true
                    self.requestData()
                    self.cluesTableView.reloadData()
                    self.toast(withText: "变更成功", andDruation: 1.5)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //MARK: - 公海领取、分配、删除
    func operationClues(methodName: String,clueID: String,mark: String) {
        /**参数*/
        self.showProgress(withStr: "正在加载中...")
        let userModel = UserModel.getUserModel()
        var parameters = [String:String]()
        var remindString:String = ""
        if mark=="4" {
            parameters["id"] = clueID
            remindString = "删除成功"
        }else if mark=="2"{
            parameters["userid"] = self.allotsID
            parameters["mark"] = mark
            parameters["clue_id"] = clueID
            remindString = "分配成功"
        }else{
            parameters["userid"] = userModel.id
            parameters["mark"] = mark
            parameters["clue_id"] = clueID
            remindString = "领取成功"
        }
        LoginRequest.getPost(methodName: methodName, params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            print("结果\(dataDic)")
            self.showDismiss()
            let status = dataDic["status"] as! Int
            if status==1{
                self.toast(withText: remindString , andDruation: 1.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.fresh!(true)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }else{
                self.toast(withText: "操作失败", andDruation: 2)
            }
            
        }
    }
    //MARK: - 添加评论信息
    func insertCommentText(_ text: String,_ index: Int) {
        let model = self.frTableView.dataArr[index]
        self.showProgress(withStr: "正在加载中...")
        var parameters = [String:String]()
        parameters["fo_id"] = model.id
        parameters["content"] = text
        LoginRequest.getPost(methodName: "pp.followup.comment_add", params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            
        }) { (dataDic) in
            self.showDismiss()
            
            if let json = JSON(dataDic).dictionaryObject {
                
                let code = json["status"] as! Int
                if code == 1 {
                    let userModel = UserModel.getUserModel()
                    let commentModel = SLCommentsModel.init()
                    commentModel.is_me = 1
                    commentModel.id = json["data"] as? String
                    commentModel.create_realname = userModel.realname
                    commentModel.create_userid = userModel.id
                    commentModel.content = text
                    model.comments?.append(commentModel)
                    self.frTableView.reloadSections(IndexSet.init(integer: index), with: UITableViewRowAnimation.fade)
                }
                
            }
            
            
            
        }
    }
    deinit {
        print("移除")
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

