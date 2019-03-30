//
//  GroupIsOpenVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/23.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
class GroupIsOpenVC: BaseViewController {

    var userArray:Array<RLMObject>?
    
    @IBOutlet weak var desback: UIView!
    @IBAction func btnClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
       
        if sender.tag == 1000 {
            leftImage.image = UIImage.init(named:"isClose_select")
            rightImage.image = UIImage.init(named:"isOpen_normal")
           self.leftBtn.isSelected = true
        }
        else{
        
            leftImage.image = UIImage.init(named:"isClose_normal")
            rightImage.image = UIImage.init(named:"isOpen_select")
            self.leftBtn.isSelected = false
        }
    }
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var deslable: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.view.backgroundColor = UIColor.groupTableViewBackground
       self.title = "设置群组开放性"
       self.setRightBtnWithArray(items: ["发送"])
       
       self.desback.layer.cornerRadius = 6
       self.desback.clipsToBounds = true
       self.deslable.text = "提示：若您设置为【开放】，则其他用户可通过查找方式申请加入此群组；若设置为【私享】，则其他用户无法查找到该群组，只能通过扫描群二维码的方式加入。                "
        leftBtn.isSelected = true
       
        // Do any additional setup after loading the view.
    }

    override func rightBtnClick(button: UIButton) {
       
        
                    var params = Dictionary<String, Any>()
                    params["app_token"] = sharePublicDataSingle.token
        
        if userArray != nil {
            let idStr = (NSArray.init(array: userArray!).value(forKeyPath: "userid") as! NSArray).componentsJoined(by: ",")
            
            params["userid_str"] = idStr
        }
        else{
            params["userid_str"] = ""

        }
        
        if leftBtn.isSelected {
            params["is_open"] = "0"
        }
        else
        {
           params["is_open"] = "1"
        }
        self.progressShow()
        GroupRequest.creat(params: params, hadToast: true, fail: { [weak self](error) in
            if let strongSelf = self {
                strongSelf.progressDismiss()
            }
            }, success: {[weak self] (success)  in
                print("创建群组成功",success)
                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                
                if time == nil{
                    time = "0"
                }
                
                UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self](error) in
                    if let strongSelf = self {
                        strongSelf.progressDismiss()
                    }

                }, success: {[weak self] (dic) in
                    
                    self?.progressDismiss()
                    self?.navigationController?.popToRootViewController(animated: true)
                    }
                )
                
        })
        
        
        
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
