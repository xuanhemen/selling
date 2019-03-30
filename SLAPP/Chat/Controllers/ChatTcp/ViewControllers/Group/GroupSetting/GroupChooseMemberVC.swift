//
//  GroupChooseMemberVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/4/5.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
class GroupChooseMemberVC: BaseTableVC {

    typealias backBlock = (_ user:GroupUserModel)->()
    var groupId :String?
    var block : backBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择提醒的人"
       let leftBtn = UIButton.init(type: .custom)
        leftBtn.frame = CGRect.init(x: 0, y: 100, width: 60, height: 30)
      
        leftBtn.setTitle("取消", for:.normal)
        leftBtn.setTitleColor(UIColor.white, for: .normal)
        leftBtn.sizeToFit()
        let leftItem  = UIBarButtonItem.init(customView: leftBtn)
        leftBtn.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = leftItem

        self.hidenChooseIcon = true
        
        
        self.configUIWith(fromCellName: "BaseTableCell", fromIsShowSearch: true,fromSearchType: false ,fromCellHeight: 44)
        let predicate = NSPredicate(format:"groupid == %@ AND userid != %@ AND is_delete == '0'", groupId!,sharePublicDataSingle.publicData.userid)
        self.allDataArray =  GroupUserModel.allObjects().objects(with: predicate) as! RLMResults<RLMObject>
        self.setDataArray(dataArray:(self.allDataArray!))

    }

    @objc func leftClick(){
       self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.searchView?.searchView.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.allDataArray?.object(at: UInt(indexPath.row))
        block?(model as! GroupUserModel)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func searchBarTextChangedWith(nowText: String) {
        if nowText.isEmpty {
            self.dataArray = self.allDataArray
        }
        else{
            
            let pre = NSPredicate.init(format: "realname CONTAINS %@", nowText)
            self.dataArray = self.allDataArray?.objects(with: pre)
        }
        
        table?.reloadData()
    }
    
    
    func backWithUserName(username:@escaping backBlock){
      block = username
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
