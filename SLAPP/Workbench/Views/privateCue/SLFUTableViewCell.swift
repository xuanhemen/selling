//
//  SLFUTableViewCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/5.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLFUTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSourcePrefetching {
    /**头像*/
    lazy var headImageView = UIImageView.init()
    /**发布人*/
    lazy var releaseName = UILabel()
    /**内容*/
    lazy var content = UILabel()
    /**图片数据源*/
    var imageArr = [SLFlollowUpFileModel]()
    /**用collectionView展示图片*/
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0;// 水平方向的间距
        flowLayout.minimumLineSpacing = 1; // 垂直方向的间距
        let collectionView = UICollectionView.init(frame:CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .blue
        collectionView.dataSource = self
        collectionView.delegate = self
        //if (iOS_VERSION!>=10) {
        collectionView.prefetchDataSource = self
        //}
        
        /*添加collectionview的headview
         collectionView.contentInset = UIEdgeInsetsMake(215*H, 0, 0, 0);
         */
        /*注册cell和headview，用不同标识符否则滑动collectionview的时候由于复用会导致数据错乱*/
        collectionView.register(SLCollectionImgCell.self, forCellWithReuseIdentifier: "collection")
        collectionView.register(SLMarkCollectionCell.self, forCellWithReuseIdentifier: "mark")
        collectionView.register(SLFUReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "head")
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in

            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.top.equalTo(content.snp.bottom).offset(10)
            make.height.equalTo((SCREEN_WIDTH-100-3)/3*2+100)
           // make.bottom.equalToSuperview().offset(-5)
        })
        return collectionView
    }()
    /**客户联系人*/
    lazy var contact = UILabel()
    /**跟进人*/
    lazy var followUpPerson = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        headImageView.backgroundColor = UIColor.purple
        self.addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        releaseName.text = "动力火车"
        self.addSubview(releaseName)
        releaseName.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(headImageView.snp.right).offset(10)
        }
        content.text = "今天我们就可以测试了，到底行不行就看着罢了。"
        content.numberOfLines = 0
        self.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.top.equalTo(releaseName.snp.bottom).offset(10)
            make.left.equalTo(headImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        self.collectionView.isHidden = false
        
       
        contact.text = "昨天上午10：00"
        contact.font = FONT_16
        contact.numberOfLines = 0
        contact.backgroundColor = UIColor.green
        self.addSubview(contact)
        contact.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom)
            make.left.equalTo(headImageView.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        for index in 0..<3 {
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.setTitle("删除", for: UIControlState.normal)
            btn.titleLabel?.font = FONT_14
            btn.setTitleColor(.red, for: UIControlState.normal)
        }
//        followUpPerson.text = "删除尽快答复大幅度发大幅度发地方地方大幅度发大幅度发"
//        followUpPerson.font = FONT_14
//        followUpPerson.backgroundColor = UIColor.green
//        self.addSubview(followUpPerson)
//        followUpPerson.snp.makeConstraints { (make) in
//            make.top.equalTo(self.collectionView.snp.bottom)
//            make.right.equalToSuperview().offset(-20)
//            make.width.equalTo(60)
//            make.bottom.equalToSuperview().offset(-10)
//        }
    }
    //MARK: - 代理函数
    /*返回secion个数*/
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    /*返回每个secion个数*/
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if section==0 {
            return 4
        }else{
            return 3
        }
       
    }
    /*设置item大小*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section==0{
           return CGSize(width: (SCREEN_WIDTH-100-3)/3, height:(SCREEN_WIDTH-100-3)/3)
        }else{
           return CGSize(width: (SCREEN_WIDTH-100-3)/3, height:30)
        }
        
    }
    /*创建collectionviewcell*/
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! SLCollectionImgCell
            cell.backgroundColor = UIColor.yellow
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mark", for: indexPath) as! SLMarkCollectionCell
            cell.mark.text = "标签"
            return cell
        }
        
    }
    /*设置每个section的headview大小*/
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section==1 {
            return CGSize(width: SCREEN_WIDTH, height: 70)
        }
        return CGSize(width: SCREEN_WIDTH, height: 0)
    }
    /*设置每个section的footview大小*/
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: 0, height: 0)
    }
    /*创建每个section的headview*/
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (indexPath.section == 1) {
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "head", for: indexPath) as! SLFUReusableView
            headView.backgroundColor = .white
            headView.contact.text = "客户联系人：常本与"
            headView.fuPerson.text = "跟进人：马云"
            return headView
        }else{
            let view = UIView()
            return view as! UICollectionReusableView
        }
        
    }
    /**跳转到专项列表*/
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])
    {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
