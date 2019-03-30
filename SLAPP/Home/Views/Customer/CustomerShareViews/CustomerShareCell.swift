//
//  CustomerShareCell.swift
//  SLAPP
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CustomerShareCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //数据源
    @objc var dataArray = Array<Dictionary<String,Array<BaseModel>>>()
 
    /// 返回当前的高度
    @objc var frameHeightChanged:(_ height:CGFloat)->() = {_ in
        
    }
    
//    返回结果
    func resultParams()->(all:String, dep:String, mem:String){
        
        if nameLable.myTag == 0 {
            //我自己
            return ("0","","")
        }else if nameLable.myTag == 1 {
            return ("1","","")
        }else{
            
            if UserModel.getUserModel().ismanager != "1" {
                return ("0",UserModel.getUserModel().depId ?? "","")
                
            }
            
            
            var dep = Array<String>()
            var m = Array<String>()
            if self.dataArray.count > 0 {
                for dic in self.dataArray{
                    if dic.keys.first == "dep"{
                        dep = (dic.values.first?.map({ (model) -> String in
                            let dModel:DepModel = model as! DepModel
                            return dModel.id
                        }))!
                    }else{
                        m = (dic.values.first?.map({ (model) -> String in
                            let dModel:DepMemberModel = model as! DepMemberModel
                            return dModel.id
                        }))!
                    }
                }
            }
            return ("0",dep.joined(separator: ","),m.joined(separator: ","))
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = false
    }
    
    
    func configData(array:Array<Dictionary<String,Array<BaseModel>>>?){
        if array != nil {
            self.dataArray = array!
            
        }
        self.configHeight()
        collectionView.reloadData()
    }

    //计算高度
    func configHeight(){
        
        if nameLable.myTag != 2 {
            self.frameHeightChanged(170)
            return
        }
        
        if self.dataArray.count > 0 {
            var height:CGFloat = 170
            for dic in self.dataArray {
                height += 40
                height += CGFloat((((dic.values.first?.count)!-1)/3 + 1) * 40)
            }
            self.frameHeightChanged(height)
        }else{
            self.frameHeightChanged(170)
        }
        
    }
    
    
    
    func configUI(){
        self.contentView.addSubview(nameLable)
        nameLable.editClick = { [weak self] in
            if self?.nameLable.myTag == 2 {
                let vc = DistributionDepAndMemberVC();
                if self?.dataArray.count != 0 {
                    
                    vc.aReadyArray = (self?.dataArray)!
                    
                }
                vc.resultArray = {[weak self] (d,m) in
                    
                    var array = Array<Dictionary<String,Array<BaseModel>>>()
                    if d.count > 0 {
                        array.append(["dep":d])
                    }
                    if m.count > 0 {
                        array.append(["mem":m])
                    }
                    self?.configData(array: array)
                }
                
                
                PublicMethod.appCurrentViewController().navigationController?.pushViewController(vc, animated: true)
            }
        }
        nameLable.selectChange = { [weak self](isSelect) in
            self?.configHeight()
            
            if isSelect == false {
                return
            }
            
            
            if self?.nameLable.myTag == 2 {
                if self?.dataArray.count != 0 {
                    return
                }
                
                let vc = DistributionDepAndMemberVC();
                
                vc.resultArray = {[weak self] (d,m) in
                    
                    var array = Array<Dictionary<String,Array<BaseModel>>>()
                    if d.count > 0 {
                        array.append(["dep":d])
                    }
                    if m.count > 0 {
                        array.append(["mem":m])
                    }
                    self?.configData(array: array)
                }
                
                
                PublicMethod.appCurrentViewController().navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        
        
        self.contentView.addSubview(self.collectionView)
        nameLable.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(170)
        }
        
        
        collectionView.backgroundColor = UIColor.white
        collectionView.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.nameLable.snp.bottom)!)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
        }
        collectionView.register(ProMemberCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 40)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header:CollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CollectionHeaderView
        let dic = self.dataArray[indexPath.section]
        if dic.keys.first == "dep" {
            header.nameLable.text = "部门";
        }else{
            header.nameLable.text = "人员";
        }
        
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dic = self.dataArray[section]
       
        return (dic.values.first?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell:ProMemberCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProMemberCell
        cell.deleteBtn.isHidden = true
        cell.markImage.isHidden = true
        let dic = self.dataArray[indexPath.section]
        if dic.keys.first == "dep" {
            //部门
            let dArray = dic.values.first
            let dModel:DepModel = dArray![indexPath.row] as! DepModel
            cell.nameLable.text = dModel.name
            cell.headImage.image = #imageLiteral(resourceName: "qf_depImage")
        }else{
           //人员
            let mArray = dic.values.first
            let mModel:DepMemberModel = mArray![indexPath.row] as! DepMemberModel
            cell.nameLable.text = mModel.realname
            cell.headImage.sd_setImage(with: URL.init(string: (mModel.head) + imageSuffix), placeholderImage: UIImage.init(named: "mine_avatar"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: memberCellWidth-10, height: 30)
    }
    
    
    lazy var collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    
    
    
    
    
    
    
    
    
    
    
    lazy var nameLable = { () -> CustomerBottomSelectView in
        let lable = CustomerBottomSelectView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 170))
//        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
