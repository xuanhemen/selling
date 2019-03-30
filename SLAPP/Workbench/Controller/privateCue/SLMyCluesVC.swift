//
//  SLMyCluesVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON


class SLMyCluesVC: BaseVC,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    /**数据源*/
    lazy var dataArr:[SLCluesSectionModel] = [SLCluesSectionModel]()
    /**控制折叠*/
    lazy var controlArr = NSMutableArray()
    /**标识搜索*/
    var isSearch:Bool = false
    /**搜索数据源*/
    var searchDataArr = NSMutableSet()
    /**首页请求参数*/
    @objc var pageList:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的线索"
        
        self.view.backgroundColor = UIColor.white
        let addBarItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addClues))
        let searchBarItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(searchClues))
        self.navigationItem.rightBarButtonItems = [addBarItem,searchBarItem]
        /**请求线索*/
        self.requestClues()
        /**注册通知，当有线索分组移动时刷新列表*/
        weak var weakSelf:SLMyCluesVC? = self
        NotificationCenter.default.addObserver(weakSelf!, selector: #selector(freshClues), name: NSNotification.Name(rawValue:"isFresh"), object: nil)
        
    }
    /**刷新列表*/
    @objc func freshClues(nofice : Notification){
        self.tableView.mj_header.beginRefreshing()
    }
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    @objc func addClues() {
        
        let cvc = SLCreateCluesVC()
        cvc.pool = WhichPool.privatePool
        cvc.fresh = { isFresh in
            self.dataArr.removeAll()
            self.requestClues()
        }
        self.navigationController?.pushViewController(cvc, animated: true)
    }
    //MARK: - 搜索
    @objc func searchClues() {
        
        let vc = SLSearchResultVC()
        let arr = self.searchDataArr.allObjects as! [SLCluesModel]
        vc.dataArr = arr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.searchDataArr.removeAllObjects()
            self.dataArr.removeAll()
            self.requestClues()
        })
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        return tableView
    }()
    /**头部个数*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    /**头部高度*/
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == self.dataArr.count-1 {
            return 30
        }
        return 50
    }
    /**头部视图*/
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataArr[section]
        if section == dataArr.count-1 {
            let headView = UIView()
            headView.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
            let title = UILabel()
            title.text = "我的线索"
            title.textColor = UIColor.black
            title.font = UIFont.boldSystemFont(ofSize: 14)
            headView.addSubview(title)
            title.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(20)
            }
            return headView
        }else{
            
            let headView = SLCluesHeadView()
            headView.longPress = {
                /**弹出分组编辑界面*/
                let gvc = SLGroupVC()
                gvc.fresh = {
                    self.dataArr.removeAll()
                    self.requestClues()
                }
                let nvc = UINavigationController.init(rootViewController: gvc)
                var arr = self.dataArr
                arr.removeLast()
                gvc.dataArr = arr
                self.present(nvc, animated: true, completion: nil);
            }
            headView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50)
            if model.isShow == true {
                headView.isSelected = true
                headView.arrowBtn.isSelected = true
            }
            headView.tag = section
            headView.gruopName.text = model.name
            headView.peopleCount.text = model.count
            headView.addTarget(self, action: #selector(sectionClicked), for: UIControlEvents.touchUpInside)
            return headView
        }
    }
    /**展开或关闭*/
    @objc func sectionClicked(button: SLCluesHeadView) {
        let model = dataArr[button.tag]
        if model.list.count == 0 {
            self.toast(withText: "此分组下暂无线索", andDruation: 1.5)
            return
        }
        button.isSelected = !button.isSelected
        if button.isSelected == true {
            //旋转箭头方向
            UIView.animate(withDuration: 0.3) {
                button.arrowBtn.imageView?.transform = CGAffineTransform(rotationAngle: .pi/2)
            }
            model.isShow = true
            let set = NSIndexSet.init(index: button.tag)
            self.tableView.reloadSections(set as IndexSet, with: UITableViewRowAnimation.none)
        }else{
            UIView.animate(withDuration: 0.3) {
                button.arrowBtn.imageView?.transform = CGAffineTransform(rotationAngle: -.pi/2)
            }
            model.isShow = false
            let set = NSIndexSet.init(index: button.tag)
            self.tableView.reloadSections(set as IndexSet, with: UITableViewRowAnimation.none)
        }
    }
    /**每个头部下的行数*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataArr[section]
        
        if model.isShow == false
        {
            return 0
        }
        return model.list.count
    }
    /**行高*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 70
    }
    /**返回cell*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentifier = "clues"
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
        if cell == nil {
            cell = SLCluesTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: indentifier)
        }
        let cluesCell = cell as! SLCluesTableViewCell
        let model:SLCluesSectionModel = self.dataArr[indexPath.section]
        let modelt = model.list[indexPath.row]
        cluesCell.setCellWithModel(model: modelt)
        self.searchDataArr.addObjects(from: model.list)
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model:SLCluesSectionModel = self.dataArr[indexPath.section]
        let modelt = model.list[indexPath.row]
        let cvc = SLCluesDetailVC()
        cvc.cluesID = modelt.id
        cvc.pool = WhichPool.privatePool
        cvc.cluesModel = modelt
        cvc.fresh = { isFreshList in
            if isFreshList == true {
                self.tableView.mj_header.beginRefreshing()
                return
            }
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(cvc, animated: true)
    }
    //MARK: - 请求私海线索
    func requestClues() {
        /**参数*/
        self.showProgress(withStr: "正在加载中...")
        var parameters = [String:String]()
        var urlString:String = ""
        if self.pageList == "" {
            urlString = "pp.clue.lists"
        }else{
            urlString = "pp.clue.index_lists"
            parameters["clue_ids"] = self.pageList
        }
        LoginRequest.getPost(methodName: urlString, params: parameters.addToken(), hadToast: true, fail: { (error) in
            print(error)
            self.tableView.mj_header.endRefreshing()
        }) { (dataDic) in
            self.showDismiss()
            self.tableView.mj_header.endRefreshing()
            if let json = JSON(dataDic).dictionary,let array = json["group"]?.array
            {
                for sub in array{
                    let model = SLCluesSectionModel.deserialize(from: sub.dictionaryObject)
                    model?.isShow = false
                    self.dataArr.append(model!)
                }
                let listModel = SLCluesSectionModel()
                listModel.name = "我的线索"
                if let listArr = json["list"]?.array{
                    for subObjc in listArr{
                        let model = SLCluesModel.deserialize(from: subObjc.dictionaryObject)
                        listModel.list.append(model!)
                    }
                }
                self.dataArr.append(listModel)
            }
            self.tableView.reloadData()
        
        }
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

