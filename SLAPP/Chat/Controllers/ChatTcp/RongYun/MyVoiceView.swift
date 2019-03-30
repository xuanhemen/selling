
//
//  MyVoiceView.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/7.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol MyVoiceViewDelegate {
    func clickPlay()
    //点击了无效的语音文件
    func clickAbortive()
//    func currentTime(_ timeStr:String)
}

class MyVoiceView: UIView {

    

    weak var delegate:MyVoiceViewDelegate?
    var model:RCMessageModel?
    var isPan:Bool?
    
    lazy var leftBtn : UIButton = {
    let btn = UIButton.init(type: .custom)
    return btn
    }()
    
    
   lazy var progressSlider:UISlider = {
      let s = UISlider.init()
      return s
    }()
    
    var number:Float?
    var currentNumber:Float?
    
   lazy var timeLable:UILabel = {
     
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textAlignment = .center
        return lable
    
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftBtn)
         addSubview(progressSlider)
//        NotificationCenter.default.addObserver(self, selector: #selector(avfinish), name: NSNotification.Name(rawValue: "avFinish"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(avStart), name: NSNotification.Name(rawValue: "avStart"), object: nil)
        
     
     
      
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
   
    
    

    
    /// 根据传入的消息model 初始化UI
    ///
    /// - Parameter model: 消息模型
    func congigUIWithModel(_ model:RCMessageModel) {
        
        
      
      self.model = model
    
      leftBtn.removeFromSuperview()
      progressSlider.removeFromSuperview()
      timeLable.removeFromSuperview()
        
        
        
        addSubview(leftBtn)
        leftBtn.addTarget(self, action: #selector(btnClick(_ :)), for: .touchUpInside)
        
        addSubview(progressSlider)
        progressSlider.maximumValue = 1.0;
        progressSlider.minimumValue = 0.0;
        progressSlider.isContinuous = true
        currentNumber = 0
        progressSlider.value = currentNumber!
        
        addSubview(timeLable)
//        timeLable.text = "59.9''"
      //根据消息方向去初始化界面
        
      timeLable.frame = CGRect(x: self.frame.width-50, y: 0, width: 50, height: 40)
      if model.messageDirection == .MessageDirection_RECEIVE {
       
        leftBtn.frame = CGRect.init(x:0 , y: 0, width: 40, height: 40)
        progressSlider.frame = CGRect.init(x:41, y: 0, width:self.frame.width-90 , height: 40)
//        leftBtn.frame = CGRect.init(x: 10, y: 5, width: 30, height: 30)
//         addSubview(leftBtn)
//        leftBtn.addTarget(self, action: #selector(btnClick(_ :)), for: .touchUpInside)
        leftBtn.setImage(UIImage.init(named: "playBlue"), for: .normal)
        leftBtn.setImage(UIImage.init(named: "playBlue"), for: .selected)
        leftBtn.setImage(UIImage.init(named: "playBlue"), for: .highlighted)
//        progressSlider.frame = CGRect.init(x:40, y: 0, width:self.frame.width-50 , height: 40)
//        addSubview(progressSlider)
//        progressSlider.maximumValue = 1.0;
//        progressSlider.minimumValue = 0.0;
//        progressSlider.isContinuous = true
//        currentNumber = 0
//        progressSlider.value = currentNumber!
        progressSlider.setThumbImage(UIImage.init(named: "slider"), for: .normal)
         progressSlider.tintColor = UIColor.hexString(hexString: "1681e1")
        self.configCurrentTime()
        self.synchronousUIWithPlayer(isMy: false)
        
    }
    else
    {
    
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
       progressSlider.frame = CGRect.init(x:41, y: 0, width:self.frame.width-90 , height: 40)
//        leftBtn.frame = CGRect.init(x:self.frame.size.width-40 , y: 5, width: 30, height: 30)
//        addSubview(leftBtn)
//        leftBtn.addTarget(self, action: #selector(btnClick(_ :)), for: .touchUpInside)
        leftBtn.setImage(UIImage.init(named: "playWhite"), for: .normal)
        leftBtn.setImage(UIImage.init(named: "playWhite"), for: .selected)
        leftBtn.setImage(UIImage.init(named: "playWhite"), for: .highlighted)
//        progressSlider.frame = CGRect.init(x:10, y: 0, width:self.frame.width-50 , height: 40)
//        progressSlider.maximumValue = 1.0;
//        progressSlider.minimumValue = 0.0;
//        progressSlider.isContinuous = true
//        currentNumber = 0
//        progressSlider.value = 1-currentNumber!
        progressSlider.setThumbImage(UIImage.init(named: "sliderWhite"), for: .normal)
        progressSlider.tintColor = UIColor.white
//        addSubview(progressSlider)
//        progressSlider.addTarget(self, action: #selector(sliderChange(_ :)), for: .valueChanged)
        
        
        
        
        self.configCurrentTime()
        self.synchronousUIWithPlayer(isMy: true)
    }
        
     progressSlider.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:))))
        
        if currentNumber != 0 {
            if model.messageDirection == .MessageDirection_RECEIVE {
                leftBtn.setImage(UIImage.init(named: "playBlue"), for: .normal)
                leftBtn.setImage(UIImage.init(named: "playBlue"), for: .selected)
                leftBtn.setImage(UIImage.init(named: "playBlue"), for: .highlighted)
            }else{
                
                leftBtn.setImage(UIImage.init(named: "playWhite"), for: .normal)
                  leftBtn.setImage(UIImage.init(named: "playWhite"), for: .selected)
            }

        }
