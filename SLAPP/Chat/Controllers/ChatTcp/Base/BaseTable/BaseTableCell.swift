//
//  BaseTableCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/13.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm

@objc protocol BaseCellDelegate {
    func cellRightBtnClick(model:RLMObject)
}
class BaseTableCell: UITableViewCell {
    
   weak var delegate:BaseCellDelegate?
    
    @IBOutlet weak var imageLeftSpace: NSLayoutConstraint!

    @IBAction func BtnClick(_ sender: UIButton) {
        
        delegate?.cellRightBtnClick(model: self.model!)
    }
    @IBOutlet weak var rightBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var desLable: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var selectImage: UIImageView!
    
    var model:RLMObject?
    {
        didSet{
            
            if model is FriendsModel {
               let fModel  = model as! FriendsModel
               desLable.text = fModel.realname
                rightBtn.isHidden = true
//               rightBtnWidth.constant = 60
//               rightBtn.layer.borderWidth = 0.5
//               rightBtn.layer.cornerRadius = 6
//                rightBtn.clipsToBounds = true
//                rightBtn.titleLabel?.font = FONT_14
//                rightBtn.isEnabled = false
//                if fModel.type == 1 {
//                   rightBtn.layer.borderColor = UIColor.orange.cgColor
//                   rightBtn.setTitleColor(UIColor.orange, for: .normal)
//                   rightBtn.setTitle("互粉", for: .normal)
//                }
//                else if fModel.type == 2
//                {
//                    rightBtn.layer.borderColor = UIColor.hexString(hexString: "7bbb28").cgColor
//                    rightBtn.setTitleColor(UIColor.hexString(hexString: "7bbb28"), for: .normal)
//                   rightBtn.setTitle("粉丝", for: .normal)
//                }
//                else if fModel.type == 3 || fModel.type == 4
//                {
//                    rightBtn.layer.borderColor = UIColor.hexString(hexString: "7bbb28").cgColor
//                    rightBtn.setTitleColor(UIColor.hexString(hexString: "7bbb28"), for: .normal)
//                    rightBtn.setTitle("陌生人", for: .normal)
//                }
                self.cycleStyle(isCycle: true)
                if !fModel.avater.isEmpty {
                   iconImage.sd_setImage(with: NSURL.init(string: fModel.avater) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
                }
                else
                {
                     iconImage.image = UIImage.init(named: "mine_avatar")
                }
                
                

            }
            else if model is GroupUserModel{
                
                 self.cycleStyle(isCycle: true)
                let fModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", (model as! GroupUserModel).userid)).firstObject() as! UserModelTcp?

                desLable.text = fModel?.realname
                if fModel?.avater != nil {
                    iconImage.sd_setImage(with: NSURL.init(string: (fModel?.avater)!) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
                }
                else
                {
                    iconImage.image = UIImage.init(named: "mine_avatar")
                }
               
                rightBtn.isHidden = true
            }
            else if model is GroupModel {

                self.cycleStyle(isCycle: false)
                selectImage.isHidden = true
                self.imageLeftSpace.constant = -20
                
                
                
                
                
                
                
                
                let gModel = model as! GroupModel
                
//                let predicate = NSPredicate(format:"userid == %@ AND groupid == %@  AND is_delete == '0'", sharePublicDataSingle.publicData.userid,gModel.groupid)
//                
//                let results = GroupUserModel.objects(with: predicate)
                
                self.rightBtn.setTitleColor(UIColor.white, for: .normal)
                self.rightBtn.backgroundColor = UIColor.hexString(hexString: "166AD9")
                
//                if results.count == 0 {
//                    self.rightBtn.setTitleColor(UIColor.white, for: .normal)
//                    self.rightBtn.backgroundColor = UIColor.hexString(hexString: "166AD9")
//                    self.rightBtn.setTitle("申请加入", for: .normal)
//                }
//                else{
//                
//                    self.rightBtn.setTitleColor(UIColor.lightGray, for: .normal)
//                    self.rightBtn.backgroundColor = UIColor.white
//                    self.rightBtn.setTitle("已加入", for: .normal)
//                    self.rightBtn.isEnabled = false
//                }
                
                
                
                
                if !gModel.group_name.isEmpty {
                    
                let num = gModel.user_num.isEmpty ? "0" : gModel.user_num
                   desLable.text = String.init(format: "%@(%@)", gModel.group_name,num)
                }
               
               iconImage.image = UIImage.init(named: "mine_avatar")
                
                if !gModel.icon_url.isEmpty {
                    iconImage.sd_setImage(with: NSURL.init(string: gModel.icon_url) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
                }
                else
                {
                    iconImage.image = UIImage.init(named: "mine_avatar")
                }
               
                
            }
        }
    
    }
    
    func hidenChooseIcon(hiden:Bool){
    
        if hiden == true {
            selectImage.isHidden = true
            self.imageLeftSpace.constant = -20
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
//        iconImage.layer.cornerRadius = iconImage.bounds.size.width/2.0
        
    }

    
    func cycleStyle(isCycle:Bool){
        
        if isCycle == true {
            iconImage.layer.cornerRadius = 15

        }
        else{
           iconImage.layer.cornerRadius = 4
        }
        iconImage.layer.borderWidth = 0.3
        iconImage.layer.borderColor = UIColor.lightGray.cgColor
        iconImage.clipsToBounds = true
        
    }
    
    
    
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//         super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
