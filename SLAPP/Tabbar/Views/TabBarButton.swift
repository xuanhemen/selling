//
//  TabBarButton.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class TabBarButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let badgeButton = BadgeButton.init(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView?.contentMode = .center
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 11)
        self.setTitleColor(UIColor.darkGray, for: .normal)
        self.setTitleColor(kGreenColor, for: .selected)
    }
    
    var item = UITabBarItem(){
        didSet{
           
            self.setTitle(item.title, for: UIControlState.normal)
            self.setTitle(item.title, for: UIControlState.selected)
            self.setImage(item.image, for: UIControlState.normal)
            self.setImage(item.selectedImage, for: UIControlState.selected)
            
//            item.addObserver(self, forKeyPath: "badgeValue", options: .new, context: nil)
//            item.addObserver(self, forKeyPath: "title", options: .new, context: nil)
//            item.addObserver(self, forKeyPath: "image", options: .new, context: nil)
//            item.addObserver(self, forKeyPath: "selectedImage", options: .new, context: nil)
//
//            self.observeValue(forKeyPath: nil, of: nil, change: nil, context: nil)
        }
    }
    
//    deinit {
//        do{
//        try item.removeObserver(self, forKeyPath: "badgeValue")
//        try item.removeObserver(self, forKeyPath: "title")
//        try item.removeObserver(self, forKeyPath: "image")
//        try item.removeObserver(self, forKeyPath: "selectedImage")
//        }catch{
//            DLog(error)
//        }
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //设置文字
        self.setTitle(self.item.title, for: .normal)
        self.setTitle(self.item.title, for: .selected)
        //设置图片
        self.setImage(item.image, for: .normal)
        self.setImage(item.selectedImage, for: .selected)
        //设置数字提醒
        self.badgeButton.badgeValue = self.item.badgeValue
        //设置数字提醒的位置
        let badgeY:CGFloat = 5.0
        let badgeX = self.frame.size.width-self.badgeButton.frame.size.width-10;
        var badgeF = self.badgeButton.frame;
        badgeF.origin.x = badgeX;
        badgeF.origin.y = badgeY;
        self.badgeButton.frame = badgeF;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.size.width
        let imageH = contentRect.size.height
        return CGRect(x: 0, y: 0, width: imageW, height: imageH)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleY = contentRect.size.height * 0.7;
        let titleW = contentRect.size.width;
        let titleH = contentRect.size.height-titleY;
        return CGRect(x: 0, y: titleY-2, width: titleY-2, height: titleH)
    }

}
