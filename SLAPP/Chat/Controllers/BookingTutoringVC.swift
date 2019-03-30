//
//  BookingTutoringVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
import YBPopupMenu
import ReactiveCocoa
import ReactiveSwift
import Result
class BookingTutoringVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YBPopupMenuDelegate{
    var str = ""
    var textField:UITextField?
    let iconImages = ["ProPeopleIcon","Proappointment","Proappointment"]
    var consult_id:String?
    var model:Dictionary<String,Any>?
    var picker:DatePickerView?
    //导师
    var coachModel:MemberModel?
    //开始时间
    var beginDateStr:String = ""
    //辅导时长
    var tutoringTime:String = ""
    
    var popMenu:YBPopupMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.configUI()
       
    }
    
    
    
    
    
    func configUI(){
        self.view.addSubview(self.table)
        
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(kBottomSpace-49)
        }
        table.tableFooterView = self.tabFoot
        self.tabFoot.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: self.member.refreshHeight())
        
        self.tabFoot.addSubview(self.member)
        self.member.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(0)
        }
        
        
        self.member.cuttrntHeight = { [weak self](height)in
    
           self?.tabFoot.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: height)
            self?.table.tableFooterView = self?.tabFoot
        }
        //点击添加
        self.member.clickAdd = { [weak self]()in
            let vc = TutoringMembersVC()
            vc.title = "选择参与人"
            vc.type = .multiple
            vc.configAlReadyArray(alReady: (self?.member.currentMember())!)
            vc.resultArray = {(result) in
                self?.member.configAlReady(array:result)
            }
           self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        table.delegate = self
        table.dataSource = self
        
        
        
        let exitBtn:UIButton = UIButton.init(type: .custom)
        self.view.addSubview(exitBtn)
        exitBtn.backgroundColor = kGreenColor
        exitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(kBottomSpace)
            make.height.equalTo(49)
        }
        exitBtn.setTitle("预约", for: .normal)
        exitBtn.addTarget(self, action: #selector(exitBtnClick), for: .touchUpInside)
        
        
        
    }
    
    lazy var tabFoot = { () -> UIView in
        let lable = UIView.init(frame: CGRect.zero)
        return lable
    }()
    
    lazy var member = { () -> MembersView in
        let lable = MembersView.init(frame: CGRect.zero)
        return lable
    }()
    
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 100
        }
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        
        if indexPath.row < 3 {
            var cell:BookTuringCell? = (tableView.dequeueReusableCell(withIdentifier: cellIde) as? BookTuringCell)
            if cell == nil {
                cell = BookTuringCell.init(style: .default, reuseIdentifier: cellIde)
            }
            if indexPath.row == 2 {
                cell?.nameLable.text = "辅导时长:"
                cell?.type = .tutoringTime
                cell?.textField.text = tutoringTime
                cell?.textField.delegate  = self
                cell?.rightImage.image = nil
                cell?.teacherImage.isHidden = true
                textField = cell?.textField
                self.showRemind(textView: (cell?.textField)!)
            }else if indexPath.row == 0{
                
                cell?.type = .tutor
                cell?.nameLable.text = "请选择导师:"
                if self.coachModel != nil {
                    cell?.timerLable.text = coachModel?.name!
                    cell?.teacherImage.isHidden = false
                    cell?.teacherImage.snp.updateConstraints({ (make) in
                        make.width.equalTo(30)
                        make.height.equalTo(30)
                    })
                    cell?.teacherImage.setHeadImage(url: (self.coachModel?.head)!)                }
                cell?.rightImage.image = UIImage.init(named: "Arrow")
                
            }else{
                cell?.teacherImage.isHidden = true
                 cell?.nameLable.text = "开始时间:"
                 cell?.type = .tutor
                 cell?.timerLable.text = beginDateStr
                 cell?.rightImage.image = UIImage.init(named: "upArrow")
            }
            cell?.headImage.image = UIImage.init(named: iconImages[indexPath.row])
            return cell!
        }
        else{
            var cell:BookTuringProgressCell? = (tableView.dequeueReusableCell(withIdentifier: cellIde) as? BookTuringProgressCell)
            if cell == nil {
                cell = BookTuringProgressCell.init(style: .default, reuseIdentifier: cellIde)
            }
           
            cell?.progress.progress = 1 - JSON(self.model!["percentage"] as Any).floatValue
            cell?.mimuteStr = JSON(self.model!["left_minute"] as Any).intValue
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = TutoringMembersVC()
            vc.title = "选择辅导导师"
            vc.type = .single
            if self.coachModel != nil{
                vc.configAlReadyArray(alReady: [self.coachModel!])
            }
            
            vc.resultArray = {[weak self] (array)in
                if array.count > 0 {
                    self?.coachModel = array.first
                }
                self?.table.reloadRows(at: [indexPath], with: .none)
            }
            self.navigationController?.pushViewController(vc, animated: true)

         case 3:
            break
        default:
            self.addPick()
            
        }
        
        
    }
    
    
    func addPick(){
        
        if self.picker == nil {
            picker = DatePickerView()
            if self.beginDateStr != ""{
               picker?.picker.date = Date.strToDate(str: self.beginDateStr)
            }
            
            picker?.pickerResult = {[weak self] (date) in
                DLog(date)
               self?.beginDateStr = Date.timeIntervalToDateDetailStrhhmm(date: date)
               self?.table.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
               self?.picker = nil
            }
            self.view.addSubview(picker!)
            picker!.snp.makeConstraints {[weak self] (make) in
                make.top.equalTo((self?.view.snp.bottom)!)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(200)
            }
            
            UIView.animate(withDuration: 2, animations: {
                self.picker?.snp.updateConstraints({ (make) in
                    make.top.equalTo((self.view.snp.bottom)).offset(-200)
                })
            })
            
            
        }else{
            
            
        }
        
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = UIColor.groupTableViewBackground
        return table
    }()
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func exitBtnClick(){
        
        self.toBook()
    }
  
  //预约
    func toBook(){
        
        self.view.endEditing(true)
        
        var params = Dictionary<String,Any>()
        
        if (self.tutoringTime.isEmpty) {
            PublicMethod.toastWithText(toastText: "时长不能为空")
            return
        }
        
        if self.beginDateStr.isEmpty {
            PublicMethod.toastWithText(toastText: "开始时间不能为空")
            return
        }
        
        if self.member.resultIds().count == 0 {
            PublicMethod.toastWithText(toastText: "辅导参与人员不能为空")
            return
        }
        
        var url = ""
        if self.consult_id != nil {
            url = SAVE_CONSULT
            params["consult_id"] = self.consult_id!
            
        }else{
            url = ADD_CONSULT
            params["project_id"] = JSON(model as Any)["projectId"].stringValue
        }
        
       
        params["teacher_id"] = self.coachModel?.id!
        params["begintimes"] = Date.strToTimeInterval(str: self.beginDateStr)
        params["consult_minute"] = self.tutoringTime
        params["nameLists"] = self.member.resultIdStr()
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: url, params: params.addToken(), hadToast: true, fail: { (dic) in
         PublicMethod.dismiss()
        }) {[weak self] (dic) in
         PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: JSON(dic["content"]).stringValue)
            let vc = TutoringDetailVC()
            vc.new_consult_id = JSON(dic["id"] as Any).stringValue
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    
    func showRemind(textView:UITextField){
        
        textView.reactive.continuousTextValues.observe { [weak self](text) in
            
            if text.value == nil {
                return
            }
           
            
            let textstr:String = String.noNilStr(str: text.value!! as Any)
            if self?.popMenu != nil {
                self?.popMenu?.dismiss()
                self?.popMenu?.removeFromSuperview()
                self?.popMenu = nil
            }
            if !String.isNumberType(str: textstr) {
                return
            }
            let aStr = NSString.init(string: textstr)
             DLog(aStr)
            if aStr.floatValue > 10 {
                self?.str = "分钟"
            }else{
                self?.str = "小时"
            }
            
            if self?.popMenu == nil {
                self?.popMenu = YBPopupMenu.showRely(on: textView, titles: [self?.str as Any], icons: nil, menuWidth: 60, otherSettings: { (pop) in
                    pop?.delegate = self
                    pop?.showMaskView = false
                    pop?.priorityDirection = .top
                    pop?.maxVisibleCount = 1
                    pop?.itemHeight =  30
                    pop?.borderWidth = 1
                    pop?.fontSize = 12
                    pop?.dismissOnTouchOutside = true
                    pop?.dismissOnSelected = true
                })
            }else{
                
                
            }
            
            
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.tutoringTime = textField.text!
    }
    
    
    @objc func configAlreadyInfo(model:Dictionary<String,Any>,mArray:Array<MemberModel>?){
        
        self.model = model
        self.title = JSON(model["project_name"] as Any).stringValue
        if mArray != nil {
            //项目概况中的预约要把项目对应的参与人带过来
            self.member.configAlReady(array: mArray!)
        }
        if model["id"] == nil {
            //表示新增
            self.table.reloadData()
            return
        }
        
        self.consult_id = JSON(model)["id"].stringValue
        
        let cmodel = MemberModel()
        cmodel.name = JSON(model)["teacher_realname"].stringValue
         cmodel.head = JSON(model)["teacher_head"].stringValue
         cmodel.id = JSON(model)["teacher_sso_userid"].stringValue
        self.coachModel = cmodel
        
        self.beginDateStr = Date.timeIntervalToDateDetailStr(timeInterval: Double(JSON(model)["begintime"].doubleValue))
        self.tutoringTime = JSON(model)["consult_time_text"].stringValue
        
        if mArray == nil {
            var array = Array<MemberModel>()
            for dic in JSON(model["user_lists"] as Any).arrayObject! {
                let subModel = MemberModel()
                subModel.id = JSON(dic)["sso_id"].stringValue
                subModel.head = JSON(dic)["heads"].stringValue
                subModel.name = JSON(dic)["sso_realname"].stringValue
                array.append(subModel)
            }
            self.member.configAlReady(array: array)
        }
        else{
            
        }
         self.title = JSON(model)["project_name"].stringValue
        
        
        self.table.reloadData()
    }
    
    
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        
      
        textField?.text?.append(str)
        self.popMenu?.removeFromSuperview()
        self.popMenu = nil
        
    }
}
