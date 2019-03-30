//
//  Extension.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class MakeUIViewGreatAgain: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var interfaceBuilderBackgroundColor: UIColor?
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.backgroundColor = self.interfaceBuilderBackgroundColor ?? self.backgroundColor
    }
}

extension UIImage{
    class func imageFromColor(color:UIColor) -> UIImage {
        let rect=CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return theImage!;
    }
}

extension String {
    
    ///   NSRange 转 Range<String.Index>
    ///
    /// - Parameter nsRange: <#nsRange description#>
    /// - Returns: <#return value description#>
    func changeToRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    /// Range<String.Index> 转 NSRange
    ///
    /// - Parameter range: <#range description#>
    /// - Returns: <#return value description#>
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
//    func nsRange(from range: Range<String.Index>) -> NSRange {
//        let from = range.lowerBound.samePosition(in: utf16)
//        let to = range.upperBound.samePosition(in: utf16)
//        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
//                       length: utf16.distance(from: from, to: to))
//    }
    
    func getTextHeight(font:UIFont,width:CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
    func getTextWidth(font:UIFont,height:CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.width
    }
    func getSpaceLabelHeight(font:UIFont,width:CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = textLineSpace
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle], context: nil)
        return boundingBox.height
    }
    
    func isFloatNumber() -> Bool {
        let tNumRegularExpression = try? NSRegularExpression.init(pattern: "[0-9.0-9]", options: NSRegularExpression.Options.caseInsensitive)
        let tNumMatchCount = tNumRegularExpression?.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: self.count))
        if self.count == tNumMatchCount{
            return true
        }
        return false
    }
    
    static func changeToString(inValue:Any) -> String {
        var str = ""
        if inValue is NSNumber {
            str = (inValue as! NSNumber).stringValue
        }else if inValue is String{
            str = inValue as! String
        }else if inValue is Float || inValue is Int{
            str = "\(inValue)"
        }
        
        return str
    }
    
}


extension UIAlertController{
    /// 快速创建弹框
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - preferredStyle: 样式
    ///   - btns: 按钮字典
    ///   - btnActions: 按钮事件
    convenience init(title: String?, message: String?, preferredStyle:UIAlertControllerStyle,btns:Dictionary<String,String>,btnActions:@escaping (UIAlertAction,String)->()) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        var cancelAction:UIAlertAction? = nil
        if btns.keys.contains(kCancel){
            cancelAction = UIAlertAction(title: btns[kCancel], style: UIAlertActionStyle.cancel, handler: { (action) in
                btnActions(action, kCancel)
            })
        }
        for key in btns.keys{
            if key != kCancel{
                let okAction = UIAlertAction(title: btns[key], style: UIAlertActionStyle.default, handler: { (action) in
                    btnActions(action, key)
                })
                
                self.addAction(okAction)
            }
        }
        if cancelAction != nil{
            self.addAction(cancelAction!)
        }
    }
    /// 快速创建弹框
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - preferredStyle: 样式
    ///   - okAndCancel: 按钮元组，第二个位置为“”时没有取消按钮
    ///   - btnActions: 按钮事件
    convenience init(title: String?, message: String?, preferredStyle:UIAlertControllerStyle,okAndCancel:(String,String),btnActions:@escaping (UIAlertAction,String)->()) {
        self.init(title: title, message: message, preferredStyle: preferredStyle, btns: okAndCancel.1 == "" ? ["ok":okAndCancel.0] : ["ok":okAndCancel.0,kCancel:okAndCancel.1], btnActions: btnActions)
    }
}

extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension UIImageView{
    
    func animationStart(){
        
        var array = Array<UIImage>()
        
        for i in 1...3 {
            array.append(UIImage(named:String.init(format: "voiceR%d",i))!)
        }
        self.animationImages = array
        self.animationDuration = 1
        self.animationRepeatCount = 0
        self.startAnimating()
        
    }
    
    
    func stopAnimation(){
        self.stopAnimating()
        self.animationImages = nil
    }
    
    
}


