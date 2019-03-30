//
//  MyCustomListViewController.swift
//  SLAPP
//
//  Created by fank on 2018/11/29.
//  Copyright © 2018年 柴进. All rights reserved.
//  我的客户

import UIKit
import SwiftyJSON
import YBPopupMenu

class MyCustomListViewController: BaseVC {
    
    enum PopTypeEnum : Int {
        
        case add = 10
        case sort = 20
        case filter = 30
        
        var value : Int {
            return self.rawValue
        }
    }
    
    enum AddDetailTypeEnum : Int {
        
        case scan = 0
        case photo = 1
        case merge = 2
        case unKnown = -1
        
        init(type: Int) {
            switch type {
            case 0: self = .scan
            case 1: self = .photo
            case 2: self = .merge
            default: self = .unKnown
            }
        }
        
        var value : Int {
            return self.rawValue
        }
        
        func description() -> String {
            switch self {
            case .scan:
                return "扫名片"
            case .photo:
                return "选择名片"
            case .merge:
                return "合并客户"
            case .unKnown:
                return ""
            }
        }
    }
    
    enum SortDetailTypeEnum : Int {
        
        case asc = 0
        case desc = 1
        case unKnown = -1
        
        init(type: Int) {
            switch type {
            case 0: self = .asc
            case 1: self = .desc
            default: self = .unKnown
            }
        }
        
        var value : Int {
            return self.rawValue
        }
        
        func description() -> String {
            switch self {
            case .asc:
                return "创建时间升序"
            case .desc:
                return "创建时间降序"
            case .unKnown:
                return ""
            }
        }
    }
    
    enum FilterDetailTypeEnum : Int {
        
        case all = 0
        case trade = 1
        case leader = 2
        case province = 3
        case unKnown = -1
        
        init(type: Int) {
            switch type {
            case 0: self = .all
            case 1: self = .trade
            case 2: self = .leader
            case 3: self = .province
            default: self = .unKnown
            }
        }
        
        var value : Int {
            return self.rawValue
        }
        
        func description() -> String {
            switch self {
            case .all:
                return "全部"
            case .trade:
                return "行业"
            case .leader:
                return "负责人"
            case .province:
                return "省份"
            case .unKnown:
                return ""
            }
        }
    }
    
    @objc var pageList = ""
    
    var orderTag = ""
    var principalTag = ""
    var tradeTag : (one:String, two:String) = ("", "")
    var addressTag : (province:String, city:String, area:String) = ("", "", "")
    
    var areaView : AreaView?
    
    var searchView : UISearchBar!
    
    var provinceArray : NSMutableArray = []
    
    var cityArray : NSMutableArray = []
    
    var districtArray : NSMutableArray = []
    
    var dataArray : [MyCustomListModel] = []
    
    var areaTuple : (areaIndex: Int, selectId: String) = (0, "")
    
