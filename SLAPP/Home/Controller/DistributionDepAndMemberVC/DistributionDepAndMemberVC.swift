//
//  DistributionDepAndMemberVC.swift
//  SLAPP
//
//  Created by apple on 2018/6/7.
//  Copyright © 2018年 柴进. All rights reserved.
//
import SwiftyJSON
import UIKit
//分配部门及人员
class DistributionDepAndMemberVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    var parentId:String = ""
    var titleStr:String?
    //部门
    var depArray:Array<DepModel> = Array()
    //人员
    var memberArray:Array<DepMemberModel> = Array()
    //所有部门
    var allDepArray:Array<DepModel> = Array()
    //当前部门
    var cDepModel:DepModel?
    
    //部门选中
    var depSelectArray:Array<DepModel> = Array()
    //人员选中
    var memberSelectArray:Array<DepMemberModel> = Array()
    
    //返回选中结果
    var resultArray:(_ dArray:Array<DepModel>,_ mArray:Array<DepMemberModel>)->() = {_,_ in
        
    }
//    外部传入的已经选择的数据
    var aReadyArray = Array<Dictionary<String,Array<BaseModel>>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configBackItem()
        self.configUI()
        if self.cDepModel != nil {
           self.configCurrentData()
          
        }else{
            self.configData()
        }
        
        
    }
    

    func configUI(){
       self.title = titleStr ?? "部门及人员"
        
       table.register(DisDepCell.self, forCellReuseIdentifier: "cell")
       
       self.view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
       table.delegate = self
       table.dataSource = self
        
    }
    
    func configData(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: DEP_LIST, params: [:].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            DLog(dic)
            self?.allDepArray.removeAll()
            PublicMethod.dismiss()
            if JSON(dic["data"] as Any).count > 0 {
                for subdic in JSON(dic["data"] as Any).array!{
                    if let model = DepModel.deserialize(from: JSON(subdic).dictionaryObject){
                        self?.allDepArray.append(model)
                    }
                }
                self?.configAready()
                self?.configCurrentData()
            }
        }
    }
    
    
    func configAready(){
        if self.aReadyArray.count > 0 {
            for dic in self.aReadyArray {
                if dic.keys.first == "dep" {
                    
                    self.depSelectArray = self.allDepArray.filter({ (model) -> Bool in
                       return (dic.values.first?.contains(where: { (d) -> Bool in
                        let dModel:DepModel = d as! DepModel
                            return dModel.id == model.id
                        }))!
                    })
                    
                    
                }else{
                    
                    for d in self.allDepArray {
                       let array = d.member.filter({ (model) -> Bool in
                            return (dic.values.first?.contains(where: { (d) -> Bool in
                                let dModel:DepMemberModel = d as! DepMemberModel
                                return dModel.id == model.id
                            }))!
                        })
                        self.memberSelectArray += array
                        
                    }
                    
                    
                    
                }
            }
        }
    }
    
    
    
