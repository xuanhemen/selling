//
//  MenuButton.swift
//  SLAPP
//
//  Created by 柴进 on 2018/3/22.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class MenuButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let backimg = UIImageView()
    let pImage = UIImageView()
    let pText = UILabel()
    let pPoint = UIImageView()
    let pState = UIImageView()
    var menuView = MenuListView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data:(String,String,String,Bool)) {
//        pImage.image = UIImage.init(named: "p_menu_sort_img")
        pText.text = data.1
        pPoint.image = UIImage.init(named: "p_menu_"+data.2)
    }
    
    func setFirst(data:(String,String)) {
        pImage.image = UIImage.init(named: data.0)
        pText.text = data.1
        if kScreenW == 320 {
            pText.font = kFont_Small
        }else{
            pText.font = kFont_Big
        }
    }
    
    func configUI(){
//        self.setImage(UIImage.init(named: "p_menu_button"), for: UIControlState.normal)

        self.addSubview(backimg)
        backimg.addSubview(pImage)
        backimg.addSubview(pText)
        backimg.addSubview(pPoint)
        backimg.addSubview(pState)
        
        backimg.image = UIImage.init(named: "p_menu_button")
        backimg.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalToSuperview()
        }
        
//        pImage.image = UIImage.init(named: "p_menu_sort_img")
        pImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.left.equalTo(LEFT_PADDING)
        }
        
//        pText.text = "排序"
       
        if kScreenW == 320 {
            pText.font = kFont_Small
        }else{
            pText.font = kFont_Big
        }
        pText.textColor = .white
        pText.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.left.equalTo(pImage.snp.right).offset(MARGIN)
            make.right.equalTo(-20)
        }
        
        pPoint.image = UIImage.init(named: "p_menu_down")
        pPoint.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 5, height: 12))
            make.left.equalTo(pText.snp.right).offset(MARGIN)
        }
        
        pState.image = UIImage.init(named: "p_menu_show_img")
        pState.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 12, height: 7))
            make.right.equalTo(-MARGIN)
        }
    }
}
