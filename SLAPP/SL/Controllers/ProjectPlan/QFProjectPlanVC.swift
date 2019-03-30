//
//  QFProjectPlanVC.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/19.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//
import MJExtension
import UIKit
import SwiftyJSON
class QFProjectPlanVC: UIViewController{

    var tableView = UITableView()
    var model:ProjectSituationModel?
//    var dataArray:Array<Array<QFProjectPlanModel>> = []
    var dataArray:Array<HYVisitModel> = []
    let numView = HYVisitNumView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 45))
    
    var dataResult = Dictionary<String,Any>();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.model?.name
        self.view.backgroundColor = UIColor.init(red: 235/255.0, green: 234/255.0, blue: 241/255.0, alpha: 1)
        self.view.addSubview(numView)
        self.tableViewConfig(frame: CGRect(x: 0, y:45, width: MAIN_SCREEN_WIDTH, height:MAIN_SCREEN_HEIGHT_PX-TAB_HEIGHT-45-NAV_HEIGHT))
        self.setRightBtnWithArray(items: [UIImage.init(named: "nav_add")])
        numView.statusClick = { [weak self] (_) in
            self?.refreshTable()
        }
        
        
        let leftBtn = UIButton.init(type: .custom)
        leftBtn.frame = CGRect(x: -5, y: 0, width: 40, height: 40)
        leftBtn.setImage(#imageLiteral(resourceName: "icon-arrow-left"), for: .normal)
        leftBtn.sizeToFit()
        leftBtn.addTarget(self, action: #selector(leftItemClick(button:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarItem
        
    }

    
    @objc func leftItemClick(button: UIButton) {
       
        self.tabBarController?.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configData()
        self.showTab()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
//
    func showTab(){
        if (self.navigationController?.tabBarController?.isKind(of: ProjectSituationTabVC.self))! {
            let tab:ProjectSituationTabVC = self.navigationController?.tabBarController as! ProjectSituationTabVC
            tab.tab.isHidden = false
            tab.tabBar.isHidden = true
        }
    }
   
    
    func hiddenTab(){
        
        if (self.navigationController?.tabBarController?.isKind(of: ProjectSituationTabVC.self))! {
            let tab:ProjectSituationTabVC = self.navigationController?.tabBarController as! ProjectSituationTabVC
            tab.tab.isHidden = true
            tab.tabBar.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func configData(){
         PublicMethod.showProgress()
        var params = Dictionary<String,Any>()
         params["searchkeyval"] = ["project":model?.id ?? ""]
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
    
    
    
    override func rightBtnClick(button: UIButton) {
        let vc = HYAddVisitVC()
        vc.proModel = self.model
        self.hiddenTab()
        self.navigationController?.pushViewController(vc, animated: true)
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
            str = "该项目下没有拜访记录"
        case "0":
            str = "该项目下没有准备中的拜访记录"
        case "1":
            str = "该项目下没有完成的拜访记录"
        case "2":
            str = "该项目下没有推迟的拜访记录"
        default:
            break;
        }
        self.tableView.addEmptyViewWithTitle(titleStr: str)
    }
    

    @objc func addPlan() {
        let vc = QFAddPlanVC()
        vc.model = self.model
        self.hiddenTab()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension QFProjectPlanVC:UITableViewDelegate,UITableViewDataSource  {
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
            self?.hiddenTab()
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
        self.hiddenTab()
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


