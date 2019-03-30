//
//  ProFollowUpChooseSpecaiVC.swift
//  SLAPP
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProFollowUpChooseSpecaiVC: ProFollowUpChooseMemberVC {

    var clientID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func configData(){
        self.title = "选择提醒人"
        
        guard self.type != nil else {
            return
        }
        PublicMethod.showProgress()
        let url = FOLLOWUP_REMIND_USER_LIST

        var params = Dictionary<String,Any>()
        
        if self.proId != nil {
            params["pro_id"] = self.proId
        }
        
                switch self.type! {
                case .contact:
                     params["contact_id"] = id
                case .client:
                     params["client_id"] = id
                case .clues:
                    print("近")
                default: break
        
                }
        
        
        LoginRequest.getPost(methodName: url, params: params.addToken(), hadToast: true, fail: { (fail) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            DLog(dic)
            PublicMethod.dismiss()
            self?.dataArray.removeAll()
            for subDic in JSON(dic["data"]).arrayObject!{
                let model = MemberModel.deserialize(from: JSON(subDic).dictionaryObject)
                self?.dataArray.append(model!)
            }
            self?.configSelect()
            self?.table.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
