//
//  GroupSettingTableViewHeader.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/9.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

@objc protocol GroupSettingTableViewHeaderDelegate {
    //点击成员头像
    func userItemDidClick(userId:String)
    //点击添加按钮
    func addBtnDidClick()
    //点击删除按钮
    func delBtnDidClick()
}
class GroupSettingTableViewHeader: UICollectionView {

    var users : Array<GroupUserModel> = Array()
    var isAllowedInviteMember : Bool!
    var isAllowedDeleteMember : Bool!
  weak var myDelegate : GroupSettingTableViewHeaderDelegate?
    
    convenience init() {
        let flowlayout = UICollectionViewFlowLayout.init()
        flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical

        self.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 56), collectionViewLayout: flowlayout)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.register(GroupSettingTableViewHeaderItem.self, forCellWithReuseIdentifier: "GroupSettingTableViewHeaderItem")
        
        isAllowedInviteMember = true
        isAllowedDeleteMember = false
    }

}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension GroupSettingTableViewHeader: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (MAIN_SCREEN_WIDTH - (MAIN_SCREEN_WIDTH < 375 ? 100 : CGFloat(kReal(value: 100)))) / 4, height: (MAIN_SCREEN_WIDTH - (MAIN_SCREEN_WIDTH < 375 ? 100 : CGFloat(kReal(value: 100)))) / 4 + 25)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout : UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 20
        return UIEdgeInsetsMake(15, MAIN_SCREEN_WIDTH < 375 ? 20 : CGFloat(kReal(value: 20)), 15, MAIN_SCREEN_WIDTH < 375 ? 20 : CGFloat(kReal(value: 20)))
    }
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isAllowedDeleteMember! {
            return users.count + 2;
        } else {
            if isAllowedInviteMember! {
                return users.count + 1;
            } else {
                return users.count;
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GroupSettingTableViewHeaderItem = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupSettingTableViewHeaderItem", for: indexPath) as! GroupSettingTableViewHeaderItem
        if users.count != 0 && (users.count - 1 >= indexPath.row) {
            
            cell.model = users[indexPath.row]
            
            cell.avatarImgV.sd_setImage(with: NSURL.init(string: (cell.model?.avater)!) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
            cell.avatarImgV.layer.borderWidth = 0.5
        }else if users.count >= indexPath.row {
            //添加
            cell.model = nil
            cell.avatarImgV.image = UIImage.init(named: "addMember_normal")
            cell.avatarImgV.layer.borderWidth = 0.0
        }else{
            //删除
            cell.model = nil
            cell.avatarImgV.image = UIImage.init(named: "subtractMember_normal")
            cell.avatarImgV.layer.borderWidth = 0.0
        }
        return cell
    }
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if users.count != 0 && (users.count + 1 == indexPath.row) {
            myDelegate?.delBtnDidClick()
        }else if users.count == indexPath.row{
            myDelegate?.addBtnDidClick()
        }else{
            let model = users[indexPath.row]
            myDelegate?.userItemDidClick(userId: model.userid)
        }
        
    }
   }
