//
//  SLCluesDetailSegView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLCluesDetailSegView: UIView {

    /**声明类型*/
    typealias MoveTableView = (Int) -> Void
    /**用于回调传值*/
    var moveTableView:MoveTableView? = nil
     /**可移动色块*/
    let colorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
        /**创建选项卡*/
        let titleArr = ["线索信息","跟进记录","相关信息"]
        for (index,value) in titleArr.enumerated() {
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.setTitle(value, for: UIControlState.normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.backgroundColor = UIColor.white
            btn.tag = index
            btn.addTarget(self, action: #selector(moveColorView), for: UIControlEvents.touchUpInside)
            self.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(SCREEN_WIDTH/3 * CGFloat(index))
                make.size.equalTo(CGSize(width: SCREEN_WIDTH/3, height: 40))
            })
        }
        colorView.backgroundColor = RGBA(R: 37, G: 171, B: 96, A: 1)
        colorView.bringSubview(toFront: self)
        self.addSubview(colorView)
        colorView.snp.makeConstraints { (make) in
            make.centerX.equalTo(SCREEN_WIDTH/6)
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 70, height: 3))
            
        }
        
    }
    /**移动色块*/
    @objc func moveColorView(btn: UIButton){
        UIView.animate(withDuration: 0.2) {
            var center = btn.center
            center.y = 47
            self.colorView.center = center
        }
      
        moveTableView!(btn.tag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
