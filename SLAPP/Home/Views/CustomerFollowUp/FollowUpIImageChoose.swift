//
//  FollowUpIImageChoose.swift
//  SLAPP
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

let imageSpace:CGFloat = 10.0
class FollowUpIImageChoose: UIView {
    
    var clickAdd:(Int)->() = {_ in
        
    }
    
    var delete:()->() = {
        
    }
    
    var refresh:(CGFloat)->() = { _ in
        
    }
    
    //图片数据
    var imageData:Array = Array<UIImage>()
    //图片url数据
    var imageUrlData:Array = Array<Dictionary<String,Any>>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    
    func configUI(){
//        self.layer.cornerRadius = 4;
//        self.layer.borderWidth = 0.5
//        self.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func btnClick(btn:UIButton){
        
        var num = 0
        num += imageUrlData.count
        num += imageData.count
        clickAdd(9-num)
    }
    
    
//    //添加url图片数据
//    func addImageUrlData(_: Array<String>){
//
//
//    }
//
//    //添加图片
//    func addImageData(_: Array<UIImage>){
//
//
//    }
    
    
    func showImage(){
        
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        let width  =  (kScreenW-4*imageSpace-20)/3.0
        var num = 1
        num += imageUrlData.count
        num += imageData.count
        
        if num > 9 {
            refresh((imageSpace+width)*CGFloat(3)+imageSpace)
        }else{
            refresh((imageSpace+width)*CGFloat((num-1)/3+1)+imageSpace)
        }
        
        
        
        
        for i in 0..<num {
            if i > 8 {
                break
            }
            
            if i == num-1 {
                
                
                let imageView = UIImageView()
                imageView.tag = i;
                imageView.image = #imageLiteral(resourceName: "imageAdd")
                
                imageView.frame = CGRect(x: imageSpace+(imageSpace+width)*CGFloat(i%3), y: imageSpace+(imageSpace+width)*CGFloat(i/3), width: width, height: width)
                imageView.isUserInteractionEnabled = true
                self.addSubview(imageView)
                
                
                let btn = UIButton()
                btn.frame = CGRect(x: 0, y: 0, width: width, height: width)
                imageView.addSubview(btn)
                btn.tag = 1000
                btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
                
                
                
            }else{
                let imageView = UIImageView()
                imageView.tag = i;
                imageView.backgroundColor = UIColor.red
                
                imageView.frame = CGRect(x: imageSpace+(imageSpace+width)*CGFloat(i%3), y: imageSpace+(imageSpace+width)*CGFloat(i/3), width: width, height: width)
                imageView.isUserInteractionEnabled = true
                self.addSubview(imageView)
                
                if self.imageUrlData.count > 0 && i < self.imageUrlData.count{
                   
                    let dic = self.imageUrlData[i]
                    imageView.sd_setImage(with: URL.init(string: String.noNilStr(str: dic["preview_url_small"])), placeholderImage: #imageLiteral(resourceName: "defaultImage"))
                }else{
                    
                    imageView.image = imageData[i-self.imageUrlData.count]
                }
                
                
                
                
                let btn = UIButton()
                btn.frame = CGRect(x: width-20, y: 0, width: 20, height: 20)
                imageView.addSubview(btn)
                btn.setImage(#imageLiteral(resourceName: "imageDelete"), for:.normal)
                btn.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
            }
            
            
            
        }
        
    }
    
    
    @objc func deleteBtnClick(btn:UIButton){
        let tag = (btn.superview?.tag)!
        if tag < imageUrlData.count {
            imageUrlData.remove(at: tag)
        }else{
            imageData.remove(at:tag-imageUrlData.count)
        }
        delete()
    }
    
}



