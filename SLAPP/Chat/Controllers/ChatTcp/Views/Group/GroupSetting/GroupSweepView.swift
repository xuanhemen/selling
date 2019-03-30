//
//  GroupSweepView.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/23.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class GroupSweepView: UIView {

  class func initWithImage(url:String)->(GroupSweepView)
    {
       let view = GroupSweepView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT, width: kScreenW, height: kScreenH-NAV_HEIGHT))
       view.backgroundColor = UIColor.white
       let lable = UILabel.init(frame: CGRect.init(x: 20, y: 20, width: kScreenW-40, height: 40))
        lable.text = "由于您所在的企业内没有其他成员，所以只能通过邀请好友扫描以下二维码加入该群组。"
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.textColor = UIColor.lightGray
        lable.numberOfLines = 0
       let image = UIImageView.init(frame: CGRect.init(x: 20, y: 80, width: kScreenW-40, height: kScreenW-40))
         view.addSubview(image)
       image.sd_setImage(with: NSURL.init(string: url) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
       
       view.addSubview(lable)
       return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
