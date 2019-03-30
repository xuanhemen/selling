
//
//  QFChartView.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/12.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
class QFChartView: UIView {

    var qfwidth:CGFloat?
    var qfheight:CGFloat?
    var yArray:Array<String>?
    var xArray = [["title":"实际值","value":[1,2,3,4,5],"type":0],["title":"达标值","value":[1,2,3,4,5],"type":0],["title":"健康指数","value":[1,2,3,4,5],"type":1]]
    
    
    var maxValue:CGFloat = 0.0
    let colorArray = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.purple]
    
    
    
    func uiConfig() {
        qfwidth = self.frame.size.width
        qfheight = self.frame.size.height
        yArray = ["Coach","决策者","支持度","态度","结果","个人赢"]
        xArray = [["title":"实际值","value":[0,0,10,5,0,0],"type":0],["title":"达标值","value":[3,3,8,8,4,4],"type":0],["title":"健康指数","value":[-8,-8,4,5,-6,-6],"type":1]]
        maxValue = 10
        
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setAllowsAntialiasing(true) //抗锯齿设置
        
        
        
        
        let ySpace = (qfheight!-20)/CGFloat((yArray?.count)!+1)
        
        for i in 0...(yArray?.count)! {
            if i == 0 {
                context.setStrokeColor(HexColor("#c6f9ee").cgColor)
                context.setLineWidth(ySpace)
            }else{
                if i%2 > 0 {
                    context.setStrokeColor(HexColor("#ffffff").cgColor)
                    context.setLineWidth(ySpace)
                }else{
                    context.setStrokeColor(HexColor("#dfdfdf").cgColor)
                    context.setLineWidth(ySpace)
                }
            }
            context.move(to: CGPoint(x: 10, y: 10+ySpace/2+(ySpace)*CGFloat(i)))
            context.addLine(to: CGPoint(x: qfwidth!-10, y: 10+ySpace/2+(ySpace)*CGFloat(i)))
            context.strokePath()
            
        }
        
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(0.5)
        
        for i in 0...(yArray?.count)!+1 {
            context.move(to: CGPoint(x: 10, y: 10+ySpace*CGFloat(i)))
            context.addLine(to: CGPoint(x: qfwidth!-10, y: 10+ySpace*CGFloat(i)))
            context.strokePath()
            
        }
        
        let xSpace = self.drawXAxis(ySpace: ySpace,context: context)
        
        for i in 0...(yArray?.count)!-1{
            let frame = CGRect(x: 10, y: 10+ySpace*CGFloat(i+1)+(ySpace-15)/2, width: xSpace, height: 15)
            self.drawText(string: (yArray![i] as NSString), alignment: .center, font: UIFont.systemFont(ofSize: 13, weight: .bold), frame: frame, color: HexColor("#333333"))
        }
        var lastX:CGFloat = 10
        
        let frame = CGRect(x:10, y: 10+(ySpace-15)/2, width: xSpace, height: 15)
        self.drawText(string: "项目", alignment: .center, font: UIFont.systemFont(ofSize: 13, weight: .bold), frame: frame, color: HexColor("#16a865"))
        
        for i in 0...xArray.count-1 {
            let dict = xArray[i]
            let type:Int = dict["type"] as! Int
            let title:NSString = dict["title"] as! NSString
            let valueArray = dict["value"] as! Array<AnyObject>
            let x = lastX
            var w = xSpace
            lastX = lastX + xSpace
            if type == 1 {
                lastX = lastX + xSpace
                w = xSpace*2
            }
            let frame = CGRect(x:xSpace+x, y: 10+(ySpace-15)/2, width: w, height: 15)
            self.drawText(string: title, alignment: .center, font: UIFont.systemFont(ofSize: 13, weight: .bold), frame: frame, color: HexColor("#16a865"))
            
            for j in 0...valueArray.count-1{
                let value = (valueArray[j] as! Double)
                if type == 0 {
                    let frame = CGRect(x: lastX, y: 10+ySpace*CGFloat(j+1)+(ySpace-15)/2, width: xSpace, height: 15)
                    self.drawText(string: NSString.localizedStringWithFormat("%.f", value), alignment: .center, font: UIFont.systemFont(ofSize: 13), frame: frame, color: UIColor.darkGray)
                }
                
                
                
                if type == 1 {
                    
                    
                    
                    
                    context.setLineWidth(ySpace/4)
                    
                   let myValue = self.configValue(i: j)
                    DLog(myValue)
                    var addWidth:CGFloat = 0
                    if myValue < 0 {
                        context.setStrokeColor(UIColor.red.cgColor)
                        addWidth = CGFloat(myValue)*xSpace
//                        addWidth = CGFloat(value/Double(maxValue))*xSpace
                    }else{
                        context.setStrokeColor(UIColor.green.cgColor)
                        addWidth = CGFloat(myValue)*xSpace
                    }
                    
                    context.move(to: CGPoint(x: lastX, y: 10+ySpace*CGFloat(j+1)+ySpace/2))
                    context.addLine(to: CGPoint(x: addWidth+lastX, y: 10+ySpace*CGFloat(j+1)+ySpace/2))
                    context.strokePath()
                    context.setStrokeColor(UIColor.gray.cgColor)
                    context.setLineWidth(0.5)
                    
                }
            }
        }
    }
    
    
    func configValue(i:Int)->(Double){
//        服务器返回的数据  无法用type  区分   也不敢肯定数组的顺序肯定对   只能先用名字做区分了
//        [["type": 0, "title": "实际值", "value": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]], ["type": 0, "title": "达标值", "value": [3.0, 3.0, 8.0, 8.0, 4.0, 4.0]], ["type": 1, "title": "健康指数", "value": [-3.0, -3.0, -8.0, -8.0, -4.0, -4.0]]]
        
        var sjDic = Dictionary<String,Any>() ;
        var dbDic = Dictionary<String,Any>();
        
        for sub in xArray {
            if JSON(sub["title"] as Any).stringValue.contains("实际值"){
                sjDic = sub
            }
            if JSON(sub["title"] as Any).stringValue.contains("达标值"){
                dbDic = sub
            }
            
        }
         let valueSjArray = sjDic["value"] as! Array<AnyObject>
         let valueDbArray = dbDic["value"] as! Array<AnyObject>
        
         let a = JSON(valueSjArray[i]).doubleValue
       
         let b = JSON(valueDbArray[i]).doubleValue
        
        if b == 0 {
            return 0
        }else{
            
            let c = (a-b)/b
            
            if c > 0 {
                return c > 1 ? 1 : c;
            }else if c == 0 {
                return 0;
            }else{
                return c < -1 ? -1 : c;
            }
            
        }
        
        
    }
    
    
    //绘制X轴
    func drawXAxis(ySpace:CGFloat,context:CGContext) ->CGFloat {
        var cnt = 1
        for i in 0...xArray.count-1 {
            let dict = xArray[i]
            let type:Int = dict["type"] as! Int
            cnt = cnt + 1
            if type == 1 {
                cnt = cnt + 1
            }
        }
        
        context.move(to: CGPoint(x: 10, y: 10))
        context.addLine(to: CGPoint(x: CGFloat(10), y: qfheight! - 10))
        context.strokePath()
        
        let xSpace = (qfwidth!-20)/CGFloat(cnt)
        var lastX:CGFloat = 10+xSpace
        for i in 0...xArray.count {
            context.move(to: CGPoint(x: lastX, y: 10))
            context.addLine(to: CGPoint(x: CGFloat(lastX), y: qfheight! - 10))
            context.strokePath()
            lastX = lastX + xSpace
            if i<xArray.count{
                let dict = xArray[i]
                let type:Int = dict["type"] as! Int
                if type == 1 {
                    context.setStrokeColor(UIColor.lightGray.cgColor)
                    context.move(to: CGPoint(x: lastX, y: 10+ySpace))
                    context.addLine(to: CGPoint(x: CGFloat(lastX), y: qfheight! - 10))
                    context.strokePath()
                    lastX = lastX + xSpace
                    context.setStrokeColor(UIColor.white.cgColor)
                }
            }
        }
        
        return xSpace
    }
    
    //绘制文字
    func drawText(string:NSString,alignment:NSTextAlignment,font:UIFont,frame:CGRect,color:UIColor) {
        let style = NSMutableParagraphStyle.init()
        style.alignment = alignment
        let attributes = [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:color,NSAttributedStringKey.paragraphStyle:style]
        string.draw(in: frame, withAttributes: attributes)
    }
    

}
