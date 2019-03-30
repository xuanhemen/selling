//
//  UIButton+Extension.swift
//  SLAPP
//
//  Created by rms on 2018/2/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import Foundation
extension UIButton {
    
    func changeImageTitleRect(){
        self.titleLabel?.sizeToFit()
        self.imageEdgeInsets = UIEdgeInsetsMake(0, (self.titleLabel?.width)! + 2.5, 0, -(self.titleLabel?.width)! - 2.5);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.currentImage?.size.width)!, 0, (self.currentImage?.size.width)!);
      
    }
    
    func animationStartWith(str:String){
        
        var array = Array<UIImage>()
        
        for i in 1...3 {
            array.append(UIImage(named:String.init(format: "%@%d", str,i))!)
        }
        self.imageView?.animationImages = array
        self.imageView?.animationDuration = 1
        self.imageView?.animationRepeatCount = 0
        self.imageView?.startAnimating()
        
    }
    
    
    func stopAnimation(){
        self.imageView?.stopAnimating()
        self.imageView?.animationImages = nil
    }
    
    
}
