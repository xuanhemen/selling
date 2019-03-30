//
//  TutoringMembersVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
//显示类型
public enum membersType : Int{
    case single //单个
    case multiple //多个
}

//成员类型
public enum membersStyle : Int {
    case ourcompany //
    case ourDepart //
    case contact //联系人
}




let currentCellWidth = (MAIN_SCREEN_WIDTH-50)/4

class TutoringMembersVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - style: 0   1  全公司  部门
    ///   - type: 0  1 单选多选
 @objc  func configStyleAndType(style:Int,type:Int){
        self.type = membersType.init(rawValue: type)
        self.style = membersStyle.init(rawValue: style)
    }
    
    
    
    //选择联系人的时候需要过滤公司
    var clientId:String?
    //是否是转移
    var isTransfer:Bool = false
    
    //根据用户id以及已选择
    var userId:String = ""
    var qf_otherArray = Array<MemberModel>()
    //原始数据源
    var dataArray = Array<MemberModel>()
    //当前展示的数据源
    var currentArray = Array<MemberModel>()
    //选中的数据源
    var selectArray = Array<MemberModel>()
    
    
    var style:membersStyle?
    
    //类型
    var type:membersType?{
        didSet{
            if type == .single
            {
                self.top.searchView.placeholder = "搜索"
                if (isTransfer == true){
                    self.top.searchView.placeholder = "非本部门人员请搜索"
                }
            }else{
                self.top.searchView.placeholder = "非本部门人员请搜索"
            }
            self.configData()
            self.top.type = type
        }
    }
    
    
    
    //TODO临时有增加  但是没有整理以前的代码   有时间整理  以前只有一个地方用   单个选还是多个   其中类型是固定   显示要考虑 内容
    
    func configData(){
        
        if self.type == .single {
            //单选
            if self.style == .ourcompany {
                self.configDataMember()
            }
            else{
                self.configDataTeacher()
            }
            
            
        }else{
            if self.style == .contact{
                self.configContact()
                return
            }
            //多选
            self.configDataMember()
        }
        
        
        
    }
    
    
    
    //点击保存时候的返回数据源
  @objc var resultArray:(_ result:Array<MemberModel>)->() = {_ in
        
    }
    
    //将已经存在的数据源添加
  @objc  func configAlReadyArray(alReady:Array<MemberModel>){
        self.selectArray = alReady
        if self.type != .single {
            self.top.dataArray = self.selectArray
            self.top.collectionView.reloadData()
            self.top.refresh()
        }
       self.collectionView.reloadData()
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if type == .single {
            if selectArray.count > 0{
                let index = self.currentArray.index(where: { (model) -> Bool in
                    if model.id == self.selectArray.first?.id{
                        return true
                    }
                    return false
                })
               
                self.selectArray.removeAll()
                if index != nil {
                    collectionView.reloadItems(at: [IndexPath.init(row: index!, section: 0)])
                    
                }
            }
        }
        let model = currentArray[indexPath.row]
        
        var isExist = false
        var index = 0
        for mymodel in selectArray {
            if mymodel.id == model.id {
                isExist = true
                index = selectArray.index(of: mymodel)!
            }
        }
        if isExist == true {
            selectArray.remove(at: index)
            top.topChangeWithModel(model: model, isAdd: false)
        }else{
            selectArray.append(model)
            top.topChangeWithModel(model: model, isAdd: true)
        }
        
//        let array =  selectArray.filter {[weak model] (mymodel) -> Bool in
//            if mymodel.id == model?.id {
//                return true
//            }
//            return false
//        }
//        if array.count > 0 {
//            selectArray.remove(at: selectArray.index(of: array.first!)!)
//            top.topChangeWithModel(model: model, isAdd: false)
//        }else{
//            selectArray.append(model)
//            top.topChangeWithModel(model: model, isAdd: true)
//        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TutoringMembersCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutoringMembersCell
        cell.congfigModel(model: self.currentArray[indexPath.row])
//        let array =  selectArray.filter {[weak cell] (model) -> Bool in
//            if model.id == cell?.model?.id {
//                return true
//            }
//            return false
//        }
        var isExist = false
        for mymodel in selectArray {
            if mymodel.id == cell.model?.id {
                isExist = true
            }
        }
        if isExist == true {
            cell.contentView.backgroundColor = kGreenColor
            cell.markImage.image = UIImage.init(named: "logic_select")
        }else{
            cell.markImage.image = UIImage.init(named: "logic_normal")
            cell.contentView.backgroundColor = UIColor.white
        }
        
//        if array.count>0 {
//            cell.contentView.backgroundColor = kGreenColor
//            cell.markImage.image = UIImage.init(named: "logic_select")
//        }else{
//            cell.markImage.image = UIImage.init(named: "logic_normal")
//            cell.contentView.backgroundColor = UIColor.white
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: currentCellWidth, height: self.type == .single ? 120 : 90)
    }
    
    
    lazy var collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.groupTableViewBackground
        collection.register(TutoringMembersCell.self, forCellWithReuseIdentifier: "cell")
        
        return collection
    }()
    
    lazy var top = { () -> TutoringMemberTopView in
        return TutoringMemberTopView()
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.congigUI()
        self.setRightBtnWithArray(items: ["保存"])
       
        
    }
    
    override func rightBtnClick(button: UIButton) {
        if self.selectArray.count == 0 {
            PublicMethod.toastWithText(toastText: "您还没有选择")
            return
            
        }
        
        if isTransfer == true {
            self.showAlert(titleStr: "您确认将项目转移给选中的同事吗?") {[weak self] in
                self?.resultArray((self?.selectArray)!)
            }
        }else{
            self.resultArray(self.selectArray)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    
        
    }
    
    
    func congigUI(){
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(top)
        self.view.addSubview(collectionView)
        top.searchView.delegate = self
        top.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
        }
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.top.snp.bottom)!)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        //删除选择回调
        top.removeSelect = {[weak self] (model) in
            self?.removeSelect(model: model)
        }
        
    }
    
    func removeSelect(model:MemberModel){
        
        self.selectArray = selectArray.filter({ (myModel) -> Bool in
            if model.id == myModel.id {
                return false
            }
            return true
        })
        
       let index =  self.currentArray.index { (myModel) -> Bool in
        if model.id == myModel.id {
            return true
        }
          return false
        }
        if index != nil {
            self.collectionView.reloadItems(at: [IndexPath.init(row: index!, section: 0)])
        }
        
    
        
    }
    
    
    func configDataMember(){
        PublicMethod.showProgress()
//        pp.member.search_member
//        MEMBER_LIST
        //修改---------------
        
//        var urlStr = ""
//        if (isTransfer == true){
//            urlStr = SEARCH_MEMBER
//        }else{
//            urlStr = MEMBER_LIST
//        }
        
        LoginRequest.getPost(methodName:MEMBER_LIST , params: [:].addToken(), hadToast: true, fail: { (dic) in
         PublicMethod.dismiss()
        }) {[weak self] (dic) in
          PublicMethod.dismiss()
            let array:Array<Dictionary<String,Any>> = dic["data"] as! Array<Dictionary<String, Any>>
            self?.dataArray.removeAll()
            for sdic in array {
                let model:MemberModel = MemberModel.deserialize(from: sdic)!
                //QF -- mark: 参与者观察者 创建者不能是同一个人
                if (self?.title == "选择参与人")||(self?.title=="选择观察员"){
                    if self?.userId != model.id{
                        if (self?.qf_otherArray.count)!>0{
                            var isExit = false
                            for qf_model in (self?.qf_otherArray)!{
                                if qf_model.id == model.id{
                                    isExit = true
                                }
                            }
                            if isExit == false{
                                self?.dataArray.append(model)
                            }
                        }else{
                            self?.dataArray.append(model)
                        }
                    }
                }else{
                    self?.dataArray.append(model)
                }
            }
            self?.currentArray = (self?.dataArray)!
            self?.collectionView.reloadData()
        }

    }

    //适配联系人
    func configContact(){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CONTACT_LIST, params: ["token":UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            if JSON(dic["list"] as Any).arrayValue.count > 0{
                self?.dataArray.removeAll()
                for sub:Dictionary<String,Any> in dic["list"] as! Array {
                    if let model = ProAddContactModel.deserialize(from: sub){
                        if model.client_id == self?.clientId{
                            let amodel:MemberModel = MemberModel()
                            amodel.head = ""
                            amodel.name = model.name
                            amodel.id = model.id
                            amodel.position = model.position_name
                            amodel.phone = model.phone
                            self?.dataArray.append(amodel)
                        }
                        
                    }
                    
                    
                }
                self?.currentArray = (self?.dataArray)!
                self?.collectionView.reloadData()
            }
            
        
        }
    }
    
    
    func configDataTeacher(){
         PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CONSULT_TEACHER, params: [:].addToken(), hadToast: true, fail: { (dic) in
             PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
//            DLog(dic)
            let array:Array<Dictionary<String,Any>> = dic["data"] as! Array<Dictionary<String, Any>>
            self?.dataArray.removeAll()
            for sdic in array {
                let model:MemberModel = MemberModel()
                model.head = JSON(sdic["head"] as Any).stringValue
                model.name = JSON(sdic["realname"] as Any).stringValue
                model.id = JSON(sdic["userid"] as Any).stringValue
                model.classStr = JSON(sdic["multiple_classes"] as Any).stringValue
                self?.dataArray.append(model)
            }
            self?.currentArray = (self?.dataArray)!
            self?.collectionView.reloadData()
        }
        
    }
    
    func search(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: SEARCH_MEMBER, params: ["name":top.searchView.text!].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            let array:Array<Dictionary<String,Any>> = dic["data"] as! Array<Dictionary<String, Any>>
            self?.currentArray.removeAll()
            self?.dataArray.removeAll()
            for sdic in array {
                //QF -- mark: 参与者观察者 创建者不能是同一个人
                let model:MemberModel = MemberModel.deserialize(from: sdic)!
                
                if (self?.title == "选择参与人")||(self?.title=="选择观察员"){
                    if self?.userId != model.id{
                        if (self?.qf_otherArray.count)!>0{
                            var isExit = false
                            for qf_model in (self?.qf_otherArray)!{
                                if qf_model.id == model.id{
                                    isExit = true
                                }
                            }
                            if isExit == false{
                                self?.dataArray.append(model)
                            }
                        }else{
                            self?.dataArray.append(model)
                        }
                    }
                }else{
                    self?.dataArray.append(model)
                }
            }
            self?.currentArray = (self?.dataArray)!
            self?.collectionView.reloadData()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if self.type == .single {
            
            if(isTransfer == true){
                 self.search()
            }else{
                self.currentArray = self.dataArray.filter({ (model) -> Bool in
                    if (model.name?.contains(searchBar.text!))!
                    {
                        return true
                    }
                    return false
                })
                self.collectionView.reloadData()
            }
        }
        else{
            self.search()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.currentArray = self.dataArray
            self.collectionView.reloadData()
        }
    }
    
}
