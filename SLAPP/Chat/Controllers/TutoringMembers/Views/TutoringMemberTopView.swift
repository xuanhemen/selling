//
//  TutoringMemberTopView.swift
//  SLAPP
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class TutoringMemberTopView: UIView,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var type:membersType?{
        
        didSet{
            if type == .single {
                self.collectionView.snp.updateConstraints({ (make) in
                    make.width.equalTo(0)
                })
            }
        }
        
    }
    var dataArray = Array<MemberModel>()
    //删除回调
    var removeSelect:(_ model:MemberModel)->() = {_ in 
        
    }
    
    func topChangeWithModel(model:MemberModel,isAdd:Bool){
        
        if self.type == .single {
            return
        }
        if isAdd {
            self.dataArray.append(model)
           
            self.collectionView.insertItems(at: [IndexPath.init(row: self.dataArray.count-1, section: 0)])
        }else{
            
            let index = self.dataArray.index(where: { (myModel) -> Bool in
                if (model.id == myModel.id){
                    return true
                }
                return false
            })
            self.dataArray.remove(at: index!)
            self.collectionView.deleteItems(at: [IndexPath.init(row: index!, section: 0)])
            
        }
        refresh()
    }
    
    func refresh(){
        
        var width = CGFloat(dataArray.count * 40)
        if width != 0 {
            width += CGFloat(dataArray.count+1) * 5
        }
        width = width > MAIN_SCREEN_WIDTH - 160 ? MAIN_SCREEN_WIDTH - 160 :width
        collectionView.snp.updateConstraints { (make) in
            make.width.equalTo(width)
        }
        
    }
    
    
    
    lazy var searchView = { () -> UISearchBar in
        let search = UISearchBar()
        search.setBackgroundImage(UIImage.init(named: "backWhite")!, for: .any, barMetrics: .default)
        return search
    }()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.removeSelect(self.dataArray[indexPath.row] as! MemberModel)
        self.dataArray.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
        refresh()
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
        let cell:TutoringTopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutoringTopCell
        cell.congfigModel(model: self.dataArray[indexPath.row] as! MemberModel)
//        cell.contentView.backgroundColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 40, height: 40)
    }
    
    
    lazy var collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.register(TutoringTopCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        self.addSubview(collectionView)
        self.addSubview(searchView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(0)
            make.height.equalTo(50)
            make.bottom.equalTo(0)
        }
        
        searchView.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo(0)
            make.left.equalTo((self?.collectionView.snp.right)!)
            make.right.equalTo(0)
            make.height.equalTo(50)
            make.bottom.equalTo(0)
        }
        
        searchView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
}
