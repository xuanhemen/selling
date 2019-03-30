//
//  ProPlanDetailCell.swift
//  SLAPP
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProPlanDetailCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var dataArray = Array<MemberModel>()
    
    func setData(array:Array<MemberModel>) {
        self.dataArray = array
        self.collectionView.reloadData()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        self.backgroundColor = .clear
        
        let backView = UIView()
        backView.backgroundColor = .white
        self.contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.bottom.equalTo(0)
            make.right.equalTo(-10)
            
        }
        
        
        
        
        let label = UILabel()
        label.text = "客户对象："
        backView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.height.equalTo(30)
        }
        
        backView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(label.snp.right).offset(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
    }
    
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
            
        }
        cell.markImage.isHidden = true
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
