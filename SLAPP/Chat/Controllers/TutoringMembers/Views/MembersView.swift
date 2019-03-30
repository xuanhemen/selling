//
//  MembersView.swift
//  SLAPP
//
//  Created by apple on 2018/3/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit


class MembersView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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

            return array.joined(separator: ",") as String
        }else{
            return ""
        }
    }
    
    
    func configAlReady(array:Array<MemberModel>){
        self.dataArray = array
        self.dataArray += self.baseArray
        self.collectionView.reloadData()
        self.refreshHeight()
    }
    
    
    
    var cuttrntHeight:(CGFloat)->() = {_ in
    
        
    }
    
    //点击添加
    var clickAdd:()->() = {
        
    }
    
    
    //刷新高度
    func refreshHeight()->(CGFloat){
        let num = (self.dataArray.count-1)/5
        let height = (num+1)*80 + (num+2)*5 + 40
        self.cuttrntHeight(CGFloat(height))
        
        return CGFloat(height)<120.0 ? 120.0 :CGFloat(height)
    }
    
    lazy var baseArray:Array<MemberModel> = { () -> Array<MemberModel> in
        var array = Array<MemberModel>()
        let model = MemberModel.init()
        model.name = "增加"
        model.id = "+"
        model.head = "+"
        array.append(model)
        
        let modelm = MemberModel.init()
        modelm.name = "删除"
        modelm.id = "-"
        modelm.head = "-"
        array.append(modelm)
        return array
    }()
    
    var dataArray = Array<MemberModel>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.congfigUI()
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.dataArray += self.baseArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func congfigUI(){
        self.addSubview(nameLable)
        self.addSubview(collectionView)
        nameLable.text = "选择成员"
        nameLable.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
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
            self.endDelete()
            self.clickAdd()
        }else if model.id == "-"{
            self.isDelete = !self.isDelete
            collectionView.reloadData()
        }else{
            if isDelete == true {
            self.dataArray.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
            self.refreshHeight()
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
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MembersCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MembersCell
        cell.congfigModel(model: self.dataArray[indexPath.row])
        
        if cell.model?.id! == "+" || cell.model?.id! == "-"{
            cell.markImage.isHidden = true
            if cell.model?.id == "-" && self.isDelete == true {
                cell.headImage.image = UIImage.init(named: "deleteSure")
            }
        }
        else{
            cell.markImage.isHidden = !self.isDelete
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: cellWidth, height: 80)
    }
    
    
    lazy var collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.register(MembersCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
}
