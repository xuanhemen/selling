//
//  QFAddPlanVC.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/19.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
import KMPlaceholderTextView
class QFAddPlanVC: UIViewController,QFPlanUserViewDelegate,QFChooseTypeDelegate {
    //计划model
    var planModel:QFProjectPlanModel?
    
    var model:ProjectSituationModel?
    var scrollView = UIScrollView()
    var userView = ProActionPlanUsersView()
    var chooeseTypeView = QFChooseTypeView()
    var vactionTypeLabel:UILabel?   //行动类型
    var vdateLabel:UILabel?   //时间
    var vTextView:KMPlaceholderTextView?  //行动说明
    
    var btnBackView:UIView?
    
    
    var  acbackView:UIView?
    var actionTypeLabel:UILabel?
    var actypeBackView:UIView?
    var acimageView:UIImageView?
    var acbutton:UIButton?
    
    var debackView:UIView?
    var actionDetailLabel:UILabel?
    
    var datebackView:UIView?
    var actionDateLabel:UILabel?
    var dateBackView2:UIView?
    var dateimageView:UIImageView?
    var datebutton:UIButton?
    
    
    //date选择
     var picker:DatePickerView?
    var starModel:ProjectPlanStarModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加计划"
        self.view.backgroundColor = UIColor.init(red: 235/255.0, green: 234/255.0, blue: 241/255.0, alpha: 1)
        self.configUI()
        self.configModelData()
        self.refreshFrame()
        self.configBackItem()
        
    }
    override func backBtnClick() {
        if self.chooeseTypeView.frame.origin.y > 200 {
            self.navigationController?.popViewController(animated: true)
        }else{
            UIView.animate(withDuration: 0.3) {
                self.chooeseTypeView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //修改
    func configModelData(){
        if planModel != nil {
            let stModel = ProjectPlanStarModel()
            stModel.name = (planModel?.action_style_name)!
            stModel.id = (planModel?.action_style)!
            self.starModel = stModel
            self.vactionTypeLabel?.text = stModel.name
            vTextView?.text = planModel?.action_target ?? ""
            vdateLabel?.text = Date.timeIntervalToDateDetailStrStyle(timeInterval: NSString.init(string: (planModel?.overtime)!).doubleValue)
            
            let idArray = planModel?.peopleid.components(separatedBy: ",")
            let nameArray = planModel?.people_name.components(separatedBy: ",")
            if (planModel?.logic_people_arr.count)!>0 {
                
//                "contact_id" = 7324;
//                id = 9401;
//                name = 1239862388;
                var mArray = Array<MemberModel>()
                for dic in (planModel?.logic_people_arr)!{
                    let mModel = MemberModel()
                    mModel.id = JSON(dic["contact_id"]).stringValue
                    mModel.name = JSON(dic["name"]).stringValue
                    mArray.append(mModel)
                }
                self.userView.configAlReady(array: mArray)
            }
            
            
            
        }
    }
    
    func refreshFrame(){
        
        var userViewHeight = self.configUserView(frame: CGRect(x: 0, y: 35, width: self.scrollView.frame.size.width, height: 0))
        self.actionTypeConfig(frame: CGRect(x: 0, y: 36+userViewHeight, width:self.scrollView.frame.size.width, height: 50), fatherView: self.scrollView)
        userViewHeight = 36+userViewHeight+50+1
        
        
        self.actionDetailConfig(frame: CGRect(x: 0, y: userViewHeight, width: self.scrollView.frame.size.width, height: 150), fatherView: self.scrollView)
        userViewHeight = userViewHeight + 150 + 1
        
        
        self.actionDateConfig(frame: CGRect(x: 0, y: userViewHeight, width: self.scrollView.frame.size.width, height: 50), fatherView: self.scrollView)
        userViewHeight = userViewHeight+50
        
        btnBackView?.frame = CGRect(x: 0, y: userViewHeight, width: self.scrollView.frame.size.width, height: 480)
        if userViewHeight<UIScreen.main.bounds.size.height-64{
            userViewHeight = UIScreen.main.bounds.size.height-64
        }
        self.scrollView.contentSize = CGSize(width: 0, height: userViewHeight)
        
        
        self.chooeseTypeView.frame = CGRect(x: 0, y:UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height-64)
        self.chooeseTypeView.uiConfig()
    }
    
    
    
    func configUI() {
        self.scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64)
        self.scrollView.backgroundColor = .clear
        //self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.contentSize = CGSize(width: 0, height: 0    )
        self.view.addSubview(self.scrollView)
        
//        self.userLabelConfig(frame: CGRect(x: 0, y: 5, width: self.scrollView.frame.size.width, height: 35), fatherView: self.scrollView)
        
        var userViewHeight = self.configUserView(frame: CGRect(x: 0, y: 20, width: self.scrollView.frame.size.width, height: 0))
//        self.userView.delegate = self
        self.userView.backgroundColor = .white
        self.scrollView.addSubview(self.userView)
        
        self.actionTypeConfig(frame: CGRect(x: 0, y: 36+userViewHeight, width:self.scrollView.frame.size.width, height: 50), fatherView: self.scrollView)
        userViewHeight = 36+userViewHeight+50+1
        
        
        self.actionDetailConfig(frame: CGRect(x: 0, y: userViewHeight, width: self.scrollView.frame.size.width, height: 150), fatherView: self.scrollView)
        userViewHeight = userViewHeight + 150 + 1
        
        
        self.actionDateConfig(frame: CGRect(x: 0, y: userViewHeight, width: self.scrollView.frame.size.width, height: 50), fatherView: self.scrollView)
        userViewHeight = userViewHeight+50
        
        let btnBackView = UIView.init(frame: CGRect(x: 0, y: userViewHeight, width: self.scrollView.frame.size.width, height: 480))
        btnBackView.backgroundColor = .white
        self.scrollView.addSubview(btnBackView)
        self.btnBackView = btnBackView
        
        
        let button = UIButton.init(frame: CGRect(x: 15, y: 20, width: btnBackView.frame.size.width-30, height: 40))
        button.backgroundColor = UIColor.init(red: 50/255.0, green: 137/255.0, blue: 203/255.0, alpha: 1)
        button.layer.cornerRadius = 2
        if self.planModel == nil {
            button.setTitle("添加", for: UIControlState.normal)
        }else{
            button.setTitle("修改", for: UIControlState.normal)
        }
        
        button.setTitleColor(.white, for: UIControlState.normal)
        button.addTarget(self, action: #selector(addButtonClick), for: UIControlEvents.touchUpInside)
        btnBackView.addSubview(button)
        
        userViewHeight = userViewHeight+80
        
        if userViewHeight<UIScreen.main.bounds.size.height-64{
            userViewHeight = UIScreen.main.bounds.size.height-64
        }
        self.scrollView.contentSize = CGSize(width: 0, height: userViewHeight)
        
        
        self.chooeseTypeView.frame = CGRect(x: 0, y:UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height-64)
        self.chooeseTypeView.uiConfig()
        self.chooeseTypeView.delegate = self
        self.view.addSubview(self.chooeseTypeView)
    }
    
    func configUserView(frame:CGRect) -> CGFloat{
//        for view in self.userView.subviews{
//            view.removeFromSuperview()
//        }
        let h = self.userView.refreshHeight()
        self.userView.click = { [weak self] (str) in
            if str == "+" {
                let vc = QFAddUserVC()
                vc.result = { (array) in
                    
                    self?.userView.configAlReady(array: array)
                    self?.refreshFrame()
                }
                vc.alreadyArray = (self?.userView.currentMember())!
                vc.model = self?.model
                self?.navigationController?.pushViewController(vc, animated: true)
            }else{
                self?.refreshFrame()
            }
            
        }
        self.userView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: h)
        self.userView.clipsToBounds = true
        return h
    }
    
    //客户对象
    func userLabelConfig(frame:CGRect,fatherView:UIView){
        
        let backView = UIView.init(frame: frame)
        backView.backgroundColor = .white
        fatherView.addSubview(backView)


        let titleLabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: 80, height: frame.size.height))
        titleLabel.text = "客户对象："
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        backView.addSubview(titleLabel)

        let detailLabel = UILabel.init(frame: CGRect(x: 95, y: 0, width: frame.size.width-110, height: frame.size.height))
        detailLabel.text = "这次计划想面对的客户对象"
        detailLabel.textColor = .gray
        detailLabel.textAlignment = .left
        detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        backView.addSubview(detailLabel)
        
    }

    //行动类型
    func actionTypeConfig(frame:CGRect,fatherView:UIView){
        
        if acbackView == nil {
            let backView = UIView.init(frame: frame)
            backView.backgroundColor = .white
            fatherView.addSubview(backView)
            acbackView = backView
        }else{
            acbackView?.frame = frame
        }
        
        if actionTypeLabel == nil {
            let actionTypeLabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: 80, height: frame.size.height))
            actionTypeLabel.text = "行动类型："
            actionTypeLabel.textColor = .black
            actionTypeLabel.textAlignment = .left
            actionTypeLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            self.acbackView?.addSubview(actionTypeLabel)
            self.actionTypeLabel = actionTypeLabel
        }else{
            self.actionTypeLabel?.frame = CGRect(x: 15, y: 0, width: 80, height: frame.size.height)
        }
        
        
        if self.actypeBackView == nil {
            let typeBackView = UIView.init(frame: CGRect(x:95, y: 10, width: frame.size.width-110, height: 30))
            typeBackView.layer.borderWidth = 0.5
            typeBackView.layer.borderColor = UIColor.lightGray.cgColor
            self.acbackView?.addSubview(typeBackView)
            self.actypeBackView = typeBackView
        }else{
            self.actypeBackView?.frame = CGRect(x:95, y: 10, width: frame.size.width-110, height: 30)
        }
        
        if vactionTypeLabel == nil {
            vactionTypeLabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: (self.actypeBackView?.frame.size.width)!-50, height: 30))
            vactionTypeLabel?.text = "请选择类型"
            vactionTypeLabel?.textColor = .darkGray
            vactionTypeLabel?.textAlignment = .center
            vactionTypeLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            self.actypeBackView?.addSubview(vactionTypeLabel!)
        }else{
            vactionTypeLabel?.frame = CGRect(x: 10, y: 0, width: (self.actypeBackView?.frame.size.width)!-50, height: 30)
        }
        
        if self.acimageView == nil {
            let imageView = UIImageView.init(frame: CGRect(x: (self.actypeBackView?.frame.size.width)!-30, y: 0, width: 30, height: 30))
            imageView.image = #imageLiteral(resourceName: "projectUpDown")
            imageView.contentMode = UIViewContentMode.center
            imageView.backgroundColor = UIColor.init(red: 50/255.0, green: 137/255.0, blue: 203/255.0, alpha: 1)
            self.actypeBackView?.addSubview(imageView)
            self.acimageView = imageView
        }else{
            self.acimageView?.frame = CGRect(x: (self.actypeBackView?.frame.size.width)!-30, y: 0, width: 30, height: 30)
        }
        
        if self.acbutton == nil {
            let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: (self.actypeBackView?.frame.size.width)!, height: (self.actypeBackView?.frame.size.height)!))
            button.addTarget(self, action: #selector(chooseTypeButtonClick), for: UIControlEvents.touchUpInside)
            self.actypeBackView?.addSubview(button)
            self.acbutton = button
        }else{
            self.acbutton?.frame = CGRect(x: 0, y: 0, width: (self.actypeBackView?.frame.size.width)!, height: (self.actypeBackView?.frame.size.height)!)
        }
        
        
    }
    //行动详情
    func actionDetailConfig(frame:CGRect,fatherView:UIView){
        
        if self.debackView == nil {
            let backView = UIView.init(frame: frame)
            backView.backgroundColor = .white
            fatherView.addSubview(backView)
            self.debackView = backView
        }else{
            self.debackView?.frame = frame
        }
        
        if self.actionDetailLabel == nil {
            let actionDetailLabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: 80, height: 40))
            actionDetailLabel.text = "计划说明："
            actionDetailLabel.textColor = .black
            actionDetailLabel.textAlignment = .left
            actionDetailLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            self.debackView?.addSubview(actionDetailLabel)
            self.actionDetailLabel = actionDetailLabel
        }
        else{
            self.actionDetailLabel?.frame = CGRect(x: 15, y: 0, width: 80, height: 40)
        }
        
        
        if vTextView == nil {
            vTextView = KMPlaceholderTextView.init(frame: CGRect(x: 15, y: 40, width: (self.debackView?.frame.size.width)!-30, height: 100))
            vTextView?.text = ""
            vTextView?.placeholder = "请填写计划说明"
            vTextView?.font = UIFont.systemFont(ofSize: 14)
            vTextView?.textColor = .gray
            vTextView?.layer.borderColor = UIColor.darkGray.cgColor
            vTextView?.layer.borderWidth = 0.5
            self.debackView?.addSubview(vTextView!)
        }else{
            vTextView?.frame = CGRect(x: 15, y: 40, width: (self.debackView?.frame.size.width)!-30, height: 100)
        }
        
       
    }

    //行动时间
    func actionDateConfig(frame:CGRect,fatherView:UIView){
        
        if self.datebackView == nil {
            let backView = UIView.init(frame: frame)
            backView.backgroundColor = .white
            fatherView.addSubview(backView)
            self.datebackView = backView
        }else{
            self.datebackView?.frame = frame
        }
        
        if self.actionDateLabel == nil {
            let actionDateLabel = UILabel.init(frame: CGRect(x: 15, y: 10, width: 80, height: 40))
            actionDateLabel.text = "行动时间："
            actionDateLabel.textColor = .black
            actionDateLabel.textAlignment = .left
            actionDateLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            self.datebackView?.addSubview(actionDateLabel)
            self.actionDateLabel = actionDateLabel
        }else{
            self.actionDateLabel?.frame = CGRect(x: 15, y: 10, width: 80, height: 40)
        }
        
        if self.dateBackView2 == nil {
            let dateBackView = UIView.init(frame: CGRect(x:95, y: 15, width: frame.size.width-110, height: 30))
            dateBackView.layer.borderWidth = 0.5
            dateBackView.layer.borderColor = UIColor.lightGray.cgColor
            self.datebackView?.addSubview(dateBackView)
            self.dateBackView2 = dateBackView
        }
        else{
            self.dateBackView2?.frame = CGRect(x:95, y: 15, width: frame.size.width-110, height: 30)
        }
        
        if vdateLabel == nil {
            vdateLabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: (self.dateBackView2?.frame.size.width)!-50, height: 30))
            vdateLabel?.text = ""
            vdateLabel?.textColor = .darkGray
            vdateLabel?.textAlignment = .center
            vdateLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            self.dateBackView2?.addSubview(vdateLabel!)
        }else{
            vdateLabel?.frame = CGRect(x: 10, y: 0, width: (self.dateBackView2?.frame.size.width)!-50, height: 30)
        }
        
        
        if self.dateimageView == nil {
            let imageView = UIImageView.init(frame: CGRect(x: (dateBackView2?.frame.size.width)!-30, y: 0, width: 30, height: 30))
            imageView.image = UIImage.init(named: "project_rili")
            self.dateBackView2?.addSubview(imageView)
            self.dateimageView = imageView
        }else{
            self.dateimageView?.frame = CGRect(x: (dateBackView2?.frame.size.width)!-30, y: 0, width: 30, height: 30)
        }
        
        if self.datebutton == nil {
            let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: (self.dateBackView2?.frame.size.width)!, height: (self.dateBackView2?.frame.size.height)!))
            button.addTarget(self, action: #selector(chooseDateButtonClick), for: UIControlEvents.touchUpInside)
            self.dateBackView2?.addSubview(button)
            self.datebutton = button
        }else{
            self.datebutton?.frame = CGRect(x: 0, y: 0, width:(self.dateBackView2?.frame.size.width)!, height: (self.dateBackView2?.frame.size.height)!)
        }
        
        
    }
    
    //MARK: - ***********   点击    ***********
    func btnSelectedWithIndex(index: Int) {
        if index == -1 {
            let addUserVC = QFAddUserVC()
            self.navigationController?.pushViewController(addUserVC, animated: true)
        }
        print(index)
    }
    func chooseModel(model: ProjectPlanStarModel) {
        self.title = "添加计划"
        self.vactionTypeLabel?.text = model.name
        starModel = model
    }
    
    @objc func addButtonClick(){
        print("添加")
        self.add()
    }
    @objc func chooseDateButtonClick(){
        print("选择日期")
        self.addPick()
    }
    @objc func chooseTypeButtonClick(){
       
        self.getStar()
    }
    
    func toShowStarView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.title = "选择行动类型"
            self.chooeseTypeView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64)
        }) { (true) in
            
        }
    }
    
    func getStar(){
        
        
        PublicMethod.showProgress()
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id
        params["peoples_id"] = self.userView.resultIdStr()
        LoginRequest.getPost(methodName: ACTION_PLAN_STAR, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            
            let array =  JSON(dic["data"]).arrayObject
            var dataArray  = Array<ProjectPlanStarModel>()
            for dic in array! {
                if let model:ProjectPlanStarModel = ProjectPlanStarModel.deserialize(from:dic as! Dictionary<String,Any>){
                    dataArray.append(model)
                }
            }
            self?.chooeseTypeView.dataArray = dataArray
            self?.toShowStarView()
        }
        
    }
    
    
    
    
    func add(){
        
        if self.userView.contactIdsStr().isEmpty {
            PublicMethod.toastWithText(toastText: "相关联系人不能为空")
            return
        }
        
        if starModel == nil {
            PublicMethod.toastWithText(toastText: "行动类型不能为空")
            return
        }
        
        if (vTextView?.text.isEmpty)!  {
            PublicMethod.toastWithText(toastText: "计划说明不能为空")
            return
        }
        
        if (vdateLabel?.text?.isEmpty)!  {
            PublicMethod.toastWithText(toastText: "计划时间不能为空")
            return
        }
        
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id
        params["peoples_id"] = self.userView.contactIdsStr()
        params["action_style"] = starModel?.id
        params["action_target"] = vTextView?.text
        params["overtime"] = Date.strToTimeIntervalyymmddStyle(str: (vdateLabel?.text)!)
        PublicMethod.showProgress()
        
        var url = ""
        if planModel == nil {
            url = ADD_ACTION_PLAN
        }else{
            url = SAVE_ACTION_PLAN
            params["action_id"] = planModel?.id
        }
        
        LoginRequest.getPost(methodName: url, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { [weak self](dic) in
            
            PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: "添加成功")
            self?.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    func addPick(){
        
        if self.picker == nil {
            picker = DatePickerView()
            if !(vdateLabel?.text?.isEmpty)! {
                picker?.picker.date = Date.strToDateStyle(str: (vdateLabel?.text)!)
            }
            picker?.pickerResult = {[weak self] (date) in
                DLog(date)
                self?.vdateLabel?.text = Date.timeIntervalToDateDetailStrhhmmStyle(date: date)
                
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
    
    
    
    
}
