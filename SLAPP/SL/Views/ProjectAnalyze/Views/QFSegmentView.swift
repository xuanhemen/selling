//
//  QFSegmentView.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/10.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit

protocol QFSegmentViewDelegate : class{
    
    func segmentSelectIndex(index:Int,tag:Int)
}

class QFSegmentView: UIView {

    weak var mainDelegate: QFSegmentViewDelegate?
    var scrollView = UIScrollView.init()
    
    func selectIndex(index:Int) {
        let btn:UIButton = self.scrollView.viewWithTag(index+100) as! UIButton
        self.btnClick(btn)
    }
    func segmentAddElement(titleArray:Array<String>,showCnt:Int,delegate:QFSegmentViewDelegate?){
        self.mainDelegate = delegate
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.scrollView.isScrollEnabled = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        let contentWidth = (Int)(titleArray.count/showCnt+1)*(Int)(self.frame.size.width)
        self.scrollView.contentSize = CGSize(width: contentWidth, height: 0)
        self.addSubview(self.scrollView)

        let remainder = titleArray.count%showCnt
        var cnt = titleArray.count/showCnt;
        
        if titleArray.count == showCnt {
            
            for i in 0...showCnt-1 {
                let space = SCREEN_WIDTH/CGFloat(showCnt)
                let view = UIView.init(frame: CGRect(x: CGFloat(i)*space, y: 0, width: space, height: self.frame.size.height))
                view.backgroundColor = .clear
                self.scrollView.addSubview(view)
                
                let btn = UIButton.init(frame: CGRect(x:0, y: 0, width: space, height: self.frame.size.height))
                btn.setTitleColor(.gray, for: UIControlState.normal)
                btn.setTitle(titleArray[i], for: UIControlState.normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                btn.tag = i+100;
                btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
                
                let layer = CALayer.init()
                layer.frame = CGRect(x:0, y:btn.frame.size.height-2, width:btn.frame.size.width,height: 2);
                layer.backgroundColor = UIColor.clear.cgColor
                btn.layer.addSublayer(layer)
                
                view.addSubview(btn)
                
                
                if btn.tag-100 == 0 {
                    btn.setTitleColor(.white, for: UIControlState.normal)
                    layer.backgroundColor = UIColor.init(red: 87/255.0, green: 193/255.0, blue: 108/255.0, alpha: 1).cgColor
                }
                
                
                
            //1
                
            }
        }else{
            if remainder>0 {
                cnt = cnt+1;
            }
            
            for i in 0...cnt-1 {
                let view = UIView.init(frame: CGRect(x: CGFloat(i)*self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height))
                view.backgroundColor = .clear
                self.scrollView.addSubview(view)
                
                var jcnt = showCnt
                if i==cnt-1{
                    jcnt = remainder
                }
                
                for j in 0...jcnt-1 {
                    var startX:CGFloat = 0.0
                    var endX:CGFloat = self.frame.size.width
                    if i>0 {
                        startX = 40.0
                        let stepBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height))
                        stepBtn.backgroundColor = .clear
                        stepBtn.setTitleColor(.gray, for: UIControlState.normal)
                        stepBtn.setTitle("···", for: UIControlState.normal)
                        stepBtn.addTarget(self, action:#selector(stepBtnClick(_:)), for:.touchUpInside)
                        view.addSubview(stepBtn)
                    }
                    if i<cnt-1 {
                        endX = self.frame.size.width-40
                        let nextBtn = UIButton.init(frame: CGRect(x: self.frame.size.width-40.0, y: 0, width: 40, height: self.frame.size.height))
                        nextBtn.backgroundColor = .clear
                        nextBtn.setTitleColor(.gray, for: UIControlState.normal)
                        nextBtn.addTarget(self, action: #selector(nextBtnClick(_:)), for: .touchUpInside)
                        nextBtn.setTitle("···", for: UIControlState.normal)
                        view.addSubview(nextBtn)
                    }
                    let btn = UIButton.init(frame: CGRect(x:startX+CGFloat(j)*((endX-startX)/CGFloat(showCnt)), y: 0, width: (endX-startX)/CGFloat(showCnt), height: self.frame.size.height))
                    btn.setTitleColor(.gray, for: UIControlState.normal)
                    btn.setTitle(titleArray[i*showCnt+j], for: UIControlState.normal)
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                    btn.tag = i*showCnt+j+100;
                    btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
                    
                    let layer = CALayer.init()
                    layer.frame = CGRect(x:0, y:btn.frame.size.height-2, width:btn.frame.size.width,height: 2);
                    layer.backgroundColor = UIColor.clear.cgColor
                    btn.layer.addSublayer(layer)
                    
                    view.addSubview(btn)
                    
                    
                    if btn.tag-100 == 0 {
                        btn.setTitleColor(.white, for: UIControlState.normal)
                        layer.backgroundColor = UIColor.init(red: 87/255.0, green: 193/255.0, blue: 108/255.0, alpha: 1).cgColor
                    }
                    
                }
                
            }
        }
        
        
        
    }

    @objc func stepBtnClick(_ sender:UIButton) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x-self.frame.size.width, y: 0)
    }
    @objc func nextBtnClick(_ sender:UIButton) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x+self.frame.size.width, y: 0)
    }
    @objc func btnClick(_ sender:UIButton) {
        self.mainDelegate?.segmentSelectIndex(index: sender.tag-100,tag:self.tag)
        for view in self.scrollView.subviews {
            if view.isKind(of: UIView.self){
                if view.subviews.count>0 {
                    for subView in view.subviews{
                        if subView.isKind(of: UIButton.self){
                            if subView.tag == sender.tag{
                                sender.setTitleColor(UIColor.white, for: UIControlState.normal)
                                for layer in sender.layer.sublayers!{
                                    if layer.frame.size.height == 2 {
                                        layer.backgroundColor = UIColor.init(red: 87/255.0, green: 193/255.0, blue: 108/255.0, alpha: 1).cgColor
                                    }
                                }
                            }else{
                                
                                (subView as! UIButton).setTitleColor(UIColor.gray, for: UIControlState.normal)
                                
                                if subView.layer.sublayers != nil {
                                    for layer in subView.layer.sublayers!{
                                        layer.backgroundColor = UIColor.clear.cgColor
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
}
