
//
//  MyVoiceCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/7.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
let chatWidth:CGFloat = kScreenW-150


enum CellStatus {
    case play
    case playIng //播放中
    case pause   //暂停
    case finish
}

@objc protocol  MyVoiceViewCellDelegate {
    
    func clickPlay(cell:MyVoiceCell,model:RCMessageModel,progress:Double)
    //无效的语音
    func clickPlayAbortive(model:RCMessageModel)
}


class MyVoiceCell: RCVoiceMessageCell {

    weak var myDelegate :MyVoiceViewCellDelegate?
    lazy var myView:MyVoiceView = {
      let  my = MyVoiceView.init(frame: CGRect.init())
      return my
    }()
  
    var voiceImage:UIImageView?
    
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
            }
    
    func initialize() {

        bubbleBackgroundView = UIImageView.init(frame: CGRect.init())
        messageContentView.addSubview(bubbleBackgroundView!)
        
        if (myView.leftBtn.imageView?.isAnimating)! {
            myView.leftBtn.imageView?.stopAnimating()
        }
        myView.removeFromSuperview()
       
        messageContentView.addSubview(myView)
        myView.delegate = self
        
        
        if voiceImage == nil {
            voiceImage = UIImageView()
            voiceImage?.image = UIImage.init(named: "voiceR3")
            messageContentView.superview?.addSubview(voiceImage!)
            
                    }
        voiceImage?.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func getBubbleBackgroundViewSize(str:String) -> (CGSize)
    {
      return CGSize.init(width: 0, height: 0)
    }
    
    override func setDataModel(_ model: RCMessageModel!) {
        
        
        self.model = model
        
//        if voiceUnreadTagView != nil {
//            voiceUnreadTagView.removeFromSuperview()
//            voiceUnreadTagView = nil
//        }
        
       super.setDataModel(model)
        
        if model.receivedStatus == .ReceivedStatus_LISTENED {
            voiceUnreadTagView?.removeFromSuperview()
            voiceUnreadTagView = nil
        }
        
       self.setAutoLayout()
        
        
        
    }
    
    func setAutoLayout(){
        
        
        
        
        
        
        let bubbleBackgroundViewSize:CGSize = CGSize.init(width: lengthWithModel(), height: 40)
        var messageContentViewRect:CGRect = self.messageContentView.frame
         messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        
        
        
        if .MessageDirection_RECEIVE == self.messageDirection {
            self.messageContentView.frame = messageContentViewRect;
            self.bubbleBackgroundView?.frame = CGRect.init(x: 0, y: 0, width: bubbleBackgroundViewSize.width, height: bubbleBackgroundViewSize.height)
            
            let image:UIImage = RCKitUtility.imageNamed("chat_from_bg_normal", ofBundle: "RongCloud.bundle")
            self.bubbleBackgroundView?.image = image.resizableImage(withCapInsets: UIEdgeInsetsMake(image.size.height * 0.8, image.size.height * 0.8, image.size.height * 0.2, image.size.height * 0.2))
            
            if model.receivedStatus == .ReceivedStatus_LISTENED {
                voiceUnreadTagView?.removeFromSuperview()
                voiceUnreadTagView = nil
            }
            else{
                
                voiceUnreadTagView?.frame = CGRect.init(x:lengthWithModel()+10, y: 0, width: 10, height: 10)
            }
            
            voiceImage?.frame = CGRect.init(x:messageContentViewRect.origin.x+messageContentViewRect.width+10, y:messageContentViewRect.origin.y+10, width: 20, height: 20)
            
        }
        else
        {
            messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
            messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
            messageContentViewRect.origin.x =
                self.baseContentView.bounds.size.width -
                (messageContentViewRect.size.width + 6 +
                    RCIM.shared().globalMessagePortraitSize.width + 10);
            self.messageContentView.frame = messageContentViewRect;
            
            self.bubbleBackgroundView?.frame = CGRect.init(x: 0, y: 0, width: bubbleBackgroundViewSize.width, height: bubbleBackgroundViewSize.height)
            
            let image:UIImage = RCKitUtility.imageNamed("chat_to_bg_normal", ofBundle: "RongCloud.bundle")
            
            self.bubbleBackgroundView?.image = image.resizableImage(withCapInsets: UIEdgeInsetsMake(image.size.height * 0.8, image.size.height * 0.2, image.size.height * 0.2, image.size.height * 0.8))
            
            
            voiceImage?.frame = CGRect.init(x:messageContentViewRect.origin.x-30, y:messageContentViewRect.origin.y+10, width: 20, height: 20)
            
             self.messageFailedStatusView.superview?.frame = CGRect.init(x: (self.messageFailedStatusView.superview?.frame.origin.x)!-30, y: (self.messageFailedStatusView.superview?.frame.origin.y)!, width: self.messageFailedStatusView.frame.size.width, height: self.messageFailedStatusView.frame.size.height)
        }
        
        
        
        
        
       
        
        myView.frame =  CGRect.init(x: 0, y: 0, width: messageContentView.frame.width, height: 40)
        
        myView.congigUIWithModel(self.model)
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPre(_ :)))
        myView.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tap(_ :)))
        
        myView.addGestureRecognizer(tap)
    }
    
    
    
    /// 开始播放
    func play(){
        
        DispatchQueue.main.async { [weak self] in
            self?.myView.btnClick((self?.myView.leftBtn)!)
        }
        
        
//        self.clickPlay()
    }
    
    
    @objc func tap(_ tap:UITapGestureRecognizer){
     
        if model.messageId == shareAVManager.model?.messageId {
            if shareAVManager.isPlaying() == false {
                play()
            }
            
        }else{
        
            play()
        
        }
      
        
        
    }
    
    @objc func longPre(_ long:UILongPressGestureRecognizer){
    
        if long.state == .ended {
            return
        }else if (long.state == .began){
         delegate?.didLongTouchMessageCell!(model, in: bubbleBackgroundView)
        }
        
    }
    
  
    
    func cellStatus(status:CellStatus)
    {
        
        
        switch status {
        case .play:
//            myView.leftBtn.setImage(UIImage.init(named: "playWhite"), for: .normal)
            
        break
        
        case .playIng:
            voiceImage?.isHidden = false
            if .MessageDirection_RECEIVE == self.messageDirection{
               myView.leftBtn.setImage(UIImage.init(named: "pauseBlue"), for: .normal)
            }
            else{
               myView.leftBtn.setImage(UIImage.init(named: "pauseWhite"), for: .normal)
            }
            
            
            break
        case .pause:
            
//            myView.leftBtn.stopAnimation()
            voiceImage?.stopAnimating()
            voiceImage?.isHidden = true
            if .MessageDirection_RECEIVE == self.messageDirection{
                myView.leftBtn.setImage(UIImage.init(named: "playBlue"), for: .normal)
            }
            else{
                myView.leftBtn.setImage(UIImage.init(named: "playWhite"), for: .normal)
            }
            
            break
        case .finish:
            
//            myView.leftBtn.stopAnimation()
            voiceImage?.stopAnimating()
            voiceImage?.isHidden = true
            if .MessageDirection_RECEIVE == self.messageDirection{
                myView.leftBtn.setImage(UIImage.init(named: "playBlue"), for: .normal)
                myView.progressSlider.value = 0
            }
            else{
                myView.leftBtn.setImage(UIImage.init(named: "playWhite"), for: .normal)
                myView.progressSlider.value = 0
            }
            
            myView.timeLable.text = String.init(format: "%.1f ''", myView.number!)
            myView.currentNumber = 0.0
            break
        default: break
            
        }
        
    }
    
    
    //定时器响应
    func timeChange(){
//      DLog("************************----cell 执行timer------%p",self)
     self.myView.timerChange()
    }
    
    
    
    
    /// 根据语音消息的时间长度去视频播放器的长度
    ///
    /// - Returns: <#return value description#>
    func lengthWithModel()->(CGFloat){
    
     let voiceModel:RCVoiceMessage = self.model!.content as! RCVoiceMessage
        
     let time : CGFloat = (CGFloat((voiceModel.duration-1))/59.0)
     
        var width:CGFloat = 0.0
        if chatWidth < 240 {
            width = 240.0
        }else{
           width = chatWidth
        }
        
     return (width/2.0) + (chatWidth/2.0)*time
    }
    
    
    
    
    
    deinit {
        myView.removeFromSuperview()
       
        bubbleBackgroundView.removeFromSuperview()
    }
}


