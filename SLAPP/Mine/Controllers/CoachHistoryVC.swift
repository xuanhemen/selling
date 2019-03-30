//
//  CoachHistoryVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 柴进. All rights reserved.
//
import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit
import SwiftyJSON
class CoachHistoryVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var btn:UIButton?
    var dataArray = Array<Any>()
    var curruntArray = Array<Any>()
    let topView = UIView()
    let searchView = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 40))
    
    
    
    lazy var timeTitleLeft = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 20)
        lable.textAlignment = .center
        lable.textColor = UIColor.white
        return lable
    }()
    
    lazy var timeTitleLeftValue = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 25)
        lable.textAlignment = .center
        lable.textColor = UIColor.white
        return lable
    }()
    
    
    lazy var timeTitleRightTitle = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 20)
        lable.textAlignment = .center
         lable.textColor = kGreenColor
        return lable
    }()
    
    lazy var timeTitleRightValue = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 25)
        lable.textAlignment = .center
        lable.textColor = kGreenColor
        return lable
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.title = "辅导付费记录"
        self.congfigData()
        
    }

    func congfigData(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: COACHPAY_LIST, params: [:].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            self?.dataArray.removeAll()
            if (dic["list"] is NSNull){
                return
            }
            
            DLog(dic);
            
            
            self?.dataArray = JSON(dic["list"]).arrayObject!
            self?.timeTitleRightValue.text = JSON(dic["left_hour"]).stringValue+"小时"
            self?.timeTitleLeftValue.text = JSON(dic["used_hour"]).stringValue+"小时"
            self?.curruntArray = (self?.dataArray)!
            self?.congfigNodata()
            self?.table.reloadData()
        }
        
    }
    
    override func rightBtnClick(button: UIButton) {
        btn = button
        topView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(40)
        }
        btn?.isHidden = true
    }
    
    
    func configUI(){
        self.setRightBtnWithArray(items: [UIImage.init(named: "search_white")])
//        searchView.barStyle = .black
        searchView.backgroundColor = kGrayColor_Slapp
        searchView.setBackgroundImage( UIImage.imageFromColor(color: kGrayColor_Slapp), for: .any, barMetrics: .default)
        searchView.showsCancelButton = true
        
        
        
        
        let cancelBtn:UIButton = searchView.value(forKeyPath: "cancelButton") as! UIButton
        cancelBtn.isEnabled = true
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .highlighted)
        cancelBtn.addTarget(self, action: #selector(cancelbtn), for: .touchUpInside)
        
        
        searchView.delegate = self
        searchView.placeholder = "搜索内容"
        
        
        
        
        
        
        
        
        self.view.addSubview(searchView)
        topView.backgroundColor = kGrayColor_Slapp
        self.view.addSubview(topView)
        table.tableFooterView = UIView()
        
        
        
        
        
        
        
        
        
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(0)
            make.height.equalTo(120)
        }
        
        
        topView.addSubview(timeTitleLeft)
        topView.addSubview(timeTitleLeftValue)
        topView.addSubview(timeTitleRightTitle)
        topView.addSubview(timeTitleRightValue)
        
        timeTitleLeft.text  = "消费总时长:"
        timeTitleLeft.snp.makeConstraints {[weak topView] (make) in
            make.top.equalTo(20)
            make.left.equalTo(0)
            make.height.equalTo(20)
            make.right.equalTo((topView?.snp.centerX)!)
        }
        
//        timeTitleLeftValue.text = "asdasd"
        timeTitleLeftValue.snp.makeConstraints {[weak timeTitleLeft] (make) in
            make.top.equalTo((timeTitleLeft?.snp.bottom)!).offset(20)
            make.left.equalTo(0)
            make.height.equalTo(30)
            make.right.equalTo((topView.snp.centerX))
        }
        
        
        timeTitleRightTitle.text  = "剩余时长:"
        timeTitleRightTitle.snp.makeConstraints { [weak topView](make) in
            make.top.equalTo(20)
            make.right.equalTo(0)
            make.height.equalTo(20)
            make.left.equalTo((topView?.snp.centerX)!)
        }
        
        
//        timeTitleRightValue.text  = "消费总时长:"
        timeTitleRightValue.snp.makeConstraints {[weak timeTitleRightTitle,weak topView] (make) in
            make.top.equalTo((timeTitleRightTitle?.snp.bottom)!).offset(20)
            make.right.equalTo(0)
            make.height.equalTo(30)
           make.left.equalTo((topView?.snp.centerX)!)
        }
        
        
        
        self.view.addSubview(table)
        table.snp.makeConstraints { [weak topView](make) in
            make.top.equalTo((topView?.snp.bottom)!).offset(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        table.delegate = self
        table.dataSource = self
        
        table.addEmptyViewWithTitle(titleStr: "无付费记录")
    }
    
    
    
    @objc func cancelbtn(){
        topView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(0)
        }
        
        if btn != nil {
            btn?.isHidden = false
           
        }
        curruntArray = self.dataArray
        self.congfigNodata()
        table.reloadData()
    }
    
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.curruntArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dic:Dictionary<String,Any> = self.curruntArray[section] as! Dictionary<String, Any>  {
            return (JSON(dic["list"]).array?.count)!
        }
        return  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        var cell:CoachPayHisCell? = tableView.dequeueReusableCell(withIdentifier: cellIde) as? CoachPayHisCell
        if cell == nil {
            cell = CoachPayHisCell.init(style: .default, reuseIdentifier: cellIde)
        }
        let dic:Dictionary<String,Any> = self.curruntArray[indexPath.section] as! Dictionary<String, Any>
//        DLog(dic)
        let subDic = JSON(dic["list"] as Any)[indexPath.row].dictionaryObject
        cell?.model = subDic
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dic:Dictionary<String,Any> = self.curruntArray[section] as! Dictionary<String, Any>
        return String.noNilStr(str:dic["time_day_str"])
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dic:Dictionary<String,Any> = self.curruntArray[indexPath.section] as! Dictionary<String, Any>
        let subDic = JSON(dic["list"] as Any)[indexPath.row].dictionaryObject
        
        let vc = TutoringDetailVC()
        vc.new_consult_id = JSON(subDic!["id"] as Any).stringValue
        
        self.navigationController?.pushViewController(vc, animated: true);
        
        
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()
    
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard !(searchBar.text?.isEmpty)! else {
            return
        }
        curruntArray.removeAll()
        let str = searchBar.text!
//        let pre = NSPredicate.init(format: "show CONTAINS %@ OR time_day_str CONTAINS %@ ",str,str)
        for sub in self.dataArray {
            if let asub:Dictionary<String,Any> = sub as! Dictionary<String, Any> {
        
                let array:Array<Any> = JSON(asub["list"]).arrayObject!.filter({ (dic) -> Bool in
                    if let subDic:Dictionary<String,Any> = dic as! Dictionary<String, Any>{
                        return String.noNilStr(str: subDic["show"]).range(of: str) != nil
                    }
                    return false
                })
                if array.count > 0{
        let resultDic = ["time_day_str":asub["time_day_str"]!,"list":array];
                    curruntArray  +=  [resultDic as Any]
                }
            
            }
        }
        self.congfigNodata()
        
        table.reloadData()
        
        
    }
    
    func congfigNodata(){
        table.tableFooterView = UIView()
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.resignFirstResponder()
            curruntArray = self.dataArray
            self.congfigNodata()
            table.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
