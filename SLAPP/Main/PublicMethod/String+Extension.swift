//
//  String+Extension.swift
//  SLAPP
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import Foundation

extension String {
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func sizeWithText(text:String, font:UIFont, maxSize:CGSize) -> CGSize {
        return (text as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil).size
    }
    
    func doAwayColon()->(String){
        var newString = ""
        if (self.components(separatedBy: "：").count) > 1 {
            let baseArr = self.components(separatedBy: "，")
            for subS in baseArr {
                newString.append((subS.components(separatedBy: "：").first)!)
                newString.append("，")
            }
            newString.removeLast()
            return newString
        }
        return self
    }
    
    
    
    static func configAttributedStr(oldStr:String,subStr:String,oldColor:UIColor,color:UIColor)->(NSMutableAttributedString){
        
        
        let range = NSRange.init(location: 0, length: (oldStr as NSString).length)
        let aStr = NSMutableAttributedString.init(string: oldStr)
        let subStrRange = (oldStr as NSString).range(of: subStr)
        aStr.addAttributes([NSAttributedStringKey.foregroundColor:oldColor], range:range)
        aStr.addAttributes([NSAttributedStringKey.foregroundColor:color], range: subStrRange)
        return aStr
    }
    
    
    
    
    
    /// 富文本字符串
    ///
    /// - Parameters:
    ///   - oldStr: 要处理的字符串
    ///   - subStr: 单独处理的子字符串
    ///   - oldColor: 整体的颜色
    ///   - color: 子字符串的颜色
    ///   - font: 字体
    ///   - lineSpacing: 行间距  传负数为默认
    /// - Returns: 返回处理完的字符串
    static func configAttributedStr(oldStr:String,subStr:String,oldColor:UIColor,color:UIColor,font:UIFont,lineSpacing:Int)->(NSMutableAttributedString){
        
        
        let range = NSRange.init(location: 0, length: (oldStr as NSString).length)
        let aStr = NSMutableAttributedString.init(string: oldStr)
        let subStrRange = (oldStr as NSString).range(of: subStr)
        aStr.addAttributes([NSAttributedStringKey.foregroundColor:oldColor], range:range)
        aStr.addAttributes([NSAttributedStringKey.foregroundColor:color], range: subStrRange)
        
        
        aStr.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        
        
        if lineSpacing > 0 {
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = CGFloat(lineSpacing)
            aStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: range)
        }
        
        
        return aStr
    }
    
    
    
    static func noNilStr(str:Any?)->(String){
        
        if str is NSNull {
            return ""
        }
        
        if str is NSNumber {
            
            return "\(str!)"
        }
        
        if str is String {
            if String(describing: str!) == "(null)"{
                return ""
            }
            return String(describing: str!)
        }
        
        if str == nil {
            return ""
        }
        
        return String(describing: str!)
    }
    
    static func isNumberType(str:String)->(Bool){
        guard !str.isEmpty else {
            return false
        }
        let reg = try! NSRegularExpression.init(pattern: "[0-9.0-9]", options: .caseInsensitive)
        let count = reg.numberOfMatches(in: str, options: .reportProgress, range: NSRange.init(location: 0, length: str.count))
        return count == str.count ? true :false
    }
    
    
    static func isMobile(str:String)->(Bool){
        guard !str.isEmpty else {
            return false
        }
        let mobile = "1([1-9]|)\\d{9}$"
        let regextestmobile = NSPredicate.init(format: "%@ MATCHES %@", str,mobile)
        if regextestmobile.evaluate(with: str) {
            return true
        }
        return false
    }
    
    
    
    // MARK: - html字符串转富文本
    static func htmlStr(htmlStr:String)->(NSAttributedString){
        do {
            let str = String.init(format: "<span style= color:white>%@<span", htmlStr)
            return try NSAttributedString.init(data: str.data(using: String.Encoding.unicode)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch{
            DLog(error)
        }
        return NSAttributedString.init(string: "")
    }
    
    

    
    /// 对粘贴复制的手机号做过滤
    ///
    /// - Returns: 返回过滤后的手机号
    func removeHiddenCode()->(String){
        let str = self.replacingOccurrences(of: "\\p{Cf}", with: "", options: String.CompareOptions.regularExpression, range:self.range(of: self))
        return str
    }
    
    
    
    /// base64编码
    ///
    /// - Parameter str: <#str description#>
    /// - Returns: <#return value description#>
    static func base64Encode(str:String)->(String){
        let data:Data =  str.data(using: .utf8)!
        if data.isEmpty {
            return ""
        }
        return data.base64EncodedString(options: .lineLength64Characters)
    }
    
    
    /// base64解码
    ///
    /// - Parameter str: <#str description#>
    /// - Returns: <#return value description#>
    static func base64Decode(str:String)->(String){
        
//        do {
//            try <#throwing expression#>
//        } catch <#pattern#> {
//            <#statements#>
//        }
        
        
        let data:Data? = Data.init(base64Encoded: str, options: .ignoreUnknownCharacters)
        if data == nil {
            return ""
        }
        let aStr = String.init(data: data!, encoding: .utf8)
        return String.noNilStr(str:aStr)
    }
    
}
