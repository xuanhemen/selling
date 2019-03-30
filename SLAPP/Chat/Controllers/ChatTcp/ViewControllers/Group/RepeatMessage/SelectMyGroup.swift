//
//  SelectMyGroup.swift
//  GroupChatPlungSwiftPro
//
//  Created by 柴进 on 2017/4/21.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
enum ConversationType {
    case group
    case theme
}
class SelectMyGroup:BaseViewController {
    
    var table:UITableView?
    var searchView:BaseSearchView?
    
    var finishSelect:(_ selectList:Array<RLMObject>,_ otherText:String?)->() = {
        a,b in
    }
    

    //基础数据源
    var groupDataArray:Array<RLMObject>? = []
    var themeDataArray:Array<RLMObject>? = []
    var groupSearchText : String? = ""
    var themeSearchText : String? = ""
    //当前显示的数据源
    var dataArray:Array<RLMObject>?
    var selectedArray:Array<RLMObject>? = [] //记录已经选择的群组/话题
    var conversationList : NSArray = []
    var message : RCMessageContent? //转发的消息
    var hiddenSelectIcon:Bool? = true //默认为单选
    var leftBtn:UIButton?
    var rightBtn:UIButton?
    fileprivate var conversationType: ConversationType! = .group
    var iszhuanfa : Bool? //用来区分转发和转推
    var targetId : String?{
        didSet{
//        只能转推到会话列表的群组和话题中    
            conversationList = RCIMClient.shared().getConversationList([RCConversationType.ConversationType_GROUP.rawValue]) as NSArray
            
            let idArr = NSMutableArray.init(array: conversationList.value(forKeyPath: "targetId") as! NSArray) 

            var isTopIdArr = Array<String>()
            var allDataArray : Array<RLMObject>? = []
            for i in 0..<idArr.count {
                let groupid : String = idArr[i] as! String
                let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@", sharePublicDataSingle.publicData.userid,groupid)).firstObject() as! GroupUserModel?
                let conversation = RCIMClient.shared().getConversation(.ConversationType_GROUP, targetId: groupid)
                if groupUserModel?.is_delete == "0" && groupid != targetId {
                    if let groupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@ AND is_delete == '0'",groupid)).firstObject() as! GroupModel?{
                        if (conversation?.isTop)! {
                            let index = (allDataArray?.count)!
                            allDataArray?.insert(groupModel, at: index)
                        }else{
                            
                            allDataArray?.append(groupModel)
                        }
                    }
                
                    isTopIdArr.append(groupid)
                }
            }
            
//            for i in 0..<idArr.count {
//                let groupid : String = idArr[i] as! String
//                let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@", sharePublicDataSingle.publicData.userid,groupid)).firstObject() as! GroupUserModel?
//                if groupUserModel?.is_delete == "0" && groupid != targetId && !isTopIdArr.contains(groupid){
//                    self.allDataArray?.append(GroupModel.objects(with: NSPredicate.init(format: "groupid == %@ AND is_delete == '0'",groupid)).firstObject()!)
//                }
//            }
           
            self.groupDataArray = allDataArray?.filter({ (model:RLMObject) -> Bool in
                return (model as! GroupModel).type == "0"
            })
            self.themeDataArray = allDataArray?.filter({ (model:RLMObject) -> Bool in
                return (model as! GroupModel).type == "1"
            })
            self.dataArray = self.groupDataArray
       
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    /// UI初始化
    fileprivate func configUI()
    {
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        leftBtn = UIButton.init(type: .custom)
        leftBtn?.frame = CGRect.init(x: 0, y: 100, width: 60, height: 30)
        leftBtn?.setTitleColor(UIColor.white, for: .normal)
        leftBtn?.setImage(UIImage.init(named: "icon-arrow-left"), for: .normal)
        leftBtn?.sizeToFit()
        let leftItem  = UIBarButtonItem.init(customView: leftBtn!)
        leftBtn?.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        self.navigationItem.backBarButtonItem = leftItem

        rightBtn = UIButton.init(type: .custom)
        rightBtn?.frame = CGRect.init(x: 0, y: 100, width: 60, height: 30)
        rightBtn?.setTitle("多选", for:.normal)
        rightBtn?.setTitleColor(UIColor.white, for: .normal)
        rightBtn?.sizeToFit()
        let rightItem  = UIBarButtonItem.init(customView: rightBtn!)
        rightBtn?.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = rightItem
        
        searchView = Bundle.main.loadNibNamed("BaseSearchView", owner: self, options: nil)?.last as? BaseSearchView
        searchView?.frame = CGRect.init(x: 0, y: NAV_HEIGHT, width: kScreenW, height: searchView_height)
        searchView?.configCollectionViewWith(isShowCollect: true)
        searchView?.delegate = self
        searchView?.isShowCollectionView = true
        self.view.addSubview(searchView!)
        
        var tableY : CGFloat = NAV_HEIGHT+searchView_height
        if self.iszhuanfa! {
            tableY += cardView_height
            let cardView = CardView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT+searchView_height, width: self.view.frame.size.width, height: cardView_height))
            cardView.backgroundColor = kGrayColor_Slapp
            cardView.titleNormalColor = kCardNoSelectColor
            cardView.bottomLineNormalColor = kGreenColor
            cardView.titleSelectColor = .white
            cardView.creatBtns(withTitles: ["闲聊","话题"])
            cardView.btnClickBlock = ({ (btn) in
                switch btn {
                case 10:
                    self.conversationType = .group
                    self.searchView?.searchView.text = self.groupSearchText
                    self.searchViewResearch(keyText: self.groupSearchText, dataArr: self.groupDataArray)
                case 11:
                    self.conversationType = .theme
                    self.searchView?.searchView.text = self.themeSearchText
                    self.searchViewResearch(keyText: self.themeSearchText, dataArr: self.themeDataArray)
                    
                default:
                    break
                }
                self.showRemind()
                self.table?.reloadData()
                return false
            })
            self.view .addSubview(cardView)
        }
        
