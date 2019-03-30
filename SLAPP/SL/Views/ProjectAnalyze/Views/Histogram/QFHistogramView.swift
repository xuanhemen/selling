//
//  QFHistogramView.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/11.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit

class QFHistogramView: UIView {
    var qfwidth:CGFloat?
    var qfheight:CGFloat?
    var yArray:Array<String>?
    var xArray:Array<String>?
    
    
    var maxValue:CGFloat?
    var valueArray:Array<CGFloat>?
    let colorArray = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.purple]
    
    
    
    func uiConfig() {
        qfwidth = self.frame.size.width
        qfheight = self.frame.size.height
        yArray = ["Coach","决策者","支持度","态度","结果","个人赢"]
        xArray = ["抉择区","突破区","优势区","赢单区"]
        maxValue = 100
        valueArray = [70,90,44,60,33,120]
        
    }
    
    override func draw(_ rect: CGRect) {
    
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setAllowsAntialiasing(true) //抗锯齿设置
        
        //绘制轴
        context.setStrokeColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1 );//设置画笔颜色方法一
        context.setLineWidth(1.5);//线条宽度
        context.move(to: CGPoint(x: 50, y: 20))//开始点位置
        context.addLine(to: CGPoint(x: 50, y: qfheight!-20))//结束点位置
        context.addLine(to: CGPoint(x: qfwidth!-20, y: qfheight!-20))//结束点位置
        context.strokePath()
        
        context.setStrokeColor( UIColor.darkGray.cgColor )
        let yHeight = (qfheight!-40)/CGFloat((yArray?.count)!)
        
        
        for i in 0...(yArray?.count)!{
            let tempHeight = 20+yHeight*CGFloat(i)
            context.setLineWidth(1.5);//线条宽度
            context.move(to: CGPoint(x: 50, y: tempHeight))
            context.addLine(to: CGPoint(x: 45, y: tempHeight))
            context.strokePath()
            
            guard i < (yArray?.count)! else {
                break
            }
            
            let str1 = yArray![i]
            let style = NSMutableParagraphStyle.init()
            style.alignment = .center
            
            let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.darkGray,NSAttributedStringKey.paragraphStyle:style]
            let size:CGSize = (str1 as NSString).size(withAttributes: attributes)
            (str1 as NSString).draw(in: CGRect(x: 0, y: tempHeight+(yHeight-size.height)/2, width: 50, height: size.height), withAttributes: attributes)
            
            var rectWidth = (valueArray![i]/maxValue!)*(self.qfwidth!-70)
            
            if rectWidth > self.qfwidth!-70 {
                rectWidth = self.qfwidth!-70
            }
            
            //绘制矩形
            context.setStrokeColor(colorArray[i].cgColor)
            context.setLineWidth(yHeight/2);//线条宽度
            context.move(to: CGPoint(x: 51.5, y: tempHeight+yHeight/2))
            context.addLine(to: CGPoint(x: 51.5+rectWidth, y: tempHeight+yHeight/2))
            context.strokePath()
            
            context.setLineWidth(1.5);//线条宽度
        }
        
        for i in 0...(yArray?.count)!{
            let tempHeight = 20+yHeight*CGFloat(i)
            context.setStrokeColor(UIColor.cyan.cgColor)
            context.setLineWidth(1.5);//线条宽度
            
            guard i < (yArray?.count)! else {
                break
            }
            
            var rectWidth = (valueArray![i]/maxValue!)*(self.qfwidth!-70)
            
            if rectWidth > self.qfwidth!-70 {
                rectWidth = self.qfwidth!-70
            }
            
            var lastWidth:CGFloat = 0
            if i<(valueArray?.count)!-1 {
                lastWidth = (valueArray![i+1]/maxValue!)*(self.qfwidth!-70)
                if lastWidth > self.qfwidth!-70 {
                    lastWidth = self.qfwidth!-70
                }
            }
            //画圆
            context.addEllipse(in: CGRect(x: 51.5+rectWidth-2, y: tempHeight+yHeight/2-2, width: 4, height: 4)); //画圆 x,y左上角坐标
            context.strokePath() //关闭路径
            
            if i<(valueArray?.count)!-1 {
                context.move(to: CGPoint(x: 51.5+rectWidth, y: tempHeight+yHeight/2))
                context.addLine(to: CGPoint(x: 51.5+lastWidth, y: tempHeight+yHeight/2+yHeight))
                context.strokePath()
            }
            
            context.setStrokeColor(UIColor.darkGray.cgColor)
            context.setLineWidth(1.5);//线条宽度
        }
        
        let xWidth = (qfwidth!-70)/CGFloat((xArray?.count)!)
        for i in 0...(xArray?.count)!{
            let tempWidth = 50+xWidth*CGFloat(i)
            
            context.move(to: CGPoint(x: tempWidth, y: qfheight!-20))
            context.addLine(to: CGPoint(x: tempWidth, y: qfheight!-15))
            context.strokePath()
            
            guard i < (xArray?.count)! else {
                break
            }
            
            let str2 = xArray![i]
            let style = NSMutableParagraphStyle.init()
            style.alignment = .center
            
            let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.darkGray,NSAttributedStringKey.paragraphStyle:style]
            let size:CGSize = (str2 as NSString).size(withAttributes: attributes)
            (str2 as NSString).draw(in: CGRect(x: tempWidth, y:qfheight!-20+(20-size.height)/2, width: xWidth, height: size.height), withAttributes: attributes)
        }
        

        
        
        
        //let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length),path, nil)
        //CTFrameDraw(frame, context)

        //dayStr2.draw(at: CGPoint(x: 0, y: 0),withAttributes: attributes )
        
        
