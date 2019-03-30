//
//  ProjectTutoringVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProjectTutoringVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    var dataArray = Array<Dictionary<String,Any>>()
    var model:ProjectSituationModel?
    var consultBtn:UIButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "辅导"
        self.configUI()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configData()
    }
    
    func configUI(){
        
        self.view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
//            make.height.equalTo(0)
            make.bottom.equalTo(-kTabBarHeight)
        }
        nodataView.isHidden = true
        table.addSubview(nodataView)
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        
        
        consultBtn.backgroundColor = kGreenColor
        consultBtn.layer.cornerRadius = 5
        consultBtn.layer.masksToBounds = true
        consultBtn.setTitleColor(UIColor.white, for: .normal)
        consultBtn.titleLabel?.font = kFont_Big
        consultBtn.setTitle("预约新辅导", for: .normal)
        self.view.addSubview(consultBtn)
        consultBtn.isHidden = true
        consultBtn.snp.makeConstraints { (make) in
            //            make.top.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-TAB_HEIGHT-10)
        }
        consultBtn.addTarget(self, action: #selector(consultBtnClicked), for: .touchUpInside)
    }
    @objc func consultBtnClicked(btn:UIButton){
        self.isHasTime()
    }
    func configData(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_LIST, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            
            PublicMethod.dismiss()
            self?.dataArray.removeAll()
//            if dic["data"] is Array{
                self?.dataArray = dic["list"] as! [Dictionary<String, Any>]
                self?.table.reloadData()
//            }
            if (self?.dataArray.count)! > 0 {
                self?.nodataView.isHidden = true
                var isHave = false
                for subDict in (self?.dataArray)! {
                    if JSON(subDict["consult_status_name"] as Any).stringValue == "预约成功" || JSON(subDict["consult_status_name"] as Any).stringValue == "预约中" || JSON(subDict["consult_status_name"] as Any).stringValue == "辅导中"{
                        isHave = true
                    }
                }
                if isHave == true {
                    self?.consultBtn.isHidden = true
                }else{
                    self?.consultBtn.isHidden = false
                }
                
            }else{
                self?.consultBtn.isHidden = true
                self?.nodataView.isHidden = false
            }
            
            
            if  String.noNilStr(str: self?.model?.save_auth) == "0" {
                self?.consultBtn.isHidden = true
            }
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "ConsultListCell"
        var cell:ConsultListCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ConsultListCell
        if cell==nil {
            cell = ConsultListCell.init(style: .default, reuseIdentifier: cellIde)
        }
        cell?.model = self.dataArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TutoringDetailVC()
        let dic = self.dataArray[indexPath.row]
        vc.new_consult_id = JSON(dic["id"] as Any).stringValue
    self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        
        return table
    }()

    //无数据
//    lazy var nodataView = {[weak self] ()->UIImageView in
//        let nodataImage = UIImageView.init(image: UIImage(named: "noChatImg"))
//        nodataImage.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 200)
//        nodataImage.center = (self?.view.center)!
//        nodataImage.contentMode = UIViewContentMode.scaleAspectFit
//        return nodataImage
//    }()
    
    
    lazy var nodataView = { () -> UIView in
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-TAB_HEIGHT))
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 200))
        view.addSubview(imageView)
        imageView.center = view.center
        imageView.image = UIImage(named: "noChatImg")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: MAIN_SCREEN_WIDTH/2-70, y: view.centerY+150, width: 140, height: 40)
        btn.setTitle("立即预约新辅导", for: .normal)
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.borderColor = kGreenColor.cgColor
        btn.titleLabel?.font = kFont_Middle
        btn.setTitleColor(kGreenColor, for: .normal)
        btn.addTarget(self, action: #selector(tutoringClick), for: .touchUpInside)
        view.addSubview(btn)
        return view
    }()
    
    @objc func tutoringClick(){
        self.toRefresh()
    }
    
    func toRefresh(){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                self?.model = model;
                self?.isHasTime()
            }
        }
        
    }
    
    
    
    func isHasTime(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: COACHPAY_LIST, params: [:].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            DLog(dic)
            
            let a =  JSON(dic["left_hour_str"]).floatValue
            if a <= 0 {
                PublicMethod.toastWithText(toastText: "您好，您的可预约时长用完了")
                return
            }else{
                
                DLog("asdasdasdasdasdasd")
                var per = "0.0"
                let all = JSON(dic["license_minute"] as Any).intValue
                let left = JSON(dic["left_minute"] as Any).intValue
                per = JSON(dic["per"]).stringValue
                if all != 0{
                    per = String.init(format: "%.1f",CGFloat(left)/CGFloat((all)))
                    
                }
                
               
                
                
                self?.toMakeAppointment(per:per,left:"\(left)")
            }
        }
        
    }
    
    func toMakeAppointment(per:String,left:String){
        let vc = BookingTutoringVC()
        let model = ["projectId":self.model?.id,"project_name":self.model?.name,"percentage":per,"left_minute":left]
        vc.configAlreadyInfo(model: model, mArray: self.model?.configPartners())
       self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
}
