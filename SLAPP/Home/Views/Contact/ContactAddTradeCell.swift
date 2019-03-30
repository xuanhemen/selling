//
//  ContactAddTradeCell.swift
//  SLAPP
//
//  Created by rms on 2018/3/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ContactAddTradeCell: ContactAddBaseCell {
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bgView.isHidden = true
        
        tradeView = SelectTradeView.init(frame: CGRect.init(x: LEFT_PADDING, y: LEFT_PADDING, width: MAIN_SCREEN_WIDTH - LEFT_PADDING * 2, height: self.contentView.height))
        self.contentView.addSubview(tradeView)
        
        tradeView.selectBtn1.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
        tradeView.selectBtn2.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectBtnClick(btn:UIButton)  {
        if self.selectTradeBtnClickBlock != nil {
            if btn.tag == 10{
                tradeView.selectBtn1.setTitle(self.selectTradeBtnClickBlock!(btn), for: .normal)
            }
            if btn.tag == 11{
                tradeView.selectBtn2.setTitle(self.selectTradeBtnClickBlock!(btn), for: .normal)
            }
        }
    }
}