    @IBOutlet weak var sortButton: UIButton!
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var filterResultLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottonScrollLineLeadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        
        self.initAreaDataFunc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initData()
    }
    
    @IBAction func btnClickFunc(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.25) {
            self.bottonScrollLineLeadingConstraint.constant = (sender.tag == 1 ? self.sortButton.x : self.filterButton.x) + 10
            self.view.layoutIfNeeded()
        }
        
        switch sender.tag {
        case 1: // 排序
            YBPopupMenu.showRely(on: sender, titles: [SortDetailTypeEnum.description(.asc)(), SortDetailTypeEnum.description(.desc)()], icons: [], menuWidth: 130, delegate: self)
        case 2: // 筛选
            YBPopupMenu.showRely(on: sender, titles: [FilterDetailTypeEnum.description(.all)(), FilterDetailTypeEnum.description(.trade)(), FilterDetailTypeEnum.description(.leader)(), FilterDetailTypeEnum.description(.province)()], icons: [], menuWidth: 100, delegate: self)
        default:
            break
        }
    }
    
    @objc func searchBtnClickFunc() {
        let vc = SearchViewController()
        vc.from = 3
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func addBtnClickFunc(sender: UIButton) {
        if let vc = R.storyboard.customPool.createCustomViewController() {
            vc.isFromPublicSea = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func moreBtnClickFunc(sender: UIButton) {
        YBPopupMenu.showRely(on: sender, titles: [AddDetailTypeEnum.description(.scan)(), AddDetailTypeEnum.description(.photo)(), AddDetailTypeEnum.description(.merge)()], icons: [], menuWidth: 100, delegate: self)
    }
    
    func resetParamsFunc() {
        
        self.orderTag = ""
        self.principalTag = ""
        self.tradeTag = ("", "")
        self.addressTag = ("", "", "")
        
        self.initData()
    }
    
    func addRightBarButtonItemsFunc() {
        
        let addBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        addBtn.setImage(R.image.nav_add_new(), for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnClickFunc), for: .touchUpInside)
        
        let moreBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        moreBtn.setImage(R.image.nav_more(), for: .normal)
        moreBtn.addTarget(self, action: #selector(moreBtnClickFunc), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: moreBtn), UIBarButtonItem(customView: addBtn)]
    }
    
    func initAreaDataFunc() {
        
        if let url = R.file.addressJson(), let data = try? Data(contentsOf: url) {
            
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                
                let addressJson = JSON(jsonData)
                
                addressJson["province"].arrayValue.forEach { (json) in
                    if let model = AddressAreaModel(json.dictionaryObject) {
                        self.provinceArray.add(model)
                    }
                }
                
                addressJson["city"].arrayValue.forEach { (json) in
                    if let model = AddressAreaModel(json.dictionaryObject) {
                        self.cityArray.add(model)
                    }
                }
                
                addressJson["district"].arrayValue.forEach { (json) in
                    if let model = AddressAreaModel(json.dictionaryObject) {
                        self.districtArray.add(model)
                    }
                }
            }
        }
    }
    
    func initData() {
        
        var params : [String:String] = [:]
        var urlString = ""
        if self.pageList == ""{
            
            urlString = CUSTOM_POOL_PRIVATE_LIST
            
            params["token"] = UserModel.getUserModel().token ?? ""
            params["order"] = self.orderTag
            params["trade_one"] = self.tradeTag.one
            params["trade_two"] = self.tradeTag.two
            params["principal"] = self.principalTag
            params["province"] = self.addressTag.province
            params["city"] = self.addressTag.city
            params["area"] = self.addressTag.area
            
            print("*** params = \(params)")
        }else{
            
            urlString = CUSTOM_POOL_PAGE_PRIVATE_LIST
            
            params["token"] = UserModel.getUserModel().token ?? ""
            params["client_ids"] = self.pageList
        }
       
        
        self.showProgress(withStr: "正在加载中...")
        LoginRequest.getPost(methodName: urlString, params: params, hadToast: true, fail: { [weak self] (dict) in
            print("*** = \(dict)")
            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
            self?.showDismiss()
            
            print("*** = \(dict)")
            
            if let jsons = JSON(dict)["data"].array {
                
                self?.dataArray.removeAll()
                
                jsons.forEach({ (json) in
                    self?.dataArray.append(MyCustomListModel.myCustomListModel(json: json))
                })
                
                if let count = self?.dataArray.count, count > 0 {
                    if self?.principalTag != "" || self?.tradeTag.one != "" || self?.addressTag.province != "" {
                        self?.filterResultLabel.isHidden = false
                        self?.filterResultLabel.text = "(\(count))"
                    } else {
                        self?.filterResultLabel.isHidden = true
                    }
                } else {
                    self?.filterResultLabel.isHidden = true
                }
                
                self?.tableView.reloadData()
            }
        }
    }
    
    func initSearchViewFunc() {
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW - 120, height: 30))
        titleView.layer.masksToBounds = true
        titleView.layer.cornerRadius = 8
        
        self.searchView = UISearchBar(frame: CGRect(x: -10, y: 0, width: titleView.width + 20, height: titleView.height))
        self.searchView.placeholder = "请输入搜索关键字..."
        self.searchView.tintColor = UIColor.blue
        self.searchView.delegate = self
        
        titleView.addSubview(self.searchView)
        
        self.navigationItem.titleView = titleView
    }
    
    func initView() {
        
        self.title = "我的客户"
        
        self.initSearchViewFunc()
        
        self.addRightBarButtonItemsFunc()
        
        self.filterResultLabel.isHidden = true
    }

}

