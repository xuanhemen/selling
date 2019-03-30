//
//  ThemeListCellBottomView.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/6/7.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
private let separateLineViewWidth : CGFloat = 0.5
// 代理
protocol ThemeListCellBottomViewDelegate :NSObjectProtocol{
    // 点击菜单
    func menuBtnDidClick(btn:UIButton)
}

class ThemeListCellBottomView: UIView {
    var delegate: ThemeListCellBottomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatBtnsWithTitleImage(btnTitleImages:Array<Array<String>>){
        for i in 0..<btnTitleImages.count {
            let btn = UIButton.init()
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btn.setTitleColor(UIColor.lightGray, for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.titleLabel?.font = FONT_12
            btn.setTitle(btnTitleImages[i][0], for: .normal)
            btn.setImage(UIImage.init(named: btnTitleImages[i][1]), for: .normal)
            self.addSubview(btn)
            btn.mas_makeConstraints { [unowned self](make) in
                make!.top.equalTo()(self)
                make!.left.equalTo()((SCREEN_WIDTH - CGFloat(btnTitleImages.count - 1) * separateLineViewWidth) / CGFloat(btnTitleImages.count) * CGFloat(i) + CGFloat(i) * separateLineViewWidth)
                make!.height.equalTo()(self)
                make!.width.equalTo()((SCREEN_WIDTH - CGFloat(btnTitleImages.count - 1) * separateLineViewWidth) / CGFloat(btnTitleImages.count))
            }
            if i < btnTitleImages.count - 1 {
                let separateLineView = UIView.init()
                separateLineView.backgroundColor = UIColor.lightGray
                self.addSubview(separateLineView)
                separateLineView.mas_makeConstraints { (make) in
                    make!.left.equalTo()(btn.mas_right)
                    make!.top.equalTo()(8)
                    make!.bottom.equalTo()(-8)
                    make!.width.equalTo()(separateLineViewWidth)
                }
            }
        }
    }
}

extension ThemeListCellBottomView {

    @objc func btnClick(btn:UIButton){
    
        delegate?.menuBtnDidClick(btn: btn)
    }
}
