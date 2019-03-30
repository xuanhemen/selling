//
//  ChatContentSearchVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 2017/4/27.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

typealias click = (_ mID:ChatContentModel)->()

class ChatContentSearchVC: BaseViewController {

    var clickCell:click?
    var table:UITableView?
    var dataArray:Array = Array<ChatContentModel>()
    var searchView:UISearchBar?
    var targetId:String?
    var isLoading:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        
    }

    func configUI(){
        
      isLoading = false
      searchView = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: NAV_HEIGHT))
      self.navigationItem.titleView = searchView
      searchView?.delegate = self as! UISearchBarDelegate
        
        
      table = UITableView.init(frame:CGRect(x: 0, y:NAV_HEIGHT, width: kScreenW, height: kScreenH-NAV_HEIGHT))
      self.view.addSubview(table!)
      table?.delegate = (self as UITableViewDelegate)
      table?.dataSource = (self as UITableViewDataSource)
      table?.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchView?.becomeFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (searchView?.isFirstResponder)! {
            searchView?.resignFirstResponder()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < (table?.contentSize.height)! && self.isLoading == true {
            self.searchMoreMessage()
        }
        
    }
    
    func searchMoreMessage(){
        
        let contentModel:ChatContentModel = self.dataArray[self.dataArray.count-1]
        let array = RCIMClient.shared().searchMessages(.ConversationType_GROUP, targetId: targetId!, keyword: self.searchView?.text, count: 50, startTime: contentModel.time!)
        if (array?.count)! < 50 {
            self.isLoading = false
        }
        else{
           self.isLoading = true
        }
        
        var resultArray = self.dataArray
        for m in array! {
            let message:RCMessage = m as RCMessage
            let contentModel:ChatContentModel = ChatContentModel()
            contentModel.otherInformation = RCKitUtility.formatMessage(message.content)
            contentModel.time = message.sentTime
            
            contentModel.messageID = m.messageId
            resultArray.append(contentModel)
 
        }
        
        self.dataArray = resultArray
        if self.dataArray.count == 0 {
            
        self.remindNoSearchContent()
        }
        else{
          table?.tableFooterView = UIView()
        }
        table?.reloadData()
    }
    
        func remindNoSearchContent(){
            let fView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 50))
            
            let line = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 1))
            line.backgroundColor = UIColor.groupTableViewBackground
            fView.addSubview(line)
            
            
            let numberLable = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: kScreenW, height: 30))
            numberLable.textAlignment = NSTextAlignment.center
            numberLable.font = UIFont.systemFont(ofSize: 14)
            
            numberLable.text = "无结果"
            fView.addSubview(numberLable)
            table?.tableFooterView = fView
        }

    func cellClick(cellClick:@escaping click){
       clickCell = cellClick
        
    }
    
    

    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}



extension ChatContentSearchVC:UISearchBarDelegate{

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            dataArray.removeAll()
            table?.reloadData()
            return
        }
        
        let array:Array = RCIMClient.shared().searchMessages(.ConversationType_GROUP, targetId: self.targetId!, keyword: searchText, count: 50, startTime: 0)
        
        var resultArray:Array = Array<ChatContentModel>()
        for m in array {
            let message:RCMessage = m as RCMessage
            let contentModel:ChatContentModel = ChatContentModel()
            contentModel.otherInformation = RCKitUtility.formatMessage(message.content)
            contentModel.time = message.sentTime
            
            contentModel.messageID = m.messageId
            let predicate = NSPredicate.init(format: "groupid == %@ AND is_delete == '0' AND im_userid == %@", argumentArray: [self.targetId,message.senderUserId])
            let result = GroupUserModel.allObjects().objects(with: predicate)
            if result.count > 0 {
                let userModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", (result.firstObject() as! GroupUserModel).userid)).firstObject() as! UserModelTcp?
                if  userModel?.avater != nil {
                    
                    contentModel.portraitUri = (userModel?.avater)!
                }
                if userModel?.realname != nil {
                    
                    contentModel.name = (userModel?.realname)!
                }
            }
            
            resultArray.append(contentModel)
            
            
        }
        dataArray = resultArray
        
        
       
        
//        [self refreshSearchView:searchText];
        if (self.dataArray.count < 50) {
            self.isLoading = false;
        }else{
            self.isLoading = true;
        }

        if self.dataArray.count == 0 {
            
            self.remindNoSearchContent()
        }
        else{
            table?.tableFooterView = UIView()
        }

        
        table?.reloadData()
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }

    
    
    
    
    

}

extension ChatContentSearchVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell:ChatContentCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ChatContentCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ChatContentCell", owner: self, options: nil)?.last as? ChatContentCell
        }
        cell?.setModel(model: self.dataArray[indexPath.row])
        return cell!
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model  = self.dataArray[indexPath.row]
//        clickCell?(model)
        
        let talk = SmallTalkVC()
        talk.searchModel = model
        talk.conversationType = .ConversationType_GROUP
        talk.targetId = self.targetId

        talk.isSearch = true
        let unreadCount = RCIMClient.shared().getUnreadCount(.ConversationType_GROUP, targetId: self.targetId)
        talk.unReadMessage = Int(unreadCount)
        talk.enableNewComingMessageIcon = true
        talk.enableUnreadMessageIcon = true
        
       self.navigationController?.pushViewController(talk, animated: true)
        
    }

}
