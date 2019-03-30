//
//  QFAddressVC.swift
//  SLAPP
//
//  Created by qwp on 2018/5/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

enum TYPE {
    case Provence
    case City
    case Region
    case Def
    case Default
}

protocol QFAddressVCDelegate:NSObjectProtocol {
    func selectId(id:String,string:String,type:TYPE);
}

class QFAddressVC: UIViewController {

    var dataArray = Array<Any>()
    
    var delegate:QFAddressVCDelegate?
    
    
    var type = TYPE.Default
    
    var baseId = ""
    
    
    let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch type {
        case .Provence:
            self.title = "请选择省"
            self.getProvince(idStr: "0") {
                self.tableView.reloadData()
                print("QF -- log : province ",self.dataArray)
            }
            break
        case .City:
            self.title = "请选择市"
            self.getCity(idStr: baseId) {
                self.tableView.reloadData()
                print("QF -- log : city ",self.dataArray)
            }
            break
        case .Region:
            self.title = "请选择地区"
            self.getRegion(idStr: baseId) {
                self.tableView.reloadData()
                print("QF -- log : Region ",self.dataArray)
            }
            break
        case .Def:
            self.title = "请选择部门"
            self.getDep(idStr: baseId) {
                self.tableView.reloadData()
                print("QF -- log : 部门 ",self.dataArray)
            }
            break
        default:
            break
        }
    }
    func tableViewConfig(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /// 获取省
    func getProvince(idStr:String,finish:@escaping ()->()){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROVINCE, params: [:].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            finish()
        }) { (dic) in
            PublicMethod.dismiss()
            self.dataArray.removeAll()
            self.dataArray = dic["data"] as! [Any]
            finish()
        }
        
    }
    
    
    ///
    func getCity(idStr:String,finish:@escaping ()->()){
        let parent_id = idStr
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CITIES, params: ["provinceid":parent_id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            finish()
        }) { (dic) in
            PublicMethod.dismiss()
            self.dataArray.removeAll()
            self.dataArray = dic["data"] as! [Any]
            finish()
        }
        
    }
    
    func getRegion(idStr:String,finish:@escaping ()->()){
        let parent_id = idStr
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: REGION, params: ["cityid":parent_id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            finish()
        }) { (dic) in
            PublicMethod.dismiss()
            self.dataArray.removeAll()
            self.dataArray = dic["data"] as! [Any]
            finish()
        }
    }
    func getDep(idStr:String,finish:@escaping ()->()){
        let parent_id = idStr
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: QF_SHOW_DEP, params: ["dep_id":parent_id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            finish()
        }) { (dic) in
            PublicMethod.dismiss()
            self.dataArray.removeAll()
            self.dataArray = dic["data"] as! [Any]
            finish()
        }
        
    }

}
extension QFAddressVC:UITableViewDelegate,UITableViewDataSource  {
    //MARK: - tableview代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CELL"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        let dict:Dictionary<String,Any> = self.dataArray[indexPath.row] as! Dictionary<String,Any>
        if type == .Provence{
            cell?.textLabel?.text = dict["province"] as! String
        }
        if type == .City{
            cell?.textLabel?.text = dict["city"] as! String
        }
        if type == .Region{
            cell?.textLabel?.text = dict["area"] as! String
        }
        if type == .Def{
            cell?.textLabel?.text = dict["name"] as! String
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    //点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict:Dictionary<String,Any> = self.dataArray[indexPath.row] as! Dictionary<String,Any>
        var resultId = ""
        var resultStr = ""

        switch type {
        case .Provence:
            resultId = dict["provinceid"]! as! String
            resultStr = dict["province"]! as! String
            break
        case .City:
            resultId = dict["cityid"]! as! String
            resultStr = dict["city"]! as! String
            break
        case .Region:
            resultId = dict["areaid"]! as! String
            resultStr = dict["area"]! as! String
            break
        case .Def:
            resultId = dict["id"]! as! String
            resultStr = dict["name"]! as! String
            break
        default:
            break
        }
        
        self.delegate?.selectId(id: resultId, string: resultStr,type: type)
        self.navigationController?.popViewController(animated: true)
    }
    
}
