//
//  SLCluesBottomView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

protocol BtnClick:NSObjectProtocol {
    /**按钮点击代理*/
    func btnClicked(tag: Int) -> Void
}
class SLCluesBottomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate:BtnClick?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(frame: CGRect, titleArray:Array<String>) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        let layer = CALayer()
        layer.backgroundColor = RGBA(R: 233, G: 233, B: 233, A: 1).cgColor
        layer.frame = CGRect(x: 0, y: 49.7, width: SCREEN_WIDTH, height: 0.3)
        self.layer.addSublayer(layer)
        let toplayer = CALayer()
        toplayer.backgroundColor = RGBA(R: 233, G: 233, B: 233, A: 1).cgColor
        toplayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.3)
        self.layer.addSublayer(toplayer)
        
        let arrCount = titleArray.count
        for index in 0..<arrCount {
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.setTitle(titleArray[index], for: UIControlState.normal)
            btn.setTitleColor(RGBA(R: 37, G: 171, B: 96, A: 1), for: UIControlState.normal)
            btn.titleLabel?.font = FONT_16
            btn.frame = CGRect(x: SCREEN_WIDTH/CGFloat(arrCount)*CGFloat(index), y: 0, width: SCREEN_WIDTH/CGFloat(arrCount), height: 50)
            btn.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
            btn.backgroundColor = UIColor.clear
            btn.tag = index
            self.addSubview(btn)
            let layer = CALayer()
            layer.backgroundColor = RGBA(R: 150, G: 150, B: 150, A: 1).cgColor
            layer.frame = CGRect(x: SCREEN_WIDTH/CGFloat(arrCount), y: 12, width: 0.3, height: 26)
            btn.layer.addSublayer(layer)

        }
    }
    @objc func buttonClicked(button: UIButton) {
        self.delegate?.btnClicked(tag: button.tag)
    }
}