extension MyVoiceCell:MyVoiceViewDelegate{
    
    //点击了无效的文件
    func clickAbortive(){
    
       
        //        myDelegate?.clickPlay(cell: self, model: self.model)
        if model.receivedStatus != RCReceivedStatus.ReceivedStatus_LISTENED {
            model.receivedStatus = RCReceivedStatus.ReceivedStatus_LISTENED
            RCIMClient.shared().setMessageReceivedStatus(model.messageId, receivedStatus: RCReceivedStatus.ReceivedStatus_LISTENED)
            if voiceUnreadTagView != nil {
                voiceUnreadTagView.isHidden = true
            }
            
        }
        else{
            if voiceUnreadTagView != nil {
                voiceUnreadTagView.isHidden = true
            }
        }
        
         myDelegate?.clickPlayAbortive(model: self.model)

    }
    
    
    func clickPlay() {
        
        if voiceImage?.isAnimating == false {
            voiceImage?.animationStart()
            voiceImage?.isHidden = false
        }
        
        
        myDelegate?.clickPlay(cell: self, model: self.model, progress: Double(myView.currentNumber!))
//        myDelegate?.clickPlay(cell: self, model: self.model)
        if model.receivedStatus != RCReceivedStatus.ReceivedStatus_LISTENED {
           model.receivedStatus = RCReceivedStatus.ReceivedStatus_LISTENED
         RCIMClient.shared().setMessageReceivedStatus(model.messageId, receivedStatus: RCReceivedStatus.ReceivedStatus_LISTENED)
            if voiceUnreadTagView != nil {
               voiceUnreadTagView.isHidden = true
            }
        
        }
        else{
            if voiceUnreadTagView != nil {
                voiceUnreadTagView.isHidden = true
            }
        }

    }
    
    
}
