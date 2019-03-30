//
//  HYClientAndContactsVisitListVC.swift
//  SLAPP
//
//  Created by apple on 2018/12/21.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class HYClientAndContactsVisitListVC: BaseVC {

   @objc var clientId:String = "";
   @objc var contactId:String = ""
    
    var tableView = UITableView()
    var dataArray:Array<HYVisitModel> = []
    let numView = HYVisitNumView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 45))
    
    var dataResult = Dictionary<String,Any>();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "相关拜访"
        self.view.backgroundColor = UIColor.init(red: 235/255.0, green: 234/255.0, blue: 241/255.0, alpha: 1)
        self.view.addSubview(numView)
        self.tableViewConfig(frame: CGRect(x: 0, y:45, width: MAIN_SCREEN_WIDTH, height:MAIN_SCREEN_HEIGHT_PX-45-NAV_HEIGHT))
        numView.statusClick = { [weak self] (_) in
            self?.refreshTable()
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configData()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func configData(){
        PublicMethod.showProgress()
        var params = Dictionary<String,Any>()
        if self.contactId.isEmpty {
            params["searchkeyval"] = ["customer":self.clientId]
        }else{
            params["searchkeyval"] = ["contact":self.contactId]
        }
        
        LoginRequest.getPost(methodName: kotherVisit_list, params: params.addToken(), hadToast: true, fail: {[weak self] (f) in
            PublicMethod.dismissWithError()
            self?.tableView.mj_header.endRefreshing()
        }) {[weak self] (s) in
            PublicMethod.dismiss()
            self?.tableView.mj_header.endRefreshing()
            self?.dataResult = s;
            self?.numView.refresh(withResult: s)
            self?.refreshTable()
        }
        
    }
    
    
    
    
    /// 刷新界面，展示当前状态下的数据   没有选择的展示全部
    func refreshTable(){
        self.addEmptyNoti()
        
        guard !dataResult.isEmpty else {
            return
        }
        self.dataArray.removeAll()
        let status = numView.currentStatusKey()
        if status == "" {
            if dataResult["list"] != nil{
                for sub in JSON(dataResult["list"] as Any).arrayObject! {
                    let model:HYVisitModel = HYVisitModel.mj_object(withKeyValues: sub)
                    self.dataArray.append(model)
                }
            }
        }else if status == "0"{
            
            if dataResult["zblist"] != nil{
                for sub in JSON(dataResult["zblist"] as Any).arrayObject! {
                    let model:HYVisitModel = HYVisitModel.mj_object(withKeyValues: sub)
                    self.dataArray.append(model)
                }
            }
            
        }else if status == "1"{
            if dataResult["wclist"] != nil{
                for sub in JSON(dataResult["wclist"] as Any).arrayObject! {
                    let model:HYVisitModel = HYVisitModel.mj_object(withKeyValues: sub)
                    self.dataArray.append(model)
                }
            }
            
        }else if status == "2"{
            if dataResult["tclist"] != nil{
                for sub in JSON(dataResult["tclist"] as Any).arrayObject! {
                    let model:HYVisitModel = HYVisitModel.mj_object(withKeyValues: sub)
                    self.dataArray.append(model)
                }
            }
            
        }
        self.tableView.reloadData()
        
    }
    
    
    
   
    
    
    //MARK: - ***********  UIConfig    ***********
    
    func tableViewConfig(frame:CGRect)  {
        self.tableView = UITableView.init(frame: frame, style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        //        self.tableView.tableFooterView = footViewConfig()
        self.view.addSubview(self.tableView)
        
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.configData()
        })
        
    }
    
    
    /// 无数据时候的提醒
    func addEmptyNoti(){
        
        let status = numView.currentStatusKey()
        var str = ""
        switch status {
        case "":
            str = "没有拜访记录"
        case "0":
            str = "没有准备中的拜访记录"
        case "1":
            str = "没有完成的拜访记录"
        case "2":
            str = "没有推迟的拜访记录"
        default:
            break;
        }
        self.tableView.addEmptyViewWithTitle(titleStr: str)
    }
}

extension HYClientAndContactsVisitListVC:UITableViewDelegate,UITableViewDataSource  {
    //MARK: - ***********   tableview代理    ***********
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return self.dataArray.count
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
        //        return self.dataArray[section].count
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        HYVisitHomeCell.h
        
        let cellID = "HYVisitHomeCell"
        var cell:HYVisitHomeCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? HYVisitHomeCell
        if cell == nil {
            cell = HYVisitHomeCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        cell?.model = self.dataArray[indexPath.row]
        //        cell?.setData(model: self.dataArray[indexPath.section][indexPath.row])
        self.configCell(cell: cell!)
        return cell!
        
        //        let cellID = "QFProjectPlanCell"
        //        var cell:QFProjectPlanCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? QFProjectPlanCell
        //        if cell == nil {
        //            cell = QFProjectPlanCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
        //            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //        }
        //        cell?.setData(model: self.dataArray[indexPath.section][indexPath.row])
        //        return cell!
    }
    
    func configCell(cell:HYVisitHomeCell){
        cell.bottomClickWithKey = { [weak self] (key,vModel) in
            if key == "查看"
            {
                let vc = HYLookatVisitVC()
                vc.visit_id = vModel?.id
                self?.navigationController?.pushViewController(vc, animated: true)
            }else if key == "总结"
            {
                let vc = HYSummaryVC()
                vc.visit_id = vModel?.id
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }else if key == "预约"
            {
                let vc = HYReservationVC()
                vc.visitId = vModel?.id
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }else if key == "准备"
            {
                let vc = HYVisitDetailVC()
                vc.visit_id = vModel?.id
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            
        }
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        //        let headerView = UIView.init(frame: frame)
        //        headerView.backgroundColor = self.view.backgroundColor
        //
        //        let model = self.dataArray[section].first
        //
        //        self.headerViewLabelConfig(frame: CGRect(x: 15, y: 5, width: headerView.frame.size.width-30, height: 20), fatherView: headerView,text: (model?.date)!)
        //        return headerView
        return nil;
    }
    func headerViewLabelConfig(frame:CGRect,fatherView:UIView,text:String){
        let titleLabel = UILabel.init(frame: frame)
        titleLabel.text = text
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        fatherView.addSubview(titleLabel)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
        //         return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    //点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.dataArray[indexPath.row]
        let vc = HYVisitDetailVC()
        vc.visit_id = model.id;
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        let model = self.dataArray[indexPath.section][indexPath.row]
        //        let vc = QFProjectPlanDetailVC()
        //        vc.isProjectIn = true
        //        vc.planModel = model
        //
        //        vc.model = self.model
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    

}