//        //绘制点 或 实心圆
//        context.fillEllipse( in: CGRect(x: 10, y: 10, width: 2, height: 2))
//        context.fillEllipse( in: CGRect(x: 15, y: 10, width: 1, height: 1))
//        context.fillEllipse( in: CGRect(x: 20, y: 10, width: 0.5, height: 0.5))
//
//
//        //绘制虚线
//        context.setLineWidth(1);
//        let dashArray: [CGFloat] = [2, 6,4,2 ]
//        context.setLineDash(phase: 1, lengths: dashArray )
//        context.move(to: CGPoint(x: 120, y: 40))//开始点位置
//        context.addLine(to: CGPoint(x: 180, y: 40))//结束点位置
//        context.strokePath();
//
//        context.setLineDash(phase: 1, lengths: [1,1] )//还原点类型
//        context.move(to: CGPoint(x: 200, y: 40))//开始点位置
//        context.addLine(to: CGPoint(x: 260, y: 40))//结束点位置
//        context.strokePath();
//
//        //绘制曲线
//        context.setLineDash(phase: 0, lengths: [1,0] )//还原点类型
//
//        context.move(to: CGPoint(x: 10, y: 80))//开始点位置
//        context.addCurve(to: CGPoint(x: 150, y: 80), control1: CGPoint(x: 50, y: 90), control2: CGPoint(x: 90, y: 70))
//        context.strokePath();
//
//        context.move(to: CGPoint(x: 160, y: 80))//开始点位置
//        context.addQuadCurve(to: CGPoint(x: 250, y: 80), control: CGPoint(x: 200, y: 65))
//        context.strokePath();
//
//        //画圆
//        context.setLineWidth(0.5);//线条宽度
//        context.setStrokeColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1);
//        context.addEllipse(in: CGRect(x: 10, y: 120, width: 20, height: 20)); //画圆 x,y左上角坐标
//        context.strokePath() //关闭路径
//
//        //画圆弧，单位弧度，clockwise: 顺时针计算，弧度 = 角度 * π ／ 180 x,y中心点坐标
;//设置画笔颜色方法二
//        context.addArc(center: CGPoint(x: 50, y: 130), radius: 10, startAngle: 0, endAngle: CGFloat(90 * Double.pi/180), clockwise: true )
//        context.strokePath() //关闭路径
//        context.addArc(center: CGPoint(x: 70, y: 130), radius: 10, startAngle: 0, endAngle: CGFloat(90 * Double.pi/180), clockwise: false )
//        context.strokePath() //关闭路径
//
//        //绘制矩形
//        context.setStrokeColor( UIColor.gray.cgColor );
//        context.addRect(CGRect(x: 100, y: 120, width: 30, height: 20 ))
//        context.strokePath();
        
        
    }
    
}
