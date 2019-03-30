//
//  ToSetPermanceCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import SwiftyJSON
class ToSetPermanceCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var all: UILabel!
    @IBOutlet weak var mon3: UILabel!
    @IBOutlet weak var mon2: UILabel!
    @IBOutlet weak var mon1: UILabel!
    @IBOutlet weak var text3: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text1: UITextField!
    var mySum : Double = 0
    
    var textChange = { () in
        
    }
    
    var index:Int?{
      didSet{
        self.mon(array: monArray[index!])
       }
    }
    
    var lookatModel:Dictionary<String,Any>?{
        
        didSet{
            text1.text = String.noNilStr(str: lookatModel?[monthKeyArray[index!][0]])
            text2.text = String.noNilStr(str: lookatModel?[monthKeyArray[index!][1]])
            text3.text = String.noNilStr(str: lookatModel?[monthKeyArray[index!][2]])
            self.allTextShow()
        }
    }
    
    //检测必须满足
    func check()->(Bool,Double){
        if !String.isNumberType(str: text1.text!) {
            PublicMethod.toastWithText(toastText: monArray[index!][3].appending(monArray[index!][0]).appending("的绩效必须为数字"))
            return (false,0)
            
        }
        if !String.isNumberType(str: text2.text!) {
            PublicMethod.toastWithText(toastText: monArray[index!][3].appending(monArray[index!][1]).appending("的绩效必须为数字"))
            return (false,0)
        }
        if !String.isNumberType(str: text3.text!) {
            PublicMethod.toastWithText(toastText: monArray[index!][3].appending(monArray[index!][2]).appending("的绩效必须为数字"))
            return (false,0)
        }
        
        var sum = 0.0
        if String.isNumberType(str: text1.text!) {
            
            sum += Double(text1.text!)!
        }
        if String.isNumberType(str: text2.text!) {
            sum += Double(text2.text!)!
        }
        if String.isNumberType(str: text3.text!) {
            sum += Double(text3.text!)!
        }
        
        return (true,sum)
    }
    
    
    func configData()->(Dictionary<String,String>){
        
        var dic = Dictionary<String,String>()
        dic.updateValue(text1.text!, forKey: monthKeyArray[index!][0])
        dic.updateValue(text2.text!, forKey: monthKeyArray[index!][1])
        dic.updateValue(text3.text!, forKey: monthKeyArray[index!][2])
        return dic
    }
    
    
    let monthKeyArray = [["January_planamount","February_planamount","March_planamount"],["April_planamount","May_planamount","June_planamount"],["July_planamount","August_planamount","September_planamount"],["October_planamount","November_planamount","December_planamount"]]
    
    let monArray = [["1月","2月","3月","一季度"],["4月","5月","6月","二季度"],["7月","8月","9月","三季度"],["10月","11月","12月","四季度"]]
    let allArray = ["一季度合计:","二季度合计:","三季度合计:","四季度合计:"]
    func mon(array:[String]){
         mon1.text = array[0]
         mon2.text = array[1]
         mon3.text = array[2]
         all.text = array[3]
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        self.selectionStyle = .none
        text1.keyboardType = .numbersAndPunctuation
        text2.keyboardType = .numbersAndPunctuation
        text3.keyboardType = .numbersAndPunctuation
        text1.reactive.continuousTextValues.observe { [weak self](text) in
            
            let str = String.noNilStr(str: text.value)
            if !str.isEmpty{
                if  str.last == "." {
                    return
                }
            }
            
            self?.addAll(text: String.noNilStr(str:text.value))
        }
        
        text2.reactive.continuousTextValues.observe { [weak self](text) in
            let str = String.noNilStr(str: text.value)
            if !str.isEmpty{
                if  str.last == "." {
                    return
                }
            }
           self?.addAll(text: String.noNilStr(str: text.value))
        }
        text3.reactive.continuousTextValues.observe { [weak self](text) in
            let str = String.noNilStr(str: text.value)
            if !str.isEmpty{
                if  str.last == "." {
                    return
                }
            }
            self?.addAll(text: String.noNilStr(str: text.value))
        }
        
        text1.delegate  = self
        text2.delegate = self
        text3.delegate = self
        

        
    }
    
    
    
    

    
    
    func addAll(text:String){
        self.allTextShow()
        if text.isEmpty {
            all.text = allArray[index!].appending("0万")
            return
        }
        
        if !String.isNumberType(str: text) {
            PublicMethod.toastWithText(toastText: "必须输入数字")
            return
        }
        
        
        
    }
    
    
    func allTextShow(){
        var sum = 0.0
        if String.isNumberType(str: text1.text!) {
            
            sum += Double(text1.text!)!
        }
        if String.isNumberType(str: text2.text!) {
            sum += Double(text2.text!)!
        }
        if String.isNumberType(str: text3.text!) {
            sum += Double(text3.text!)!
        }
        mySum = sum
        all.text = allArray[index!].appending("\(sum)").appending("万")
        textChange()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if (textField.text?.isEmpty)! {
            textField.text = "0"
        }else{
            let str = textField.text!
            if str.last == "." {
                textField.text = str.replacingOccurrences(of: ".", with: "")
                
            }
            
            
        }
        
        
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.isEmpty)! && string == "." {
            PublicMethod.toastWithText(toastText: "第一位必须输入数字")
            return false
        }
        
        if string == "."{
            if textField.text?.range(of: string) != nil {
                 PublicMethod.toastWithText(toastText: "只能输入一个小数点")
                return false
            }
            
        }
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
