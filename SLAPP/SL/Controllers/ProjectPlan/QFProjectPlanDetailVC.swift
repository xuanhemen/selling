//
//  QFProjectPlanDetailVC.swift
//  SLAPP
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import YBPopupMenu
import SwiftyJSON
class QFProjectPlanDetailVC: BaseVC,UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate {
    @objc var planModel:QFProjectPlanModel? //上一级带过来
    var myPlanModel:QFProjectPlanModel?  //自己请求的
    var mArray = Array<MemberModel>()
    var array = Array<String>()
    @objc var model:ProjectSituationModel?
    @objc var id:String?
    @objc var isProjectIn = true
    let btn = UIButton.init(type: .custom)
    let chooseBtn = UIButton.init(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "项目计划"
        self.view.backgroundColor = HexColor("#f2f2f2")
        self.configUI()
        self.setRightBtnWithArray(items: [UIImage.init(named: "promore")])
    }
    
   
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configData()
        if (self.tabBarController?.isKind(of: ProjectSituationTabVC.self))! {
            let tabVC:ProjectSituationTabVC = self.tabBarController as! ProjectSituationTabVC
            tabVC.tab.isHidden = true
        }
//
//
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.tabBarController?.isKind(of: ProjectSituationTabVC.self))! {
            let tabVC:ProjectSituationTabVC = self.tabBarController as! ProjectSituationTabVC
            tabVC.tabBar.isHidden = true;
            tabVC.tab.isHidden = false
        }
