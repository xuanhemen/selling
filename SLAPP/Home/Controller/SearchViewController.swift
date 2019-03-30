//
//  SearchViewController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/2/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
let CardView_Width = 200.0
let CardView_Height = 42.0
let kCalendarMenuViewHeight = 35.0
let kCalendarContentViewHeightShort = 85.0
let kVisitCountView_Height = 40.0

class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    @objc var from:Int = 0 //0 首页  1项目  2辅导
    var cardView: CardView?//切换器
    var searchType = 0
    var task:URLSessionDataTask? = nil
    var model = [Dictionary<String, Any>]()
    var isEndSearch = false
    let searchView = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 30))
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = searchView
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchView.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.titleView = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        self.configUI()
        if from == 0 || from == 1 {
            self.cardView?.configSelect(with: 10)
        }else if from == 2 {
            self.cardView?.configSelect(with: 11)
        }else if from == 3 {
            self.cardView?.configSelect(with: 12)
        }else if from == 4 {
            self.cardView?.configSelect(with: 13)
        }
    }
    let resultTable = UITableView.init(frame: CGRect(x: 0, y: CGFloat(CardView_Height), width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX), style: UITableViewStyle.plain)
    let nearlySearch = NearlySearch.init(frame: CGRect(x: 0, y: CGFloat(CardView_Height) , width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX), style: UITableViewStyle.plain)
    
    
    func configUI() {
//        tableView.backgroundColor = UIColor.groupTableViewBackground
        
//        let searchView = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 30))
        nearlySearch.isScroll = { [weak self] in
            self?.searchView.resignFirstResponder()
        }
        
        
        searchView.backgroundColor = UIColor.clear
        searchView.setBackgroundImage(UIImage.init(named: "backColor")!, for: .any, barMetrics: .default)
        searchView.showsCancelButton = false
        
        self.view.backgroundColor = .white
        
        searchView.delegate = self
        searchView.placeholder = "请输入搜索内容"
        
        searchView.tintColor = .blue
//        searchView.showsSearchResultsButton = true
        //cardDemo
        cardView = CardView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: CGFloat(CardView_Height)))
        cardView?.backgroundColor = kGrayColor_Slapp
