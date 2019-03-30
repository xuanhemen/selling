//
//  QFAddUserVC.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/20.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
class QFAddUserVC: UIViewController,UISearchBarDelegate {
    var model:ProjectSituationModel?
    let QF_Width = UIScreen.main.bounds.size.width
    let QF_Height = UIScreen.main.bounds.size.height
    
    var tableView:UITableView?
    var selectArray = Array<ProAddContactModel>()
    
    var alreadyArray = Array<MemberModel>()
    var dataArray = Dictionary<String,Array<ProAddContactModel>>()
    var currentDataArray = Dictionary<String,Array<ProAddContactModel>>()
    var sectionCurrentArray = Array<String>()
    var sectionArray = Array<String>()
    //选择返回结果
    var result:(_ array:[MemberModel])->() = {_ in
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiConfig()
        
        self.configDataMember()
        self.setRightBtnWithArray(items: ["保存"])
    }
    
    lazy var searchView = { () -> UISearchBar in
        let search = UISearchBar()
        search.placeholder = "输入搜索"
        search.setBackgroundImage(UIImage.init(named: "backGray")!, for: .any, barMetrics: .default)
        return search
    }()
    
    override func rightBtnClick(button: UIButton) {
        if selectArray.count == 0 {
            PublicMethod.toastWithText(toastText: "还没有选择的客户对象")
            return
        }
        var array = Array<MemberModel>()
        for model in selectArray {
            let mModel:MemberModel = MemberModel()
            mModel.id = model.contact_id
            mModel.name = model.name
            mModel.head = ""
            mModel.pid  = model.contact_id
            array.append(mModel)
        }
        result(array)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func configDataMember(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: ACTION_PLAN_PEOPLE, params: ["project_id":self.model?.id].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            DLog(dic)
            PublicMethod.dismiss()
            if JSON(dic["data"] as Any).arrayValue.count > 0{
                for sub:Dictionary<String,Any> in dic["data"] as! Array {
                    if let model = ProAddContactModel.deserialize(from: sub){
                        
                        for memberModel in (self?.alreadyArray)! {

                            if memberModel.id == model.contact_id {
                                self?.selectArray.append(model)
                            }
                        }
                        
                        if self?.dataArray[model.key] != nil {
                            self?.dataArray[model.key]?.append(model)
                        }else{
                            self?.dataArray[model.key] = Array<ProAddContactModel>()
                            self?.dataArray[model.key]?.append(model)
                            self?.sectionArray.append(model.key)
                        }
                    }
                }
                
            }
            
            self?.sectionArray.sort(by: {
                return $0<$1
            })
            self?.currentDataArray = (self?.dataArray)!
            self?.sectionCurrentArray = (self?.sectionArray)!
            self?.alreadyArray.removeAll()
            self?.tableView?.reloadData()
        }
        
    }
    
    
    
    
    func uiConfig() {
        self.title = "选择客户对象"
        self.view.backgroundColor = UIColor.init(red: 235/255.0, green: 234/255.0, blue: 241/255.0, alpha: 1)
        
        self.tableViewConfig(frame: CGRect(x: 0, y: 0, width: QF_Width, height: QF_Height-64))
    }
    
    func tableViewConfig(frame:CGRect)  {
        self.tableView = UITableView.init(frame: frame, style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.backgroundColor = self.view.backgroundColor
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.tableView!)
        
        self.tableView?.tableHeaderView = self.configSearchView()
    }
    func configSearchView() ->UIView {
//        let backView = UIView.init(frame: CGRect(x: 15, y: 0, width: QF_Width-30, height: 60))
        searchView.frame = CGRect(x: 15, y: 0, width: QF_Width-30, height: 60)
        searchView.delegate = self
//        let searchView = UIView.init(frame: CGRect(x: 15, y: 10, width: QF_Width-30, height: 40))
//        searchView.backgroundColor = .white
//        backView.addSubview(searchView)
//
//        let searchImageView = UIImageView.init(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
//        searchImageView.image = #imageLiteral(resourceName: "project_search")
//        searchView.addSubview(searchImageView)
//
//        let searchTextField = UITextField.init(frame: CGRect(x: 40, y: 5, width: searchView.frame.size.width-50, height: 30))
//        searchTextField.placeholder = "不属于本客户的联系人直接搜索"
//        searchTextField.font = UIFont.systemFont(ofSize: 15)
//        searchView.addSubview(searchTextField)
        
        return searchView
    }

}
extension QFAddUserVC:UITableViewDelegate,UITableViewDataSource  {
    
    //MARK: - tableview代理
    func numberOfSections(in tableView: UITableView) -> Int {
      return self.sectionCurrentArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let str = sectionCurrentArray[section]
        let array = self.currentDataArray[str]
        return (array?.count)!
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "QFUserCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QFUserCell
        if cell == nil {
            cell = QFUserCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
       
        let model = self.currentDataArray[sectionCurrentArray[indexPath.section]]?[indexPath.row]
        cell?.setData(model:model!)
        
        if selectArray.contains(model!) {
            cell?.backView?.backgroundColor = HexColor("#44C288")
        }else{
            cell?.backView?.backgroundColor = .white
        }
        cell?.click = { [weak self] () in
            self?.clickWithIndex(indexPath: indexPath)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let headerView = UIView.init(frame: frame)
        headerView.backgroundColor = self.view.backgroundColor
        
        let titleLabel = UILabel.init(frame: CGRect(x: 15, y: 5, width: QF_Width-30, height: 30))
        titleLabel.text = sectionArray[section]
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    //点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let submodel = self.currentDataArray[sectionCurrentArray[indexPath.section]]?[indexPath.row]
        
        let vc = ProRolePlanVC()
        vc.title = self.model?.name
        vc.projectId = (self.model?.id)!
        vc.model = self.model
        vc.currentUserId = submodel?.id
        vc.currentName = (submodel?.name)!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func clickWithIndex(indexPath:IndexPath){
        let model = self.currentDataArray[sectionCurrentArray[indexPath.section]]?[indexPath.row]
        if selectArray.contains(model!) {
            selectArray.remove(at: selectArray.index(of: model!)!)
        }else{
            selectArray.append(model!)
        }
        self.tableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty)! else {
            return
        }
        self.currentDataArray.removeAll()
        self.sectionCurrentArray.removeAll()
        for key in sectionArray {
            let array = self.dataArray[key]?.filter({ (model) -> Bool in
                if model.name.contains(searchBar.text!){
                    DLog(model.name)
                    return true
                }
                else{
                    return false
                }
            })
            if !(array?.isEmpty)! {
                self.currentDataArray[key] = array
                sectionCurrentArray.append(key)
            }
        }
        self.tableView?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.currentDataArray = self.dataArray
            self.sectionCurrentArray = sectionArray
            self.tableView?.reloadData()
        }
    }
    
}
