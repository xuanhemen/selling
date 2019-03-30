//
//  ProEditRoleInfoVC.swift
//  SLAPP
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProEditRoleInfoVC: BaseVC {
    //是否有编辑权限
    var isAuth:Bool = false
    var model:ProjectSituationModel?
    let roleView = RoleAnalysisView.init(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: 有问题   添加上级后应该只是刷新  角色信息就可以   但是没有时间改  
        self.toSwitcher()
    }
    
    
    func toSwitcher(){
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
    
   
    
    
    
    
    func configUI(){
        
        self.view.backgroundColor = UIColor.white
        roleView.isAuth = self.isAuth
        roleView.model = self.model
        self.view.addSubview(roleView)
        
        roleView.createBtn.isHidden = true
        roleView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
        //删除  和 查看
        roleView.roleAction = {[weak self,weak roleView] (type,pid,index) in
            if type == 0 {
                let vc = RoleInfoVC()
                vc.isAuth = self?.isAuth
                vc.situationModel = self?.model
                vc.id = pid
                self?.navigationController?.pushViewController(vc, animated: true)
                vc.click = { [weak self] in
                    self?.toSwitcher()
                }
            }
            else if type == 2{
                
                
                self?.fetchRoleData(id: pid)
                
            }
            else{
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
                        vc.click = { [weak self] (_,_)  in
//                            self?.toSwitcher()
                        }
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }
            else{
                
                PublicMethod.showProgress()
                LoginRequest.getPost(methodName:PROJECT_OPEN_CLOSE, params: ["project_id":self?.model?.id,"close_status":"0"].addToken(), hadToast: true, fail: { (dic) in
                    PublicMethod.dismiss()
                }, success: {[weak self](dic) in
                    PublicMethod.dismiss()
                    PublicMethod.toastWithText(toastText: JSON(dic["msg"]).stringValue)
                    self?.toSwith()
                })
            }
        }
        
    }
    
    func toSwith(){
        
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toSwitcher"), object: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                vc.contact_id = roleModel.contact_id
                vc.textArray = [ roleModel.name,roleModel.department,roleModel.level_str,roleModel.style_str,roleModel.sub_str,roleModel.impact_str,roleModel.engagement_str,roleModel.feedback_str,roleModel.support_str,roleModel.orgresult_str,roleModel.personalwin_str,roleModel.parent_str]
                if !(roleModel.coach_str.isEmpty) {
                    vc.textArray.insert(roleModel.coach_str, at: 11)
                }
                self?.navigationController?.pushViewController(vc, animated: true)
                vc.click = {[weak self](_,_) in
                    self?.toSwitcher()
                }
            }
        })
    }
    
    
}