//   适配当前部门数据
    func configCurrentData(){
        if self.cDepModel == nil {
            self.cDepModel = self.allDepArray.filter { (model) -> Bool in
                return model.top == "1"
                }.first
            self.depArray = self.allDepArray.filter({ (model) -> Bool in
                return model.parentid == self.cDepModel?.id
            })
            
            self.memberArray = (self.cDepModel?.member)!
        }
        else{
            self.depArray = self.allDepArray.filter({ (model) -> Bool in
                return model.parentid == self.cDepModel?.id
            })
            self.memberArray = (self.cDepModel?.member)!
        }
        self.table.reloadData()

    }
    
    
    // MARK: - table delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return depArray.count
        }
        return  memberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIde = "cell"
        let cell:DisDepCell = tableView.dequeueReusableCell(withIdentifier: cellIde, for: indexPath) as! DisDepCell
        if indexPath.section == 0 {
            cell.dModel = self.depArray[indexPath.row];
            if self.isSelectParent(cModel: self.cDepModel!){
                cell.markImage.image = #imageLiteral(resourceName: "dxSelect")
            }else{
                if self.depSelectArray.contains(cell.dModel!) {
                    cell.markImage.image = #imageLiteral(resourceName: "dxSelect")
                }else{
                    cell.markImage.image = #imageLiteral(resourceName: "dxNormal")
                }
            }
            cell.nextClick = { [weak self](model) in
                self?.gotoNext(model: model)
            }
        }else{
          cell.mModel = self.memberArray[indexPath.row];
            if self.isSelectParent(cModel: self.cDepModel!){
                cell.markImage.image = #imageLiteral(resourceName: "dxSelect")
            }
            else{
                if self.memberSelectArray.contains(cell.mModel!) {
                    cell.markImage.image = #imageLiteral(resourceName: "dxSelect")
                }else{
                    cell.markImage.image = #imageLiteral(resourceName: "dxNormal")
                }
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.isAllNoDepAndMember(cModel: self.cDepModel!) {
            if self.isSelectParent(cModel: self.cDepModel!) {
                self.depSelectArray += self.depArray
                self.memberSelectArray += self.memberArray
            }
        }
        

        
        
        if indexPath.section == 0 {
            let dModel = self.depArray[indexPath.row]
            if self.depSelectArray.contains(dModel) {
                self.depSelectArray.remove(at: self.depSelectArray.index(of: dModel)!)
                self.fitterParentSelectDelete(isSelectMemeber: false)
            }else{
                self.depSelectArray.append(dModel)
                self.fitterParentSelectAdd(cModel: self.cDepModel!)
            }
            
        }else{
            
            let cModel = self.memberArray[indexPath.row]
            if self.memberSelectArray.contains(cModel){
                self.memberSelectArray.remove(at: self.memberSelectArray.index(of: cModel)!)
                self.fitterParentSelectDelete(isSelectMemeber: true)
            }else{
                self.memberSelectArray.append(cModel)
                self.fitterParentSelectAdd(cModel: self.cDepModel!)
            }
            
            
        }
        
        self.table.reloadRows(at: [indexPath], with: .automatic)
    }
    
    lazy var table = { () -> UITableView in
        let table  = UITableView()
        return table
    }()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
//    跳转到子集
    func gotoNext(model:DepModel){
        self.cDepModel = model
        self.configCurrentData()
        self.table.reloadData()
        
        
//        let nextVc = DistributionDepAndMemberVC()
//        nextVc.titleStr = self.cDepModel?.short_name
//        nextVc.allDepArray = self.allDepArray
//        nextVc.depSelectArray = self.depSelectArray
//        nextVc.memberSelectArray = self.memberSelectArray
//        nextVc.cDepModel = model
//        nextVc.resultArray = {[weak self] (d,m)in
//            self?.depSelectArray = d
//            self?.memberSelectArray = m
//            self?.table.reloadData()
//        }
//        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    
    
   //当前选择来处理其父类部门的选择
    /// 当只是操作部门的时候只对父类部门有影响，当选择成员的时候不仅对父类部门有影响，同级部门也有影响
    /// - Parameter isSelectMemeber: 是否选择了成员
    func fitterParentSelectDelete(isSelectMemeber:Bool){
        self.removeParent(model: self.cDepModel!)
        if isSelectMemeber == true {
            for model in self.depArray {
                if self.depSelectArray.contains(model){
                    self.depSelectArray.remove(at: self.depSelectArray.index(of: model)!)
                }
            }
        }
    }
    
    func removeParent(model:DepModel){
    
        if self.depSelectArray.contains(model) {
            self.depSelectArray.remove(at: self.depSelectArray.index(of: model)!)
            return
        }
        let array = self.allDepArray.filter({ (dModel) -> Bool in
            return dModel.id == model.parentid
        })
        if array.count > 0 {
            let pModel = array.first
            self.removeParent(model: pModel!)
        }
        
    }
    
    
    
    /// 对当前部门子集做选中操作
    func fitterParentSelectAdd(cModel:DepModel){
        if cModel.top == "1" {
            return
        }
        if self.isAllDepAndMember(cModel: cModel) {
            self.removeCurrent(cModel: cModel)
            self.depSelectArray.append(cModel)
            
            let array = self.allDepArray.filter { (model) -> Bool in
                return model.id == cModel.parentid
            }
            if array.count > 0 {
                self.fitterParentSelectAdd(cModel: array.first!)
            }
            
        }

    }
    
    
    /// 删除当前子集及人员的选中
    ///
    /// - Parameter cModel: 父类model
    func removeCurrent(cModel:DepModel){
        
        let depArray = self.allDepArray.filter { (model) -> Bool in
            return model.parentid == cModel.id
        }
        self.depSelectArray = self.depSelectArray.filter { (model) -> Bool in
            return !depArray.contains(model)
        }
        let mArray = cModel.member
        self.memberSelectArray = self.memberSelectArray.filter({ (model) -> Bool in
            return !mArray.contains(model)
        })
        
        
    }
    
    
    
    
    /// 判断当前部门的子集部门和人员是否都选中
    ///
    /// - Returns: 返回是否都选中
    func isAllDepAndMember(cModel:DepModel)->(Bool){
        
        let depArray = self.allDepArray.filter { (model) -> Bool in
            return model.parentid == cModel.id
        }
        for dModel in depArray {
            if !self.depSelectArray.contains(dModel) {
                return false
            }
        }
        let mArray = cModel.member
        for mModel in mArray {
            if !self.memberSelectArray.contains(mModel) {
                return false
            }
        }
        return true
        
    }
    
    
    
    /// 是否都不包涵
    ///
    /// - Parameter cModel: <#cModel description#>
    /// - Returns: <#return value description#>
    func isAllNoDepAndMember(cModel:DepModel)->(Bool){
        
        let depArray = self.allDepArray.filter { (model) -> Bool in
            return model.parentid == cModel.id
        }
        for dModel in depArray {
            if self.depSelectArray.contains(dModel) {
                return false
            }
        }
        let mArray = cModel.member
        for mModel in mArray {
            if self.memberSelectArray.contains(mModel) {
                return false
            }
        }
        return true
    }
    
    
    
    func isSelectParent(cModel:DepModel)->(Bool){
        
        

        if self.depSelectArray.contains(cModel) {
            return true
        }else{
            
            if cModel.top == "1"{
                return false
            }
            
            let array = self.allDepArray.filter { (model) -> Bool in
                return model.id == cModel.parentid
            }
            if array.count > 0 {
               return self.isSelectParent(cModel: array.first!)
            }else{
                return false
            }
        }
    }
    
    
    
    
    
    @objc override func backBtnClick() {
        
        if self.cDepModel?.top == "1" {
            self.resultArray(self.depSelectArray,self.memberSelectArray);
            self.navigationController?.popViewController(animated: true)
        }else{
            
            let array = self.allDepArray.filter({ (dModel) -> Bool in
                return dModel.id == self.cDepModel?.parentid
            })
            if array.count > 0 {
                self.cDepModel = array.first
                self.configCurrentData()
                self.table.reloadData()
            }
        
        }
        
    }
    
    

}
