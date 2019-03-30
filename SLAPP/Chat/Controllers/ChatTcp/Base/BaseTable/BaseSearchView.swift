//
//  BaseSearchView.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/10.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
let itemWidth:CGFloat = 35
let itemSpace:CGFloat = 10
@objc protocol BaseSearchViewDelegate {
    
    /// 删除展示项目的代理
    ///
    /// - Parameter item: 删除的对象
    func searchDeleteItem(item:RLMObject)
    
    
    
    /// 搜索框的值发生变化
    ///
    /// - Parameter nowText: 当前搜索框的值
    func searchBarTextChangedWith(nowText:String)
    
    @objc optional func searchBarSearchButtonClicked(nowText:String)
}

class BaseSearchView: UIView {

    
   weak var delegate:BaseSearchViewDelegate?
    
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var collectWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isShowCollectionView:Bool?
    
    
    var dataArray:Array<RLMObject>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.searchView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "backGray")!)
        self.searchView.placeholder = "搜索"
          self.searchView.setBackgroundImage(UIImage.init(named: "backGray")!, for: .any, barMetrics: .default)
        
//        searchView.inputAccessoryView?.backgroundColor = UIColor.groupTableViewBackground
        dataArray = Array.init()
        searchView.delegate = self
        
            }
    
    
    /// 配置数据
    ///
    /// - Parameter array: 要展示的数据
    public func configWithDataArray(array:Array<RLMObject>)
    {
        guard self.isShowCollectionView == true else {
            return
        }
        dataArray = array
        self.collectionView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "backGray")!)
        self.refreshLayout()
        self.collectionView .reloadData()
    }
    
    
    

}

extension BaseSearchView{

    
    
    /// 配置collectionView
   public func configCollectionViewWith(isShowCollect:Bool)
    {
        isShowCollectionView = isShowCollect
        guard isShowCollect == true else {
            return
        }
        self.collectWidth.constant = 0.1
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.itemSize = CGSize.init(width: 30, height: 30)
        layout.scrollDirection = .horizontal;
        layout.minimumLineSpacing = itemSpace;
        //      layout.UICollectionViewDelegateFlowLayout = self
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    
        
    
    
    /// 更新layout
    fileprivate func refreshLayout()
    {
        if self.dataArray?.count == 0 {
            self.collectWidth.constant = 0
        }
        else
        {
            if ((self.dataArray?.count)!*Int(itemSpace+itemWidth)+100) <= Int(kScreenW){
                self.collectWidth.constant = CGFloat((self.dataArray?.count)!*Int(itemSpace+itemWidth))

            }
            else
            {
               self.collectWidth.constant = kScreenW-100
            }
        }
    }
    
}


//MARK: - ---------------------collectionView代理----------------------
extension BaseSearchView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        //临时处理  应该自定义cell
                for view in cell.subviews {
                    if view is UIImageView {
                        view .removeFromSuperview()
                    }
                }
        
        let image = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        let model = dataArray?[indexPath.row]
        if model is FriendsModel {
            let fModel  = model as! FriendsModel
            if !fModel.avater.isEmpty {
                
                image.sd_setImage(with: NSURL.init(string: fModel.avater) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
            }
            else
            {
                image.image = UIImage.init(named: "mine_avatar")
            }
        }
        else if (model is GroupUserModel){
            let fModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", (model as! GroupUserModel).userid)).firstObject() as! UserModelTcp?
            if fModel?.avater != nil {
                image.sd_setImage(with: NSURL.init(string: (fModel?.avater)!) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
            }
            else
            {
                image.image = UIImage.init(named: "mine_avatar")
            }
        }else if (model is GroupModel){
            let fModel  = model as! GroupModel
            if !fModel.icon_url.isEmpty {
                image.sd_setImage(with: NSURL.init(string: fModel.icon_url) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
            }
            else
            {
                image.image = UIImage.init(named: "mine_avatar")
            }
        }
        
        cell.addSubview(image)
        
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard indexPath.row<(self.dataArray?.count)! else {
            return
        }
        let item = self.dataArray?[indexPath.row]
        delegate?.searchDeleteItem(item: item!)
        self.dataArray?.remove(at: indexPath.row)
        self.refreshLayout()
        self.collectionView.reloadData()
        
    }
}



//MARK: - ---------------------搜索框代理方法----------------------
extension BaseSearchView:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        delegate?.searchBarTextChangedWith(nowText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchBarSearchButtonClicked!(nowText: searchBar.text!)
    }
}
