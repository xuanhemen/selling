//
//  AVPlayerManager.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/28.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import AVFoundation





/// 播放器管理对象单例
 let shareAVManager = AVPlayerManager()



class AVPlayerManager: NSObject {
   typealias finish = (_ isFinished:Bool) ->()
    typealias timeChange = () ->()
    
   var isAuto:Bool? //是否需要自动播放
   var model:RCMessageModel?
  
   /// 播放器
   var player:AVAudioPlayer?
   var timer:Timer?

   var finishBlock:finish?
   var timeChangeBlock:timeChange?
   var isOnceMore:Bool?
    
    override init() {
        super.init()
    }
    
//     func callPhone(notification:Notification){
//        
//        
//        let type:NSNumber = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as! NSNumber
//        
//        
//        if type == 1 {
//           
//            finishBlock?(false)
//            self.saveProgress(time: 1)
//            player?.stop()
//            
//            timerStop()
//        }
//        else{
//            
////           self.player?.play()
////            if self.isPlaying() {
////              self.timerStart()
////            }
//           
//        }
//    
//    }
    
    
    /// 静态方法用来停止播放  
    class func avPlayerStop(){
       shareAVManager.stopPlay()
    }
    
    //当前播放进度
    func currentProgress()->(Float){
        if player == nil {
            return 0
        }
//        if (player?.isPlaying)! {
//            return (Float)((player?.currentTime)!/(player?.duration)!)
//        }
        return (Float)((player?.currentTime)!/(player?.duration)!)
    }

    func currentTime()->(String){
        if player == nil {
            return "0:00"
        }
        
         let second = Int(round((shareAVManager.player?.currentTime)!))
        
        return ("\(second/60)"+":"+"\(second%60)")
        
        
    }
    
}

extension AVPlayerManager{
    
    

    func playAudioWithModel(progress:Double,mModel:RCMessageModel,compete:@escaping finish,action:@escaping timeChange){
        finishBlock = compete
        timeChangeBlock = action
        
        if mModel.receivedStatus != RCReceivedStatus.ReceivedStatus_LISTENED  {
                    isAuto = true
                }else{
                   isAuto = false
                }

        if isOnceMore == true {
            isAuto = true
        }
        
        let voiceModel:RCVoiceMessage = mModel.content as! RCVoiceMessage
        self.model = mModel

        
        player = try? AVAudioPlayer.init(data: voiceModel.wavAudioData)
        player?.prepareToPlay()
        player?.delegate = self
        
        if progress > 0 {
            player?.currentTime = progress
        }
        
        player?.play()
        
        timerStart()
        
        
        self.configInfraredSensing()
        //
     }
    
    
    
    
    
    
    func playUrlDataWithModel(progress:Double,mModel:RCMessageModel,compete:@escaping finish,action:@escaping timeChange){
        finishBlock = compete
        timeChangeBlock = action
        isAuto = false
        let voiceModel:ProjectVoiceMessageContent = mModel.content as! ProjectVoiceMessageContent
        self.model = mModel
        if voiceModel.url.isEmpty {
            return
        }
        DLog(voiceModel.url)
        let playData = try? Data.init(contentsOf: URL(string: voiceModel.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
        if playData == nil {
            return
        }
        DLog(playData!)
        
        do {
            player = try? AVAudioPlayer.init(data: playData!)
        } catch  {
            DLog("播放器出现错误了")
        }
        
        player?.prepareToPlay()
        player?.delegate = self
        
        if progress > 0 {
            player?.currentTime = progress
        }
        
        player?.play()
        
        timerStart()
        
        
        self.configInfraredSensing()
        //
    }
    
    
    
    
    
    
    
    
    
    func configInfraredSensing(){
    
//        let sessionCategory:UInt32 = kAudioSessionCategory_MediaPlayback
        
        
        let audionSession = AVAudioSession.sharedInstance()
        try?  audionSession.setCategory(AVAudioSessionCategoryPlayback)
        
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(stateChange), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
    }
    
    
    
    /// 传感器检测到的状态发生变化
    @objc func stateChange(){
        
        if UIDevice.current.proximityState == true {
          try?  AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        }else{
        try?  AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            if self.isPlaying() == false{
               UIDevice.current.isProximityMonitoringEnabled = false
               NotificationCenter.default.removeObserver(self)
            }
            
        }
    
    }
    
    
    
    func stopPlay(){
       isOnceMore = false
        if self.isPlaying() {
            player?.stop()
//            self.saveProgress(time: 1)
            timerStop()
            finishBlock?(false)
//            finishBlock = nil
//            timeChangeBlock = nil
            NotificationCenter.default.removeObserver(self)
            UIDevice.current.isProximityMonitoringEnabled = false
        }
        
    
    }
    
    
    func startPlay(){
        isOnceMore = false
        if self.player != nil {
            player?.play()
            
            timerStart()
//            finishBlock?(false)
//            finishBlock = nil
//            timeChangeBlock!()
//            NotificationCenter.default.removeObserver(self)
//            UIDevice.current.isProximityMonitoringEnabled = false
             self.configInfraredSensing()
        }
        
        
    }
    
    
    func oncePlay(){
        isOnceMore = true
        player?.stop()
        self.saveProgress(time: 1)
        timerStop()
        finishBlock = nil
        timeChangeBlock = nil
    }
    
    
    func isPlaying()->(Bool){
    
        if player != nil {
            return player!.isPlaying
        }
    
        return false
    }
    
    
    func timerStart(){
        
        if self.timer != nil
        {
            timer?.fireDate = Date.distantPast
            timer?.fire()
        }
        else
        {
          timer = Timer(timeInterval: 0.1, target: self, selector: #selector(timerChange), userInfo: nil, repeats: true)
          RunLoop.current.add(self.timer!, forMode: .commonModes)
          self.timer?.fire()
        }

        
    }
    
    func timerStop(){
      timer?.fireDate = Date.distantFuture
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.isProximityMonitoringEnabled = false
//    timer?.invalidate()
//    timer = nil
    }
    
    @objc  func timerChange(){
       
       timeChangeBlock?()
    }
    
    
    
    
    func saveProgress(time:Double){
        
        guard model != nil else {
            return
        }
        let progressModel = AVPlayerProgressModel()
        progressModel.messageId = String((model?.messageId)!)
        if time != 0 {
            
            if self.player?.currentTime != nil{
            progressModel.progress = (self.player?.currentTime)!
            }
        }
        else{
            progressModel.progress = 0
        }
        
        DispatchQueue.main.async {
             DataBaseOperation.addData(rlmObject: progressModel)
        }
       
        
        
    }

}



extension AVPlayerManager:AVAudioPlayerDelegate{

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        player.stop()
        timerStop()
        self.saveProgress(time: 1)
      
         finishBlock?(true)
        
        
//        DLog("播放完了++++++++++++++++++++")
       
//        finishBlock = nil
//        timeChangeBlock = nil
        
        }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        player.stop()
        self.saveProgress(time: 0)
        timerStop()
        finishBlock?(false)
        finishBlock = nil
        timeChangeBlock = nil
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "avFinish"), object: [self.model])
        
    }
    
    
}






