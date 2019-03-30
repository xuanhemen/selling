//
//  QFFollowUpProjectListVC.swift
//  SLAPP
//
//  Created by qwp on 2018/7/18.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit

class QFFollowUpProjectListVC: BaseVC {

    var dataArray = Array<QFFollowUpProjectModel>()
    var isContact = true
    let tableView = UITableView.init()
  @objc var id = ""
    
    var selectProjectModel:(_ model:QFFollowUpProjectModel)->() = {_ in
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = HexColor("#F2F2F2")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.addEmptyViewWithNoAction()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        
        
        var params = Dictionary<String,Any>()
        var urlStr = FOLLOWUP_PROJECT_LIST
        if isContact == true {
            self.title = "联系人所有项目"
            params["contact_id"] = self.id
//            urlStr = QF_contact_projectlist
        }else{
            self.title = "客户所有项目"
            params["client_id"] = self.id
//            urlStr = CLIENT_PROJECT_LIST
        }
        
        LoginRequest.getPost(methodName: urlStr, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            DLog(dic)
            self?.dataArray.removeAll()
            let array = dic["data"] as! Array<Dictionary<String,Any>>
            for subDic in array {
                let model = QFFollowUpProjectModel.init()
                model.id = String.noNilStr(str: subDic["id"])
                model.name = String.noNilStr(str: subDic["name"])
                self?.dataArray.append(model)
            }
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}

extension QFFollowUpProjectListVC:UITableViewDelegate,UITableViewDataSource  {
    //MARK: - tableview代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "QFFollowUpProjectCell"
        var cell:QFFollowUpProjectCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? QFFollowUpProjectCell
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("QFFollowUpProjectCell", owner: nil, options: nil)?.last as! QFFollowUpProjectCell)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        cell?.numLabel.text = String.init(format: "%ld", indexPath.row)
        let model = self.dataArray[indexPath.row]
        cell?.nameLabel.text =  model.name
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
        let headerView = UIView.init(frame: frame)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    //点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray[indexPath.row]
        self.selectProjectModel(model)
        self.navigationController?.popViewController(animated: true)
    }
    
}
