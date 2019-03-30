//
//  ProjectDetailVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProjectDetailVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var dataArray:Array = Array<Dictionary<String,Any>>()
    var type:String?
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "项目详情列表"
        self.table.backgroundColor = UIColor.groupTableViewBackground
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        self.table.separatorStyle = .none
        self.table.register(UINib.init(nibName: "ProjectDetailCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.configData()
        self.setRightBtnWithArray(items: ["全部"])
    }
    
    override func rightBtnClick(button: UIButton) {
        
       
        sharePublicDataSingle.publicTabbar?.selectedWithIndex(index: 1)
    }
    

    func configData(){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: INTELLISENSE_MORE, params: ["type":type!].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            self?.dataArray = dic["data"] as! Array<[String : Any]>
            self?.table.reloadData()
        }
        
        
    }
    
    
    //MARK: - ---------------------table代理------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        let cell:ProjectDetailCell = tableView.dequeueReusableCell(withIdentifier: cellIde) as! ProjectDetailCell
        let dic:Dictionary<String,Any> = dataArray[indexPath.row]
        cell.selectionStyle = .none
        
        cell.projectName.text = String.noNilStr(str: dic["name"])
//        cell.percent.text = String.noNilStr(str: dic["len"]).appending("%")
        cell.company.text = String.noNilStr(str: dic["client_name"])
        cell.amount.text = String.noNilStr(str: dic["amount"]).appending("万")
        let timeStr = String.noNilStr(str: dic["dealtime"])
        if timeStr.isEmpty {
            cell.time.text = ""
        }else{
            cell.time.text = Date.timeIntervalToDateStr(timeInterval:Double(timeStr)!)
        }
        cell.statusImage.image = UIImage.init(named: "ch_project_stage_icon".appending(String.noNilStr(str: dic["stage"])))

       
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dic:Dictionary<String,Any> = dataArray[indexPath.row]
//        let vc = ProjectSituationVC()
//        vc.projectID = String.noNilStr(str: dic["id"])
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":String.noNilStr(str: dic["id"])].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            DLog(dic)
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
       let tab = ProjectSituationTabVC()
                tab.model = model;
                self?.navigationController?.pushViewController(tab, animated: true)
            }
        }
        
        
        
        
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
////        "http://t-sl.xslp.cn/main.html#/projectSurvey/id/" + oneAtt.0
//        let dic:Dictionary<String,Any> = dataArray[indexPath.row]
////        let url = URL.init(string: h5_host + "main.html#/projectSurvey/id/" + (dic["id"] as! String) + "/app")
//        let canBack = CanBackWebVC()
//        canBack.url = h5_host + "main.html#/projectSurvey/id/" + (String.noNilStr(str: dic["id"])) + "/app"
//        self.navigationController?.pushViewController(canBack, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
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
