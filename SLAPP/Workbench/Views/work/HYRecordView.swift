//
//  HYRecordView.swift
//  SLAPP
//
//  Created by qwp on 2018/9/13.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit
import AVFoundation
import LameTool

class HYRecordView: UIView {
    
    @objc weak var target:WorkbenchVC?
    
    let viewMargin : CGFloat = 20
    
    var typeDataArr : Array<Any>?//一级数据
    var detailDataArr : Array<Any>?//二级数据
    
    //MARK: - ---------------------录音----------------------
    /// 文件保存地址
    var recordFilePatch = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! + "/RRecord.mav"
    var recordMp3FilePatch = ""
    /// 录音最大时间
    let maxRecordTime = 60
    
    /// 录音实体
    var recorder:AVAudioRecorder? = nil
    
    var player: AVAudioPlayer?
    
    var recordView:RecordView? = nil
    
    var saveRecordView : SaveRecordView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let btn = UIButton()
        self.startRecord(sender: btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //点击完成
    fileprivate func clickFirstMenu(_ btn: UIButton , saveRecordView:SaveRecordView) {
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: RECORDING_SECOND_SELECT, params: ["type":(self.typeDataArr![btn.tag] as AnyObject).value(forKeyPath: "id") as Any ,"token":UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
            PublicMethod.dismiss()
            if dic["data"] is Array<Any>{
                self.detailDataArr = dic["data"] as? Array<Any>
                if self.detailDataArr?.count == 0 {
                    let alert = UIAlertController.init(title: "已经没有下级菜单，是否直接保存", message: nil, preferredStyle: UIAlertControllerStyle.alert, okAndCancel: ("保存", "取消"), btnActions: { (action, key) in
                        if key == "ok" {
                            self.stopRecord()
                            self.sendData(type: (self.typeDataArr![btn.tag] as AnyObject).value(forKeyPath: "id") as Any, id: "0", name: (self.typeDataArr![btn.tag] as AnyObject).value(forKeyPath: "name") as Any, filePath: self.recordMp3FilePatch, duration: self.recDuration)
                        }
                    })
                    self.detailDataArr = nil
                    self.target?.present(alert, animated: true, completion: nil)
                    return
                }
                self.recType = (self.typeDataArr![btn.tag] as AnyObject).value(forKeyPath: "id") is NSNumber ? String(describing: (self.typeDataArr![btn.tag] as AnyObject).value(forKeyPath: "id") as! NSNumber) : (self.typeDataArr![btn.tag] as AnyObject).value(forKeyPath: "id") as! String
                var nameArr : Array<String> = Array.init()
                for i in 0..<(dic["data"] as! Array<Any>).count{
                    
                    nameArr.append(((dic["data"] as! Array<Any>)[i] as AnyObject).value(forKeyPath: "name") as! String)
                }
                saveRecordView.scrollTodetailView(detailArr: nameArr)
            }else{
                self.detailDataArr = nil
                self.stopRecord()
                self.sendData(type: (self.typeDataArr![btn.tag] as AnyObject).value(forKeyPath: "id") as Any, id: "0", name: (self.typeDataArr![btn.tag] as AnyObject).value(forKeyPath: "name") as Any, filePath: self.recordMp3FilePatch, duration: self.recDuration)
            }
        }
    }
    var timer:Timer? = nil
    var recType = ""
    var recParallelism_id = ""
    var recParallelism_name = ""
    var recDuration = "0"
    
    
    fileprivate func clickFinish() {
        if (self.recorder?.isRecording)! {
            self.pauseRecord()
            PublicMethod.showProgressWithStr(statusStr: "正在获取菜单")
            LoginRequest.getPost(methodName: RECORDING_FIRST_SELECT, params: ["token":UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
                PublicMethod.dismiss()
            }) { (dic) in
                if dic["data"] is Array<Any>{
                    self.typeDataArr = dic["data"] as? Array<Any>
                    var nameArr : Array<String> = Array.init()
                    for i in 0..<(dic["data"] as! Array<Any>).count{
                        nameArr.append(((dic["data"] as! Array<Any>)[i] as AnyObject).value(forKeyPath: "name") as! String)
                    }
                    self.saveRecordView = SaveRecordView.init(modelArr: nameArr, frame : CGRect(x: 0, y: 0, width: self.width, height: self.height))
                    self.saveRecordView?.moduleBtnClickBlock = ({ (btn) in
                        self.clickFirstMenu(btn,saveRecordView: self.saveRecordView!)
                    })
                    self.saveRecordView?.saveBtnClickBlock = ({ [weak self](moduleIndex,detailIndex) in
                        let id = self?.detailDataArr == nil ? "" : (self?.detailDataArr![detailIndex!] as AnyObject).value(forKeyPath: "id") as Any
                        let name = self?.detailDataArr == nil ? (self!.typeDataArr![moduleIndex!] as AnyObject).value(forKeyPath: "name") as Any : (self?.detailDataArr![detailIndex!] as AnyObject).value(forKeyPath: "name") as Any
                        self?.stopRecord()
                        
                        self?.sendData(type: self?.recType, id: id, name: name, filePath: (self?.recordMp3FilePatch)!, duration: (self?.recDuration)!)
                        
                    })
                    
                    self.saveRecordView?.cancleBtnClickBlock = {btn in
                        self.stopRecord()
                        self.recordView?.removeFromSuperview()
                        self.saveRecordView?.removeFromSuperview()
                        self.recordView = nil
                        self.removeFromSuperview()
                    }
                    
                    self.addSubview(self.saveRecordView!)
                    self.bringSubview(toFront: self.recordView!)
                }
                PublicMethod.dismiss()
                DLog(dic)
            }
            recordView?.controlBtn.backgroundColor = .black
            recordView?.controlBtn.setTitleColor(.white, for: UIControlState.normal)
            recordView?.progressView.waveColor = .black
            recordView?.timeLable.textColor = .black
            recordView?.backgroundColor = .white
            
        }else{
            self.recorder?.record()
            timer?.fireDate = Date.distantPast
            self.saveRecordView?.removeFromSuperview()
            self.saveRecordView = nil
            
            recordView?.controlBtn.backgroundColor = .white
            recordView?.controlBtn.setTitleColor(.red, for: UIControlState.normal)
            recordView?.progressView.waveColor = .white
            recordView?.timeLable.textColor = .white
            recordView?.backgroundColor = .orange
        }
    }
    
    func normalizedPowerLevelFromDecibels(decibels:Float) -> Float {
        if decibels < -60 || decibels == 0 {
            return 0
        }
        return powf((powf(10.0, 0.05 * decibels) - powf(10, 0.05 * -60.0)) * (10.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 4.0)
    }
    
    @objc func updateMeters() {
        
        if recorder == nil {
            return
        }
        recorder?.updateMeters()
        let normalizedValue = self.normalizedPowerLevelFromDecibels(decibels: (recorder?.averagePower(forChannel: 0))!)
        recordView?.progressView.update(withLevel: CGFloat(normalizedValue))
    }
    /// 开始录音方法
    ///
    /// - Parameter sender: 按钮
    @objc func startRecord(sender:UIButton){
        
        self.umAnalyticsWithName(name: um_recordStart)
        
        if recordView != nil{return}
        recDuration = "0"
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (ti) in
            self.recDuration = String(Int(self.recDuration)! + 1)
            let first = (String(Int(self.recDuration)!/60).count > 1) ? String(Int(self.recDuration)!/60) : ("0" + String(Int(self.recDuration)!/60))
            let second = (String(Int(self.recDuration)!%60).count > 1) ? String(Int(self.recDuration)!%60) : ("0" + String(Int(self.recDuration)!%60))
            self.recordView?.timeLable.text = first + ":" + second
        })
        recordView = RecordView.init(frame: CGRect.init(x: 15, y: MAIN_SCREEN_HEIGHT - TAB_HEIGHT - 70 - NAV_HEIGHT, width: MAIN_SCREEN_WIDTH - 30, height: 60))
        var displaylink = CADisplayLink.init(target: self, selector: #selector(updateMeters))
        displaylink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        self.addSubview(recordView!)
        
        recordView?.controlBtnClickBlock = ({ (btn) in
            self.clickFinish()
        })
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err{
            DLog("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            DLog("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 32000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: recordFilePatch)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder?.isMeteringEnabled = true
            recorder!.record()
            DLog("开始录音")
        } catch let err {
            DLog("录音失败:\(err.localizedDescription)")
        }
    }
    
    /// 暂停录音
    @objc func pauseRecord(){
        recorder?.pause()
        timer?.fireDate = Date.distantFuture
    }
    /// 停止录音
    @objc func stopRecord() {
        timer?.invalidate()
        timer = nil
        if let recorder = self.recorder {
            if recorder.isRecording {
                DLog("正在录音，马上结束它，文件保存到了：\(recordFilePatch)")
            }else {
                DLog("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            DLog("没有初始化")
        }
        recordMp3FilePatch = LameTool.audio(toMP3: recordFilePatch, isDeleteSourchFile: false)
    }
    @objc func playRecord() {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: recordMp3FilePatch))
            DLog("歌曲长度：\(player!.duration)")
            player!.play()
        } catch let err {
            DLog("播放失败:\(err.localizedDescription)")
        }
    }
    
