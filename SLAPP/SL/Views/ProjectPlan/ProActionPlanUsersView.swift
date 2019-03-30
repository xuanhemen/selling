//
//  ProActionPlanUsersView.swift
//  SLAPP
//
//  Created by apple on 2018/4/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProActionPlanUsersView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var cellAuth:String = "1"
    var click:(String)->() = {_ in
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.congfigUI()
        self.dataArray += self.baseArray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var isDelete:Bool = false
    
    //当前人员
    func currentMember()->(Array<MemberModel>){
        return self.dataArray.filter { (model) -> Bool in
            return !(model.id == "+" || model.id == "-" )
        }
    }
    
    
    //返回添加的人员的id  [id]
    func resultIds()->(Array<String>){
        let array = self.currentMember()
        return array.map({ (model) -> String in
            return model.id!
        })
    }
    
    
    //以，隔开的参与人员
    func resultIdStr()->(String){
        let array = self.resultIds()
        if array.count > 0 {
            if array.count == 1 {
                return array.first!
            }
            //            DLog(array.joined(separator: ",") as String)
            return array.joined(separator: ",") as String
        }else{
            return ""
        }
    }
    
    
    //联系人id  添加计划时候用
    func contactIds()->(Array<String>){
        let array = self.currentMember()
        return array.map({ (model) -> String in
            return model.pid ?? model.id!
        })
    }
    
    //联系人id 添加计划时候用
    func contactIdsStr()->(String){
        let array = self.contactIds()
        if array.count > 0 {
            if array.count == 1 {
                return array.first!
            }
            //            DLog(array.joined(separator: ",") as String)
            return array.joined(separator: ",") as String
        }else{
            return ""
        }
    }
    
    
    
    func configAlReady(array:Array<MemberModel>){
        self.dataArray = array
        if cellAuth == "1"  {
            self.dataArray += self.baseArray
        }
        self.collectionView.reloadData()
        
        
        //        self.refreshHeight()
    }
    
    
    
    var cuttrntHeight:(CGFloat)->() = {_  in
        
        
    }
    
    var currentHeightWithDelete:(CGFloat)->() = {_ in
        
        
    }
    
    //点击添加
    var clickAdd:()->() = {
        
    }
    
    
    //刷新高度
    func refreshHeight()->(CGFloat){
        let num = (self.dataArray.count-1)/3
        let height = (num+1)*30 + (num+2)*5 + 30
        let result = CGFloat(height)<70.0 ? 70.0 :CGFloat(height)
        self.cuttrntHeight(CGFloat(result))
        return result
    }
    
    lazy var baseArray:Array<MemberModel> = { () -> Array<MemberModel> in
        var array = Array<MemberModel>()
        let model = MemberModel.init()
        model.name = "增加"
        model.id = "+"
        model.head = "+"
        array.append(model)
        return array
    }()
    
    var dataArray = Array<MemberModel>()
    
    func congfigUI(){
        self.addSubview(nameLable)
        self.addSubview(collectionView)
        nameLable.text = "选择成员"
        nameLable.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(30)
        }
        
        collectionView.backgroundColor = UIColor.white
        collectionView.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.nameLable.snp.bottom)!)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = self.dataArray[indexPath.row]
        if model.id == "+" {
            //            self.click("-")
        }else{
            if isDelete == true {
                self.dataArray.remove(at: indexPath.row)
                self.collectionView.deleteItems(at: [indexPath])
                self.click("other")
            }
        }
        
    }
    
    
    func endDelete(){
        if self.isDelete == true {
            self.isDelete = false
            collectionView.reloadData()
            return
        }
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsetsMake(0, 5, 5, 5);
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProMemberCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProMemberCell
        cell.configWithModel(model: self.dataArray[indexPath.row])
        cell.click = {[weak self] (str) in
            if str == "-" {
                self?.isDelete = !(self?.isDelete)!
                self?.collectionView.reloadData()
            }else{
                self?.isDelete = false
                self?.collectionView.reloadData()
                self?.toChangeStatus(str: str)
            }
            
        }
        
        //删除标记
        if cell.model?.id! == "+"{
            cell.markImage.isHidden = true
        }
        else{
            cell.markImage.isHidden = !self.isDelete
        }
        if self.isDelete == true {
            //是在删除的操作的情况下   变成确认按钮
            cell.deleteBtn.setImage(UIImage.init(named: "deleteSure"), for: .normal)
        }else{
            cell.deleteBtn.setImage(UIImage.init(named: "memberDelete"), for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: memberCellWidth, height: 30)
    }
    
    
    lazy var collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.register(ProMemberCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    func toChangeStatus(str:String){
        self.click(str)
    }
    
    
}
