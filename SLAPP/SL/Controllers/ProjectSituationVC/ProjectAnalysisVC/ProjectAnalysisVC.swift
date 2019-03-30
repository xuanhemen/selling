//
//  ProjectAnalysisVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProjectAnalysisVC: BaseVC {
    var isAuth:Bool = false
    
    var model:ProjectSituationModel?
    var flowView:ProSituationFlowView?
    //角色信息
    let roleView = RoleAnalysisView.init(frame: CGRect.zero)
   let cardView = CardView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "形势与流程"
        self.configUI()
        self.configData()
        roleView.isAuth = (model?.save_auth == "1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.toReloadData()
    }
    
    func configData(){
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id!
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_SHOW_PRO_SPBE, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { [weak self](dic) in
            DLog(dic)
            PublicMethod.dismiss()
            if let array:Array<Dictionary<String,Any>> = dic["data"] as? Array<Dictionary<String, Any>>{
                var result = Array<ProAnalysisModel>()
                for subDic in array {
                    let model = ProAnalysisModel.deserialize(from: subDic)
                    result.append(model!)
                }
                self?.configFlowData(result: result)
            }
        }
    }
    
    
    //还原形势流程历史选择
    func configFlowData(result:Array<ProAnalysisModel>){
        if (self.model?.logic_situation.count)! > 0 {
            if (self.model?.logic_situation.count)! == result.count{
                for i in 0 ..< (self.model?.logic_situation.count)! {
                    let lModel = self.model?.logic_situation[i]
                    let model = result[i]
                    let array = model.list.filter({[weak lModel] (subModel) -> Bool in
                       return subModel.index == lModel?.index
                    })
                    if array.count > 0{
                    model.select = array.first
                 }
                }
            }
            self.flowView?.dataArray = result
        }
        else{
            self.flowView?.dataArray = result
        }
        
        if (self.model?.logic_situation.count)! > 0 {
            self.cardView.configSelect(with: 11)
        }
    }
    
    
    func configUI(){
        
        
        
        cardView.backgroundColor = kGrayColor_Slapp
        cardView.titleNormalColor = HexColor("85899c")
        cardView.titleSelectColor = UIColor.white
        cardView.bottomLineNormalColor = UIColor.orange
        cardView.creatBtns(withTitles: ["形势与流程","角色分析"])
        cardView.btnClickBlock = ({[weak backScrollView] (tag) in
            
            backScrollView?.contentOffset = CGPoint.init(x: MAIN_SCREEN_WIDTH*CGFloat(tag-10), y: 0)
            return false
        }
        )
        self.view.addSubview(cardView)
        cardView.configSelect(with: 10)
        
        self.view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints {[weak cardView] (make) in
            make.top.equalTo((cardView?.snp.bottom)!).offset(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        backScrollView.backgroundColor = UIColor.yellow
        
        flowView = ProSituationFlowView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT-50))
        
        backScrollView.addSubview(flowView!)
        flowView?.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(MAIN_SCREEN_WIDTH)
            make.height.equalToSuperview()
        }
        
        flowView?.click = { [weak self] in
            self?.toSaveFlow()
        }
        
        
        roleView.model = self.model
        backScrollView.addSubview(roleView)
        roleView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(MAIN_SCREEN_WIDTH)
            make.width.equalTo(MAIN_SCREEN_WIDTH)
            make.height.equalToSuperview()
        }
        

        //删除  和 查看
        roleView.roleAction = {[weak self,weak roleView] (type,pid,index) in
            if type == 0 {
                let vc = RoleInfoVC()
                vc.isAuth = self?.isAuth
                vc.situationModel = self?.model
                vc.id = pid
                self?.navigationController?.pushViewController(vc, animated: true)
            }else if type == 1{
                let alert = UIAlertController.init(title: "确定删除吗？", message: "", preferredStyle: .alert, btns: [kCancel:"取消","sure":"确定"], btnActions: { (ac, str) in
                    if str != kCancel {
                        PublicMethod.showProgress()
                        LoginRequest.getPost(methodName: PROJECT_DEL_PEOPLE, params: ["people_id":pid].addToken(), hadToast: true, fail: { (dic) in
                            PublicMethod.dismiss()
                        }) {[weak self] (dic) in
                            self?.model?.logic_people.remove(at: index.row)
                            roleView?.table.reloadData()
                            PublicMethod.dismissWithSuccess(str: "删除成功")
                            
                        }
                    }
                })
                self?.present(alert, animated: true, completion: nil)
            }else if type == 2 {
                self?.fetchRoleData(id: pid)
                
            }else{
                
            }
            
        }
        
        //添加  和  生成报告
        roleView.click = {[weak self](type) in
            if type == .add {
                PublicMethod.showProgress()
                LoginRequest.getPost(methodName:PARAM_PEOPLE, params: ["project_id":self?.model?.id].addToken(), hadToast: true, fail: { (dic) in
                    PublicMethod.dismiss()
                }, success: {[weak self] (dic) in
                   
                    PublicMethod.dismiss()
                    if  let model:ProParamsPeople = ProParamsPeople.deserialize(from: dic)!{
                        let vc =  ProjectAddRoleAnalysisVC();
                        vc.projectId = self?.model?.id
                        vc.situationModel = self?.model
                        vc.model = model;
                        vc.click = { [weak self](_,_) in
//                            self?.toReloadData()
                        }
                    self?.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }
            else{
                
                PublicMethod.showProgress()
                LoginRequest.getPost(methodName:PROJECT_OPEN_CLOSE, params: ["project_id":self?.model?.id,"close_status":"0"].addToken(), hadToast: true, fail: { (dic) in
                    PublicMethod.dismiss()
                }, success: {[weak self] (dic) in
                   
                    PublicMethod.dismiss()
                    PublicMethod.toastWithText(toastText: JSON(dic["msg"]).stringValue)
                    self?.toSwitcher()
                })
            }
        }
        
        
        
        
       let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH*2, height: backScrollView.height))
        view.backgroundColor = UIColor.green
        backScrollView.addSubview(view)

    }
    
    func toReloadData(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                self?.model = model;
                self?.roleView.model = self?.model
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    
    
    
    //保存或修改形势流程
    func toSaveFlow(){
        
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id!
        var more = Dictionary<String,String>()
        for model in (flowView?.dataArray)! {
            if model.select != nil{
                more[model.key] = model.select?.index
            }else{
                more[model.key] = ""
            }
        }
        params["more"] = BaseRequest.makeJsonStringWithObject(object: more)
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_SAVE_SPBE, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
             PublicMethod.dismiss()
             PublicMethod.toastWithText(toastText: "提交成功")
             self?.cardView.configSelect(with: 11)
        }
    }
    
    //分析完成后立马切换到分析结果
    func toSwitcher(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toSwitcher"), object: nil)
        self.navigationController?.popViewController(animated: true)
//        todo
//        let tab:ProjectSituationTabVC = self.tabBarController as! ProjectSituationTabVC
//        tab.toSwitcher()
    }
    
    
    
    lazy var backScrollView = { () -> UIScrollView in
        let sc = UIScrollView()
        sc.contentSize = CGSize.init(width: MAIN_SCREEN_WIDTH*2, height: 0)
        sc.isScrollEnabled = false
        return sc
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    //先获取到角色信息 再修改
    func fetchRoleData(id:String){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: LOGIC_PEOPLE_INFO, params: ["people_id":id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            if let mymodel = LogicPeopleInfoModel.deserialize(from: dic){
                if Int(mymodel.save_auth)!>=1  {
                    self?.gotoEditRole(projectId: (self?.model?.id)!,roleModel:mymodel)
                }
            }
            
        }
    }
    
    
    //修改
    func gotoEditRole(projectId:String,roleModel:LogicPeopleInfoModel) {
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName:PARAM_PEOPLE, params: ["project_id":projectId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }, success: {[weak self] (dic) in
            PublicMethod.dismiss()
            if  let newModel:ProParamsPeople = ProParamsPeople.deserialize(from: dic)!{
                let vc =  ProjectAddRoleAnalysisVC();
                vc.projectId = projectId
                vc.parentid = roleModel.parentid
                vc.situationModel = self?.model
                vc.model = newModel
                vc.peopleId = roleModel.id
                
                vc.textArray = [ roleModel.name,roleModel.department,roleModel.level_str,roleModel.style_str,roleModel.sub_str,roleModel.impact_str,roleModel.engagement_str,roleModel.feedback_str,roleModel.support_str,roleModel.orgresult_str,roleModel.personalwin_str,roleModel.parent_str]
                if !(roleModel.coach_str.isEmpty) {
                    vc.textArray.insert(roleModel.coach_str, at: 11)
                }
                self?.navigationController?.pushViewController(vc, animated: true)
                vc.click = {[weak self](_,_) in
                    self?.configData()
                }
            }
        })
    }
}
