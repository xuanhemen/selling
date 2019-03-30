//
//  RecorderPlayerListViewController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/2/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import AVFoundation
import MJRefresh
class RecorderPlayerListViewController: BaseVC,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate {
    
    var projectId:String?
    var click:(_ dic:Dictionary<String,Any>)->() = {_ in
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 + LEFT_PADDING
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "RecorderPlayerTableViewCell"
        var cell:RecorderPlayerTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? RecorderPlayerTableViewCell
        if cell==nil {
            cell = RecorderPlayerTableViewCell.init(style: .default, reuseIdentifier: cellIde)
            
        }
        cell?.lbContactName.text = String.noNilStr(str: self.modelList[indexPath.row]["intitle"]) == "" ? (String.noNilStr(str: self.modelList[indexPath.row]["parallelism_name"]!) + " 的语音") : (String.noNilStr(str: self.modelList[indexPath.row]["intitle"]))
        
        let recDuration = Int(String.noNilStr(str: self.modelList[indexPath.row]["duration"]!))!/1000
        let first = (String(Int(recDuration)/60).count > 1) ? String(Int(recDuration)/60) : ("0" + String(Int(recDuration)/60))
        let second = (String(Int(recDuration)%60).count > 1) ? String(Int(recDuration)%60) : ("0" + String(Int(recDuration)%60))
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.lbPosition.text = first + ":" + second
        cell?.lbCompany.text = String.noNilStr(str: self.modelList[indexPath.row]["type_name"])
        cell?.phoneNum = indexPath
        cell?.onPlayCall = {[weak self] index in
//            self?.modelList[(index?.row)!]
//            self?.table.selectRow(at: index, animated: true, scrollPosition: UITableViewScrollPosition.none)
            self?.selectIndex = index!
            self?.playView.isHidden = false
            self?.play(url: (String.noNilStr(str: self?.modelList[(index?.row)!]["file"])))
            self?.playView.lbContactName.text = cell?.lbContactName.text
            self?.playView.lbPosition.text = cell?.lbPosition.text
            self?.playView.lbCompany.text = cell?.lbCompany.text
            self?.playView.phoneNum = cell?.phoneNum
            
            self?.table.reloadData()
//            cell?.rImage.image = UIImage.init(named: "mrOrange")
        }
        cell?.onDelCall = {index in
            let alert = UIAlertController.init(title: "提示", message: "您确定要删除" + (cell?.lbContactName.text)! + " 的这条语音么？", preferredStyle: UIAlertControllerStyle.alert, okAndCancel: ("删除", "取消"), btnActions: { (action, key) in
                if key == "ok" {
                    PublicMethod.showProgressWithStr(statusStr: "正在删除")
                    LoginRequest.getPost(methodName: RECORDING_DELETE, params: ["id":self.modelList[indexPath.row]["id"],kToken:UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
                        PublicMethod.dismissWithError()
                    }, success: { (dic) in
                        PublicMethod.dismissWithSuccess(str: "删除成功")
                        self.getData()
                    })
                }
            })
            self.present(alert, animated: true, completion: nil)
            
        }
        if selectIndex == indexPath{
            cell?.rImage.image = UIImage.init(named: "mrOrange")
            cell?.headerImage.setBackgroundImage(UIImage(named:"mrPas"), for: .normal)
        }else{
            cell?.rImage.image = UIImage.init(named: "mrGreen")
            cell?.headerImage.setBackgroundImage(UIImage(named:"mrPlay"), for: .normal)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.projectId != nil {
            self.click(self.modelList[indexPath.row])
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.playView.isHidden = false
        self.play(url: (String.noNilStr(str: self.modelList[indexPath.row]["file"])))
        let cell = tableView.cellForRow(at: indexPath) as! RecorderPlayerTableViewCell
        self.playView.lbContactName.text = cell.lbContactName.text
        self.playView.lbPosition.text = cell.lbPosition.text
        self.playView.lbCompany.text = cell.lbCompany.text
        self.playView.phoneNum = cell.phoneNum
//        table.indexPathForSelectedRow = indexPath
//        table.reloadRows(at: [indexPath], with: UITableViewRowAnimation.left)
//        table.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        selectIndex = indexPath
        table.reloadData()
//        cell.rImage.image = UIImage.init(named: "mrOrange")
    }
    
    let table = UITableView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT))
    var modelList = Array<Dictionary<String,Any>>()
    let playView = AVPlayerView.init(frame: CGRect(x: LEFT_PADDING, y: MAIN_SCREEN_HEIGHT_PX - 100 - NAV_HEIGHT , width: MAIN_SCREEN_WIDTH - LEFT_PADDING * 2, height: 60))
    var timer:Timer? = nil
    var selectIndex = IndexPath.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if player != nil {
            player?.stop()
        }
    }
    
    fileprivate func getData() {
        PublicMethod.showProgressWithStr(statusStr: "获取数据中")
        var url = ""
        var params = Dictionary<String,Any>()
        if self.projectId != nil {
            url = record_search_pro
            params["project_id"] = projectId
//            url = RECORDING_LIST
        }else{
            url = RECORDING_LIST
        }
        
        LoginRequest.getPost(methodName: url, params:params.addToken(), hadToast: true, fail: {[weak self] (dic) in
//            DLog(dic)
            PublicMethod.dismissWithError()
            self?.table.mj_header.endRefreshing()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            self?.table.mj_header.endRefreshing()
            self?.modelList = dic["data"] as! [Dictionary<String, Any>]
            if self?.modelList.count == 0 {
                if self?.projectId != nil {
                PublicMethod.toastWithText(toastText: "该项目还没有对应的语音")
                }
            }
            self?.table.reloadData()
        }
    }
    
    func configUI() {
        self.title = "语音备忘录"
        self.view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.register(RecorderPlayerTableViewCell.self, forCellReuseIdentifier: "RecorderPlayerTableViewCell")
        table.backgroundColor = UIColor.groupTableViewBackground
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        self.table.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in
            self?.getData()
        })
        
        table.addEmptyViewAndClickRefresh {[weak self] in
            self?.getData()
        }
        
        
        getData()
        
        
        self.view.addSubview(playView)
        playView.isHidden = true
        playView.onPlayCall = {_ in
            if (self.player?.isPlaying)! {
                self.player?.pause()
                self.playView.headerImage.setBackgroundImage(UIImage(named:"mrPlay"), for: .normal)
                NotificationCenter.default.removeObserver(self)
                UIDevice.current.isProximityMonitoringEnabled = false
            }else{
                self.player?.play()
                self.playView.headerImage.setBackgroundImage(UIImage(named:"mrPas"), for: .normal)
                self.configInfraredSensing()
            }
        }
        playView.onDelCall = {index in
            self.playView.isHidden = true
            self.timer?.invalidate()
            self.timer = nil
            if self.player != nil {
                self.player?.stop()
                NotificationCenter.default.removeObserver(self)
                UIDevice.current.isProximityMonitoringEnabled = false
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var player:AVAudioPlayer? = nil
    func play(url:String) {
        if player != nil {
            player?.stop()
        }
        do {
            PublicMethod.showProgress()
            let playData = try Data.init(contentsOf: URL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
            PublicMethod.dismiss()
            player = try AVAudioPlayer(data: playData)
            self.playView.headerImage.setBackgroundImage(UIImage(named:"mrPas"), for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (ti) in
                let recDuration = self.player?.currentTime
                let first = (String(Int(recDuration!)/60).count > 1) ? String(Int(recDuration!)/60) : ("0" + String(Int(recDuration!)/60))
                let second = (String(Int(recDuration!)%60).count > 1) ? String(Int(recDuration!)%60) : ("0" + String(Int(recDuration!)%60))
                self.playView.lbPosition.text = first + ":" + second
            })
            player?.delegate = self
            DLog("歌曲长度：\(player?.duration)")
            player?.play()
            self.configInfraredSensing()
        } catch let err {
            DLog("播放失败:\(err.localizedDescription)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playView.headerImage.setBackgroundImage(UIImage(named:"mrPlay"), for: .normal)
            self.selectIndex = IndexPath.init()
            self.table.reloadData()
    }
    
    func configInfraredSensing(){
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
            if player == nil || player?.isPlaying == false{
                UIDevice.current.isProximityMonitoringEnabled = false
                NotificationCenter.default.removeObserver(self)
            }
        }
    }

}
