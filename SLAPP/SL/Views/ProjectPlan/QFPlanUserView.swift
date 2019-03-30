//
//  QFPlanUserView.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/19.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit

protocol QFPlanUserViewDelegate:NSObjectProtocol {
    func btnSelectedWithIndex(index:Int);
    
}

class QFPlanUserView: UIView {

    var delegate:QFPlanUserViewDelegate?
    
    
    func configUI(array:Array<Any>,width:CGFloat,line:Int) -> CGFloat {
        let space:CGFloat = (width-CGFloat(line-1)*5-30)/CGFloat(line)
        var h:CGFloat = 5+space
        for i in 0...array.count {
            
            let frame = CGRect(x: 15+CGFloat(i%line)*(space+5), y: 5+CGFloat(i/line)*(space+5), width: space, height: space)
            let view = UIView.init(frame: frame)
            view.backgroundColor = .blue
            self.addSubview(view)
            
            if i==array.count{
                view.backgroundColor = .clear
                let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:view.frame.size.height))
                btn.setBackgroundImage(#imageLiteral(resourceName: "projectAddJian"), for: UIControlState.normal)
                btn.addTarget(self, action: #selector(addButtonClick), for: UIControlEvents.touchUpInside)
                view.addSubview(btn)
            }
        }
        if (array.count+1)%line != 0{
            h = h*CGFloat((array.count+1)/line+1)
        }else{
            h = h*CGFloat((array.count+1)/line)
        }
        return h+10
    }
    
    @objc func addButtonClick() {
        self.delegate!.btnSelectedWithIndex(index: -1)
    }

}
