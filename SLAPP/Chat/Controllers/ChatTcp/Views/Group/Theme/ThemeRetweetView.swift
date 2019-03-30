//
//  ThemeRetweetView.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/6/26.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
// 代理
protocol ThemeRetweetViewDelegate :NSObjectProtocol{
    // 点击菜单
    func selectButtonDidClick(btn:UIButton)
}

class ThemeRetweetView: UIView {
    var delegate: ThemeRetweetViewDelegate?
    var selectedBtn : UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(iconButton)
//        self.addSubview(nameLabel)
        
        iconButton.mas_makeConstraints { (make) in
            make!.left.equalTo()(LEFT_PADDING)
//            make!.size.equalTo()(CGSize(width: 35, height: 35))
            make!.top.bottom().equalTo()(0)
            make!.right.equalTo()(-LEFT_PADDING)

        }
//        nameLabel.mas_makeConstraints { [unowned self](make) in
//            make!.left.equalTo()(self.iconButton.mas_right)!.offset()(5)
//            make!.centerY.equalTo()(self)
//            make!.right.equalTo()(-LEFT_PADDING)
//        }

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //选择状态icon
    lazy var iconButton: UIButton = {
        var iconButton = UIButton.init()
        iconButton.contentHorizontalAlignment = .left
        iconButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//        iconButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 30)
        iconButton.addTarget(self, action: #selector(selectButtonClick(btn:)), for: .touchUpInside)
        iconButton.setImage(UIImage.init(named: "logic_normal"), for: .normal)
        iconButton.setImage(UIImage.init(named: "logic_select"), for: .selected)
        iconButton.setTitleColor(UIColor.black, for: .normal)
        iconButton.titleLabel?.font = FONT_14
        return iconButton
    }()
    //名称
    lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = FONT_14
        nameLabel.textColor = UIColor.black
        return nameLabel
    }()

}
extension ThemeRetweetView {
    
    @objc func selectButtonClick(btn:UIButton){
        delegate?.selectButtonDidClick(btn: btn)
    }
}
