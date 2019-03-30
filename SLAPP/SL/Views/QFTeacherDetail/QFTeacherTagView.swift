//
//  QFTeacherTagView.swift
//  SLAPP
//
//  Created by qwp on 2018/4/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class QFTeacherTagView: UIView {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let tagView = UIView()

    func setData(array:Array<String>,type:Int) -> CGFloat {
        if type == 0{
            imageView.image = #imageLiteral(resourceName: "qf_biaoqianimage")
            titleLabel.text = "标签"
        }else{
            imageView.image = #imageLiteral(resourceName: "qf_zhuzuoImage")
            titleLabel.text = "著作"
        }
        if array.count == 0 {
            return 100
        }else{
            self.configTagView(array: array, type: type)
            return 50 + self.tagView.frame.size.height
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 2
        self.backgroundColor = .white
        
        
        self.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "qf_gerenjianjieImage")
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.height.width.equalTo(20)
        }
        
        self.addSubview(titleLabel)
        titleLabel.text = "个人简介"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLabel.textColor = HexColor("#333333")
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            make.top.equalTo(15)
            make.height.equalTo(20)
            make.right.equalTo(-15)
        }
        
        let line = UILabel()
        self.addSubview(line)
        line.backgroundColor = HexColor("#F2F2F2")
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(49.5)
            make.height.equalTo(0.5)
            make.right.equalTo(0)
        }
        
        self.addSubview(tagView)
    }
    
    func configTagView(array:Array<String>,type:Int){
        
        for view in tagView.subviews{
            view.removeFromSuperview()
        }
        let vwidth = (SCREEN_WIDTH-80)/3
        let vheight = vwidth/3
        var j:Int = 0
        if array.count%3 == 0 {
            j = array.count/3
        }else{
            j = array.count/3+1
        }
        
        tagView.frame = CGRect(x: 15, y: 50, width: SCREEN_WIDTH-20, height: (CGFloat(j)+1)*15+vheight*CGFloat(j))
        
        
        
        for i in 0..<array.count {

            let sView = UIView.init(frame: CGRect(x: (vwidth+15)*CGFloat(i%3), y: 15+CGFloat(i/3)*(vheight+15), width: vwidth, height: vheight))
            
            let label = UILabel.init(frame: CGRect(x: (vwidth+15)*CGFloat(i%3), y: 15+CGFloat(i/3)*(vheight+15), width: vwidth, height: vheight))
            label.text = array[i]
            label.numberOfLines = 1
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.adjustsFontSizeToFitWidth = true
            if type == 0{
                sView.backgroundColor = UIColor.init(red: 77/255.0, green: 172/255.0, blue: 97/255.0, alpha: 1)
                sView.layer.cornerRadius = vheight/2
            }else{
                sView.backgroundColor = UIColor.init(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1)
                sView.layer.cornerRadius = 2
            }
    
            tagView.addSubview(sView)
            tagView.addSubview(label)
        }
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