    //上传录音
    func sendData(type:Any,id:Any,name:Any,filePath:String,duration:String){
        let data:Data = try! Data.init(contentsOf: URL.init(fileURLWithPath: filePath), options:.alwaysMapped)
        let params = ["token":UserModel.getUserModel().token,"type":type,"parallelism_id":id,"parallelism_name":name,"duration":String(Double(duration)!*1000)]
        PublicMethod.showProgressWithStr(statusStr: "上传录音中")
        LoginRequest.postRecordWith(params: params as! Dictionary<String, Any>, data: data, url: passport+SEND_RECORD, hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
            DLog(dic)
            PublicMethod.dismiss()
            let recId = dic["id"]
            PublicMethod.showProgressWithStr(statusStr: "获取标签中")
            LoginRequest.getPost(methodName: RECORD_LABEL, params: [kToken:UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
                DLog(dic)
                PublicMethod.dismissWithError()
            }, success: { (dic) in
                DLog(dic)
                PublicMethod.dismiss()
                var labels = Array<String>()
                for label in dic["data"] as! Array<Dictionary<String,Any>>{
                    labels.append(String.noNilStr(str: label["label"]!))
                }
                let  addrec = AddRecordTagView.init(modelArr: labels, frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
                self.addSubview(addrec)
                
                self.saveRecordView?.removeFromSuperview()
                self.saveRecordView = nil
                self.recordView?.removeFromSuperview()
                self.recordView = nil
                addrec.skipBtnClickBlock = {
                    addrec.removeFromSuperview()
                    let alert = UIAlertController.init(title: "录音已保存，您可以在【我的】里的【语音备忘录】中查看", message: nil, preferredStyle: UIAlertControllerStyle.alert, okAndCancel: ("我知道了", ""), btnActions: { (action, key) in
                        self.removeFromSuperview()
                    })
                    self.target?.present(alert, animated: true, completion: nil)
                }
                addrec.sureBtnClickBlock = {name,tag in
                    PublicMethod.showProgressWithStr(statusStr: "上传信息中")
                    LoginRequest.getPost(methodName: RECORDING_MARK_ADD, params: ["id":recId,"intitle":name,"label":tag,kToken:UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
                        DLog(dic)
                        PublicMethod.dismissWithError()
                    }, success: { (dic) in
                        PublicMethod.dismissWithSuccess(str: "上传成功")
                        addrec.removeFromSuperview()
                        let alert = UIAlertController.init(title: "录音已保存，您可以在【我的】里的【语音备忘录】中查看", message: nil, preferredStyle: UIAlertControllerStyle.alert, okAndCancel: ("我知道了", ""), btnActions: { (action, key) in
                            self.removeFromSuperview()
                        })
                        self.target?.present(alert, animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    
}
