//
//  GroupListCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/1.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
private let headerImageViewWidth : CGFloat = 44.0
class GroupListCell: RCConversationBaseCell {

//    系统消息自定义的id
    var customTargetId:String = ""
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(headerImageView)
        self.contentView.addSubview(badgeLb)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(detailLabel)

        headerImageView.mas_makeConstraints { (make) in
            make!.top.left().equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize(width: headerImageViewWidth, height: headerImageViewWidth))
        }
        nameLabel.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.headerImageView)
            make!.left.equalTo()(self.headerImageView.mas_right)!.offset()(LEFT_PADDING)
            make!.right.equalTo()(self.timeLabel.mas_left)!.offset()(-LEFT_PADDING)
        }
        timeLabel.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.headerImageView)
            make!.right.equalTo()(-LEFT_PADDING)
        }
        detailLabel.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.nameLabel)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.bottom.equalTo()(self.headerImageView)
        }
    }
    override var model: RCConversationModel!{
        didSet {
            self.backgroundColor = model.isTop ? model.topCellBackgroundColor : model.cellBackgroundColor

            self.headerImageView.sd_setImage(with: NSURL.init(string: model.extend != nil ? model.extend as! String : " ") as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
//            self.headerImageView.badgeCenterOffset = CGPoint(x : -2, y : 0)
            
            let groupIdArr : Array<String> = GroupModel.objects(with: NSPredicate.init(format: "parentid == %@", model.targetId)).value(forKeyPath: "groupid") as! Array<String>
            var subGroupMesTotalCount : Int32? = 0
            for targetId in groupIdArr {
                subGroupMesTotalCount = subGroupMesTotalCount! + RCIMClient.shared().getUnreadCount(.ConversationType_GROUP, targetId: targetId)
            }
            if model.unreadMessageCount > 0 || subGroupMesTotalCount! > 0{
//                self.headerImageView.showBadge()
                self.badgeLb.isHidden = false
            }else{
//                self.headerImageView.clearBadge()
                self.badgeLb.isHidden = true
            }
            
            if model.sentTime == 0 {
                self.timeLabel.text = ""
            }else{
                let target : Date = Date.init(timeIntervalSince1970: TimeInterval(model.sentTime / 1000))
                self.timeLabel.text = self.convertDate(date: target)
            }
            self.timeLabel.sizeToFit()
            timeLabel.mas_updateConstraints { [unowned self](make) in
                make!.width.equalTo()(self.timeLabel.frame.size.width)
            }

            self.nameLabel.text = model.conversationTitle
            
            if model.objectName.characters.count > 0 {
                var unreadMessageCountStr : String?
                if model.unreadMessageCount > 1 {
                    unreadMessageCountStr = model.unreadMessageCount > 99 ? "[99条+]" : "[\(model.unreadMessageCount)条]"
                }else{
                    unreadMessageCountStr = ""
                }
                
                var lastSender : String?
                if model.senderUserId == sharePublicDataSingle.publicData.im_userid {
                    lastSender = nil
                }else if model.senderUserId.contains("system"){
                    lastSender="[系统]"
                }else{
                    let groupUserModel = GroupUserModel.objects(with: NSPredicate.init(format:"im_userid == %@ AND is_delete == '0'", model.senderUserId)).firstObject() as? GroupUserModel
                    if groupUserModel != nil {
                        let userModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", (groupUserModel?.userid)!)).firstObject() as! UserModelTcp?
                        
                        lastSender = userModel?.realname
                    }
                }
                var msg : String? = RCKitUtility.formatMessage(model.lastestMessage)
                if model.objectName == RCGroupNotificationMessageIdentifier {
                    let notModel:RCGroupNotificationMessage = model.lastestMessage as! RCGroupNotificationMessage
                    if notModel.operation == GroupNotificationMessage_GroupOperationAdd || notModel.operation == GroupNotificationMessage_GroupOperationKicked {
                        
                        if notModel.message.contains(sharePublicDataSingle.publicData.realname) {
                            msg = notModel.message.replacingOccurrences(of: sharePublicDataSingle.publicData.realname, with: "你")

                        }  else {
                            msg = notModel.message
                        }
                    }
                }
                if model.objectName == RCRecallNotificationMessageIdentifier && lastSender != nil{
                    msg = lastSender! + "撤回了一条消息"
                    lastSender = nil
                }
                if msg == nil {
                    msg = ""
                }
                let detailText  = unreadMessageCountStr! + (model.hasUnreadMentioned ? "[有人@我]" : "") as String + (lastSender == nil ? "" : (lastSender! + " : ")) + msg!

                let attrText = NSMutableAttributedString.init(string: detailText)
                if model.hasUnreadMentioned {
                    let range : Range = detailText.range(of: "[有人@我]")!
                    let nsrange = detailText.nsRange(from: range)
                    attrText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.red], range: nsrange!)
                }
                self.detailLabel.attributedText = attrText

            }
        }
    }
    func convertDate(date:Date) -> String {
        if Date.isToday(target: date) {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }else if Date.isLastDay(target: date) {
            return "昨天"
        }else if Date.isOneWeek(target: date) {
            return Date.weekWithDateString(target: date)
        }else{
            return Date.formattDay(target: date)
        }
    }
    class func cell(withTableView tableView: UITableView) -> GroupListCell {
//        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: self)) as? GroupListCell
//        if cell == nil {
//            cell = GroupListCell.init(style: .default, reuseIdentifier: String(describing: self))
//            cell?.selectionStyle = .none
//        }
        let cell = GroupListCell.init(style: .default, reuseIdentifier: String(describing: self))
        cell.selectionStyle = .none

        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Getter and Setter
    //头像
    lazy var headerImageView: StitchingImageView = {
        var headerImageView = StitchingImageView.init(frame: CGRect(x: 0, y: 0, width: headerImageViewWidth, height: headerImageViewWidth))
        headerImageView.layer.cornerRadius = 4.0
        headerImageView.clipsToBounds = true
        headerImageView.layer.borderColor = UIColor.hexString(hexString: headerBorderColor).cgColor
        headerImageView.layer.borderWidth = 0.5
        return headerImageView
    }()
    //badgeView
    lazy var badgeLb: UILabel = {
        var badgeLb = UILabel.init()
        badgeLb.frame = CGRect.init(x: LEFT_PADDING+headerImageViewWidth - 4, y: LEFT_PADDING - 4, width: 8, height: 8)
        badgeLb.layer.cornerRadius = 4
        badgeLb.layer.masksToBounds = true
        badgeLb.backgroundColor = UIColor.red
        return badgeLb
    }()
    //名称
    lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = FONT_14
        nameLabel.textColor = UIColor.black
        return nameLabel
    }()
    
    //时间
    lazy var timeLabel: UILabel = {
        var timeLabel = UILabel()
        timeLabel.font = FONT_14
        timeLabel.textColor = UIColor.lightGray
        timeLabel.sizeToFit()
        return timeLabel
    }()
    
    //内容
    lazy var detailLabel: UILabel = {
        var detailLabel = UILabel()
        detailLabel.font = FONT_14
        detailLabel.textColor = UIColor.lightGray
        return detailLabel
    }()
   
}
