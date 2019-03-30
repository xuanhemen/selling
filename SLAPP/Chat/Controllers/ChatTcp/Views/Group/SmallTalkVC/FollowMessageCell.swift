//
//  FollowMessageCell.swift
//  SLAPP
//
//  Created by apple on 2018/9/4.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class FollowMessageCell: RCMessageCell {
    
    var titleLable = UILabel.init()
    var contentLable = UILabel.init()
    var bottomLable = UILabel.init()
    var backView = UIView.init()
    
    override class func size(for model: RCMessageModel!, withCollectionViewWidth: CGFloat, referenceExtraHeight: CGFloat) -> CGSize {
        super.size(for: model, withCollectionViewWidth: withCollectionViewWidth, referenceExtraHeight: referenceExtraHeight)
        if kScreenW <= 320 {
            myWidth = 200
        }
        let bubbleBackgroundViewSize:CGSize = ThemeMessageCell.getBubbleSize(textLabelSize: CGSize.init(width: myWidth, height: 180))
        let cont = model.content as! FollowMessageContent
        
        var allHeight : CGFloat = 10 + cont.title.getTextHeight(font: UIFont.systemFont(ofSize: 15), width: bubbleBackgroundViewSize.width - 20) + 10  + 35
        if cont.content.characters.count > 0 {
            allHeight += (cont.content.getSpaceLabelHeight(font: UIFont.systemFont(ofSize: 14), width: bubbleBackgroundViewSize.width - 20) + 10)
        }
        //        if model.isDisplayMessageTime == true{
        //            allHeight += 60
        //        }
        return CGSize.init(width: withCollectionViewWidth, height: allHeight + referenceExtraHeight)
        
    }
    class func conFigSize(model:RCMessageModel)->(CGSize){
        
        if kScreenW <= 320 {
            myWidth = 200
        }
        let bubbleBackgroundViewSize:CGSize = ThemeMessageCell.getBubbleSize(textLabelSize: CGSize.init(width: myWidth, height: 180))
        let cont = model.content as! FollowMessageContent
        
        var allHeight : CGFloat = 10 + cont.title.getTextHeight(font: UIFont.systemFont(ofSize: 15), width: bubbleBackgroundViewSize.width - 20) + 10  + 35
        if cont.content.characters.count > 0 {
            allHeight += (cont.content.getSpaceLabelHeight(font: UIFont.systemFont(ofSize: 14), width: bubbleBackgroundViewSize.width - 20) + 10)
        }
        if model.isDisplayMessageTime == true{
            allHeight += 60
        }
        return CGSize.init(width: kScreenW, height: allHeight)
    }
    
    override func setDataModel(_ model: RCMessageModel!) {
        let cont = model.content as! FollowMessageContent
        DLog("hao_____\(cont)")
        super.setDataModel(model)
        //        self.contentLable.text = cont.content
        self.contentLable.changeLineSpace(text: cont.content, space: textLineSpace)
        self.titleLable.text = cont.title
        let bubbleBackgroundViewSize:CGSize = ThemeMessageCell.getBubbleSize(textLabelSize: CGSize.init(width: myWidth, height: 180))
        let messageContentViewRect:CGRect = self.messageContentView.frame
        if .MessageDirection_RECEIVE == self.messageDirection {
            self.messageContentView.frame = CGRect(x: messageContentViewRect.origin.x, y: messageContentViewRect.origin.y, width: bubbleBackgroundViewSize.width, height: messageContentViewRect.size.height)
        }
        else{
            self.messageContentView.frame = CGRect(x: messageContentViewRect.origin.x-(bubbleBackgroundViewSize.width-messageContentViewRect.width), y: messageContentViewRect.origin.y, width: bubbleBackgroundViewSize.width, height: messageContentViewRect.size.height)
            
        }
        if kScreenW <= 320 {
            myWidth = 200
        }
        
        var allHeight : CGFloat = 10 + cont.title.getTextHeight(font: UIFont.systemFont(ofSize: 15), width: bubbleBackgroundViewSize.width - 20) + 10  + 35
        if cont.content.characters.count > 0 {
            allHeight += (cont.content.getSpaceLabelHeight(font: UIFont.systemFont(ofSize: 14), width: bubbleBackgroundViewSize.width - 20) + 10)
        }
        
        self.titleLable.frame = CGRect.init(x: 10, y: 10, width: self.messageContentView.frame.width - 20, height: cont.title.getTextHeight(font: UIFont.systemFont(ofSize: 15), width: bubbleBackgroundViewSize.width - 20))
        //文字
        self.contentLable.frame = CGRect.init(x: 10, y: 10 + self.titleLable.frame.size.height + 10, width: self.messageContentView.frame.width - 20, height: cont.content.getSpaceLabelHeight(font: UIFont.systemFont(ofSize: 14), width: bubbleBackgroundViewSize.width - 20))
        
        self.bottomLable.frame = CGRect.init(x: 10, y: allHeight - 35, width: self.messageContentView.frame.size.width - 20, height: 35)
        
        self.backView.frame = CGRect.init(x: 0, y: 0, width: self.messageContentView.frame.size.width, height: allHeight)
    }
    
    override init!(frame: CGRect) {
        DLog(frame)
        super.init(frame: frame)
        self.messageContentView.backgroundColor = UIColor.clear
        self.backView.backgroundColor = UIColor.white
        self.backView.layer.cornerRadius = 5
        self.backView.layer.masksToBounds = true
        self.messageContentView.addSubview(self.backView)
        
        self.backView.addSubview(self.titleLable)
        self.titleLable.textColor = UIColor.black
        self.backView.addSubview(self.contentLable)
        self.contentLable.textColor = UIColor.gray
        
        let longPre = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressed(sender:)))
        self.backView.addGestureRecognizer(longPre)
        let sortPre = UITapGestureRecognizer.init(target: self, action: #selector(singleTap(sender:)))
        self.backView.addGestureRecognizer(sortPre)
        
        self.titleLable.font = UIFont.systemFont(ofSize: 15)
        
        self.contentLable.font = UIFont.systemFont(ofSize: 14)
        
        self.titleLable.numberOfLines = 0
        self.contentLable.numberOfLines = 0
        
        let seperateLine = UIView.init()
        seperateLine.backgroundColor = UIColor.gray
        self.bottomLable.addSubview(seperateLine)
        seperateLine.mas_makeConstraints { (make) in
            make!.left.top().right().equalTo()(0)
            make!.height.equalTo()(0.5)
        }
        let rightArrow = UIImageView.init(image: UIImage.init(named: "theme_rightArrow"))
        self.bottomLable.addSubview(rightArrow)
        rightArrow.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.bottomLable)
            make!.right.equalTo()(-5)
            make!.size.equalTo()(CGSize.init(width: 16, height: 16))
        }
        
        self.bottomLable.font = UIFont.systemFont(ofSize: 12)
        self.bottomLable.textColor = UIColor.gray
        self.bottomLable.text = "跟进记录"
        self.backView.addSubview(self.bottomLable)
        
        //            self.messageContentView.registerFrameChangedEvent({ (conFrame) in
        //                //头像
        //                self.titleLable.frame = CGRect.init(x: 10, y: 10, width: conFrame.width - 20, height: 35)
        ////                self.titleLable.backgroundColor = UIColor.hexString(hexString: "1782D2")
        //                self.titleLable.sizeToFit()
        //                //文字
        //                self.contentLable.frame = CGRect.init(x: 10, y: 30, width: conFrame.size.width - 20, height: conFrame.size.height - 35)
        //                self.contentLable.sizeToFit()
        //            })
    }
    
    @objc func longPressed(sender:UILongPressGestureRecognizer) -> () {
        if sender.state == .ended {
            return
        }else if sender.state == .began {
            self.delegate.didLongTouchMessageCell!(self.model, in: self)
        }
    }
    @objc func singleTap(sender:UITapGestureRecognizer) -> () {
        self.delegate.didTapMessageCell!(self.model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
