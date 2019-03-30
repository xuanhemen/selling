//
//  GroupSearchVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/22.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
import MJRefresh
let pageNum = 20
class GroupSearchVC: BaseViewController {
    var table:UITableView?
    var dataArray:Array<GroupModel>?
    var allDataArray:Array<GroupModel>? //记录已经加载的数据
    var searchView:UISearchBar?
    var pageCount = 1 //当前页数
    var allPageCount = 1 //记录已经加载的页数
    var total : Int? = 0 //总数据个数
    var first : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加"
        dataArray = Array()
        allDataArray = Array()
        first = true
//        configData(keyword: "")
        configUI()
    }
    
    
    
    fileprivate func configUI()
    {
        searchView = UISearchBar.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT, width: kScreenW, height: 50))
        searchView!.setBackgroundImage(UIImage.init(named: "backGray")!, for: .any, barMetrics: .default)
        searchView!.delegate = self
        searchView!.placeholder = "搜索"
        searchView?.becomeFirstResponder()
        self.view.addSubview(searchView!)
        
        
        table = UITableView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT+50, width: kScreenW, height: kScreenH-NAV_HEIGHT-50))
        self.view.addSubview(table!)
        table?.delegate = self;
        table?.dataSource = self;
        table?.tableFooterView = UIView.init()
       
    }
    
    fileprivate func configData(keyword : String) {
        
        var params = Dictionary<String, Any>()
        params["app_token"] = sharePublicDataSingle.token
        if keyword.characters.count > 0 {
            params["keyword"] = keyword
        }
        params["is_join"] = 0 //未加入
        params["is_open"] = 1 // 公开
        params["offset"] = pageCount // 当前页
        params["length"] = pageNum // 每页记录数
        self.progressShow()
        GroupRequest.search(params: params, hadToast: true, fail: {[weak self](error) in
            if let strongSelf = self {
                strongSelf.progressDismiss()
            }
        }, success: {[weak self] (sdic) in
            if let strongSelf = self{
                strongSelf.progressDismiss()
                
                DispatchQueue.main.async {
                    var array : Array<Dictionary<String, Any>>! = []
                    if sdic["list"] != nil{
                        array = sdic["list"] as! Array<Dictionary<String, Any>>
                    }
                    if (strongSelf.first)!{
                        strongSelf.first = false
                        if array.isEmpty{
                            //                    self?.progressDismissWith(str: "没有找到符合的群组")
                            strongSelf.table?.reloadData()
                            strongSelf.showRemind()
                            return
                        }
                    }
                    //普通带文字上拉加载的定义
                    if strongSelf.table?.mj_footer == nil{
                        strongSelf.table?.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: strongSelf, refreshingAction: #selector(strongSelf.footerRefresh))
                    }
                    strongSelf.table?.mj_footer.endRefreshing()
                    if array.count == pageNum {
                        strongSelf.table?.mj_footer.isHidden = false
                    }else if array.count < pageNum {
                        strongSelf.table?.mj_footer.isHidden = true
                    }
                    for i in 0..<array.count  {
                        let model = GroupModel()
                        let dic:Dictionary = array[i]
                        model.setValuesForKeys(dic)
                        strongSelf.dataArray?.append(model)
                    }
                    if keyword.characters.count == 0{
                        strongSelf.allDataArray = strongSelf.dataArray
                        strongSelf.allPageCount = strongSelf.pageCount
                        strongSelf.total = Int(String.changeToString(inValue: sdic["total"] as Any))
                    }
                    strongSelf.table?.reloadData()
                    strongSelf.showRemind()
                }
            }
            
        })
        
    }

    //上拉加载操作
    @objc func footerRefresh(){

        pageCount += 1
        self.configData(keyword: (searchView?.text)!)
//            table?.reloadData()
//        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchView?.resignFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// 提醒个数
    func showRemind(){
        
        let fView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 50))
        
        let line = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 1))
        line.backgroundColor = UIColor.groupTableViewBackground
        fView.addSubview(line)
        
        let numberLable = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: kScreenW, height: 30))
        numberLable.textAlignment = NSTextAlignment.center
        numberLable.font = UIFont.systemFont(ofSize: 14)
        
        numberLable.text = "没有查找到相关的群组"
        fView.addSubview(numberLable)
        
        if (self.dataArray?.count)! == 0 {
            table?.tableFooterView = fView
        }else{
            table?.tableFooterView = UIView.init()
        }
        
    }

}


extension GroupSearchVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray != nil ? (dataArray?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:BaseTableCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as! BaseTableCell?
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("BaseTableCell", owner: self, options: nil)?.last as! UITableViewCell? as! BaseTableCell?
        }
        
        let model:RLMObject = self.dataArray![indexPath.row]
        cell?.model = model
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (searchView?.isFirstResponder)! {
            searchView?.resignFirstResponder()
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (searchView?.isFirstResponder)! {
            searchView?.resignFirstResponder()
        }
    }

    
}

extension GroupSearchVC:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchView?.showsCancelButton = true

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchView?.showsCancelButton = false
        searchView?.text = nil
        searchBar.resignFirstResponder()
        dataArray = allDataArray //点击取消按钮显示已经加载过的所有数据
        pageCount = allPageCount
        if self.table?.mj_footer != nil {
            
            if dataArray?.count == total {
                self.table?.mj_footer.isHidden = true
            }else {
                self.table?.mj_footer.isHidden = false
            }
        }
//        showRemind()
        table?.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        
        pageCount = 1
        dataArray?.removeAll()
        configData(keyword: searchBar.text!)
    }
  
}






extension GroupSearchVC:BaseCellDelegate{
   
    
 
    
    func cellRightBtnClick(model: RLMObject) {
        
        
        let applyJoinGroupVc = ApplyJoinGroupViewController()
        applyJoinGroupVc.groupModel = model as? GroupModel
        self.navigationController?.pushViewController(applyJoinGroupVc, animated: true)

    }
    
}
