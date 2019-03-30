//
//  ProSituationMemberCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
let memberCellWidth = (MAIN_SCREEN_WIDTH-50)/3
public enum memberStyle : Int {
    case patter //参与
    case observer //观察
    case contacts //联系
}

class ProSituationMemberCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var projectId:String?
    var type:memberStyle?
    var cellAuth:String = "1"
   @objc var click:(String)->() = {_ in
        
    }
    
    
    /// 0 参与   2 联系人
    ///
    /// - Parameter tag: <#tag description#>
  @objc  func configTypeWithTag(tag:Int){
        
        self.type = memberStyle.init(rawValue: tag)
    }
    
    var clickPeople:(_ pid:String,_ type:memberStyle?)->() = { _,_  in
        
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.congfigUI()
        self.dataArray += self.baseArray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
    }
    
    
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

    
  @objc  var isDelete:Bool = false
    
    //当前人员
   @objc func currentMember()->(Array<MemberModel>){
        return self.dataArray.filter { (model) -> Bool in
            return !(model.id == "+" || model.id == "-" )
        }
    }
    
    
    
    /// 以字典的形势返回当前的成员
    ///
    /// - Returns: <#return value description#>
    @objc func currentMemberWithDicType()->(Array<Dictionary<String,Any>>){
        let array = self.currentMember();
        return array.map({ (model) -> Dictionary<String,Any> in
            return ["id":model.id ?? "","name":model.name ?? ""]
        });
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
    
    
 @objc   func configAlReady(array:Array<MemberModel>){
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
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(collectionView)
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

        }else {
            if isDelete == true {
                self.dataArray.remove(at: indexPath.row)
                self.collectionView.deleteItems(at: [indexPath])
                self.click("other")
            }else{
                if model.id != "-"{
                    self.clickPeople(String.noNilStr(str: model.id),self.type)
                }
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
            self?.toChangeStatus(str: str)
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
    
    
 @objc   lazy var collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.register(ProMemberCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
  @objc  lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    func toChangeStatus(str:String){
        self.click(str)
    }
  
    @objc func refreshLayoutForVisit(){
//    nameLable.snp.makeConstraints { (make) in
//    make.top.equalToSuperview().offset(0)
//    make.left.equalToSuperview().offset(10)
//    make.right.equalToSuperview().offset(0)
//    make.height.equalTo(30)
//    }
        
        nameLable.snp.updateConstraints { (make) in
            make.height.equalTo(15)
        }
}
    
    
}
