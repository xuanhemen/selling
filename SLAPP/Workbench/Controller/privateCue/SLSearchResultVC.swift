//
//  SLSearchResultVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/16.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLSearchResultVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    var dataArr = [SLCluesModel]()
    var searchDataArr = [SLCluesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        print(dataArr.count)
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "关键字"
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.showsCancelButton = true
        searchBar.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 35)
        let cancelBtn = searchBar.value(forKeyPath: "cancelButton") as! UIButton
        cancelBtn.isEnabled = true
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.setTitleColor(.white, for: UIControlState.normal)
        self.navigationItem.titleView = searchBar
        // Do any additional setup after loading the view.
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchDataArr.removeAll()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let cancel = searchBar.value(forKeyPath: "cancelButton") as! UIButton
        cancel.isEnabled = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchDataArr = self.dataArr.filter({ (model) -> Bool in
            let isContain = model.name?.contains(searchBar.text ?? "")
            return isContain!
        })
        self.tableView.reloadData()
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        return tableView
    }()
    /**行数*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return  self.searchDataArr.count
    }
    /**行高*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    /**返回cell*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentifier = "clues"
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifier)
        if cell == nil {
            cell = SLCluesTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: indentifier)
        }
        let cluesCell = cell as! SLCluesTableViewCell
       
        let model:SLCluesModel = self.searchDataArr[indexPath.row]
        cluesCell.setCellWithModel(model: model)
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model:SLCluesModel = self.searchDataArr[indexPath.row]
        let cvc = SLCluesDetailVC()
        cvc.cluesID = model.id
        cvc.pool = WhichPool.privatePool
        cvc.isFromSearch = "search"
        cvc.fresh = { isFreshList in
            
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(cvc, animated: true)
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