//        let tabVC:ProjectSituationTabVC = self.tabBarController as! ProjectSituationTabVC
//        tabVC.tab.isHidden = false
    }
    func configData(){
        
        var params = Dictionary<String,Any>()
        if self.id != nil {
              params["action_id"] = id
        }else{
              params["action_id"] = planModel?.id
        }
      
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: ACTION_PLAN_ONE, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            DLog(dic)
            PublicMethod.dismiss()
            if let model = QFProjectPlanModel.deserialize(from: dic){
                self?.myPlanModel = model
                self?.model?.name = String.noNilStr(str: dic["pro_name"])
                if (model.logic_people_arr.count)>0 {
                    self?.mArray.removeAll()
                    for dic in (model.logic_people_arr){
                        let mModel = MemberModel()
                        mModel.id = JSON(dic["contact_id"] as Any).stringValue
                        mModel.name = JSON(dic["name"] as Any).stringValue
                        self?.mArray.append(mModel)
                    }
                }
                
                
                
                if self?.myPlanModel?.is_achieve == "1" {
                    //1 是关闭状态
                    self?.btn.setTitle("完成", for: .normal)
                    
                     self?.setRightBtnWithArray(items: [])
                }else{
                    self?.btn.setTitle("未完成", for: .normal)
                    if self?.myPlanModel?.save_auth == "1" {
                        //有权限
                         self?.setRightBtnWithArray(items: [UIImage.init(named: "promore")])
                    }else{
                        //没有权限
                        self?.setRightBtnWithArray(items: [])
                    }
                   
                   
                }
                self?.table.reloadData()
            }
            
        }
        
    }
    
    
    func openAndClose(){
        PublicMethod.showProgress()
        var params = Dictionary<String,Any>()
        params["action_id"] = myPlanModel?.id
        LoginRequest.getPost(methodName: ACHIEVE_ACTION_PLAN, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            
            PublicMethod.dismiss()
            if self?.myPlanModel?.is_achieve == "1" {
                PublicMethod.toastWithText(toastText: "操作成功")
            }else{
                PublicMethod.toastWithText(toastText: "操作成功")
            }
            self?.configData()
        }
    }
    
    
    func del(){
        
        self.showAlert(titleStr: "确认要删除吗？") { [weak self] in
            
            PublicMethod.showProgress()
            var params = Dictionary<String,Any>()
            params["action_id"] = self?.myPlanModel?.id
            LoginRequest.getPost(methodName: DEL_ACTION_PLAN, params: params.addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismissWithError()
            }) {[weak self] (dic) in
                PublicMethod.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
            
        }
        
       
        
    }
    
    
    override func rightBtnClick(button: UIButton) {
        array.removeAll()
//        "打开","关闭","编辑","删除"
        if self.myPlanModel?.is_achieve == "1" {
            //1 是关闭状态
//            array.append("打开")
        }else{
//            array.append("完成")
            array.append("编辑")
            array.append("删除")
        }
        
        
        YBPopupMenu.showRely(on: button, titles: array, icons: ["menuCopy","menuTrans","menuDelete","menuClose"], menuWidth: 100) { [weak self] (menuView) in
            menuView?.delegate = self
        }
    }
    
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        let str = array[index]
        if str == "打开" {
            self.openAndClose()
        }else if str == "完成" {
            self.openAndClose()
        }else if str == "删除"{
            self.del()
        }
        else{
            let vc = QFAddPlanVC()
            vc.planModel = self.myPlanModel
            vc.model = self.model
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    

    func configUI(){
        self.view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        table.backgroundColor = self.view.backgroundColor
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 100))
        footView.backgroundColor = self.view.backgroundColor
        table.tableFooterView = footView
        
        footView.addSubview(btn)
        btn.backgroundColor = UIColor.orange
        btn.frame = CGRect(x: 25, y: 20, width: MAIN_SCREEN_WIDTH-50, height: 40)
        btn.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
        
        let sView = UIImageView.init(frame: CGRect(x: btn.frame.size.width-30, y: 0, width: 30, height: 40))
        sView.backgroundColor = HexColor("#BD5120")
        btn.addSubview(sView)
        
        let imageView = UIImageView.init(frame: CGRect(x: 8, y:10, width: 14, height: 20))
        imageView.image = #imageLiteral(resourceName: "project_plan_down")
        sView.addSubview(imageView)
        
        chooseBtn.backgroundColor = HexColor("#BD5120")
        chooseBtn.frame = CGRect(x: 25, y: 60.5, width: MAIN_SCREEN_WIDTH-50, height: 40)
        chooseBtn.setTitleColor(.white, for: .normal)
        chooseBtn.isHidden = true
        chooseBtn.addTarget(self, action: #selector(chooseBtnclick), for: .touchUpInside)
        footView.addSubview(chooseBtn)
    }
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            
            
            let num = (self.mArray.count-1)/2
            let height = (num+1)*30 + (num+2)*5 + 30
            let result = CGFloat(height)<50.0 ? 50.0 :CGFloat(height)
            
            return result
        }
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4  {
            return 50
        }
        var textHeight:CGFloat = 0
        textHeight = self.heightForView(text: (myPlanModel?.action_target)!, font: UIFont.systemFont(ofSize: 17), width: SCREEN_WIDTH-40)
        return 60+textHeight
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        //QF -- mark -- 调整行间距
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        //label.attributedText = setStr
        label.sizeToFit()
        return label.frame.height+label.font.ascender
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myPlanModel != nil {
            return  5
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            
            let cellIde = "ProPlanDetailCell"
            var cell:ProPlanDetailCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProPlanDetailCell
            if cell == nil {
                cell = ProPlanDetailCell.init(style: .default, reuseIdentifier: cellIde)
            }
            cell?.setData(array:mArray)
            return cell!
        }else if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4  {
            let cellIde = "ProPlanDetailDefaultCell"
            var cell:ProPlanDetailDefaultCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProPlanDetailDefaultCell
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ProPlanDetailDefaultCell", owner: nil, options: nil)?.last as! ProPlanDetailDefaultCell)
            }
            if indexPath.row == 0{
                if isProjectIn == false{
                    cell?.nextArrow.isHidden = false
                }else{
                    cell?.nextArrow.isHidden = true
                }
                cell?.cellTitleLabel.text = "项目名称:"
                cell?.cellDetailLabel.text = model?.name
            }else if indexPath.row == 2{
                cell?.nextArrow.isHidden = true
                cell?.cellTitleLabel.text = "行动类型:"
                cell?.cellDetailLabel.text = (myPlanModel?.action_style_name)!
            }else{
                cell?.nextArrow.isHidden = true
                cell?.cellTitleLabel.text = "行动时间:"
               
                cell?.cellDetailLabel.text = Date.timeIntervalToDateDetailStrStyle(timeInterval: NSString.init(string: (myPlanModel?.overtime)!).doubleValue)
//                cell?.cellDetailLabel.text = myPlanModel?.date + myPlanModel?.date_d + " "
            }
            
            return cell!
        }else{
            let cellIde = "ProPlanDetailDesCell"
            var cell:ProPlanDetailDesCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? ProPlanDetailDesCell
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ProPlanDetailDesCell", owner: nil, options: nil)?.last as! ProPlanDetailDesCell)
            }
            cell?.cellDesLabel.text = (myPlanModel?.action_target)!
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isProjectIn == false{
            if indexPath.row == 0 {
                self.selectProject(projectId: (model?.id)!)
            }
        }
        
        
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func chooseBtnclick(){
        self.openAndClose()
        self.chooseBtn.isHidden = true
    }

    @objc func btnclick(){
        
        //var str = ""
        if self.myPlanModel?.is_achieve == "1" {
            //1 是关闭状态
            chooseBtn.setTitle("未完成", for: .normal)
            //str = "您确定要将计划状态变更为未完成吗"
        }else{
            chooseBtn.setTitle("完成", for: .normal)
            //str = "您确定要将计划状态变更为完成吗"
           
            
        }
        self.chooseBtn.isHidden = !self.chooseBtn.isHidden
        
        
//        let alert = UIAlertController.init(title: str, message: "", preferredStyle: .alert, btns: [kCancel:"否","yes":"是"]) {[weak self] (a, key) in
//            if key == "yes"{
//                self?.openAndClose()
//            }
//        }
//        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //暂时没用到
    func selectProject(projectId: String) {
        print(projectId)
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":projectId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                let tab = ProjectSituationTabVC()
                tab.model = model; self?.navigationController?.pushViewController(tab, animated: true)
            }
        }
        
    }

}

