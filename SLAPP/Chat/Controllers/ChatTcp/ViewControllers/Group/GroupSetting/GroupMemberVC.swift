//
//  GroupMemberVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/16.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
enum SearchType {
    case friend
    case stranger
}
class GroupMemberVC: BaseTableVC {
    
    //创建群组和添加成员共用  但是数据处理和UI还是有一些小区别 因此添加了一个字段 isCreatGroup
    //是否是创建群组
    var cardView:CardView?
    var isCreatGroup:Bool?
    var rightBtn:UIButton?
    var isAddMember:Bool? //是添加 还是删除
    var groudId:String?
    
    typealias back = (_ resultArray:Array<Any>)->()
    fileprivate var resultBlock : back?
    //------------以下参数只在区分搜索类型的页面用到-----------
    fileprivate var searchType: SearchType! = .friend
    var searchText_friend : String? = ""
    var searchText_stranger : String? = ""//记录搜索框的内容
    var strangersArr : RLMResults<RLMObject>?//记录之前搜索的陌生人
    var isFirstCard : Bool? = true //第一次切换至陌生人
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.configNav()
        DataBaseOperation.removeDataWithArray(rlmObjects: FriendsModel.allObjects())
        if isCreatGroup == true {
            configUIWithCreatGroup()
            self.configUIWith(fromCellName: "BaseTableCell", fromIsShowSearch: true,fromSearchType: true ,fromCellHeight: 44)
        }
        else
        {
            configUIWithAddMember()
            if self.isAddMember == false {
                super.configUIWith(fromCellName: "BaseTableCell", fromIsShowSearch: true,fromSearchType: true ,fromCellHeight: 44)
            }else{
                self.addCardView()
                self.configUIWith(fromCellName: "BaseTableCell", fromIsShowSearch: true,fromSearchType: true ,fromCellHeight: 44)
            }

        }
   
    }

    override func configUIWith(fromCellName: String, fromIsShowSearch: Bool, fromSearchType: Bool, fromCellHeight: CGFloat) {
        super.configUIWith(fromCellName: fromCellName, fromIsShowSearch: fromIsShowSearch, fromSearchType: fromSearchType, fromCellHeight: fromCellHeight)
        searchView?.frame = CGRect.init(x: 0, y: NAV_HEIGHT+cardView_height, width: kScreenW, height: 50)
        
        self.table?.frame = CGRect.init(x: 0, y:50+NAV_HEIGHT+cardView_height, width: kScreenW, height:kScreenH-NAV_HEIGHT-50-cardView_height)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if self.isAddMember == false{
            
            /// 删除成员
            var array = NSArray.init(array: (self.memberArray)!)
            if self.memberArray?.count == 0 {
                return
            }
            let model :GroupUserModel = array.firstObject as! GroupUserModel
            self.memberArray?.removeAll()
            array = array.value(forKeyPath: "userid") as! NSArray
            
            let predicate = NSPredicate(format:"userid in %@ AND groupid ==%@ AND userid != %@ AND is_delete == '0'", array,model.groupid,sharePublicDataSingle.publicData.userid)
            self.allDataArray =  GroupUserModel.allObjects().objects(with: predicate) as! RLMResults<RLMObject>
            self.setDataArray(dataArray:(self.allDataArray!))
            
            return
        }
        else{
            
            if self.searchType == .stranger {//在陌生人页面时不需要更新好友
                return
            }
            //添加成员  必须得更新自己的好友  保证数据是最新的
            self.updateFriend(type: 1)
            self.updateFriend(type: 2)
        }

        
    }
    
    
    /// 更新好友列表
    func updateFriend(type:NSNumber){
        var params = Dictionary<String, Any>()
        params["app_token"] = sharePublicDataSingle.token
        params["type"] = type
        self.progressShow()
        
        UserRequest.friends(params: params, hadToast: true, fail: { [weak self](Error) in
            DLog("出现错误")
            if let strongSelf = self{
                strongSelf.progressDismiss()
            }

        }) {[weak self] (sucess) in
            
           
            //
            
            
            self?.configFriendData(array: sucess["user_list"] as! Array<Dictionary<String, Any>>, type: type)
            
            
            if let strongSelf = self{
                DispatchQueue.main.async{
                    strongSelf.progressDismiss()
                    strongSelf.allDataArray =  FriendsModel.objects(with: NSPredicate.init(format: "type == 1")) as? RLMResults<RLMObject>
                    if (strongSelf.searchText_friend?.characters.count)! > 0{
                        let pre = NSPredicate.init(format: "realname CONTAINS %@", (strongSelf.searchView?.searchView.text)!)
                        strongSelf.setDataArray(dataArray:(strongSelf.allDataArray?.objects(with: pre))!)

                    }else{
                        strongSelf.setDataArray(dataArray:strongSelf.allDataArray!)
                    }
                    strongSelf.table?.reloadData()
                    if strongSelf.allDataArray?.count == 0{
                        
//                        strongSelf.creatMind()
                        if strongSelf.isCreatGroup == true {
                            
                            
                            strongSelf.navigationItem.rightBarButtonItem?.isEnabled = true
                            strongSelf.rightBtn?.setTitleColor(UIColor.white, for: .normal)
                            
                        }
//                        else{
//                            self?.getImageWithGroup(id:strongSelf.groudId!)
//                        }
                    }
                }
                
            }
            
        }
        
    }
    
    /// 查找用户
    func searchUser(keyword: String?){
        var params = Dictionary<String, Any>()
        params["app_token"] = sharePublicDataSingle.token
        params["keyword"] = keyword
        params["type"] = "2"
        
        self.progressShow()
        
        UserRequest.searchUser(params: params, hadToast: true, fail: { [weak self](Error) in
            DLog("出现错误")
            if let strongSelf = self{
                strongSelf.progressDismiss()
            }
            
        }) { [weak self](sucess) in
            
            self?.configFriendData(array: sucess["user_list"] as! Array<Dictionary<String, Any>>, type: 1)
            
            if let strongSelf = self{
                strongSelf.progressDismiss()
                
                strongSelf.strangersArr = FriendsModel.objects(with: NSPredicate.init(format: "realname CONTAINS %@", (strongSelf.searchView?.searchView.text)!)) as? RLMResults<RLMObject>
                strongSelf.setDataArray(dataArray:(strongSelf.strangersArr)!)
                strongSelf.table?.reloadData()
                strongSelf.showRemind()

            }
            
        }
        
    }
  
    func configFriendData(array:Array<Dictionary<String,Any>>,type:NSNumber){
        
        guard array.count > 0 else {
            return
        }
        
        let friendArray = array.map { (dic) -> [String:Any] in
            var fDic = Dictionary<String, Any>()
            fDic.updateValue(String.noNilStr(str: dic["avater"]), forKey: "avater")
            fDic.updateValue(String.noNilStr(str: dic["im_userid"]), forKey: "im_userid")
            fDic.updateValue(String.noNilStr(str: dic["realname"]), forKey: "realname")
            fDic.updateValue(String.noNilStr(str: dic["userid"]), forKey: "userid")
            fDic.updateValue(type, forKey: "type")
            return fDic
        }
        
        guard friendArray.count > 0 else {
            return
        }
        DataBaseOperation.addDataWithArray(rlmObjects: friendArray as! Array<Any>, aClass: FriendsModel.self)
        
        
        
    }
    
    
    /// 获取群组的二维码
    ///
    /// - Parameter id: 群组id
    func getImageWithGroup(id:String){
    
        var params = Dictionary<String, Any>()
        params["app_token"] = sharePublicDataSingle.token
        params["groupid"] = id
        GroupRequest.getQrCode(params: params, hadToast: true, fail: { [weak self](error) in
            if let strongSelf = self {
                strongSelf.progressDismiss()
            }
        }) {[weak self] (success) in
           
            self?.progressDismiss()
            self?.creatSweep(url: success["qr_url"] as! String)
        }

    }
    
    
    /// 创建群组二维码显示界面
    ///
    /// - Parameter url: 二维码图片地址
    func creatSweep(url:String)
    {
      let sweep = GroupSweepView.initWithImage(url: url)
      self.view.addSubview(sweep)
    }
    
    /// 创建群组UI
    func configUIWithCreatGroup()
    {
        self.title = "选择联系人"
        rightBtn = UIButton.init(type: .custom)
        rightBtn?.frame = CGRect.init(x: 0, y: 100, width: 60, height: 30)
        rightBtn?.setTitle("确定", for:.normal)
          rightBtn?.setTitleColor(UIColor.white, for: .normal)
        rightBtn?.sizeToFit()
        let rightItem  = UIBarButtonItem.init(customView: rightBtn!)
        rightBtn?.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
//         rightItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightItem
        self.addCardView()
    }
    
    
    /// 添加成员UI
    func configUIWithAddMember()
    {
        self.view.backgroundColor = kGrayColor_Slapp2
        let titleLable = UILabel.init(frame: CGRect(x: (kScreenW-100)/2, y: NAV_HEIGHT-44+7, width: 100, height: 30))
        titleLable.text = "选择联系人"
        titleLable.textColor = UIColor.white
        self.view.addSubview(titleLable)
        
        
        
        
        let leftBtn = UIButton.init(type: .custom)
        leftBtn.frame = CGRect.init(x: 15, y: NAV_HEIGHT-44+7, width: 40, height: 30)
        leftBtn.setTitle("取消", for:.normal)
        self.view.addSubview(leftBtn)
        leftBtn.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        
        
        rightBtn = UIButton.init(type: .custom)
        rightBtn?.frame = CGRect.init(x: kScreenW-70, y: NAV_HEIGHT-44+7, width: 60, height: 30)
        rightBtn?.isEnabled = false
        rightBtn?.setTitle("确定", for:.normal)
        rightBtn?.setTitleColor(UIColor.lightGray, for: .normal)
        rightBtn?.sizeToFit()
        self.view.addSubview(rightBtn!)
        rightBtn?.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
    }
    
    func addCardView(){
    
        cardView = CardView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT, width: self.view.frame.size.width, height: cardView_height))
        cardView?.backgroundColor = kGrayColor_Slapp2
        cardView?.titleNormalColor = kCardNoSelectColor
        cardView?.bottomLineNormalColor = kGreenColor
        cardView?.titleSelectColor = .white
        cardView?.creatBtns(withTitles: ["本部门","其他部门"])
        cardView?.btnClickBlock = ({ (btn) in
            switch btn {
            case 10:
                self.searchType = .friend
                self.searchView?.searchView.placeholder = "搜索"
                self.searchView?.searchView.text = self.searchText_friend
                if (self.searchView?.searchView.text?.characters.count)! > 0 {
                    
                    let pre = NSPredicate.init(format: "realname CONTAINS %@ AND type == 1", (self.searchView?.searchView.text)!)
                    self.dataArray = self.allDataArray?.objects(with: pre)
                }else{
                    self.dataArray = self.allDataArray
                }
                if self.dataArray != nil{
                    self.setDataArray(dataArray:self.dataArray!)
                }
                
            case 11:
                self.searchType = .stranger
                self.searchView?.searchView.placeholder = "请输入用户名（邮箱/手机号）"
                self.searchView?.searchView.text = self.searchText_stranger
                if self.isFirstCard! {
                    self.strangersArr = FriendsModel.objects(with: NSPredicate.init(format: "type == 2")) as? RLMResults<RLMObject>
                    self.isFirstCard = false
                }
                if self.strangersArr != nil{
                    self.setDataArray(dataArray:self.strangersArr!)
                }
            default:
                break
            }
            self.table?.reloadData()
            self.showRemind()
//            self.creatMind()
            return false
        })
        
        self.view.addSubview(cardView!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.searchView?.searchView.resignFirstResponder()
    }
    
    
    @objc func leftClick(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func rightClick(){
        
       
        if isCreatGroup == true {
            
            let isOpenVC = GroupIsOpenVC(nibName: "GroupIsOpenVC", bundle: nil)
            isOpenVC.userArray = selectedArray
            self.navigationController?.pushViewController(isOpenVC, animated: true)
            
        }
        else if (isAddMember == false){
            self.addAlertView(title: "您确定要移除该成员吗?", message: "", actionTitles: ["确定","取消"], okAction: { (okAction) in
                var params = Dictionary<String, Any>()
                
                params["app_token"] = sharePublicDataSingle.token
                let idStr = (NSArray.init(array: self.selectedArray!).value(forKeyPath: "userid") as! NSArray).componentsJoined(by: ",")
                params["userid_str"] = idStr
                params["groupid"] = self.groudId!
                self.progressShow()
                GroupRequest.delUser(params: params, hadToast: true, fail: { [weak self](error) in
                    if let strongSelf = self {
                        strongSelf.progressDismiss()
                    }
                }, success: { (dic) in
                    
                    
                    let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                    let time = UserDefaults.standard.object(forKey: username) as! String
                    
                    UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time], hadToast: true, fail: { [weak self](error) in
                        if let strongSelf = self {
                            strongSelf.progressDismiss()
                        }

                    }, success: {[weak self] (dic) in
                        
                        self?.progressDismiss()
                        //删除成员
                        self?.resultBlock?((self?.selectedArray!)!)
                        self?.dismiss(animated: true, completion: nil)
                        }
                    )
                    
                })
                
            }, cancleAction: { (cancleAction) in
                
            })
        }
        else
        {
            
            //增加成员
            
            var params = Dictionary<String, Any>()
            
//            params["app_token"] = sharePublicDataSingle.token
             params["app_token"] = UserModel.getUserModel().token
            let idStr = (NSArray.init(array: selectedArray!).value(forKeyPath: "userid") as! NSArray).componentsJoined(by: ",")
            params["userid_str"] = idStr
            params["groupid"] = groudId!
            self.progressShow()
            GroupRequest.inviteUser(params: params, hadToast: true, fail: { [weak self](error) in
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                }
            }, success: { (dic) in
                
                
                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                let time = UserDefaults.standard.object(forKey: username) as! String
                
                UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time], hadToast: true, fail: { [weak self](error) in
                    if let strongSelf = self {
                        strongSelf.progressDismiss()
                    }

                }, success: {[weak self] (dic) in
                    
                    self?.progressDismiss()
                    
                if self?.resultBlock != nil  {
                    
                    var resultArray = Array<Any>()
                    for i in 0..<(self?.selectedArray?.count)! {
                        
                        let fModel = self?.selectedArray?[i] as! FriendsModel
                        let userModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", fModel.userid)).firstObject() as! UserModelTcp?

                        let gModel = GroupUserModel()
                        gModel.userid = fModel.userid
                        if  userModel?.avater != nil {
                            gModel.avater = (userModel?.avater)!
                        }
                        if userModel?.realname != nil {
                            gModel.realname = (userModel?.realname)!
                        }
                        resultArray.append(gModel)
                    }
                    
                    
                    self?.resultBlock?(resultArray)
                    self?.dismiss(animated: true, completion: nil)
                    }
                    }
                )

            
            })
            
         }
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.searchView?.searchView.isFirstResponder)! {
            self.searchView?.searchView.resignFirstResponder()
        }
    }

    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.searchView?.searchView.isFirstResponder)! {
            self.searchView?.searchView.resignFirstResponder()
        }
        
        if self.isAddMember == false{
            let model:GroupUserModel = self.dataArray![UInt(indexPath.row)] as! GroupUserModel
            
            if (self.memberArray?.contains(where: { (m) -> Bool in
                
                return m.userid == model.userid
                
            }) == true) {
                
                return
            }
            
            
            
            
            let index = self.selectedArray?.index(where: { (m) -> Bool in
                return (m as! GroupUserModel).userid == model.userid
            })
            if (index != nil) {
                self.selectedArray?.remove(at: index!)
            }
            else
            {
                self.selectedArray?.append(model)
                
            }

        }
        else{
        
            let model:FriendsModel = self.dataArray![UInt(indexPath.row)] as! FriendsModel
            
            if (self.memberArray?.contains(where: { (m) -> Bool in
                
                return m.userid == model.userid
                
            }) == true) {
                
                return
            }
            
            
            
            
            let index = self.selectedArray?.index(where: { (m) -> Bool in
                return (m as! FriendsModel).userid == model.userid
            })
            if (index != nil) {
                self.selectedArray?.remove(at: index!)
            }
            else
            {
                self.selectedArray?.append(model)
                
            }

        }
        
        
        if self.isShowSearch! {
            
            searchView?.configWithDataArray(array:selectedArray!)
            
        }
        tableView.reloadData()
        
        
        changeRightBtnStatus()
        
        
        
    }
    
    
    /// 改变右边按钮状态
    func changeRightBtnStatus(){
        if selectedArray?.count != 0 {
            let countStr = String.init(format: "确定(%d)", (selectedArray?.count)!)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            rightBtn?.setTitleColor(UIColor.white, for: .normal)
            rightBtn?.isEnabled = true
            rightBtn?.setTitle(countStr, for: .normal)
            rightBtn?.sizeToFit()
        }
        else
        {
            
            if isCreatGroup == true {
                rightBtn?.setTitle("确定", for: .normal)
            }
            else{
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                rightBtn?.isEnabled = false
                rightBtn?.setTitleColor(UIColor.lightGray, for: .normal)
                rightBtn?.setTitle("确定", for: .normal)
            }
        }
        
    }
   
    
    
    override func searchDeleteItem(item: RLMObject) {
        
        if isAddMember == false {
            let model = item as! GroupUserModel
            
            if (self.memberArray?.contains(where: { (m) -> Bool in
                
                return m.userid == model.userid
                
            }) == true) {
                
                return
            }
            
            
            
            let index = self.selectedArray?.index(where: { (m) -> Bool in
                return (m as! GroupUserModel).userid == model.userid
            })
            if (index != nil) {
                self.selectedArray?.remove(at: index!)
            }
 
        }
        else{
            let model = item as! FriendsModel
            
            if (self.memberArray?.contains(where: { (m) -> Bool in
                
                return m.userid == model.userid
                
            }) == true) {
                
                return
            }
            
            
            
            let index = self.selectedArray?.index(where: { (m) -> Bool in
                return (m as! FriendsModel).userid == model.userid
            })
            if (index != nil) {
                self.selectedArray?.remove(at: index!)
            }
            
        }
        
        table?.reloadData()
        changeRightBtnStatus()
    }
    
    
    
    //MARK: - ---------------------添加 或 删除 给上一个界面返回的数据----------------------
    public func resultWithArray(resultArray:@escaping back)
    {
       resultBlock = resultArray
    }
    
    
    
    //MARK: - ---------------------搜索内容发生变化的响应----------------------
    override func searchBarTextChangedWith(nowText:String)
    {
        if self.searchType == .stranger {
            return
        }
        if self.allDataArray?.count == 0 {
            return
        }
        if self.searchType == .friend {
            self.searchText_friend = nowText
        }
        if nowText.isEmpty {
            self.dataArray = self.allDataArray
        }
        else{
            
           let pre = NSPredicate.init(format: "realname CONTAINS %@", nowText)
           self.dataArray = self.allDataArray?.objects(with: pre)
        }
        table?.reloadData()
        self.showRemind()
    }
    
    override func searchBarSearchButtonClicked(nowText: String) {
        if self.searchType == .stranger {
            self.searchText_stranger = nowText
            self.searchUser(keyword: nowText)
        }
    }

    
    func creatMind(){
        if self.allDataArray != nil {
            
            if self.allDataArray?.count == 0{
                noDatamind.isHidden = false
            }else{
                noDatamind.isHidden = true
            }
        }
        if self.searchType == .stranger{
            noDatamind.isHidden = true
        }
    }
    lazy var noDatamind : UILabel = {
    
        var noDatamind = UILabel.init(frame: CGRect.init(x: 0, y: 200, width: 150, height: 20))
        noDatamind.textAlignment = .center
        noDatamind.center = self.view.center
        noDatamind.text = "暂时没有好友"
        self.view.addSubview(noDatamind)
        return noDatamind
    }()

}


