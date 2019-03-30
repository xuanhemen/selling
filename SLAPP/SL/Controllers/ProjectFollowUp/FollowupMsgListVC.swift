//
//  FollowupMsgListVC.swift
//  SLAPP
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class FollowupMsgListVC: UITableViewController {
    //类型
    var type:VC_CHOOSE_TYPY?
    var dataArray = Array<MyFollowupModel>()
   @objc var proId:String = ""
    
    @objc var contactId = ""
    @objc var contactName = ""
    @objc var clientId = ""
   
    
    
    
    
    
    
    /// 做type赋值
    ///
    /// - Parameter type: 0 - 1 - 2 客户  联系人  项目
    @objc func configType(t:Int){
        if t == 0 {
            self.type = .client
        }else if t == 1 {
            self.type = .contact
        }else{
            self.type = .project
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "与我相关的消息"
        self.tableView.register(MyFollowupCell.self, forCellReuseIdentifier: "cell")
        self.configData()
        self.tableView.tableFooterView = UIView()
    }
    
    
    func configData(){
        
        var url = ""
        switch self.type! {
        case .client:
            url = CLIENT_MY_FOLLOW_MESSAGE
        case .contact:
            url = QF_contact_followup_message
        case .project :
            url = MY_FOLLOW_MESSAGE
        default: break
            
        }
        
        
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: url, params: ["id":proId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            DLog(dic)
            PublicMethod.dismiss()
            for subDic in JSON(dic["data"] as Any).arrayObject!{
                if let model = MyFollowupModel.deserialize(from: JSON(subDic).dictionary){
                    self?.dataArray.append(model)
                }
            }
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyFollowupCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyFollowupCell
        cell.model = self.dataArray[indexPath.row];
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.type! {
        case .project:
            let vc = SDTimeLineTableDetailViewController()
            vc.cId = self.dataArray[indexPath.row].fo_id
            vc.proID = self.proId
            self.navigationController?.pushViewController(vc, animated: true)
        case .client:
            let vc = CustomerFollowUpDetailVC()
            vc.customerId = self.proId
            vc.cId = self.dataArray[indexPath.row].fo_id
            self.navigationController?.pushViewController(vc, animated: true)
        case .contact:
            let vc = QFTimeLineDetailVC()
            vc.cId = self.dataArray[indexPath.row].fo_id
            vc.contactId = self.contactId
            vc.contactName = self.contactName
            vc.clientId = self.clientId
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
