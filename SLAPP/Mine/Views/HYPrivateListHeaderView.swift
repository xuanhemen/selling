//
//  HYPrivateListHeaderView.swift
//  SLAPP
//
//  Created by apple on 2018/11/28.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit

class HYPrivateListHeaderView: UIView {
    let search = RCDSearchBar.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
    
//    存放cell 的数组
    var subCellArray:Array<GroupListCell> = Array()
    
//    cell 点击后的闭包响应
    var cellClickWithTargetId:(_ id:String,_ name:String)->() = { (id,name) in
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.groupTableViewBackground
        self.configUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configUI(){
        
        self.addSubview(search)
        
         /// 约定好的一些系统消息类型
        let targetIdArray = ["systemAtMessage","systemCommentMessage","systemPraiseMessage","system2"]
        let imageArray = ["tome","commenticon","praiseicon","consult_message_ico"]
        let titleArray = ["@我的","评论","赞","在线辅导"]
        for i in 0..<4 {
            let cell = GroupListCell.init(style: .default, reuseIdentifier: "cell")
            cell.backgroundColor = UIColor.white
            cell.frame = CGRect.init(x: 0, y: 44+65*i, width: Int(kScreenW), height: 65);
            cell.headerImageView.image = UIImage.init(named: imageArray[i])
            cell.nameLabel.text = titleArray[i]
            cell.detailLabel.text = "暂时没有收到该类消息"
            let line = UIView.init(frame: CGRect(x: 15, y: 65-0.3, width: kScreenW-15, height: 0.3))
            cell.addSubview(line)
            line.backgroundColor = UIColor.groupTableViewBackground
            self.addSubview(cell)
            cell.customTargetId = targetIdArray[i]
            subCellArray.append(cell)
            cell.badgeLb.isHidden = true
            
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 65)
            cell.addSubview(btn)
            btn.addTarget(self, action: #selector(btnClick(btn: )), for: .touchUpInside)
        }
    }
    
    
    
    @objc func btnClick(btn:UIButton){
        if btn.superview!.isKind(of: GroupListCell.self) {
            let cell:GroupListCell = btn.superview as! GroupListCell
            self.cellClickWithTargetId(cell.customTargetId,cell.nameLabel.text!)
        }
        
    }
    
    /// 刷新系统消息相关的数据
    func refresh(){
        
        for cell in subCellArray {
            DispatchQueue.global(qos: .default).async
         {
//               查询该回话类型对应的最新的一条消息
                let subArray = RCIMClient.shared().getLatestMessages(RCConversationType.ConversationType_SYSTEM, targetId: cell.customTargetId, count: 1)
                if !(subArray?.isEmpty)!
                {
                    let model:RCMessage = subArray!.first! as! RCMessage;
                    if model.content .isKind(of: RCTextMessage.self)
                    {
                        DispatchQueue.main.async {
                            cell.detailLabel.text = (model.content as! RCTextMessage).content
                        }
                        
                    }
                    
                    
                    DispatchQueue.global(qos: .default).async{
//                        查询未读数
                        if(RCIMClient.shared().getUnreadCount(RCConversationType.ConversationType_SYSTEM, targetId: cell.customTargetId) == 0){
                            DispatchQueue.main.async {
                                cell.badgeLb.isHidden = true
                            }
                        }else{
                            DispatchQueue.main.async {
                                cell.badgeLb.isHidden = false
                            }
                        }
                    }
                    
                    
                    
                        
                 }
            

         }
        
        
    }
 }
    
}
