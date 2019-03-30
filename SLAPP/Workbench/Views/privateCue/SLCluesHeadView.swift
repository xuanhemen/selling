//
//  SLCluesHeadView.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLCluesHeadView: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    /**声明类型*/
    typealias LongPress = () -> Void
    var longPress:LongPress? = nil
    
    /**箭头*/
    let arrowBtn:UIButton = UIButton.init(type: UIButtonType.custom)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        /**
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y:49.7, width: SCREEN_WIDTH, height: 0.3)
        layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(layer)
          */
        /**添加线条*/
        let lineView = UIView()
        lineView.backgroundColor = RGBA(R: 233, G: 233, B: 233, A: 1)
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-0.5)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 0.5))
        }
        arrowBtn.setImage(UIImage(named: "Arrow"), for: UIControlState.normal)
        arrowBtn.setImage(UIImage(named: "pstArrow"), for: UIControlState.selected)
        self.addSubview(arrowBtn)
        arrowBtn.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 10, height: 10))
        })
        /**添加长按手势*/
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(edit))
        longPress.minimumPressDuration = 0.5;//定义按的时间
        self.addGestureRecognizer(longPress)
        
    }
    /**长按事件*/
    @objc func edit(gestureRecognizer: UILongPressGestureRecognizer){
        //不判断状态会连续调用方法，所以要判断状态
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            self.longPress!()
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**组名*/
    lazy var gruopName: UILabel = {
        let gruopName = UILabel()
        gruopName.text = "分组"
        gruopName.textColor = kTitleColor
        gruopName.font = UIFont.systemFont(ofSize: 17)
        gruopName.sizeToFit()
        self.addSubview(gruopName)
        gruopName.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        })
        return gruopName
    }()
    /**人数*/
    lazy var peopleCount: UILabel = {
        let peopleCount = UILabel()
        peopleCount.textColor = UIColor.gray
        peopleCount.font = UIFont.systemFont(ofSize: 14)
        peopleCount.sizeToFit()
        self.addSubview(peopleCount)
        peopleCount.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowBtn.snp.left).offset(-20)
        })
        return peopleCount
    }()

}
