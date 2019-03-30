//
//  DrawLineManager.swift
//  SD
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class DrawLineManager: NSObject {
   
    class func drawLine(start:CGPoint,end:CGPoint,width:CGFloat,lineColor:UIColor,inView:UIView){
        let line = CAShapeLayer()
        line.lineCap = kCALineCapRound
        line.lineJoin = kCALineJoinBevel
        line.strokeColor = lineColor.cgColor
        line.lineWidth = width
        line.strokeEnd = 0.0
        inView.layer.addSublayer(line)
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = width
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        line.path = path.cgPath
        line.strokeEnd = 1.0
    }
}