// MARK: - 代理相关
extension MyCustomListViewController : YBPopupMenuDelegate, AreaSelectDelegate, UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchView.resignFirstResponder()
        self.searchBtnClickFunc()
    }
    
    func select(_ index: Int, selectID areaID: String!) {
        
        self.areaTuple = (index, areaID)
        self.selectAreaFunc()
        
        switch index {
        case 1:
            self.addressTag.province = areaID
        case 2:
            self.addressTag.city = areaID
        case 3:
            self.addressTag.area = areaID
        default:
            break
        }
        
        self.initData()
    }
    
    func getSelectAddressInfor(_ addressInfor: String!) {
        self.areaTuple.areaIndex = 0
    }
    
    func alertLeaderNameFunc() {
        
        let alertController = UIAlertController(title: nil, message: "负责人", preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.darkGray
        
        alertController.addTextField { (textField) in
            textField.placeholder = "请输入负责人姓名"
        }
        
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "筛选", style: .default, handler: { [weak alertController] (_) in
            if let text = alertController?.textFields?.first?.text {
                self.principalTag = text
                self.initData()
            }
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func selectAreaFunc() {
        
        if self.areaView == nil {
            self.areaView = AreaView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            self.areaView?.isHidden = true
            self.areaView?.address_delegate = self
            UIApplication.shared.keyWindow?.addSubview(areaView!)
        }
        
        switch self.areaTuple.areaIndex {
        case 0:
            self.areaView?.show()
            self.areaView?.provinceArray = self.provinceArray
        case 1:
            
            let array : NSMutableArray = []
            self.cityArray.forEach { (model) in
                if let model = model as? AddressAreaModel {
                    if model.parent == self.areaTuple.selectId {
                        array.add(model)
                    }
                }
            }
            
            self.areaView?.cityArray = array
        case 2:
            
            let array : NSMutableArray = []
            self.districtArray.forEach { (model) in
                if let model = model as? AddressAreaModel {
                    if model.parent == self.areaTuple.selectId {
                        array.add(model)
                    }
                }
            }
            
            self.areaView?.regionsArray = array
        default:
            self.areaTuple.areaIndex = 0
        }
    }
    
    func selectCustomTradeFunc() {
        
        let vc = ChooseTradeVC()
        vc.result = { [weak self] (tradeModel) -> Void in
            self?.tradeTag = (tradeModel.parent_id, tradeModel.index_id)
            self?.initData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addDetailClickFunc(addEnum: AddDetailTypeEnum) {
        switch addEnum {
        case .scan:
            self.chooseImageFunc()
        case .photo:
            self.chooseImageFunc(isScan: false)
        case .merge:
            if let vc = R.storyboard.customPool.customMergeViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
    func sortDetailClickFunc(sortEnum: SortDetailTypeEnum) {
        
        switch sortEnum {
        case .asc:
            self.sortButton.setTitle("升序", for: .normal)
            self.orderTag = "1"
        case .desc:
            self.sortButton.setTitle("降序", for: .normal)
            self.orderTag = "0"
        default:
            break
        }
        
        self.initData()
    }
    
    func filterDetailClickFunc(filterEnum: FilterDetailTypeEnum) {
        
        self.filterButton.setTitle(filterEnum.description(), for: .normal)
        
        switch filterEnum {
        case .all:
            self.resetParamsFunc()
        case .trade:
            self.selectCustomTradeFunc()
        case .leader:
            self.alertLeaderNameFunc()
        case .province:
            self.selectAreaFunc()
        default:
            break
        }
    }
    
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        print("*** index = \(index), titles = \(ybPopupMenu.titles)")
        
        if let title = ybPopupMenu.titles.first as? String {
            switch title {
            case AddDetailTypeEnum.description(.scan)():
                self.addDetailClickFunc(addEnum: AddDetailTypeEnum(type: index))
            case SortDetailTypeEnum.description(.asc)():
                self.sortDetailClickFunc(sortEnum: SortDetailTypeEnum(type: index))
            case FilterDetailTypeEnum.description(.all)():
                self.filterDetailClickFunc(filterEnum: FilterDetailTypeEnum(type: index))
            default:
                break
            }
        }
    }
}

// MARK: - 代理相关
extension MyCustomListViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if image.size.width > SCREEN_WIDTH {
            image = image.imageScaled(to: CGSize(width: SCREEN_WIDTH, height: image.size.height * SCREEN_WIDTH / image.size.width))
        }
        
        if picker.sourceType == UIImagePickerControllerSourceType.camera {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        self.dismiss(animated: true, completion: nil)
        
        if let vc = R.storyboard.customPool.scanNameCardViewController() {
            if picker.sourceType == UIImagePickerControllerSourceType.photoLibrary {
                vc.isScan = false
            }
            vc.isPublicSea = false
            vc.selectedImage = image
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func chooseImageFunc(isScan:Bool = true) {
        
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.delegate = self
        
        switch isScan {
        case true: // 拍照
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.camera
        case false: // 相册
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(imagePickerVc, animated: true, completion: nil)
    }
}

// MARK: - tableview相关
extension MyCustomListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomListCell") as! MyCustomListCell
        
        cell.myCustomListModel = self.dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = R.storyboard.customPool.customDetailViewController() {
            vc.isPublicSea = false
            vc.customIdString = self.dataArray[indexPath.row].idString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
