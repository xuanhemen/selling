//
//  ContactSingleView.swift
//  SLAPP
//
//  Created by rms on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ContactSingleView: UIView {
    var coverBtn : UIButton!
    var coverBtnClickBlock : ((_ contactId: String?) -> ())?
    var modelDic : Dictionary<String,Any>!
    convenience init(modelDic : Dictionary<String,Any>, frame : CGRect) {
        self.init()
        self.frame = frame
        self.modelDic = modelDic
        let imageV = UIImageView.init(frame: CGRect.init(x: 15, y: 15, width: frame.size.width -  30, height: frame.size.width - 30))
        imageV.layer.cornerRadius = imageV.frame.size.width * 0.5
        imageV.layer.masksToBounds = true
        imageV.sd_setImage(with: NSURL.init(string:modelDic["imgurl"] as! String + imageSuffix)! as URL, placeholderImage: UIImage.init(named: "ch_protrait_green"))
        self.addSubview(imageV)
        let nameLb = UILabel.init(frame: CGRect.init(x: 0, y: frame.size.width, width: frame.size.width, height: frame.size.height - frame.size.width))
        nameLb.textColor = UIColor.black
        nameLb.textAlignment = .center
        nameLb.font = kFont_Middle
        nameLb.text = modelDic["name"] is String ? modelDic["name"] as! String : ""
        self.addSubview(nameLb)
        
        coverBtn = UIButton.init(frame: self.bounds)
        coverBtn.addTarget(self, action: #selector(coverBtnClick), for: .touchUpInside)
        coverBtn.backgroundColor = UIColor.clear
        self.addSubview(coverBtn)
    }
    @objc func coverBtnClick(btn: UIButton){
        
        if self.coverBtnClickBlock != nil{
            self.coverBtnClickBlock!(modelDic["id"] is String ? modelDic["id"] as! String : "")
        }
    }
}
