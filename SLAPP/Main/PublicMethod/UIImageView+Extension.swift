//
//  UIImageView+Extension.swift
//  SLAPP
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import Foundation
extension UIImageView{
    
    func setImageWith(url:String,imageName:String){
        
//        self.kf.setImage(with:URL.init(string: url), placeholder:UIImage.init(named: imageName), options: nil, progressBlock: nil, completionHandler: nil)
        self.sd_setImage(with: NSURL.init(string: url.appending(imageSuffix)) as URL?, placeholderImage: UIImage.init(named: imageName))
    }
    
    func setHeadImage(url:String){
        self.setImageWith(url: url, imageName: "mine_avatar")
    }
}