//        cardView?.creatBtnsWithTitles(titlesArr: ["项目","辅导","客户","联系人"])
        cardView?.titleNormalColor = kCardNoSelectColor
        cardView?.titleSelectColor = .white
        cardView?.creatBtns(withTitles: ["项目","辅导","客户","联系人"])
        cardView?.btnClickBlock = {[weak self] btnTag in
            DLog(btnTag)
            self?.searchType = btnTag - 10

            self?.searchBar((self?.searchView)!, textDidChange: (self?.searchView.text!)!)

            self?.nearlySearch.model = Array<Dictionary<String,Any>>()
            self?.nearlySearch.reloadData()
            self?.nearlySearch.getData(searchType: btnTag - 10)
            return false
        }
        self.view.addSubview(cardView!)
        self.view.addSubview(nearlySearch)
        nearlySearch.getData(searchType: 0)
        nearlySearch.selectNearly = {typeId in
            switch self.searchType {
            case 0:
                self.selectProject(projectId: typeId)
            case 2:
                self.selectUser(userId: typeId)
            case 3:
                self.selectContact(contactId: typeId)
            case 1:
                self.selectTuroring(turorId:typeId)
            default: break
                
            }
        }
        self.view.addSubview(resultTable)
        resultTable.isHidden = true
        resultTable.backgroundColor = UIColor.groupTableViewBackground
        resultTable.register(UITableViewCell.self, forCellReuseIdentifier: "nearlySearch")
        resultTable.delegate = self
        resultTable.dataSource = self
       
    }
    
    //选中一个辅导
    func selectTuroring(turorId:String){
        let vc = TutoringDetailVC()
        vc.new_consult_id = turorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //选中一个联系人
    func selectContact(contactId:String){
        PublicMethod.showProgressWithStr(statusStr: "获取联系人信息中...")
        LoginRequest.getPost(methodName: CONTACT_DETAIL, params: [kToken:UserModel.getUserModel().token as Any,"contact_id":contactId], hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
//            NSArray * arr = tempDic[@"client_all"];
//            NSMutableArray * clientModels = [SLContactClientModel mj_objectArrayWithKeyValuesArray:arr];
//            if ([clientModels count]==1) {
//                SLContactClientModel *model = clientModels[0];
//                HYContactDetailVC * cvc = [[HYContactDetailVC alloc]init];
//                cvc.contact_id = model.contact_id;
//                cvc.client_id = model.client_id;
//                [self.navigationController pushViewController:cvc animated:YES];
//            }else{
//                NSArray * phoneArr = tempDic[@"phone_arr"];
//                SLContactMoreClientVC *  mvc = [[SLContactMoreClientVC alloc]init];
//                mvc.dataArr = clientModels;
//                mvc.phoneArr = phoneArr;
//                mvc.name = tempDic[@"name"];
//                [self.navigationController pushViewController:mvc animated:YES];
//            }
            PublicMethod.dismiss()
           // client_list
            if let json = JSON(dic).dictionary,let arr = json["client_list"]?.arrayObject {
                let clientModels = SLContactClientModel.mj_objectArray(withKeyValuesArray: arr)
                if clientModels?.count==1 {
                    let model = clientModels![0] as! SLContactClientModel
                    let cvc = HYContactDetailVC()
                    cvc.contact_id = model.contact_id
                    cvc.client_id = model.client_id
                    self.navigationController?.pushViewController(cvc, animated: true)
                }else{
                    let phoneArr = dic["phone_arr"]
                    let mvc = SLContactMoreClientVC()
                    mvc.dataArr = clientModels as! [SLContactClientModel]
                    mvc.phoneArr = phoneArr as! [Any]
                    mvc.name = dic["name"] as! String
                    self.navigationController?.pushViewController(mvc, animated: true)
                }
            }
          //  let arr = dic["client_list"]
            
           
        }
    }
    
    //选中一个客户
    func selectUser(userId:String){
        PublicMethod.showProgressWithStr(statusStr: "获取客户信息中...")
        LoginRequest.getPost(methodName: CLIENT_DETAIL, params: [kToken:UserModel.getUserModel().token as Any,"id":userId],hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
            PublicMethod.dismiss()
//            let detailVC = QFCustomerDetailVC()
//            detailVC.clientId = userId
//            detailVC.modelDic = dic
//            self.navigationController?.pushViewController(detailVC, animated: true)
            
            if let vc = R.storyboard.customPool.customDetailViewController() {
                vc.isPublicSea = false
                vc.customIdString = userId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    //选中一个project
    func selectProject(projectId: String) {
//        print(projectId)
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":projectId].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                let tab = ProjectSituationTabVC()
                tab.model = model; self?.navigationController?.pushViewController(tab, animated: true)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.searchView.resignFirstResponder()
    }

    //MARK: - ***********  tableViewDelegate     ***********
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isEndSearch{
            return 44
        }
        switch searchType {
        case 3:
            return 70.0
        case 2,0:
            return 60.0
        default:
            return 44
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEndSearch {
            switch searchType {
            case 0:do {
                var cell = tableView.dequeueReusableCell(withIdentifier: "HYSearchProjectCell")
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("HYSearchProjectCell", owner: self, options: [:])?.last as! HYSearchProjectCell
                }
                (cell as! HYSearchProjectCell).setViewModelWithDictWithDict(model[indexPath.row])
                return cell!
                }
            case 2:do {
                var cell = tableView.dequeueReusableCell(withIdentifier: "HYSearchClientCell")
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("HYSearchClientCell", owner: self, options: [:])?.last as! HYSearchClientCell
                }
                (cell as! HYSearchClientCell).cellNameLabel.text = String.noNilStr(str: model[indexPath.row]["name"])
                var place = String.noNilStr(str: model[indexPath.row]["place"])
                if place == "" {
                    place = "暂无地址信息"
                }
                (cell as! HYSearchClientCell).cellAdressLabel.text = place
                return cell!
                }
            case 3:
                var cell = tableView.dequeueReusableCell(withIdentifier: "HYContactNewCell")
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("HYContactNewCell", owner: self, options: [:])?.last as! HYContactNewCell
                }
                (cell as! HYContactNewCell).cellNameLabel.text = String.noNilStr(str: model[indexPath.row]["name"])
                (cell as! HYContactNewCell).cellPositionLabel.text = String.noNilStr(str: model[indexPath.row]["position_name"])
                (cell as! HYContactNewCell).cellCompanylabel.text = String.noNilStr(str: model[indexPath.row]["client_name"])
                
                (cell as! HYContactNewCell).dict = model[indexPath.row]
                return cell!
            default:do {
                }
            }
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "nearlySearch")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "nearlySearch")
        }
        if isEndSearch {
            cell?.imageView?.image = nil
        }else{
            cell?.imageView?.image = UIImage.init(named: "tableSearch")
        }
        var name = String.noNilStr(str: model[indexPath.row]["name"])
        if name == "" && searchType==1{
            name = "【辅导】 " + String.noNilStr(str: model[indexPath.row]["project_name"])
        }
        cell?.textLabel?.text = name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEndSearch{
            let id =  String.noNilStr(str: self.model[indexPath.row]["id"])
            if searchType == 0 {
                self.selectProject(projectId: id)
            }else if searchType == 1 {
                self.selectTuroring(turorId: id)
            }else if searchType == 2 {
                self.selectUser(userId: id)
            }else if searchType == 3 {
                self.selectContact(contactId: id)
            }
        }else{
            self.searchView.text = String.noNilStr(str: model[indexPath.row]["name"])
            self.searchBarSearchButtonClicked(self.searchView)
        }
    }
    
    // MARK: - UISearchBarDelegate

    /// 点击搜索按钮后结果
    ///
    /// - Parameter searchBar: <#searchBar description#>
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if task != nil{
            task?.cancel()
            task = nil
        }
        isEndSearch = true
        PublicMethod.showProgressWithStr(statusStr: "搜索中")
        LoginRequest.getPost(methodName: CLECK_SEARCH, params: ["type":searchType,"name":searchBar.text as Any,kToken:UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }, success: { (dic) in
            PublicMethod.dismiss()
            DLog(dic)
            self.model.removeAll()
            let arr = dic["data"] as! [Dictionary<String,Any>]
            
            for subJson in arr {
                self.model.append(subJson)
            }
            self.resultTable.reloadData()
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.nearlySearch.isHidden = false
            self.resultTable.isHidden = true
        }else{
            if !self.nearlySearch.isHidden{
                self.nearlySearch.isHidden = true
                self.resultTable.isHidden = false
            }
            if task != nil{
                task?.cancel()
                task = nil
            }
            isEndSearch = false
//            task = LoginRequest.getPostWithTask(methodName: SEARCH_PROCESS, params: ["type":searchType,"name":searchText,kToken:UserModel.getUserModel().token as Any], hadToast: false, fail: { (dic) in
//                DLog(dic)
//            }, success: { (dic) in
//                if dic["data"] is [Dictionary<String, Any>]{
//                    self.model = dic["data"] as! [Dictionary<String, Any>]
//                    self.resultTable.reloadData()
//                }else{
//                    self.model = [Dictionary<String, Any>]()
//                    self.resultTable.reloadData()
//                }
//            })
//            task?.cancel()
        }
    }
    
    
    
}