        table = UITableView.init(frame: CGRect.init(x: 0, y: tableY, width: kScreenW, height: kScreenH-tableY))
        table?.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(table!)
        table?.delegate = self;
        table?.dataSource = self;
//        table?.tableFooterView = UIView.init()
        //写在这里是因为已经获取到了数据源,但是table并未创建,以致空页面未显示
        self.showRemind()
        self.table?.reloadData()
    }
    @objc func leftClick(button: UIButton) {
        if hiddenSelectIcon! {
            self.navigationController?.popViewController(animated: true)
        }else{
            hiddenSelectIcon = true
            changeLeftBtnStatus()
            self.selectedArray?.removeAll()
            changeRightBtnStatus()
            searchView?.configWithDataArray(array:selectedArray!)
            table?.reloadData()
        }
    }

    @objc func rightClick(button: UIButton) {
        if button.titleLabel?.text == "多选" {
            hiddenSelectIcon = false
            self.selectedArray?.removeAll()
            table?.reloadData()
        }else{
            //TODO:群转发操作
//            self.selectedArray?.removeAll()
//            changeRightBtnStatus()
//            searchView?.configWithDataArray(array:selectedArray!)
//            table?.reloadData()
           self.addRepeatMessageView()
        }
        changeLeftBtnStatus()
        changeRightBtnStatus()
    }
    func changeLeftBtnStatus(){
        if hiddenSelectIcon! {
            leftBtn?.setImage(UIImage.init(named: "icon-arrow-left"), for: .normal)
            leftBtn?.setTitle("", for: .normal)
            leftBtn?.sizeToFit()
        }else{
            leftBtn?.setImage(UIImage.init(named: ""), for: .normal)
            leftBtn?.setTitle("取消", for: .normal)
            leftBtn?.sizeToFit()
        }
        
    }

    func changeRightBtnStatus(){
        if hiddenSelectIcon!{
            rightBtn?.setTitleColor(UIColor.white, for: .normal)
            rightBtn?.isEnabled = true
            rightBtn?.setTitle("多选", for: .normal)
        }else{
            if selectedArray?.count != 0 {
                let countStr = String.init(format: "确定(%d)", (selectedArray?.count)!)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                rightBtn?.setTitleColor(UIColor.white, for: .normal)
                rightBtn?.isEnabled = true
                rightBtn?.setTitle(countStr, for: .normal)
                rightBtn?.sizeToFit()
            }else{
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                rightBtn?.isEnabled = false
                rightBtn?.setTitleColor(UIColor.lightGray, for: .normal)
                rightBtn?.setTitle("确定", for: .normal)
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.searchView?.searchView.isFirstResponder)! {
            self.searchView?.searchView.resignFirstResponder()
        }
    }

    var repeatMessageView:RepeatMessageView?
    var model = GroupModel()
    
    func addRepeatMessageView() {
        self.repeatMessageView = RepeatMessageView(type: "\(type(of: message))", modelArr: self.selectedArray as! Array<GroupModel>, message:RCKitUtility.formatMessage(self.message))
        //TODO: 资源文件的二次配置
        if RCKitUtility.formatMessage(self.message) == "[图片]" {
            //            let imageUrl = (message as! RCImageMessage).imageUrl
            //
            //            (self.repeatMessageView?.resourceView as! UIImageView).sd_setImage(with: URL.init(string: imageUrl!))
            //            (self.repeatMessageView?.resourceView as! UIImageView).backgroundColor = UIColor.red
            (self.repeatMessageView?.resourceView as! UIImageView).image = (message as! RCImageMessage).thumbnailImage
        }
        
        repeatMessageView?.enterBtn.addTarget(self, action: #selector(repeatMessageAction(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.repeatMessageView!)

    }
    @objc func repeatMessageAction(btn:UIButton) {

        finishSelect(self.selectedArray!, self.repeatMessageView?.inputText.text)

    }
}

//MARK: - ---------------------TableDelegate AND DataSource----------------------
extension SelectMyGroup:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.conversationType == .group{
            return 44
        }else{
            return 54
        }

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray != nil ?Int((dataArray?.count)!): 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil
        {
            if self.conversationType == .group {
                
                cell = SelectMyGroupCell.init(style: .default, reuseIdentifier: "SelectMyGroupCell")
            }else{
                cell = SelectMyThemeCell.init(style: .default, reuseIdentifier: "SelectMyThemeCell")                
            }
        }
        (cell as! SelectMyGroupCell).hiddenSelectImage = self.hiddenSelectIcon
        
        let model:RLMObject = self.dataArray![indexPath.row]
        if (self.selectedArray?.contains(where: { (m) -> Bool in
            return (m as! GroupModel).groupid == (model as! GroupModel).groupid
        }))!{

            (cell as! SelectMyGroupCell).selectImageView.image = UIImage.init(named: "logic_select")
        }
        else
        {
            (cell as! SelectMyGroupCell).selectImageView.image = UIImage.init(named: "logic_normal")
        }

        (cell as! SelectMyGroupCell).model = model as? GroupModel
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.searchView?.searchView.isFirstResponder)! {
            self.searchView?.searchView.resignFirstResponder()
        }
        if hiddenSelectIcon! == false {
 
            let model:GroupModel = self.dataArray![indexPath.row] as! GroupModel
            
            let index = self.selectedArray?.index(where: { (m) -> Bool in
                return (m as! GroupModel).groupid == model.groupid
            })
            if (index != nil) {
                self.selectedArray?.remove(at: index!)
            }
            else
            {
                if (self.selectedArray?.count)! == 9 {
                    self.view.makeToast("您最多选择9个闲聊或话题", duration: 1.0, position: self.view.center)
                    return
                }
                self.selectedArray?.append(model)
                
            }
            
            searchView?.configWithDataArray(array:selectedArray!)
            
            changeRightBtnStatus()
            tableView.reloadData()
            return
        }

        self.model = self.dataArray?[indexPath.row] as! GroupModel
        self.selectedArray?.append(model)
    
        self.addRepeatMessageView()
    }
    
    /// 提醒个数
    func showRemind(){
        
        let fView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 50))
        
        let line = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 1))
        line.backgroundColor = UIColor.groupTableViewBackground
        fView.addSubview(line)
        
        let numberLable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 50))
        numberLable.textAlignment = NSTextAlignment.center
        numberLable.font = UIFont.systemFont(ofSize: 14)
        numberLable.numberOfLines = 0
        numberLable.text = self.conversationType == .group ? "暂无其它群组\n您可通过查找群组来加入其它群组" : "暂无其它话题"
        fView.addSubview(numberLable)
        
        if (self.dataArray?.count)! == 0 {
            table?.tableFooterView = fView
        }else{
            table?.tableFooterView = UIView.init()
        }
        
    }

    
}
extension SelectMyGroup:BaseSearchViewDelegate
{
    func searchDeleteItem(item: RLMObject)
    {
        let model = item as! GroupModel

        let index = self.selectedArray?.index(where: { (m) -> Bool in
            return (m as! GroupModel).groupid == model.groupid
        })
        if (index != nil) {
            self.selectedArray?.remove(at: index!)
        }
        changeRightBtnStatus()
        table?.reloadData()
    }
    
    func searchBarTextChangedWith(nowText:String)
    {
        var tempDataArray : Array<RLMObject>? = []
        if self.conversationType == .group{
            tempDataArray = self.groupDataArray
            groupSearchText = nowText
        }else{
            tempDataArray = self.themeDataArray
            themeSearchText = nowText
        }
        self.searchViewResearch(keyText: nowText, dataArr: tempDataArray)
        self.showRemind()
        table?.reloadData()

    }
    //因为键盘带搜索按钮,所以必须实现这个方法,否则会崩溃
    func searchBarSearchButtonClicked(nowText:String)
    {
        
    }

}
extension SelectMyGroup {

    func searchViewResearch(keyText: String?, dataArr: Array<RLMObject>?) {
        if (keyText?.isEmpty)! {
            self.dataArray = dataArr
        }
        else{
            self.dataArray?.removeAll()
            for groupModel in dataArr! {
                if (groupModel as! GroupModel).group_name.contains(keyText!) {
                    self.dataArray?.append(groupModel)
                }
            }
        }

    }

}
