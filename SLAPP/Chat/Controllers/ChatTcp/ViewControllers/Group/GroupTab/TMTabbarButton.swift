
//
//  TMTabbarButton.swift
//  TMSwiftLearn
//
//  Created by harry on 17/2/7.
//  Copyright © 2017年 timer. All rights reserved.
//

import UIKit

class TMTabbarButton: UIButton {
   
    
   var item :UITabBarItem?
//   {
//    
//    
//    
//    didSet
//    {
//        item.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//        item.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//        item.addObserver(self, forKeyPath: "selectedImage", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//        self.observeValue(forKeyPath: nil, of: nil, change: nil, context: nil)
//        
//    }
//    
//  }
//    
   override init(frame: CGRect)
   {
       super.init(frame: frame)
       imageView?.contentMode = UIViewContentMode.center
       titleLabel?.textAlignment = NSTextAlignment.center
       titleLabel?.font = UIFont.systemFont(ofSize: 11)
       self.setTitleColor(UIColor.darkGray, for: .normal)
       self.setTitleColor(UIColor.hexString(hexString: "1782D2"), for: .selected)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
//         self.removeObserver(self, forKeyPath: "title", context: nil)
//        self.removeObserver(self, forKeyPath: "image", context: nil)
//        self.removeObserver(self, forKeyPath: "selectedImage", context: nil)
        
    }
    
    }



extension TMTabbarButton
{
    public func configWithItem(_ item :UITabBarItem)
    {
//        self.item = item;
//        self.item!.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//        self.item!.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//        self.item!.addObserver(self, forKeyPath: "selectedImage", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//        self.observeValue(forKeyPath: nil, of: nil, change: nil, context: nil)
        
        self.setTitle(item.title, for: UIControlState.normal)
        self.setTitle(item.title, for: UIControlState.selected)
        
        self.setImage(item.image, for: UIControlState.normal)
        self.setImage(item.selectedImage, for: UIControlState.selected)
        
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        self.setTitle(item?.title, for: UIControlState.normal)
        self.setTitle(item?.title, for: UIControlState.selected)
        
        self.setImage(item?.image, for: UIControlState.normal)
        self.setImage(item?.selectedImage, for: UIControlState.selected)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW:CGFloat = contentRect.size.width;
        let imageH:CGFloat = contentRect.size.height;

        return CGRect(x: 0, y: -3, width: imageW, height: imageH)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleY:CGFloat = contentRect.size.height * CGFloat(0.7)
        let imageW:CGFloat = contentRect.size.width;
        let imageH:CGFloat = contentRect.size.height-titleY;
        
        return CGRect(x: 0, y: titleY-2, width: imageW, height: imageH)
    }
    
   
}
