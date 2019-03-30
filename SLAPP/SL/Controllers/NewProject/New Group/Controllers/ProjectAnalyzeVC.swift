//
//  ProjectAnalyzeVC.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/10.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProjectAnalyzeVC: UIViewController,QFRelationalDelegate {
    
    
    @objc var model:ProjectSituationModel?
    @objc var logicId = ""
    
    var myModel:ProjectAnalyzeModel?
    var proBublesModel:ProBublesModel?
    
    var navBarHairlineImageView:UIImageView?
    var table = UITableView()
    var table1 = UITableView()
    var scrollView = UIScrollView()
    var chartScroll = UIScrollView()
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    var qfSegment:QFSegmentView?
    
    var popupBackView:UIView?
    var popupButton:UIButton?
    var isPopup = false
    var planLabel = UITextView()
    
    
    var dataArray1 = [["title":"","data":["",""]],["title":"","data":["",""]],["title":"","data":["",""]],["title":"","data":["",""]]]
    var dataArray1Other = Array<bublesPeopleModel>()
  
    var dataArray = [["title":"风险预警","data":[]],["title":"三板斧","data":[]]]
    
    @objc var isHistory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model?.name
        
        self.view.backgroundColor = HexColor("#EFEFF3")
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 55/255.0, green: 57/255.0, blue: 70/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        
        navBarHairlineImageView = self.findHairlineImageViewUnder(view: (self.navigationController?.navigationBar)!)
        
        qfSegment = QFSegmentView.init(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        qfSegment?.backgroundColor = self.navigationController?.navigationBar.barTintColor
        //qfSegment?.segmentAddElement(titleArray: ["基本信息","组织结构","赢单指数","策略建议"],showCnt:4 ,delegate: self as QFSegmentViewDelegate)
        let showCnt = 3;
        let titleArray = ["基本信息","组织结构","赢单指数"]
        qfSegment?.segmentAddElement(titleArray: titleArray,showCnt:showCnt ,delegate: self as QFSegmentViewDelegate)
        self.view.addSubview(qfSegment!)
        
        var rect = CGRect(x: 0, y: 40, width: width, height: height-104-49)
        if isHistory {
            rect = CGRect(x: 0, y: 40, width: width, height: height-104)
        }
        
        self.scrollView = UIScrollView.init(frame: rect)
        self.scrollView.contentSize = CGSize(width: SCREEN_WIDTH*CGFloat(titleArray.count), height: 0)
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        self.configData()
        
        if isHistory {
            
        }else{
            let rightBtn = UIButton.init(type: .custom)
            rightBtn.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
            rightBtn.setTitle("历史", for: .normal)
            rightBtn.sizeToFit()
            rightBtn.addTarget(self, action: #selector(rightItemClick(button:)), for: .touchUpInside)
            let barItem = UIBarButtonItem.init(customView: rightBtn)
            self.navigationItem.rightBarButtonItem = barItem
        }
        
        
        let leftBtn = UIButton.init(type: .custom)
        leftBtn.frame = CGRect(x: -5, y: 0, width: 40, height: 40)
        leftBtn.setImage(#imageLiteral(resourceName: "icon-arrow-left"), for: .normal)
        leftBtn.sizeToFit()
        leftBtn.addTarget(self, action: #selector(leftItemClick(button:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc func rightItemClick(button: UIButton) {
        
        let historyVC = QFAnalysisHistoryVC()
        historyVC.model = model
        self.hidden()
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    @objc func leftItemClick(button: UIButton) {
        if isHistory {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.tabBarController?.navigationController?.popViewController(animated: true)
        }
    }
    
    func configData(){
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id
        params["logic_id"] = self.logicId
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: LOGICANALYSE, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { [weak self](dic) in
            DLog(dic)
            PublicMethod.dismiss()
            if let model:ProjectAnalyzeModel = ProjectAnalyzeModel.deserialize(from: dic){
                self?.myModel = model
                self?.configArray()
                self?.tableViewConfig()
                self?.configChartView()
                self?.configRelationalView()
            }
        }
        
        
    }
    
    //配置数据源
    func configArray(){
        
        var i = 0
        
        
        if (self.myModel?.risk_warning?.riskTitles().count)!>0 {
            self.dataArray[i]["title"] = self.myModel?.risk_warning?.title
            self.dataArray[i]["data"] = self.myModel?.risk_warning?.riskTitles()
             i += 1
        }else{
            self.dataArray.remove(at: i)
        }
        
        
        if (self.myModel?.three_broad_axe?.threeTitles().count)!>0 {
            self.dataArray[i]["title"] = self.myModel?.three_broad_axe?.title
            self.dataArray[i]["data"] = self.myModel?.three_broad_axe?.threeTitles()
            i += 1
        }else{
            self.dataArray.remove(at: i)
            
        }
        self.table.reloadData()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isHistory {
            if (self.tabBarController?.isKind(of: ProjectSituationTabVC.self))!{
                let tabVC = self.tabBarController as! ProjectSituationTabVC
                tabVC.tab.isHidden = true
                tabVC.tabBar.isHidden = true
            }
            
        }else{
            if (self.tabBarController?.isKind(of: ProjectSituationTabVC.self))!{
                let tabVC = self.tabBarController as! ProjectSituationTabVC
                tabVC.tab.isHidden = false
                tabVC.tabBar.isHidden = true
            }
        }
        navBarHairlineImageView?.isHidden = true
        self.isAnalysisVC()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navBarHairlineImageView?.isHidden = false
        
        
        
        
    }
    
    
    func hidden(){
        if (self.tabBarController?.isKind(of: ProjectSituationTabVC.self))!{
            let tabVC = self.tabBarController as! ProjectSituationTabVC
            tabVC.tab.isHidden = true
            tabVC.tabBar.isHidden = true
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    //获取导航栏下面横线
    func findHairlineImageViewUnder(view:UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.self)&&view.bounds.size.height<=1.0 {
            return (view as! UIImageView)
        }
        for subView in view.subviews {
            let imageView = self.findHairlineImageViewUnder(view: subView)
            if (imageView != nil) {
                return imageView
            }
        }
        return nil
    }
    
    //列表
    func tableViewConfig() {
        self.table = UITableView.init(frame: CGRect(x: 0, y: 0, width: width, height: self.scrollView.frame.size.height), style: .grouped)
        self.table.backgroundColor = self.view.backgroundColor
        self.table.delegate = self
        self.table.dataSource = self
        self.table.showsVerticalScrollIndicator = false
        self.table.showsHorizontalScrollIndicator = false
        self.table.separatorStyle = UITableViewCellSeparatorStyle.none
        self.scrollView.addSubview(self.table)
        
        
//        let headerView = ProjectAnalyzeHeaderView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 500))
//        headerView.backgroundColor = self.view.backgroundColor
//        self.table.tableHeaderView = headerView
//        let height = headerView.configUI(model: self.myModel!)
//        headerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
//        headerView.click = { [weak self](tag) in
//            if tag == 1{
//                //self?.qfSegment?.selectIndex(index:2)
//            }else if tag == 2{
//                self?.toRiskList()
//            }
//        }
        
        let fenxiV:HYFenXiHeaderV = Bundle.main.loadNibNamed("HYFenXiHeaderV", owner: self, options: [:])?.last as! HYFenXiHeaderV
        fenxiV.action = { [weak self] (index) in
            let titleArray = ["形势分析","目标分析","角色覆盖"];
            let urlArray = ["pp.logicAnalyse.pro_an_situ","pp.logicAnalyse.pro_an_goal","pp.logicAnalyse.pro_an_role"];
            let vc = HYSubFenxiVC();
            self?.navigationController?.pushViewController(vc, animated: true)
            vc.title = titleArray[index];
            vc.urlString = urlArray[index];
            vc.projectId = self?.model?.id
            vc.logic_id = self?.model?.pro_anaylse_logic_id
            
        }
        let situationM = self.myModel?.percentage!["situation"]
        let goalM = self.myModel?.percentage!["goal"]
        let roleM = self.myModel?.percentage!["role"]
        let chance_classM = self.myModel?.percentage!["chance_class"]
        let health_degreeM = self.myModel?.percentage!["health_degree"]
        
        fenxiV.configUI(withPercentArray:[situationM?.percentage as Any,goalM?.percentage as Any,roleM?.percentage as Any,chance_classM?.percentage as Any,health_degreeM?.percentage as Any])
        fenxiV.title1.text = String.noNilStr(str: situationM?.title)
        fenxiV.title2.text = String.noNilStr(str: goalM?.title)
        fenxiV.title3.text = String.noNilStr(str: roleM?.title)
        fenxiV.title4.text = String.noNilStr(str: chance_classM?.title)
        fenxiV.title5.text = String.noNilStr(str: health_degreeM?.title)
        self.table.tableHeaderView = fenxiV
        
        
        
        self.table1 = UITableView.init(frame: CGRect(x: 0, y: 0, width: width, height: self.scrollView.frame.size.height), style: .grouped)
        self.table1.backgroundColor = self.view.backgroundColor
        self.table1.delegate = self
        self.table1.dataSource = self
        self.table1.showsVerticalScrollIndicator = false
        self.table1.showsHorizontalScrollIndicator = false
        self.table1.separatorStyle = UITableViewCellSeparatorStyle.none
        self.scrollView.addSubview(self.table1)
        
        let headerView1 = ProjectAnalyzeHeaderView.init(frame: CGRect(x: 0, y: 0, width: width, height: 500))
        self.table1.tableHeaderView = headerView1
        let height1 = headerView1.configUINoValue(model:self.myModel!)
        headerView1.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height1+20)
        
    }
    //组织结构图
    func configRelationalView() {
        
        LoginRequest.getPost(methodName: LOGICANALYSE_GETPLANSUGGESTION, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
            
        }) { [weak self](dic) in
           
            if let model:ProBublesModel = ProBublesModel.deserialize(from: dic){
                self?.proBublesModel = model
                self?.configPlanSuggest()
                let peopleArr = model.people
                if peopleArr.count>0{
                    let params = self?.makeNodeDict(array:peopleArr)
                    let relationalView = QFRelationalGraphView.init(frame: CGRect(x: (self?.width)!, y: 0, width: (self?.width)!, height: (self?.scrollView.frame.size.height)!))
                    relationalView.uiConfig(dict: params!)
                    relationalView.delegate = self
                    self?.scrollView.addSubview(relationalView)
                }
            }
        }
    }
    func qf_delegateClickRole(pid: String) {
        if (self.tabBarController?.isKind(of: ProjectSituationTabVC.self))!{
        let tabVC:ProjectSituationTabVC = self.tabBarController as! ProjectSituationTabVC
        tabVC.isChart = true
        }
        let vc = RoleInfoVC()
//        vc.isAuth = tabVC.isEditAuth
        vc.situationModel = self.model
        vc.isEditShow = false
        vc.id = pid
        vc.organizationChart = {
//            let vc:ProjectSituationTabVC = self.tabBarController as! ProjectSituationTabVC
//            vc.isChart = false
        }
        self.hidden()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //策略建议数据适配
    func configPlanSuggest(){
        self.dataArray1.removeAll()
        for model in self.proBublesModel!.allarray
        {
            var dic = Dictionary<String,Any>()
            dic["title"] = model.name
            dic["data"] = model.titles()
            if model.titles().count != 0 {
                self.dataArray1.append(dic)
                self.dataArray1Other.append(model)
            }
            
            self.table1.reloadData()
        }
        self.table1.layoutIfNeeded()
        self.table1.frame = CGRect(x: 0, y: 0, width: width, height: self.table1.contentSize.height);
        self.table1.isScrollEnabled = false;
        self.table.tableFooterView = self.table1;
        
        
    }
    
    
    
    
    func makeNodeDict(array:Array<bublesPeopleSubModel>)  -> Dictionary<String,Any>{
        var leastHierarchy = 500
        var subArray = Array<Dictionary<String,Any>>()
        for i in 0...array.count-1{
            let model = array[i]
            if model.parentid == "0"||model.parentid==""{
                if model.hierarchy<leastHierarchy{
                    leastHierarchy = model.hierarchy
                }
                subArray.append(self.addNodes(fatherNodeInfo: model, array: array))
            }
        }
        var params = Dictionary<String,Any>()
        params.updateValue("开始分支", forKey: "name")
        params.updateValue(["id":"-1"], forKey: "dict")
        var newArray = Array<Dictionary<String,Any>>()
        for dict in subArray{
            let subP:Dictionary<String,Any> = dict["dict"] as! Dictionary<String,Any>
            if (subP["hierarchy"] as! Int) != leastHierarchy{
                
                var subD = Dictionary<String,Any>()
                subD = dict
                for _ in 0...(subP["hierarchy"] as! Int)-leastHierarchy-1{
                    var subParams = Dictionary<String,Any>()
                    subParams.updateValue("组织结构图", forKey: "name")
                    subParams.updateValue(["id":"-1"], forKey: "dict")
                    subParams.updateValue([subD], forKey: "node")
                    subD = subParams
                }
                newArray.append(dict)
                
            }else{
                newArray.append(dict)
            }
        }
        params.updateValue(newArray, forKey: "node")
        return params
    }
    
    func addNodes(fatherNodeInfo:bublesPeopleSubModel,array:Array<bublesPeopleSubModel>) -> Dictionary<String,Any>{
        
        var params = Dictionary<String,Any>()
        var subArray = Array<Dictionary<String,Any>>()
        for model in array{
            if model.parentid == fatherNodeInfo.id{
                let dict = self.addNodes(fatherNodeInfo: model, array: array)
                subArray.append(dict)
            }
        }
        params.updateValue(fatherNodeInfo.toJSON() as Any, forKey: "dict")
        params.updateValue(fatherNodeInfo.name, forKey: "name")
        params.updateValue(subArray, forKey: "node")
        return params;
    }
    
    //赢单指数
    func configChartView() {
        chartScroll = UIScrollView.init(frame: CGRect(x: width*2, y: 0, width: width, height: self.scrollView.frame.size.height))
        chartScroll.contentSize = CGSize(width: width*3, height: 0)
        chartScroll.isPagingEnabled = true
        chartScroll.isScrollEnabled = true
        chartScroll.showsVerticalScrollIndicator = false
        chartScroll.showsHorizontalScrollIndicator = false
        self.scrollView.addSubview(chartScroll)
        
        self.popupBackView = UIView.init(frame: CGRect(x: width*2+10, y: self.width, width: self.width-20, height: chartScroll.frame.size.height-self.width-20))
        self.popupBackView?.backgroundColor = UIColor.init(red: 86/255.0, green: 199/255.0, blue: 158/255.0, alpha: 1)
        self.scrollView.addSubview(self.popupBackView!)
        
        popupButton = UIButton.init(frame: CGRect(x: 50, y: 0, width: (self.popupBackView?.frame.size.width)!-100, height: 32))
        popupButton?.setImage(#imageLiteral(resourceName: "project_plan_up") , for: UIControlState.normal)
        popupButton?.addTarget(self, action: #selector(popupStrategyView), for: .touchUpInside)
        self.popupBackView?.addSubview(popupButton!)
        //#imageLiteral(resourceName: "project_plan_up")
        
        planLabel.isEditable = false
        planLabel.isSelectable = false
        planLabel.isScrollEnabled = false
        planLabel.backgroundColor = .clear
        planLabel.text = ""
        planLabel.textColor = .white
        planLabel.font = UIFont.systemFont(ofSize: 16)
        self.popupBackView?.addSubview(planLabel)
        planLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(30)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.bottom.equalTo()(0)
        }
        
        //赢单指数接口
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id
        LoginRequest.getPost(methodName:LOGICANALYSE_WININDEX , params: params.addToken(), hadToast: false, fail: { (dic) in
            
            DLog(dic)
        }) { [weak self](dic) in
            
            let stext = (dic["plan"] as! String)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            let setStr = NSMutableAttributedString.init(string: stext)
            setStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, stext.count))
            setStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, stext.count))
            setStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, stext.count))
            self?.planLabel.attributedText = setStr
            
            let histogramArr:Array<Any> = dic["indexinfo"] as! Array<Any>
            var yArray = Array<String>()
            let xArray = (dic["sort_name"] as! Array<String>)
            var yValueArray:Array<CGFloat> = Array()
            let maxCondition:CGFloat = 100
            var maxValue:CGFloat = 0
            
            var radarArrBase:Array<CGFloat> = Array()
            var radarArrCurrent:Array<CGFloat> = Array()
            var healthArr:Array<CGFloat> = Array()
            if histogramArr.count>0{
                for i in 0...histogramArr.count-1{
                    let dict:Dictionary<String,Any> = histogramArr[i] as! Dictionary
                    yArray.append(dict["name"]! as! String)
                    
                    let condition = JSON(dict["value"] as Any).floatValue
                    let setval = JSON(dict["setval"] as Any).numberValue
                    let floatSetval = setval.floatValue
                    
                    var tempValue = condition
                    if floatSetval>tempValue{
                        tempValue = floatSetval
                    }
                    if maxValue<CGFloat(tempValue){
                        maxValue = CGFloat(tempValue)
                    }
                    radarArrBase.append(CGFloat(floatSetval))
                    radarArrCurrent.append(CGFloat(condition))
                    healthArr.append(CGFloat(condition-floatSetval))
                    let sortArr:Array<CGFloat> = dict["sort"] as! Array<CGFloat>
                    let space = maxCondition/CGFloat(sortArr.count)
                    
                    var value:CGFloat = 0
                    if condition > 0{
                        //0,3,4,8
                        for j in 0...sortArr.count-1 {
                            let f = sortArr[j]
                            if CGFloat(condition) != f {
                                if(j==sortArr.count-1){
                                    value = value + CGFloat(condition)
                                }else{
                                    let lastF = sortArr[j+1]
                                    if lastF<=CGFloat(condition){
                                        value = value+space
                                    }else{
                                        value = (CGFloat(condition)-f)/(lastF-f)*space+value
                                        break
                                    }
                                }
                            }else{
                                break
                            }
                        }
                    }
                    yValueArray.append(value)
                }
            }
            
            let histogramView = QFHistogramView.init(frame: CGRect(x: (self?.width)!+20, y: 10, width: (self?.width)!-40, height: (self?.width)!-20))
            histogramView.backgroundColor = .white
            histogramView.layer.shadowOffset = CGSize(width:0, height:0.5)
            histogramView.layer.shadowOpacity = 0.2
            histogramView.layer.shadowColor = UIColor.gray.cgColor
            self?.chartScroll.addSubview(histogramView)
            histogramView.uiConfig()
            
            
            histogramView.yArray = yArray
            histogramView.xArray = xArray
            histogramView.maxValue = CGFloat(maxCondition)
            histogramView.valueArray = yValueArray
            
            let whiteView1 = UIView.init(frame: CGRect(x: (self?.width)!-10, y: 10, width: 20, height: histogramView.frame.size.height))
            whiteView1.backgroundColor = .white
            whiteView1.layer.shadowOffset = CGSize(width:0, height:0.5)
            whiteView1.layer.shadowOpacity = 0.2
            whiteView1.layer.shadowColor = UIColor.gray.cgColor
            self?.chartScroll.addSubview(whiteView1)
            
            
            let radarView = QFRadarChartView.init(frame: CGRect(x: 10, y: 10, width: (self?.width)!-30, height: (self?.width)!-20))
            radarView.backgroundColor = .white
            radarView.layer.shadowOffset = CGSize(width:0, height:0.5)
            radarView.layer.shadowOpacity = 0.2
            radarView.yAxisMaximum = Double(maxValue)
            radarView.layer.shadowColor = UIColor.gray.cgColor
            radarView.yAxisTags = yArray
            radarView.configUI()
            
            let entry = radarView.addChartsData(title: "赢单值", valueArr: radarArrBase, lineColor: UIColor.init(red: 119/255.0, green: 195/255.0, blue: 248/255.0, alpha: 1), lineWidth: 1, fillColor: UIColor.init(red: 119/255.0, green: 195/255.0, blue: 248/255.0, alpha: 1), fillAlpha: 0.5)
            let entry1 = radarView.addChartsData(title: "实际值", valueArr: radarArrCurrent, lineColor: UIColor.init(red: 231/255.0, green: 102/255.0, blue: 60/255.0, alpha: 1), lineWidth: 1, fillColor: UIColor.init(red: 231/255.0, green: 102/255.0, blue: 60/255.0, alpha: 1), fillAlpha: 0.5)
            
            radarView.setChartData(setArray: [entry,entry1])
            self?.chartScroll.addSubview(radarView)
            
            let chartView = QFChartView.init(frame: CGRect(x: (self?.width)!*2+20, y: 10, width: (self?.width)!-40, height: (self?.width)!-20))
            chartView.backgroundColor = .white
            chartView.layer.shadowOffset = CGSize(width:0, height:0.5)
            chartView.layer.shadowOpacity = 0.2
            chartView.layer.shadowColor = UIColor.gray.cgColor
            self?.chartScroll.addSubview(chartView)
            chartView.uiConfig()
            chartView.yArray = yArray
            chartView.xArray = [["title":"实际值","value":radarArrCurrent,"type":0],["title":"达标值","value":radarArrBase,"type":0],["title":"健康指数","value":healthArr,"type":1]]
            chartView.maxValue = maxValue+maxValue*0.2
            
            let whiteView2 = UIView.init(frame: CGRect(x: (self?.width)!*2-10, y: 10, width: 20, height: chartView.frame.size.height))
            whiteView2.backgroundColor = .white
            whiteView2.layer.shadowOffset = CGSize(width:0, height:0.5)
            whiteView2.layer.shadowOpacity = 0.2
            whiteView2.layer.shadowColor = UIColor.gray.cgColor
            self?.chartScroll.addSubview(whiteView2)
            
        }
        
        
    }
    
    
    func isAnalysisVC(){
        
        var params = Dictionary<String,Any>()
        params["project_id"] = self.model?.id
//        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: EXISTS_PROJECTANALYSE, params: params.addToken(), hadToast: true, fail: { (dic) in
//            PublicMethod.dismiss()
        }) { [weak self](dic) in
//            PublicMethod.dismiss()
            let code = JSON(dic["code"] as Any).stringValue
            if code == "2" {
                self?.toAlert()
            }
        }
        
    }
    
    func toAlert(){
        let alert = UIAlertController.init(title: "最后一次修改有新的分析报告未生成，现在是否生成？", message: "", preferredStyle: .alert, btns: [kCancel:"取消","sure":"确定"], btnActions: {[weak self] (ac, str) in
            if str != kCancel {
                PublicMethod.showProgress()
                LoginRequest.getPost(methodName:PROJECT_OPEN_CLOSE, params: ["project_id":self?.model?.id,"close_status":"0"].addToken(), hadToast: true, fail: { (dic) in
                    PublicMethod.dismiss()
                }, success: {[weak self] (dic) in
                    
                    PublicMethod.dismiss()
                    PublicMethod.toastWithText(toastText: JSON(dic["msg"] as Any).stringValue)
                    self?.toSwitcher()
                })
                
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func toSwitcher(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toSwitcher"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

//代理扩展
extension ProjectAnalyzeVC :QFSegmentViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    //tableView代理
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.table == tableView {
            return self.dataArray.count
        }
        return self.dataArray1.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.table == tableView {
            if self.dataArray[section]["title"] as! String  == "风险预警"{
                return (self.dataArray[section]["data"] as AnyObject).count > 3 ? 3 : (self.dataArray[section]["data"] as AnyObject).count
            }else{
                return (self.dataArray[section]["data"] as AnyObject).count
            }
            
        }
        return (self.dataArray1[section]["data"] as AnyObject).count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var array = Array<Dictionary<String,Any>>()
        if self.table == tableView {
            array = self.dataArray
        }else{
            array = self.dataArray1
        }
        let dict = array[section]
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        view.backgroundColor  = self.view.backgroundColor
        let label = UILabel.init(frame: CGRect(x: 15, y: 0, width: width-30, height: 40))
        label.text = (dict["title"] as! String)
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(label)
        
        if (dict["title"] as! String) == "风险预警" {
            let button = UIButton.init(frame: CGRect(x: width-60, y: 0, width: 45, height: 40))
            button.setTitle("更多", for: .normal)
            button.setTitleColor(kGreenColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(gotoFengxianYujingVC), for: .touchUpInside)
            view.addSubview(button)
        }
        
        return view
        
    }
    @objc func gotoFengxianYujingVC() {
        self.toRiskList()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var array = Array<Dictionary<String,Any>>()
        var cellID:String?
        if self.table == tableView {
            array = self.dataArray
            if array[indexPath.section]["title"] as! String == "角色策略" {
                cellID = "CELL1"
            }else if array[indexPath.section]["title"] as! String == "风险预警" {
                cellID = "CELL0"
            }else{
                cellID = "CELL2"
            }
            
        }else{
            array = self.dataArray1
            cellID = "CELL1"
        }
        let dict = array[indexPath.section]
        
        let subArray =  dict["data"] as! Array<String>
    
        var cell:ProjectAnalyzeCell! = tableView.dequeueReusableCell(withIdentifier: cellID!) as? ProjectAnalyzeCell
        if cell == nil {
            cell = ProjectAnalyzeCell(style: .default, reuseIdentifier: cellID)
            cell.uiConfig(ID:cellID!)
        }
        cell.label.text = subArray[indexPath.row]
        if cell.cellType == "CELL1" {
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:cell.label.text!)
//            if (cell.label.text?.count)! > 2 {
//                attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSMakeRange(0, 2))
//            }
            
            cell.label.attributedText = attrstring
            
            let subStr = cell.label.text?.prefix(1)
            cell.subLabel.text = String(subStr!)
            if self.table == tableView
            {
               cell.imageV.backgroundColor = UIColor.hexString(hexString: (self.myModel?.planSuggestion?.planSuggestion[indexPath.row].circle_color)!)
//                feedback_name
                let str2 = self.myModel?.planSuggestion?.planSuggestion[indexPath.row].plan_title ?? ""
                let str = cell.label.text! + "  " + str2
                cell.label.attributedText = String.configAttributedStr(oldStr: str, subStr: str2, oldColor: UIColor.black, color: UIColor.darkGray)
                
            }else{
                
//                DLog(self.dataArray1Other[indexPath.section])
                if self.dataArray1Other.count != 0 {
                    cell.imageV.backgroundColor = UIColor.hexString(hexString: self.dataArray1Other[indexPath.section].value[indexPath.row].circle_color)
                    
                    let str2 = self.dataArray1Other[indexPath.section].value[indexPath.row].plan_title ?? ""
                    let str = cell.label.text! + "  " + str2
                    cell.label.attributedText = String.configAttributedStr(oldStr: str, subStr: str2, oldColor: UIColor.black, color: UIColor.darkGray)
                }
//
            }
//
            
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell:ProjectAnalyzeCell! = tableView.cellForRow(at: indexPath) as? ProjectAnalyzeCell

        if tableView == table {
            if self.dataArray[indexPath.section]["title"] as! String == "角色策略"{
                let vc = ProRolePlanVC()
                vc.model = self.model
                vc.title = self.model?.name
                vc.projectId = (self.model?.id)!
                vc.currentUserId = self.myModel?.planSuggestion?.planSuggestion[indexPath.row].id
                vc.currentName = (self.myModel?.planSuggestion?.planSuggestion[indexPath.row].name)!
                self.hidden()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            if self.dataArray[indexPath.section]["title"] as! String == "三板斧"{
                let detailVC = ProjectAnalyzeBaseDetailVC()
                detailVC.title = self.model?.name
                detailVC.index = indexPath.row
                detailVC.myModel = self.model
                
                detailVC.model = self.myModel?.three_broad_axe?.three_broad_axe[indexPath.row]
                self.hidden()
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
            if self.dataArray[indexPath.section]["title"] as! String == "风险预警"{
                let detailVC = ProjectAnalyzeBaseDetailVC()
                detailVC.myModel = self.model
                detailVC.riskModel = self.myModel?.risk_warning?.risk_warning[indexPath.row]
                self.hidden()
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
            
            
            
            
        }
        
        if tableView == table1 {

            let dict = self.dataArray1[indexPath.section]
            let name = dict["title"] as! String
            
            var newModel:bublesPeopleSubModel?
            for model in self.proBublesModel!.allarray
            {
                if name == model.name {
                    newModel = model.value[indexPath.row]
                }
            }
            
            
            let vc = ProRolePlanVC()
            vc.title = self.model?.name
            vc.projectId = (self.model?.id)!
            vc.model = self.model
            vc.currentUserId = newModel?.id
            vc.currentName = (newModel?.name)!
            self.hidden()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    //其他代理
    func segmentSelectIndex(index: Int, tag:Int) {
        
        self.scrollView.contentOffset = CGPoint(x: width*CGFloat(index), y: 0)
    }
    
    //跳转到风险预警列表
    func toRiskList(){
        
        if (self.myModel?.risk_warning?.risk_warning.count)! > 0 {
            let vc = ProRiskingListVC()
            vc.model = self.model
            vc.myModel = self.myModel
            
            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    //弹出赢单指数下方策略
    @objc func popupStrategyView() {
        let frame = (popupBackView?.frame)!
        self.chartScroll.bringSubview(toFront: popupBackView!)
        if isPopup {
            self.popupButton?.setImage(#imageLiteral(resourceName: "project_plan_up"), for: UIControlState.normal)
            popupBackView?.frame = CGRect(x: frame.origin.x, y: self.width, width: frame.size.width, height: chartScroll.frame.size.height-self.width-20)
            self.planLabel.isScrollEnabled = false
        }else{
            popupBackView?.frame = CGRect(x: frame.origin.x, y: 10, width: frame.size.width, height: self.chartScroll.frame.size.height-20)
            self.popupButton?.setImage(#imageLiteral(resourceName: "project_plan_down"), for: UIControlState.normal)
            self.planLabel.isScrollEnabled = true
        }
        isPopup = !isPopup
    }
    
    
}