//    shareAVManager.configPlayerWith(data: self.model!)
}
    
    
    
    
    //根据消息来确定当前应该显示的时间
    func configCurrentTime(){
        let voiceModel:RCVoiceMessage = self.model!.content as! RCVoiceMessage
        let predicate = NSPredicate.init(format: "messageId == %@",String((self.model?.messageId)!))
        timeLable.text = String.init(format: "%.1f ''", Float(voiceModel.duration))
        
        let proModelSets = AVPlayerProgressModel.objects(with: predicate)
        if proModelSets.count != 0 {
            
            self.currentNumber = Float((proModelSets.firstObject() as! AVPlayerProgressModel).progress)
            let surplusTime = Float(voiceModel.duration) - self.currentNumber!
//            delegate?.currentTime(String.init(format: "%.1f''", surplusTime))
            
            timeLable.text = String.init(format: "%.1f ''", abs(surplusTime))
            self.progressSlider.value = self.currentNumber!/Float(voiceModel.duration)
//          if self.model?.messageDirection == .MessageDirection_RECEIVE
//          {
//            self.progressSlider.value = self.currentNumber!/Float(voiceModel.duration)
//          }
//          else{
//            self.progressSlider.value = 1.0 - self.currentNumber!/Float(voiceModel.duration)
//            }
        }
        else{
            
            timeLable.text = String.init(format: "%.1f ''", Float(voiceModel.duration))
//            delegate?.currentTime(String(Float(voiceModel.duration)))
        }
        number = Float(voiceModel.duration)
    }
    
    /// 同步当前UI与播放器的播放进度
    /////当当前cell滑出屏幕的时候  播放器仍然在播放   再一次创建cell的时候  需要将UI进度与播放器进度同步
    /// - Parameter isMy: 消息分方向   和自己发送的方向相同传True
    func synchronousUIWithPlayer(isMy:Bool){
    
        if shareAVManager.isPlaying() {
            guard  (shareAVManager.model?.messageId)! == model?.messageId else {
                return
            }
            
                let voiceModel:RCVoiceMessage = model!.content as! RCVoiceMessage
                self.currentNumber = Float((shareAVManager.player?.currentTime)!)
                var surplusTime = Float(voiceModel.duration) - self.currentNumber!
                if surplusTime < 0 {
                    surplusTime = 0
                }
            
            timeLable.text = String.init(format: "%.1f ''", surplusTime)
//                delegate?.currentTime(String.init(format: "%.1f''", surplusTime))
//                shareAVManager.stopPlay()
                
                if isMy == true {
                   self.progressSlider.value =  1.0 - self.currentNumber!/Float(voiceModel.duration)
                }
                else{
                self.progressSlider.value = self.currentNumber!/Float(voiceModel.duration)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.start()
                    DLog("当前播放调用了 *************** 重新开始")
                }
                
                
            
            
        }

    }
    
    
    
    
    
    
    
    //MARK: - ---------------------播放器  播放  暂停  相关处理----------------------
    //做暂停处理
    func pause(){
     
        shareAVManager.stopPlay()
        
        if model?.messageDirection == .MessageDirection_RECEIVE {
            leftBtn.setImage(UIImage.init(named: "playBlue"), for: .normal)
            leftBtn.setImage(UIImage.init(named: "playBlue"), for: .selected)
            
        }else{
            
            leftBtn.setImage(UIImage.init(named: "playWhite"), for: .normal)
            leftBtn.setImage(UIImage.init(named: "playWhite"), for: .selected)
        }
    }
    
    
    //开始播放处理
    func start(){
    
//        if (leftBtn.imageView?.isAnimating)! {
//            leftBtn.imageView?.stopAnimating()
//        }
//        
//        if model?.messageDirection == .MessageDirection_RECEIVE {
//            leftBtn.animationStartWith(str: "voiceR")
//            
//        }else{
//            leftBtn.animationStartWith(str: "voiceL")
//        }
        
        
        
        let voiceModel:RCVoiceMessage = model!.content as! RCVoiceMessage
        
        guard voiceModel.wavAudioData != nil else {
            
            delegate?.clickAbortive()
            return
        }
        
        
        if model?.messageDirection == .MessageDirection_RECEIVE {
            leftBtn.setImage(UIImage.init(named: "pauseBlue"), for: .normal)
            leftBtn.setImage(UIImage.init(named: "pauseBlue"), for: .selected)
            
        }else{
            
            leftBtn.setImage(UIImage.init(named: "pauseWhite"), for: .normal)
            leftBtn.setImage(UIImage.init(named: "pauseWhite"), for: .selected)
        }

        
        delegate?.clickPlay()
  
    }
    
    //继续播放
    func continuePlay(){
        start()
    }
    
    
    
    
    //MARK: - ---------------------按钮点击 滑块相关处理----------------------
    @objc func btnClick(_ btn:UIButton)
    {
        if shareAVManager.isPlaying() == true {
           //正在播放  有两种情况  播放自己   播放别的
           
            if self.model != shareAVManager.model {
            //正在播放的是别人  做暂停处理  并要保存别人的进度  开始播放自己
               self.start()
            }
            else{
            //正在播放的是自己  要做暂停处理
                self.pause()
                
            }
            
            
        }
        else{
            if self.model != shareAVManager.model {
               //播放没有播放或者处于播放其他语音的暂停状态
                self.start()
            }
            else{
               //当前播放器语音信息是自己的
                self.continuePlay()
            
            }
         }
}
    
    @objc func panGesture(pan : UIPanGestureRecognizer)  {
    
       if pan.state == .began {
        
        isPan = true
        
       }
    
        let point = pan.location(in: progressSlider)
        let touch_X = point.x
        // 相对于slider的比例
        var value = touch_X / (progressSlider.frame.size.width)
       if value > 1{
          value = 1
       }
    
       if value < 0 {
           value = 0
        }
        progressSlider.value = Float(value)
    
    if pan.state == .ended {
        
        isPan = false
        self.currentNumber = self.number! * progressSlider.value
//        if model?.messageDirection == .MessageDirection_RECEIVE {
//            self.currentNumber = self.number! * progressSlider.value
//        }else{
//            self.currentNumber = self.number! * (1-progressSlider.value)
//        }
        if self.currentNumber! >= self.number!{
            self.currentNumber = self.number!
        }
        start()
        
    }
    
    }

    
    
    
    
    
    
  func timerChange(){
    
    if isPan == true{
      return
    }
    
        if self.model?.messageId != shareAVManager.model?.messageId
        {
          return
        }
    
        self.currentNumber! = Float((shareAVManager.player?.currentTime)!)
        if self.currentNumber! >= self.number!{
            self.currentNumber = self.number!
        }
        timeLable.text = String.init(format: "%.1f ''", (abs( self.number!-self.currentNumber!)))
//        self.delegate?.currentTime(String.init(format: "%.1f''",(self.number!-self.currentNumber!)))
    
        self.progressSlider.value = self.currentNumber!/self.number!
//        if self.model?.messageDirection == .MessageDirection_RECEIVE {
//         self.progressSlider.value = self.currentNumber!/self.number!
//        }
//        else{
//           self.progressSlider.value = 1.0 - self.currentNumber!/self.number!
//        }
    }
    
    
    
    deinit {
        
        
//        if (leftBtn.imageView?.isAnimating)!{
//        leftBtn.stopAnimation()
//            if model?.messageDirection == .MessageDirection_RECEIVE {
//                leftBtn.setImage(UIImage.init(named: "pauseBlue"), for: .normal)
//                leftBtn.setImage(UIImage.init(named: "pauseBlue"), for: .selected)
//            }else{
//                
//                leftBtn.setImage(UIImage.init(named: "pauseWhite"), for: .normal)
//                leftBtn.setImage(UIImage.init(named: "pauseBlue"), for: .selected)
//            }
//
//        }
        NotificationCenter.default.removeObserver(self)
    }
    
    
    }
    
    







