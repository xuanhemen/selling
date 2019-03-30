//
//  RCConversationViewController+Extension.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 2017/7/12.
//  Copyright © 2017年 柴进. All rights reserved.
//

import Foundation
import SwiftyJSON
extension RCConversationViewController{
    
    
    func getReportInfo(pid:String,result:@escaping (_ model:ChatReportInfoModel)->()){
        PublicMethod.showProgress()
        LoginRequest.getPostWithTask(methodName: project_analyse_report_info, params: ["project_id":pid,"app_token":UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { (dic) in
            PublicMethod.dismiss()
            if let model =  ChatReportInfoModel.deserialize(from: dic){
                result(model)
            }
        }
    }
    
    
    
    func getRrojectList(userid:String,result:@escaping (_ resultModel:Dictionary<String,Any>)->()){
        PublicMethod.showProgress()
        LoginRequest.getPostWithTask(methodName: tcp_project_list, params: ["teacher_im_userid":userid,"app_token":UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { (dic) in
            
            PublicMethod.dismiss()
            result(dic)
//            if let model =  ChatReportInfoModel.deserialize(from: dic){
//                result(model)
//            }
        }
    }
    
    
    
    
    func chooseShow(cell:RCMessageBaseCell,isShow:Bool,listArray:NSArray,btn:UIButton){
        
        if isShow == true {
            
            let myImageView:UIImageView = UIImageView.init()
            myImageView.tag = 1234
            myImageView.contentMode = .scaleAspectFit
            btn.tag = cell.model.messageId
            
            if listArray.contains("\(cell.model.messageId)"){
//                btn.setImage(UIImage.init(named: "logic_select"), for: .normal)
                
                myImageView.image = UIImage.init(named: "logic_select")
            }else{
//                btn.setImage(UIImage.init(named: "logic_normal"), for: .normal)
                
                myImageView.image = UIImage.init(named: "logic_normal")
            }
            let subView = cell.value(forKey: "portraitImageView") as! UIImageView
            cell.contentView.addSubview(myImageView)
            cell.contentView.addSubview(btn)
            if cell.model.messageDirection == .MessageDirection_RECEIVE {
            cell.baseContentView.frame = CGRect(x:40, y: cell.baseContentView.frame.origin.y, width: cell.baseContentView.frame.size.width, height: cell.baseContentView.frame.size.height)
//                btn.frame = CGRect(x: 0, y:subView.frame.origin.x+5, width: 30, height: 30)
                //            btn?.center = CGPoint(x: 25, y: subView.center.y)

                
                myImageView.mas_makeConstraints({[weak subView,cell] (make) in
                    
                    make!.centerY.equalTo()(subView)
                    make!.left.equalTo()(cell)?.offset()(15)
                    make!.width.equalTo()(20)
                    make!.height.equalTo()(20)
                })
            }
            else{
                cell.baseContentView.frame = CGRect(x:-40, y: cell.baseContentView.frame.origin.y, width: cell.baseContentView.frame.size.width, height: cell.baseContentView.frame.size.height)
                myImageView.frame = CGRect(x:kScreenW-30, y: subView.frame.origin.x+5, width: 40, height:40)
                
                
                
                
                myImageView.mas_makeConstraints({[weak subView,cell] (make) in
                    make!.centerY.equalTo()(subView)
                    make!.right.equalTo()(cell)?.offset()(-15)
                    make?.width.equalTo()(20)
                    make?.height.equalTo()(20)
                })
                
                
                
            }
            
            cell.baseContentView.isUserInteractionEnabled = false
//            cell.contentView.bringSubview(toFront: btn)
            //            btn?.addTarget(self, action: #selector(btnClick(_:)), for:.touchUpInside )
        }else{
            
            cell.contentView.addSubview(btn)
            
            cell.baseContentView.isUserInteractionEnabled = false
            if cell.model.messageDirection == .MessageDirection_RECEIVE {
                cell.baseContentView.frame = CGRect(x:40, y: cell.baseContentView.frame.origin.y, width: cell.baseContentView.frame.size.width, height: cell.baseContentView.frame.size.height)
            }
            else{
                cell.baseContentView.frame = CGRect(x:-40, y: cell.baseContentView.frame.origin.y, width: cell.baseContentView.frame.size.width, height: cell.baseContentView.frame.size.height)
            }
            
        }
        
        
        btn.mas_makeConstraints({ [weak cell](make) in
            
            make?.top.equalTo()(cell?.contentView)
            make?.bottom.equalTo()(cell?.contentView)
            make?.left.equalTo()(cell?.contentView)
            make?.right.equalTo()(cell?.contentView)
            
        })
        
        
        
    }

    
}

extension RCMessageBaseCell {
  
    
    
    /// 清除cell原本没有的控件 （多选时，自己添加了一些控件）
    func clearCell(){
        let imgview = self.contentView.viewWithTag(1234)
        if imgview != nil {
            imgview?.removeFromSuperview()
        }
        
        for btnView in self.contentView.subviews {
            if btnView.isKind(of: UIButton.self) {
                btnView.removeFromSuperview()
            }
        }
        self.baseContentView.isUserInteractionEnabled = true
    }

}

