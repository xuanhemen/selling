//
//  AddcontactView.swift
//  SLAPP
//
//  Created by apple on 2018/2/9.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AddcontactView: UIView {
   
    @IBOutlet weak var isManagerView: UIView!
    var isManager:Bool = false
    @IBOutlet weak var isManagerImage: UIImageView!
    
    @IBAction func isManagerClick(_ sender: Any) {
        
        isManager = !isManager
        if isManager == false {
            isManagerImage.image = #imageLiteral(resourceName: "dxNormal")
        }else{
            isManagerImage.image = #imageLiteral(resourceName: "dxSelect")
        }
        
        
    }
    @IBOutlet weak var isManagerBtn: UIButton!
    var click:(_ name:String,_ phone:String)->() = {_,_ in
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        if (self.click != nil) {
            self.click("","")
        }
        
    }
    @IBAction func sureClick(_ sender: UIButton) {
        
       
        if (namaText.text?.isEmpty)! {
            PublicMethod.toastWithText(toastText: "姓名不能为空")
            return
        }
        
        if (phoneText.text?.isEmpty)! {
            PublicMethod.toastWithText(toastText: "手机号不能为空")
            return
        }
        
        
        if (self.click != nil) {
            self.click(namaText.text!,phoneText.text!)
        }
    }
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var namaText: UITextField!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var sure: UIButton!
    
    
    
    
}
